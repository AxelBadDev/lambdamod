--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LambdaMod.Usermsg = {}

local usermsg = LambdaMod.Usermsg

function usermsg.CSay( pPlayer, pText )
    if ( ToBaseEntity( pPlayer ) == NULL ) then return end
    net.Start( "DrawHintMsg" )
        net.WriteString( tostring( pText ) )
    net.Send( pPlayer )
end        