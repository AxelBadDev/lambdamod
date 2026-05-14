--========== Copyright (C) 2026 hedv948-source, All Rights Reserved ==========--
--
-- Purpose: string spliting for convars
--
--============================================================================--
_CONSPLIT = _CONSPLIT or {}

function _CONSPLIT.Q_cmdsplit( text )
  local spat, epat, buf, quoted = [=[^(['"])]=], [=[(['"])$]=]

  local parts = {}
  for str in text:gmatch("%S+") do
    local squoted = str:match(spat)
    local equoted = str:match(epat)
    local escaped = str:match([=[(\*)['"]$]=])
    if squoted and not quoted and not equoted then
      buf, quoted = str, squoted
    elseif buf and equoted == quoted and #escaped % 2 == 0 then
      str, buf, quoted = buf .. ' ' .. str, nil, nil
    elseif buf then
      buf = buf .. ' ' .. str
    end
    if not buf then 
      table.insert(parts, (str:gsub(spat,""):gsub(epat,""))) 
    end
  end
  
  if buf then 
    error("Missing matching quote for "..buf, 2 ) 
  end
  
  return parts
end

return _CONSPLIT