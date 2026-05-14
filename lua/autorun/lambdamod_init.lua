--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--
if( CLIENT ) then return end

local easyfs = require( "easyfs" )

LambdaMod = LambdaMod or {}

include "lambda/core/globals.lua"
include "lambda/core/enum.lua"
include "lambda/core/print.lua"
include "lambda/core/config.lua"
include "lambda/core/core.lua"
include "lambda/core/concmd_split.lua"
include "lambda/core/net.lua"
include "lambda/code/info.lua"

---@class Settings
---@field Console_Prefix
LambdaMod.Settings = {}
LambdaMod.Settings.Console_Prefix = "CONSOLE"


function LambdaMod.IsTableExists( pName )
    if( !LambdaMod[ pName ] ) then return false end
    return true
end  

function LambdaMod.SanitizeCommandName(name)
    name = string.lower(name or "plugin")
    name = string.gsub(name, "%s+", "_")
    name = string.gsub(name, "[^a-z0-9_]", "")
    return "sm_" .. name
end


local function includeCore( pFile )
	include( "core/" .. pFile )
end

local function includelib( pFile )
	includeCore( "includes/" .. pFile  )
end

function LambdaMod.IncludeFolder( path )
    local state
    if(SERVER) then
        state = "Server"
    elseif (CLIENT) then
        state = "Client"
    end
    
    local fullPath = "lua/" .. path .. "/"
    local fullPath_2 = path .. "/"
    
    local files = easyfs.Find( fullPath .. "*.lua", "MOD" )
    
    if( !files && #files == 0 ) then
        dbg.Warning( "No files found in '"..fullPath.."'\n" )
        return
     end 
       
    for _, v in ipairs( files ) do
        LambdaMod.CPrintf( 4, "[LM] %s ", state )
        LambdaMod.CPrintf( 0, "included %s.\n", ( fullPath_2 .. v ) )
        include(  fullPath_2 ..  v )
    end
end        

LambdaMod.CPrintf( 2, "LambdaMod has started! (%s)\n", LambdaMod["VERSION"] )

LambdaMod.IncludeFolder( "lambda/includes/modules")
LambdaMod.IncludeFolder( "lambda/includes/extensions" )
LambdaMod.IncludeFolder( "lambda/chatbase" )
LambdaMod.IncludeFolder( "lambda/meta" )
LambdaMod.IncludeFolder( "lambda" )

hook.add( "InitHUD", "LambdaWelcomeMessage", function(pPlayer)
	UTIL.ClientPrint(pPlayer, 3, string.format( "This server is using LambdaMod v%s", tostring( LambdaMod["VERSION"] )))
end ) 

local function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

local RegConsoleCmd = LambdaMod.cvar.RegConsoleCmd
local RegAdminCmd = LambdaMod.cvar.RegAdminCmd
local RegServerCmd = LambdaMod.cvar.RegServerCmd

RegAdminCmd( "lambda_cvar", function( ply, cmd, arg ) 
  local tCmd = split( arg )
  if ( !tCmd[1] )then
    LambdaMod.printfc(0, "[LM] Usage: lambda_cvar <cvar> <value>\n")
    return
  end
  --engine.ServerCommand( tCmd[1] .. " " .. tostring(tCmd[2]) .. "\n" )
  LambdaMod.cvar.SetValue( tCmd[1], tCmd[2] )
  
  
end, "Change ConVar value" )

LambdaMod.AddCommand( "admins", function( ply, args )
	if ( !LambdaMod.AdminCFG ) then 
		LambdaMod.printfc(0, "[LM] Sorry, but currently admin table isn't available right now.\n")
		return 
	end
	
	for k,v in pairs( LambdaMod.AdminCFG ) do
		LambdaMod.printfc(0, "%s\n", tostring( k ) )
	end
end )

RegServerCmd( "lambda", function( ply, cmd, arg )
    
	local args = _CONSPLIT.Q_cmdsplit( arg )
    
    --for word in arg:gmatch( "%S+" ) do
        --table.insert( tCmd, word )
    --end
    
	if !args[ 1 ] then
		LambdaMod.printfc(0, "[LM] Usage: lambda <command> [arguments]\n")
		for k, v in pairs( LambdaMod.Registered ) do
			LambdaMod.printfc(0, "    lambda %s - %-s\n", tostring( k ), tostring( ( v.help or "" ) ) )
		end
		return
	end
    --if GetConVar("developer"):GetBool() then LambdaMod:printfc(1, "CMD: %s, Args: %s\n", tostring( tCmd[1] ), tostring( tCmd[2]) ) end
	LambdaMod.RunCommand( ply, args )
	--table.remove( 
	
end, "" )  

includeC( "lambdamod_hook/chatcmdhook.lua" )  