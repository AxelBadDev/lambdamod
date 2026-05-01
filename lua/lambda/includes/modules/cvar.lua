--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose:   
--]]

LambdaMod.cvar = {}
LambdaMod.cvar.Registered = {}
LambdaMod.cvar.registeredAdmin = {}

local registered = LambdaMod.cvar.Registered
local cvar = LambdaMod.cvar
local registeredAdmin = LambdaMod.cvar.registeredAdmin

function cvar.RegConsoleCmd(pName, pFn, pHelp, flags)
  if(registered[pName]) then 
    LambdaMod.CPrintf( 3, "%s Already registered\n", pName)
    return
  end
  
  registered[pName] = 
  {
    description = tostring( pHelp ) or "",
	fn = pFn
  }
  
  concommand.Create(pName, pFn, pHelp, flags)
end

local function tobool( val )
	if ( val == nil || val == false || val == 0 || val == "0" || val == "false" ) then return false end
	return true
end

function cvar.RegAdminCmd( pName, pFn, pHelp, flags )
	if ( registered[ pName ] || registeredAdmin[ pName ] ) then 
		LambdaMod.CPrintf( 3, "%s Already registered\n", pName )
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
    	if ( ToBaseEntity( pPlayer ) != NULL && !tobool( LambdaMod.AdminCFG[ pPlayer:GetPlayerName() ].admin ) && !pPlayer:IsServer() ) then
    		LambdaMod.printfc( 3, "You don't have permission to use this command\n" );
    		return
    	end
    	pcall( registeredAdmin[ pName ].fn, pPlayer, pCmd, pArg )
    end, registeredAdmin[ pName ].description, flags )
   
end

function cvar.RegServerCmd( pName, pFn, pHelp, flags )
	if registered[ pName ] then 
		LambdaMod.CPrintf( 3, "%s Already registered\n", pName )
        return
	end
	
	registered[ pName ] = {
		description = tostring( pHelp ) or "",
		fn = pFn
	}
	
	concommand.Create( pName, function( pPlayer, pCmd, pArg )
		if ( !pPlayer:IsServer() ) then return end
		
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

function cvar.SetValue( cvarStr, value )
	if ( CLIENT ) then
		return
	end
    
    assert( (type( cvarStr ) == "string"), "bad argument #1 to 'SetValue' (string expected got " .. type(pCvar) .. ")")
	--assert( (type( value ) == "string"), "bad argument #2 to 'SetValue' (string expected got " .. type(pArg) .. ")")
	local pCvar = cvar.FindVar( cvarStr )
    if ( !pCvar ) then
        LambdaMod.Printfc(3, "SetValue: Unknown command: %s\n", cvarStr )
        return
    end
    pCvar:SetValue( tostring( value ) )    
end