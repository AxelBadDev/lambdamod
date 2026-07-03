--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

hook.add( "Host_Say", "LambdaHook_PlayerSay", function( pPlayer, msg, bTeamonly )
    return LambdaMod.Hook.Run( "PlayerSay", pPlayer, msg, bTeamonly )
end )

hook.add( "PlayerThink", "LambdaHook_PlayerThink", function( pPlayer )
    return LambdaMod.Hook.Run( "PlayerThink", pPlayer )
end )

hook.add( "GiveDefaultItems", "LambdaHook_GiveDefaultItems", function( pPlayer ) 
    return LambdaMod.Hook.Run( "GiveDefaultItems", pPlayer )
end )

hook.add( "PlayerSpawn", "LambdaHook_OnPlayerSpawn", function( pPlayer ) 
    return LambdaMod.Hook.Run( "OnPlayerSpawn", pPlayer )       
end)
