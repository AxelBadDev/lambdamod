--[[
   * Copyleft 🄯 2026 hedv948-source
--]]

require( "table" )

local table = table
local pairs = pairs
local ipairs = ipairs
local error = error

local function istable( t )
  return type( t ) == "table"
end

local function isnumber( t )
  return type( t ) == "number"
end

local function isstring( t )
  return type( t ) == "string"
end

local function isbool( t )
  return type( t ) == "boolean"
end

function table.Copy( t, lookup_table )
	if ( t == nil ) then return nil end

	local copy = {}
	setmetatable( copy, debug.getmetatable( t ) )
	for i, v in pairs( t ) do
		if ( not istable( v ) ) then
			copy[ i ] = v
		else
			lookup_table = lookup_table or {}
			lookup_table[ t ] = copy
			if ( lookup_table[ v ] ) then
				copy[ i ] = lookup_table[ v ] -- we already copied this table. reuse the copy.
			else
				copy[ i ] = table.Copy( v, lookup_table ) -- not yet copied. copy it.
			end
		end
	end
	return copy
end

function table.GetKeys( tab )

	local keys = {}
	local id = 1

	for k, v in pairs( tab ) do
		keys[ id ] = k
		id = id + 1
	end

	return keys

end

function PrintTable( tble, i )
  i = i or 0
  local indent = ""
  for j = 1, i do
    indent = indent .. "\t"
  end
  
  if not istable( tble ) then error("bad argument #1 to 'PrintTable' (table expected got " .. type( tble ) .. ")") end
  
  for k, v in pairs( tble ) do
    if isnumber( k ) then
      dbg.Msg( indent .. string.format("[%s] = %s\n", tostring(k), tostring(v)))
    elseif isstring( k ) then dbg.Msg( indent .. string.format("[\"%s\"] = %s\n", tostring(k), tostring(v)))
    end
  end
end