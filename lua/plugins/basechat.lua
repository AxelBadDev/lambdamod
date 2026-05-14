--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

PLUGIN.myinfo = 
{
	name = "Basic Chat",
	author = "hedv948-source",
	description = "Basic Communication Commands",
	version = LAMBDAMOD_VERSION,
	api = LAMBDAMOD_API_VERSION,
	url = "https://github.com/hedv948-source/lambdamod/"
}

local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local RegServerCmd = LambdaMod.cvar.RegServerCmd
local LibAdmin = LambdaMod.LibAdmin

local function Command_LmCSay( pPlayer, pCmd, pArg )
    LambdaMod.LogAction( "\"%s\" triggered lambda_csay (text %s)", pPlayer:GetPlayerName(), tostring( pArg ) )
    LambdaMod.Core.util.CSay( pArg )
end    

function PLUGIN:OnPluginStart()
    RegAdminCmd( "lambda_csay", Command_LmCSay, "" )
end    