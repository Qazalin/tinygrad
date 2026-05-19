sqlite3 -header -column "/home/qazal/.local/share/opencode/opencode.db" "
select
  p.session_id,
  s.title,
  datetime(p.time_created/1000,'unixepoch') as created,
  p.message_id,
  p.id as part_id,
  json_extract(p.data,'$.tool') as tool,
  json_extract(p.data,'$.state.status') as status,
  substr(
    json_extract(p.data,'$.state.output'),
    max(1, instr(json_extract(p.data,'$.state.output'), 'linearizer.py')-500),
    1400
  ) as output_context
from part p
join session s on s.id = p.session_id
where json_extract(p.data,'$.type') = 'tool'
  and json_extract(p.data,'$.tool') not in ('read','grep')
  and coalesce(json_extract(p.data,'$.state.output'),'') like '%linearizer.py%'
  and (
    coalesce(json_extract(p.data,'$.state.output'),'') like '%line 81%'
    or coalesce(json_extract(p.data,'$.state.output'),'') like '%assert y.src[1] not in x.backward_slice_with_self%'
    or coalesce(json_extract(p.data,'$.state.output'),'') like '%AssertionError%'
  )
order by p.time_created;
"
