--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: Player Commands
--]]

PLUGIN.myinfo = 
{
	name = "Player Commands",
	author = "hedv948-source",
	description = "Misc. Player Commands",
	version = LambdaMod.INFO._VERSION,
	api = LambdaMod.Loader.api.version,
	url = "https://github.com/hedv948-source/lambdamod/"
}

local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local LibAdmin = LambdaMod.LibAdmin

function PerformSlay( pCaller, pTargets )

	local targets = ParseTargets( pTargets, pCaller )
    if #targets == 0 then
        LambdaMod.printfc(0, "No matching players for \"%s\".\n", pTargets)
    end

    for _, t in ipairs( targets ) do
        local dmg = CTakeDamageInfo()
        dmg:SetAttacker( pCaller )
        dmg:SetInflictor( pCaller )
        dmg:SetDamage( 10000000 )
        dmg:SetDamageType( DMG_GENERIC )
		AddMultiDamage( dmg, t )
    end
    
    LambdaMod.printfc(0, "Slayed %s player(s)\n", tostring( #targets ) )
end

function PLUGIN.OnPluginStart() 
	RegAdminCmd( "lambda_slay", function( ply, cmd, arg )
		if not arg or arg == "" then LambdaMod.printfc( 0, "Usage: lambda_slay <player|me|others|all>\n" ) return end
		PerformSlay( ply, arg );
	end, "lambda_slay <player|me|others|all>" )

end