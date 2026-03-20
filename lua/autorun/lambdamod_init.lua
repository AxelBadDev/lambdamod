--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: Player Commands
--]]
if CLIENT or _CLIENT then return end -- Make sure its server-side only

local function includeCore( pFile )
	include( "core/" .. pFile )
end

local function includelib( pFile )
	includeCore( "includes/" .. pFile  )
end

include( "LambdaMod/core/core.lua" )
include( "LambdaMod/core/shared.lua" )
include( "LambdaMod/core/includes/lambdamod.lua" )
include( "LambdaMod/core/includes/cvar.lua" )
include( "LambdaMod/core/includes/libadmin.lua" )
include( "LambdaMod/core/includes/vscript.lua" )
include( "LambdaMod/config/admins.lua" )