--========= Copyright (C) 2026 hedv948-source, All Rights Reserved =========--
--                                                      
-- Purpose:  GMED Lua implemention                                        
--                                                      
--==========================================================================--
local concommand = require( "concommand" )
--[[
concommand = concommand or {}

function concommand.Add(pName, pFn, pHelp, pFlags)
	concommand.Create(pName, pFn, pHelp, pFlags)
end
]]