--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

local easyfs = require( "easyfs" )

LambdaMod = LambdaMod or {}
C_LambdaMod = C_LambdaMod or {}

include "lambda/shared/bit.lua"
include "lambda/shared/globals.lua"
include "lambda/shared/enum.lua"
include "lambda/shared/print.lua"
include "lambda/shared/config.lua"
include "lambda/shared/core.lua"
include "lambda/shared/concmd_split.lua"
include "lambda/shared/info.lua"
include "lambda/shared/folderinc.lua"
include "lambda/shared/varlib.lua"
include "lambda/shared/console.lua"
include "lambda/shared/cvar.lua"

local includes = {
    
}

for _, v in ipairs(includes) do
    if ( v != nil ) then
        include( v )
    end
end        