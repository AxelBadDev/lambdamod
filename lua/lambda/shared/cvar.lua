--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Console command interface
--
--============================================================================--

LambdaMod.cvar = {}

local bitequal = require( "bitequal" )

local cvar = LambdaMod.cvar

local engine_cvar = _G['cvar']

local PrintMessage
if ( SERVER ) then
    PrintMessage = LambdaMod.Usermsg.PrintMessage
end
    
local HUD_PRINTCONSOLE = LambdaMod.Enum.HUD.PRINTCONSOLE

--- Registers engine ConVar
--- @param pName string
--- @param pValue string|number
--- @param flags? integer (bitwise)
--- @param pHelp? string
--- @return ConVar
function cvar.ConVar( pName, pValue, flags, pHelp )
    if( LambdaMod.console.registered[ pName ] ) then
        LambdaMod.CPrintf( 3, "[LM] Warning! '%s' already registered\n", pName )
        return
    end
    
    if ( CLIENT ) then
        flags = bit.bor( FCVAR.CLIENTDLL, ( flags or FCVAR.NONE ) ) 
    end        
   
    LambdaMod.console.registered[ pName ] = {}
    
    local convar = LambdaMod.console.registered[ pName ]
    convar.iscvar = true
    convar.desc = pHelp or ""
    convar.defvalue = pValue
    
    if ( SERVER ) then
        convar.__client_only = false
    else
        convar.__client_only = true    
    end    
    
   
    return ConVar( pName, pValue, flags, LambdaMod.console.registered[ pName ]['description'] )
end      

--- Register a console command Use console library instead
---@param pName string
---@param pFn function
---@param pHelp? string
---@param flags integer
function cvar.RegConsoleCmd( pName, pFn, pHelp, flags )
    LambdaMod.RegConsoleCmd( pName, pFn, pHelp, flags )
end



local function tobool( val )
	if ( val == nil || val == false || val == 0 || val == "0" || val == "false" ) then return false end
	return true
end

--- Register an admin console command
---@param pName string
---@param pFn function
---@param pHelp? string
---@param flags? integer
function cvar.RegAdminCmd( pName, pFn, pHelp, flags )
    LambdaMod.RegAdminCmd( pName, pFn, pHelp, flags )
end


--- Register a server console command (wrapper) (backwards compatibility)
---@param pName string
---@param pFn function
---@param pHelp? string
---@param flags? integer
function cvar.RegServerCmd( pName, pFn, pHelp, flags )
    LambdaMod.RegServerCmd( pName, pFn, pHelp, flags )
end
  
function cvar.SetValue( pCaller, cvarStr, value )
    
    assert( (type( cvarStr ) == "string"), "bad argument #1 to 'SetValue' (string expected got " .. type( cvarStr ) .. ")")
	--assert( (type( value ) == "string"), "bad argument #2 to 'SetValue' (string expected got " .. type(pArg) .. ")")
    if ( _G.cvar && _G.cvar.FindVar ) then
        local ok, pCvar = pcall( _G.cvar.FindVar, cvarStr )
        if ( !pCvar:IsCommand()) then
        --    PrintMessage( pCaller, HUD_PRINTCONSOLE, string.format(
        --        "SetValue: Unknown command: %s\n", cvarStr )
           -- )    
            --return
        end
        pCvar:SetValue( tostring( value ) )   
    end
end