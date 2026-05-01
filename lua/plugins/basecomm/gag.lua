local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local LogAction = LambdaMod.LogAction
local LibAdmin = LambdaMod.LibAdmin
local hook = require( "hook" )

local GaggedPlayers = LambdaMod.GetVar( "GaggedPlayers" ):GetTable()

--LambdaMod.GaggedPlayers 

function PLUGIN.PerformGag( pCaller, pTargets )
    LogAction( "%s triggered lambda_gag", pCaller:GetPlayerName() )
    
	local targets = LibAdmin.ParseTargets( pTargets, pCaller )
	
	for _, t in ipairs( targets ) do
        LogAction( "Gagged player: %s", t:GetPlayerName() )
        GaggedPlayers:AddKeyValue( t, true )
    end
    LambdaMod.Printfc( 0, "Gagged %s player(s)\n", tostring( #targets ) )
end

function PLUGIN.PerformUnGag( pCaller, pTargets )
    LogAction( "%s triggered lambda_ungag", pCaller:GetPlayerName() )
	local targets = LibAdmin.ParseTargets( pTargets, pCaller )
	
	for _, t in ipairs( targets ) do
        LogAction( "Ungagged player: %s", t:GetPlayerName() )
        GaggedPlayers:RemoveKey( t ) -- = nil
    end
    LambdaMod.Printfc( 0, "Ungagged %s player(s)\n", tostring( #targets ) )
end