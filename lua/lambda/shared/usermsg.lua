--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LambdaMod.Usermsg = {}

local umsg = LambdaMod.Usermsg
local HUD = LambdaMod.Enum.HUD

--[[
function usermsg.CSay( pPlayer, pText )
    if ( ToBaseEntity( pPlayer ) == NULL ) then return end
    net.Start( "DrawHintMsg" )
        net.WriteString( tostring( pText ) )
    net.Send( pPlayer )
end    
]]

if( SERVER ) then
function umsg.PrintMessageAll( hud_type, message )
    UTIL.ClientPrintAll( hud_type, message )
end      

function umsg.PrintMessage( pPlayer, hud_type, message )
    UTIL.ClientPrint( pPlayer, hud_type, message )
end  
end  