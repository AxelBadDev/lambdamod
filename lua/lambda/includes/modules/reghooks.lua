--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

hook.add( "Host_Say", "LambdaHook_PlayerSay", function( pPlayer, msg, bTeamonly )
    return LambdaHook.Call( "PlayerSay", pPlayer, msg, bTeamonly )
end )

hook.add( "PlayerThink", "LambdaHook_PlayerThink", function( pPlayer )
    return LambdaHook.Call( "PlayerThink", pPlayer )
end )

hook.add( "GiveDefaultItems", "LambdaHook_GiveDefaultItems", function( pPlayer ) 
    return LambdaHook.Call( "GiveDefaultItems", pPlayer )
end )

hook.add( "PlayerSpawn", "LambdaHook_OnPlayerSpawn", function( pPlayer ) 
    return LambdaHook.Call( "OnPlayerSpawn", pPlayer )       
end)
