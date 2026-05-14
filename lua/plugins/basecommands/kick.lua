--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--
local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local LibAdmin = LambdaMod.LibAdmin

function PLUGIN.PerformKick( pCaller, pTargets )
	local targets = LambdaMod.LibAdmin.ParseTargets( pTargets, pCaller )
	
	if #targets == 0 then
        LambdaMod.printfc(3, "No matching players for \"%s\".\n", tostring(pTargets) )
        return
    end
	for _, v in ipairs( targets ) do
		LambdaMod.LogAction( "%s kicked %s\n", pCaller:GetPlayerName(), v:GetPlayerName() ) 
		LambdaMod.Core.ForwardToConsole("kick " .. v:GetPlayerName() )
	end
end