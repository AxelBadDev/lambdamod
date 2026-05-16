--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

module( "transtype", package.seeall )

local Color = Color
local Vector = Vector
local _R_Color = _R.Color
local _R_Vector = _R.Vector

function isbool( value )
    return type( value ) == "boolean"
end  

function isstring( value )
    return type( value ) == "string"
end    

function istable( value )
    return type( value ) == "boolean"
end    

function isnumber( value )
    return type( value ) == "number"
end   

function isfunction( value )
    return type( value ) == "function"
end  
  
function isvector( value )
    return type( value ) == "vector"
end    

function isColor( value )
    return type( value ) == "color"
end    

function tobool( val )
	if ( val == nil || val == false || val == 0 || val == "0" || val == "false" ) then return false end
	return true
end