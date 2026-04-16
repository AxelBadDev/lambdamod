--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose:
--]]

LambdaMod.Core = {}
LambdaMod.Core.util = {}
LambdaMod.Core.blockedCon = {}

local Core = LambdaMod.Core;
local util = Core.util;
local blockedCon = Core.blockedCon;

function Core.AddBlacklistCvar( pName )
	if ( blockedCon[ pName ] != nil ) then
		LambdaMod.printfc(3, "Core.AddBlacklistCvar: Command already registered! (%s)\n", tostring( pName ))
		return
	end
	blockedCon[ pName ] = true
end

function Core.ForwardToConsole(cmd)
  if ( _SERVER || !_CLIENT ) then
	if ( blockedCon[ cmd ] != nil ) then 
		LambdaMod.printfc(3, "Core.ForwardToConsole: Command is blocked! (%s)\n", tostring( cmd ))
		return
	end
    engine.ServerCommand(cmd  .. "\n");
  end
end

function util.CMsg( pPlayer, pHud, pString )
  if ( ToBaseEntity(pPlayer) == NULL && !pPlayer:IsPlayer() ) then
    return
  end
  UTIL.ClientPrint( pPlayer, pHud, pString );
end

function util.CMsgAll( pHud, pString )
  UTIL.ClientPrintAll( pHud, pString );
end

function util.CSay( pMsg )
	util.CMsgAll( 3, string.format("%s : %s", tostring(LambdaMod.Settings.Console_Prefix), tostring(pMsg) ) );
end

