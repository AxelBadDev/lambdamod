--========= Copyleft ? 2026 hedv948-source, Some Rights Reserved ============--
--                                                      
-- Purpose: Extends the Lua String Library                                        
--                                                      
--==========================================================================--
require( "string" )

local string = string
local math = math
local random = random
local table = table
local tostring = tostring

function string.Cap( str )
    if str=="" then return end
    local first = str:sub(1,1)
    local last = str:sub(2)
    return first:upper()..last:lower()
end

function string.ToTable( input )
  local tbl = {}
  
  local str = tostring( input )
  
  for i=1, #str do
    tbl[i] = string.sub( str, i, i )
  end
  
  return tbl
end

local pattern_escape_replacements = {
	["("] = "%(",
	[")"] = "%)",
	["."] = "%.",
	["%"] = "%%",
	["+"] = "%+",
	["-"] = "%-",
	["*"] = "%*",
	["?"] = "%?",
	["["] = "%[",
	["]"] = "%]",
	["^"] = "%^",
	["$"] = "%$",
	["\0"] = "%z"
}

function string.PatternSafe( str )
	return ( string.gsub( str, ".", pattern_escape_replacements ) )
end


local totable = string.ToTable
local string_sub = string.sub
local string_find = string.find
local string_len = string.len

function string.Explode( separator, str, withpattern )
	if ( separator == "" ) then return totable( str ) end
	if ( withpattern == nil ) then withpattern = false end

	local ret = {}
	local current_pos = 1

	for i = 1, string_len( str ) do
		local start_pos, end_pos = string_find( str, separator, current_pos, ( not withpattern ) )
		if ( not start_pos ) then break end
		ret[ i ] = string_sub( str, current_pos, start_pos - 1 )
		current_pos = end_pos + 1
	end

	ret[ #ret + 1 ] = string_sub( str, current_pos )

	return ret
end

function string.Split( str, delimiter )
	return string.Explode( delimiter, str )
end

function string.Implode( seperator, Table ) 
    return table.concat( Table, seperator )
end

function string.StartsWith( str, start )
	return string.sub( str, 1, string.len( start ) ) == start
end

function string.StripExtension( path )
	for i = #path, 1, -1 do
		local c = string.sub( path, i, i )
		if ( c == "/" or c == "\\" ) then return path end
		if ( c == "." ) then return string.sub( path, 1, i - 1 ) end
	end

	return path
end

function string.GetPathFromFilename( path )
	for i = #path, 1, -1 do
		local c = string.sub( path, i, i )
		if ( c == "/" or c == "\\" ) then return string.sub( path, i + 1 ) end
	end
	
	return ""
end

function string.GetFileFromFilename( path )
	for i = #path, 1, -1 do
		local c = string.sub( path, i, i )
		if ( c == "/" or c == "\\" ) then return string.sub( path, i + 1 ) end
	end
	
	return path
end

function string.FormattedTime( seconds, format )
	if ( not seconds ) then seconds = 0 end
	local hours = math.floor( seconds / 3600 )
	local minutes = math.floor( ( seconds / 60 ) % 60 )
	local millisecs = ( seconds - math.floor( seconds ) ) * 100
	seconds = math.floor( seconds % 60 )
	
	if ( format ) then return string.format( format, minutes, seconds, millisecs )
	else return { h = hours, m = minutes, s = seconds, ms = millisecs }
	end
end

function string.ToMinutesSecondsMilliseconds( TimeInSeconds ) return string.FormattedTime( TimeInSeconds, "%02i:%02i:%02i" ) end
function string.ToMinutesSeconds( TimeInSeconds ) return string.FormattedTime( TimeInSeconds, "%02i:%02i" ) end

local function pluralizeString( str, quantity )
	return str .. ( ( quantity ~= 1 ) and "s" or "" )
end

function string.NiceTime( seconds )

	if ( seconds == nil ) then return "a few seconds" end

	if ( seconds < 60 ) then
		local t = math.floor( seconds )
		return t .. pluralizeString( " second", t )
	end

	if ( seconds < 60 * 60 ) then
		local t = math.floor( seconds / 60 )
		return t .. pluralizeString( " minute", t )
	end

	if ( seconds < 60 * 60 * 24 ) then
		local t = math.floor( seconds / (60 * 60) )
		return t .. pluralizeString( " hour", t )
	end

	if ( seconds < 60 * 60 * 24 * 7 ) then
		local t = math.floor( seconds / ( 60 * 60 * 24 ) )
		return t .. pluralizeString( " day", t )
	end

	if ( seconds < 60 * 60 * 24 * 365 ) then
		local t = math.floor( seconds / ( 60 * 60 * 24 * 7 ) )
		return t .. pluralizeString( " week", t )
	end

	local t = math.floor( seconds / ( 60 * 60 * 24 * 365 ) )
	return t .. pluralizeString( " year", t )

end

function string.Left( str, num ) return string.sub( str, 1, num ) end
function string.Right( str, num ) return string.sub( str, -num ) end

function string.Replace( str, tofind, toreplace )
	local tbl = string.Explode( tofind, str )
	if ( tbl[ 1 ] ) then return table.concat( tbl, toreplace ) end
	return str
end