local m = {}

function m.GetRegistryClass( name )
  if( !_R[ name ] ) then error("Unknown registry class '"..name.."'", 2) end
  return _R[ name ]
end  

return m