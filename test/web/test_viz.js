const { spawn } = require("child_process");
const puppeteer = require("puppeteer");

const now = () => {
  const t = new Date();
  return t.toISOString();
}

async function main() {
  // ** start viz server
  const proc = spawn("python", ["-u", "-c", "from tinygrad import Tensor; Tensor.arange(4).realize()"], { env: { ...process.env, VIZ:"1" },
                      stdio: ["inherit", "pipe", "inherit"]});
  await new Promise(resolve => proc.stdout.on("data", r => {
    if (r.includes("ready")) resolve();
  }));

  // ** run browser tests
  let browser, page;
  try {
    browser = await puppeteer.launch({ headless: true });
    page = await browser.newPage();
    page.on("request", (r) => {
      console.log(`${now()} [REQUEST START]`, r.method(), r.url());
    });
    page.on("requestfailed", req => {
      console.log(`${now()} ✖`, req.failure().errorText, req.url());
    });
    page.on("response", async res => {
      const h = res.headers();
      const len = h["content-length"] ?? "-";
      console.log(`${now()} ←`, res.status(), res.request().url(), "len", len);
    });
    page.on("requestfinished", async req => {
      const res = req.response();
      if (res) {
        const buf = await res.buffer();
        console.log(`${now()} [REQUEST FINISH]`, req.url(), "actual", buf.length, "bytes");
      }
    });
    const res = await page.goto("http://localhost:8000", { waitUntil:"domcontentloaded" });
    if (res.status() !== 200) throw new Error("Failed to load page");
    const scheduleSelector = await page.waitForSelector("ul");
    scheduleSelector.click();
    await page.waitForSelector("rect");
    await page.waitForFunction(() => {
      const nodes = document.querySelectorAll("#nodes > g").length;
      const edges = document.querySelectorAll("#edges > path").length;
      return nodes > 0 && edges > 0;
    });
  } finally {
    // ** cleanups
    if (page != null) await page.close();
    if (browser != null) await browser.close();
    proc.kill();
  }
}

main();
