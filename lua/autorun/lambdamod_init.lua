--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: Initialize LambdaMod
--]]
if CLIENT or _CLIENT then return end -- Make sure its server-side only

local function includeCore( pFile )
	include( "core/" .. pFile )
end

local function includelib( pFile )
	includeCore( "includes/" .. pFile  )
end

include( "lambda/core/core.lua" )
include( "lambda/core/shared.lua" )
include( "lambda/core/includes/lambdamod.lua" )
include( "lambda/core/includes/cvar.lua" )
include( "lambda/core/includes/libadmin.lua" )
include( "lambda/core/includes/vscript.lua" )
include( "lambda/core/includes/libextend.lua" )
include( "lambda/config/admins.lua" )
