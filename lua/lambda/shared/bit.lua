--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LambdaMod.bit = {}
local Lbit = LambdaMod.bit

function Lbit.bor(flags, ...)
    local args = {...}
    flags = flags or 0
    for _, v in ipairs( args ) do
        flags = bitty.bor( flags, v )
    end
    
    return flags 
end

        