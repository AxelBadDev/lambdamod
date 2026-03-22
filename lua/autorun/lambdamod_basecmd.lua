--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: Commands for LambdaMod
--]]

if CLIENT or _CLIENT then return end -- Make sure its server-side only

include( "lambda/shared/defines.lua" )
include( "lambda/core/core.lua" )
include( "lambda/core/shared.lua" )
include( "lambda/core/includes/lambdamod.lua" )
include( "lambda/core/includes/cvar.lua" )
include( "lambda/core/includes/libadmin.lua" )
include( "lambda/core/includes/vscript.lua" )
include( "lambda/config/admins.lua" )

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

RegAdminCmd( "lambda_cvar", function( ply, cmd, arg ) 
  local tCmd = split( arg )
  if not tCmd[1] or not tCmd[2] then
    LambdaMod.printfc(0, "Usage: lambda_cvar <cvar> <value>\n")
    return
  end
  --engine.ServerCommand( tCmd[1] .. " " .. tostring(tCmd[2]) .. "\n" )
  cvar.FindVar( tCmd[1] ):SetValue( tostring( tCmd[2] ) )
end, "Change ConVar value" )

LambdaMod.AddCommand( "admins", function( ply, cmd, arg )
	if not _G._LM_CAdmins then 
		LambdaMod.printfc(0, "Sorry, but currently admin table isn't available right now.\n")
		return 
	end
	
	for k,v in pairs( _G._LM_CAdmins ) do
		LambdaMod.printfc(0, "%s\n", tostring( k ) )
	end
end )

RegConsoleCmd( "lambda", function( ply, cmd, arg )
	local tCmd = split( arg )
	if not tCmd[1] then
		LambdaMod.printfc(0, "Usage:\n")
		for k, v in pairs( LambdaMod.Registered ) do
			LambdaMod.printfc(0, "lambda %s %s\n", tostring( k ), tostring( ( v.helpArg or "" ) ) )
		end
		return
	end
    --if GetConVar("developer"):GetBool() then LambdaMod:printfc(1, "CMD: %s, Args: %s\n", tostring( tCmd[1] ), tostring( tCmd[2]) ) end
	LambdaMod.RunCommand( ply, tCmd[1], tCmd[2] )
end, "" )
