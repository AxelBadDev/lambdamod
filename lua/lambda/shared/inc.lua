--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

includeC "defines.lua"
includeC "bit.lua"
includeC "globals.lua"
includeC "enum.lua"
includeC "print.lua"
includeC "config.lua"
includeC "core.lua"
includeC "concmd_split.lua"
includeC "info.lua"
includeC "folderinc.lua"
includeC "varlib.lua"
includeC "errorhandlers.lua"

if SERVER then
includeC "usermsg.lua"
end

includeC "console.lua"
includeC "cvar.lua"
includeC "conmsgcfg.lua"

includeC "sandbox.lua"