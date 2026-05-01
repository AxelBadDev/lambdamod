--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: Initialize LambdaMod
--]]
--if CLIENT or _CLIENT then return end -- Make sure its server-side only

if( CLIENT ) then return end

LambdaMod = LambdaMod or {}

include "lambda/core/globals.lua"
include "lambda/core/enum.lua"
include "lambda/core/print.lua"
include "lambda/core/config.lua"
include "lambda/core/core.lua"

---@class Settings
---@field Console_Prefix
LambdaMod.Settings = {}
LambdaMod.Settings.Console_Prefix = "CONSOLE"


function LambdaMod.IsTableExists( pName )
    if( !LambdaMod[ pName ] ) then return false end
    return true
end  

LambdaMod["INFO"] = 
{
	_VERSION     = LambdaMod["VERSION"] or "fallback-alpha",  --"1.5",
	_BRANCH      = LambdaMod["BRANCH"] or "Unknown",
	_DEVELOPMENT = LambdaMod["DEVELOPMENT"] or true,
	_BUILD       = LambdaMod["BUILD"] or "0",

	_BUILD_DATE  = string.format( 
                        "%s %s %s",	
                        tostring(( LambdaMod["BUILD_DATA"].month or "Jan" )), 
                        tostring(( LambdaMod["BUILD_DATA"].day or "1" )), 
                        tostring(( LambdaMod["BUILD_DATA"].year or "1970" )) 
                   )
}

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

local function includeFolder( path )
    local state
    if(SERVER) then
        state = "Server"
    elseif (CLIENT) then
        state = "Client"
    end
    
    local fullPath = "lua/" .. path .. "/"
    local fullPath_2 = path .. "/"
    
    local files = file.Find( fullPath .. "*.lua", "MOD" )
    
    if( !files && #files == 0 ) then
        dbg.Warning( "No files found in '"..fullPath.."'\n" )
        return
     end 
       
    for _, v in ipairs( files ) do
        LambdaMod.Printfc( 4, "%s ", state )
        LambdaMod.Printfc( 5, "[LambdaMod]: " )
        LambdaMod.Printfc( 0, "included %s.\n", ( fullPath_2 .. v ) )
        include(  fullPath_2 ..  v )
    end
end        

--include( "lambda/core/defines.lua" )
--include( "lambda/core/shared.lua" )



includeFolder( "lambda/includes/modules")
includeFolder( "lambda/includes/extensions" )
includeFolder( "lambda/chatbase" )
includeFolder( "lambda/meta" )
includeFolder( "lambda" )

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
    LambdaMod.printfc(0, "Usage: lambda_cvar <cvar> <value>\n")
    return
  end
  --engine.ServerCommand( tCmd[1] .. " " .. tostring(tCmd[2]) .. "\n" )
  LambdaMod.cvar.SetValue( tCmd[1], tCmd[2] )
  
  
end, "Change ConVar value" )

LambdaMod.AddCommand( "admins", function( ply, args )
	if ( !LambdaMod.AdminCFG ) then 
		LambdaMod.printfc(0, "Sorry, but currently admin table isn't available right now.\n")
		return 
	end
	
	for k,v in pairs( LambdaMod.AdminCFG ) do
		LambdaMod.printfc(0, "%s\n", tostring( k ) )
	end
end )

RegServerCmd( "lambda", function( ply, cmd, arg )
	local tCmd = split( arg )
	
	--local parts = {}
    --for word in tCmd:gmatch( "%S+" ) do
        --table.insert( parts, word )
    --end
    
    --local cmdName = string.lower( parts[ 1 ] or "" )
    
	if !tCmd[1] then
		LambdaMod.printfc(0, "Usage:\n")
		for k, v in pairs( LambdaMod.Registered ) do
			LambdaMod.printfc(0, "lambda %s %s\n", tostring( k ), tostring( ( v.helpArg or "" ) ) )
		end
		return
	end
    --if GetConVar("developer"):GetBool() then LambdaMod:printfc(1, "CMD: %s, Args: %s\n", tostring( tCmd[1] ), tostring( tCmd[2]) ) end
	LambdaMod.RunCommand( ply, tCmd )
	--table.remove( 
	
end, "" )  

includeC( "lambdamod_hook/chatcmdhook.lua" )  