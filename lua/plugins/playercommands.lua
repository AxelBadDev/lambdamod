--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

PLUGIN:myinfo 
{
	name = "Player Commands",
	author = "AxelBadDev",
	description = "Misc. Player Commands",
	version = LAMBDAMOD_VERSION,
	api = LAMBDAMOD_API_VERSION,
	url = "https://github.com/AxelBadDev/lambdamod/"
}

PLUGIN:Include( "LambdaMod" )
PLUGIN:Include( "ChatCmd" )
PLUGIN:Include( "Hook" )

local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local LibAdmin = LambdaMod.LibAdmin

local g_Cvar_lambda_slay_damage;

function PLUGIN:PrePluginStart() 
    g_Cvar_lambda_slay_damage = ConVar( "lambda_slay_damage", "100000000", LambdaMod.bit.bor( FCVAR.REPLICATED, FCVAR.NOTIFY ), "How much damage to slay player(s)" )
end

function PLUGIN:OnPluginStart() 
    self.LambdaMod.RegAdminCmd( "lambda_slay", function( ply, cmd, arg )
        local pTargets = self.LambdaMod.ParseTargets( arg, ply )
        
        for _, t in ipairs( pTargets ) do
            self.LambdaMod.Damage( ply, t, tonumber( g_Cvar_lambda_slay_damage:GetInt() ) )
        end
        
        self.LambdaMod.LogAction( "Slayed", #pTargets, "player(s)")
    end, "" )       
    
    self.ChatCmd.AddAdminCmd( "slay", function( ply, cmd, args ) 
        local targetArg = args[ 1 ]
        if !targetArg then return "Usage: !slay player|me|all|others|index>" end
        
        local targets = self.LambdaMod.ParseTargets( targetArg, ply )
        
        for _, t in ipairs( targets ) do
            self.LambdaMod.Damage( ply, t, tonumber(g_Cvar_lambda_slay_damage:GetInt()) )
        end
        
        return "Slayed " .. #targets .. " player(s)"
        
     end, "Instantly kill target(s)" ) 
     
     self.ChatCmd.AddAdminCmd( "dissolve", function( ply, cmd, args ) 
        local targetArg = args[ 1 ]
        if !targetArg then return "Usage: !dissolve player|me|all|others|index>" end
        
        local targets = self.LambdaMod.ParseTargets( targetArg, ply )
        
        for _, t in ipairs( targets ) do
            effect.Dissolve( t, "sprites/blueglow1.vmt", gpGlobals.curtime(), 2)
        end
        
        return "Dissolved " .. #targets .. " player(s)"
        
     end, "Just like slay but dissolved target(s)" ) 
     
end

-- UTIL_CenterPrintAll( "Node Graph out of Date. Rebuilding...\n" );