--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose:   
--]]

if _CLIENT then return end

if _G.__LM_CCvar then return end
_G.__LM_CCvar = true

includeC( "lambdamod.lua" )
include( "lambda/core/core.lua" )
include( "lambda/core/shared.lua" )
includeC( "libadmin.lua" )

include( "lambda/config/admins.lua" )

local concommand = require( "concommand" )
LambdaMod = LambdaMod or {}
LambdaMod.cvar = {}
LambdaMod.cvar.Registered = {}
LambdaMod.cvar.registeredAdmin = {}
local registered = LambdaMod.cvar.Registered
local cvar = LambdaMod.cvar
local registeredAdmin = LambdaMod.cvar.registeredAdmin

function cvar.RegConsoleCmd(pName, pFn, pHelp, flags)
  if(registered[pName]) then 
    LambdaMod.SRprintf("%s Already registered\n", pName)
    return
  end
  
  registered[pName] = 
  {
    description = tostring( pHelp ) or "",
	  fn = pFn
  }
  
  concommand.Create(pName, pFn, pHelp, flags)
end

function cvar.RegAdminCmd( pName, pFn, pHelp, flags )
	if registered[ pName ] or registeredAdmin[ pName ] then 
		LambdaMod.SRprintf( "%s Already registered\n", pName )
        return
    end
    
    registeredAdmin[ pName ] = 
	{
    	description = "[ADMIN] " .. tostring( pHelp ),
    	fn = pFn
    }
    cvar.RegConsoleCmd( pName, function( pPlayer, pCmd, pArg )
    	local name = pPlayer:GetPlayerName();
    	local pCBack     
    	if not _G._LM_CAdmins[ name ] and not pPlayer:IsServer() then
    		LambdaMod.printfc( 3, "You don't have permission to use this command\n" );
    		return
    	end
    	pcall( registeredAdmin[ pName ].fn, pPlayer, pCmd, pArg )
    end, registeredAdmin[ pName ].description, flags )
   
end

function cvar.RegServerCmd( pName, pFn, pHelp, flags )
	if registered[ pName ] then 
		LambdaMod.SRprintf( "%s Already registered\n", pName )
	end
	
	--registered[ pName ] = {
		--description = tostring( pHelp ) or "",
		--fn = pFn
	--}
	
	cvar.RegConsoleCmd( pName, function( pPlayer, pCmd, pArg )
		if not pPlayer:IsServer() then return end
		
		pcall( registered[ pName ].fn, pPlayer, pCmd, pArg )
	end, registered[ pName ].description, flags )
end
  
function cvar.RemoveConsoleCmd(pName)
	if registeredAdmin[ pName ] then
		registeredAdmin[ pName ] = nil
		registered[ pName ] = nil
		concommand.Remove( pName )
	else
		registered[ pName ] = nil
		concommand.Remove( pName )
	end	
end

function cvar.SetValue( pCvar, pArg )
  local GetConVar = cvar.FindVar
	if _SERVER or not _CLIENT then
		assert( (type(pCvar) == "string"), "bad argument #1 to 'SetValue' (string expected got " .. type(pCvar) .. ")")
		assert( (type(pArg) == "string"), "bad argument #2 to 'SetValue' (string expected got " .. type(pArg) .. ")")
		GetConVar( pCvar ):SetValue( pArg )
	end
end