--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Bitwise module
--
--============================================================================--

require( "bit" )

local bit = bit

module( "bitequal", package.seeall )

local function isnumber( v )
    return type( v ) == "number"
end  

local function istable( v )
    return type( v ) == "table"
end  

local function isstring( v )
    return type( v ) == "string"
end  


function bor( t )
    assert( istable( t ), "bad arguemnt #1 to 'bor' (table expected got " .. type( t ) ..")" )
    local flags = 0
    for i, v in ipairs( t ) do
      assert( isnumber( v ), "bad bitwise operation (expected number got " .. type( v ) .. ")" )
      --print( i .. " " .. v )
      flags = bit.bor( flags, v )
    end 
    return flags 
end    

function band_equals( a, b )
    assert( isnumber( a ), "bad arguement #1 to 'band_equals' (number expected got " .. type( a ) .. ")" )
    assert( isnumber( b ), "bad arguement #2 to 'band_equals' (number expected got " .. type( b ) .. ")" )
    
    return bit.band( a, b ) 
end    
