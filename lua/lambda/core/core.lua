--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LambdaMod.Core = {}
LambdaMod.Core.util = {}
LambdaMod.Core.blockedCon = {}

local Core = LambdaMod.Core;
local util = Core.util;
local blockedCon = Core.blockedCon;

---Add blacklist console command
---@param pName string
function Core.AddBlacklistCvar( pName )
	if ( blockedCon[ pName ] != nil ) then
		LambdaMod.printfc(3, "Core.AddBlacklistCvar: Command already registered! (%s)\n", tostring( pName ))
		return
	end
	blockedCon[ pName ] = true
end

---Runs console command to server directly
---@param cmd string
---@return nil
function Core.ForwardToConsole(cmd)
  if ( _SERVER || !_CLIENT ) then
	if ( blockedCon[ cmd ] != nil ) then 
		LambdaMod.printfc(3, "Core.ForwardToConsole: Command is blocked! (%s)\n", tostring( cmd ))
		return
	end
    engine.ServerCommand(cmd  .. "\n");
  end
end

---Prints message to player
---@param pPlayer CBasePlayer
---@param pHud number
---@param pString string
---@return nil
function util.CMsg( pPlayer, pHud, pString )
  if ( ToBaseEntity(pPlayer) == NULL && !pPlayer:IsPlayer() ) then
    return
  end
  UTIL.ClientPrint( pPlayer, pHud, pString );
end

---Prints message to everyone
---@param pHud number
---@param pString string
function util.CMsgAll( pHud, pString )
  UTIL.ClientPrintAll( pHud, pString );
end

---Prints server message to everyone
---@param pMsg string
function util.CSay( pMsg )
	util.CMsgAll( 3, string.format("%s : %s", tostring(LambdaMod.Settings.Console_Prefix), tostring(pMsg) ) );
end

