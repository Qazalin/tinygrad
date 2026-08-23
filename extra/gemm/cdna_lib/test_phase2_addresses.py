#!/usr/bin/env python3
"""Exhaustive byte-range proof for Phase-2's hand-derived addresses.

This does not execute GPU ISA. It enumerates every workgroup/wave/lane/K iteration
for the supported Mx4096x4096 shapes and asserts that all global/LDS accesses stay
inside the corresponding allocations.
"""

N = K = 4096
HALF_K = K // 2
SCALE_K = K // 32
LDS_BYTES = 160 * 1024


def a_base(lane: int, wave_n: int, m_tile: int) -> int:
  q = lane >> 3
  row = ((q >> 2) << 4) + ((q & 3) >> 1) * 4 + (q & 1)
  return (m_tile * 256 + (wave_n >> 1) * 8 + (wave_n & 1) * 2 + row) * HALF_K + (lane & 7) * 16


def a_scale_base(lane: int, wave_n: int, m_tile: int) -> int:
  return (m_tile * 256 + wave_n * 32) * SCALE_K + lane * 4


def b_base(lane: int, wave_n: int, n_tile: int) -> int:
  return (n_tile * 256 + wave_n * 64) * HALF_K + lane * 16


def b_scale_base(lane: int, wave_n: int, n_tile: int) -> int:
  return (n_tile * 256 + wave_n * 64) * SCALE_K + lane * 4


def lds_read_base(lane: int) -> int:
  x = lane & 15
  base = (((x >> 3) * 2) + ((x & 3) >> 1)) * 1056
  y = lane & 7
  base += (y >> 2) * 256 + (y & 1) * 128 + (lane >> 4) * 16 + 4096
  return base


def c_lane_base(lane: int, n_tile: int, wave_n: int) -> int:
  stride = N * 2
  return ((lane & 15) * stride + (lane >> 5) * 16 + ((lane >> 4) & 1) * 32 +
          (n_tile * 256 + wave_n * 64) * 2)


def prove(M: int) -> None:
  sizes = {
    "A": M * HALF_K,
    "B": N * HALF_K,
    "SA": M * SCALE_K,
    "SB": N * SCALE_K,
    "C": M * N * 2,
  }
  maxima = {k: -1 for k in sizes}

  # Global inputs. wave_m=1 duplicates B/SB but has identical addresses.
  for mt in range(M // 256):
    for wn in range(4):
      for lane in range(64):
        ab = a_base(lane, wn, mt)
        sab = a_scale_base(lane, wn, mt)
        for ki in range(K // 256):
          desc_a = ki * 128
          desc_sa = ki * 256
          for block in range(8):
            end = desc_a + ab + block * (32 * HALF_K) + 15
            assert end < sizes["A"], ("A", M, mt, wn, lane, ki, block, end, sizes["A"])
            maxima["A"] = max(maxima["A"], end)
          for half in range(2):
            end = desc_sa + sab + half * (128 * SCALE_K) + 3
            assert end < sizes["SA"], ("SA", M, mt, wn, lane, ki, half, end, sizes["SA"])
            maxima["SA"] = max(maxima["SA"], end)

  for nt in range(N // 256):
    for wn in range(4):
      for lane in range(64):
        bb = b_base(lane, wn, nt)
        sbb = b_scale_base(lane, wn, nt)
        for ki in range(K // 256):
          desc_b = ki * 2048
          desc_sb = ki * 256
          for row16 in range(4):
            for kh in range(2):
              end = desc_b + bb + row16 * (16 * HALF_K) + kh * 1024 + 15
              assert end < sizes["B"], ("B", nt, wn, lane, ki, row16, kh, end, sizes["B"])
              maxima["B"] = max(maxima["B"], end)
          for kh in range(2):
            end = desc_sb + sbb + kh * (32 * SCALE_K) + 3
            assert end < sizes["SB"], ("SB", nt, wn, lane, ki, kh, end, sizes["SB"])
            maxima["SB"] = max(maxima["SB"], end)

  # LDS direct-load destinations and DS reads.
  max_lds_write = -1
  for wn in range(4):
    for block in range(8):
      # one 16-byte payload from each of 64 lanes
      max_lds_write = max(max_lds_write, 4096 + wn * 1056 + block * 4224 + 64 * 16 - 1)
    for kh in range(2):
      max_lds_write = max(max_lds_write, wn * 256 + kh * 1024 + 64 * 4 - 1)
  assert max_lds_write < LDS_BYTES, (max_lds_write, LDS_BYTES)

  reads = ((0,0),(64,0),(0,2),(64,2),(128,16),(192,16),(128,18),(192,18),
           (0,33),(64,33),(0,35),(64,35),(128,49),(192,49),(128,51),(192,51))
  max_lds_read = -1
  for wm in range(2):
    for lane in range(64):
      for off0, off1 in reads:
        end = lds_read_base(lane) + off0 + (off1 + wm * 66) * 256 + 15
        assert end < LDS_BYTES, ("LDS read", wm, lane, off0, off1, end, LDS_BYTES)
        max_lds_read = max(max_lds_read, end)

  # C stores. Descriptor stays at m_tile*256 just like reference; wave_m is vaddr only.
  # For one 256-row WG, also prove the 16-byte stores form an exact, collision-free
  # partition of the output tile. This is stronger than an in-bounds check and means
  # the store-only zero probe cannot hide aliasing between waves.
  stride = N * 2
  c_store_starts: set[int] | None = set() if M == 256 else None
  for mt in range(M // 256):
    desc_row = mt * 256
    desc_size = (M - desc_row) * stride
    for wm in range(2):
      wave_row_off = wm * 128 * stride
      for nt in range(N // 256):
        for wn in range(4):
          for lane in range(64):
            base = c_lane_base(lane, nt, wn) + wave_row_off
            for r in range(8):
              for half in range(2):
                rel_end = base + r * 16 * stride + half * 64 + 15
                assert rel_end < desc_size, ("C desc", M, mt, wm, nt, wn, lane, r, half, rel_end, desc_size)
                abs_start = desc_row * stride + base + r * 16 * stride + half * 64
                abs_end = desc_row * stride + rel_end
                assert abs_end < sizes["C"], ("C abs", abs_end, sizes["C"])
                if c_store_starts is not None:
                  assert abs_start not in c_store_starts, ("C store collision", abs_start, mt, wm, nt, wn, lane, r, half)
                  c_store_starts.add(abs_start)
                maxima["C"] = max(maxima["C"], abs_end)

  if c_store_starts is not None:
    expected = set(range(0, sizes["C"], 16))
    assert c_store_starts == expected, (len(c_store_starts), len(expected), min(c_store_starts), max(c_store_starts))

  print(f"M={M}: maxima " + " ".join(f"{k}={maxima[k]+1}/{sizes[k]}" for k in ("A","B","SA","SB","C")) +
        f" LDSwrite={max_lds_write+1}/{LDS_BYTES} LDSread={max_lds_read+1}/{LDS_BYTES}")


def main() -> None:
  for M in (256, 16384): prove(M)
  print("phase2 exhaustive address bounds passed")


if __name__ == "__main__": main()
