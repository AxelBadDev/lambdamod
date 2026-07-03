--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

local easyfs = require( "easyfs" )

if ( SERVER ) then
    include "lambda/init.lua"
else
    include "lambda/cl_init.lua"
end    