--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Console interface 
--
--============================================================================--

local concommand = require "concommand"

LambdaMod.console = {}
LambdaMod.console.registered = {}
LambdaMod.consolegisteredAdmin = {}

local PrintMessage

if SERVER then
    PrintMessage = LambdaMod.Usermsg.PrintMessage
end

local HUD_PRINTCONSOLE = LambdaMod.Enum.HUD.PRINTCONSOLE

local function tobool( val )
	if ( val == nil || val == false || val == 0 || val == "0" || val == "false" ) then return false end
	return true
end

--- Registers a console command
---@param pName string
---@param pFn function
---@param pHelp? string
---@param flags integer
function LambdaMod.RegConsoleCmd( pName, pFn, pHelp, flags ) 
    if( LambdaMod.console.registered[ pName ] ) then
        LambdaMod.CPrintf( 3, "[LM] Warning! '%s' already registered\n", pName)
        return
    end
    
    if ( CLIENT ) then
        flags = bit.bor( FCVAR.CLIENTDLL, ( flags or FCVAR.NONE ) ) 
    end        
   
    
    LambdaMod.console.registered[ pName ] = {}
    local regCmd = LambdaMod.console.registered[ pName ]
    regCmd.description = pHelp or ""
    regCmd.fn = pFn
    regCmd.iscvar = false
    regCmd.admin = false
    if ( SERVER ) then
        regCmd.__client_only = false
    else
        regCmd.__client_only = true
    end        
    
    local fnCallback = LambdaMod.console.registered[ pName ]
    
    concommand.Create( pName, function( pPlayer, pCmd, pArgs )
        if fnCallback then
            local ok, out = pcall( fnCallback.fn, pPlayer, pCmd, pArgs )
            if ( !ok && out ) then
                LambdaMod.CPrintf( "Failed to run '%s': %s\n")
                return
            end
        end         
    end, fnCallback.description, flags )
end


--- Registers an admin command.
---@param pName string
---@param pFn function
---@param pHelp? string
---@param flags integer
if ( SERVER ) then
function LambdaMod.RegAdminCmd( pName, pFn, pHelp, flags ) 
    if( LambdaMod.console.registered[ pName ] ) then
        LambdaMod.CPrintf( 3, "[LM] Warning! '%s' already registered\n", pName)
        return
    end
    
    LambdaMod.console.registered[ pName ] = {
        description = pHelp or "",
        fn = pFn,
        iscvar = false,
        admin = true,
        __client_only = false
    }
    
    local fnCallback = LambdaMod.console.registered[ pName ]
    
    concommand.Create( pName, function( pPlayer, pCmd, pArgs )
        if ( fnCallback.admin && ToBaseEntity( pPlayer ) != NULL && !tobool( LambdaMod.GetAdminTable()[ pPlayer:GetPlayerName() ]['admin'] ) && !pPlayer:IsServer()  ) then
            PrintMessage( pPlayer, HUD_PRINTCONSOLE, "You don't have permission to use this command" );
            return
        end
        if fnCallback then
            local ok, out = pcall( fnCallback.fn, pPlayer, pCmd, pArgs )
            if ( !ok && out ) then
                LambdaMod.CPrintf( 3, "Failed to run '%s': %s\n", pCmd, out )
                return
            end
        end         
    end, fnCallback.description, flags )
end
else
    function LambdaMod.RegAdminCmd( pName, pFn, pHelp, flags ) error( "Admin command can't be registered in client-side.", 2 ) end
end 
   
--- Registers a server command
---@param pName string
---@param pFn function
---@param pHelp? string
---@param flags integer
if SERVER then
function LambdaMod.RegServerCmd( pName, pFn, pHelp, flags ) 
    if( LambdaMod.console.registered[ pName ] ) then
        LambdaMod.CPrintf( 3, "[LM] Warning! '%s' already registered\n", pName)
        return
    end
    
    LambdaMod.console.registered[ pName ] = {
        description = pHelp or "",
        fn = pFn,
        iscvar = false,
        admin = true,
        __client_only = false
    }
    
    local fnCallback = LambdaMod.console.registered[ pName ]
    concommand.Create( pName, function( pPlayer, pCmd, pArgs )
        if ( !pPlayer:IsServer()  ) then
            return
        end
        if fnCallback then
            local ok, out = pcall( fnCallback.fn, pPlayer, pCmd, pArgs )
            if ( !ok && out ) then
                LambdaMod.CPrintf( 3, "Failed to run '%s': %s\n", pCmd, out )
                return
            end
        end         
    end, fnCallback.description, flags )
end
else
    function LambdaMod.RegServerCmd( pName, pFn, pHelp, flags ) error( "Server command can't be registered in client-side.", 2 ) end
end    