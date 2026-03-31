--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose:
--]]
require( "concommand" )

local concommand = concommand

function concommand.Add( pName, pFn, pHelp, flags)
	concommand.Create( pName, pFn, ( pHelp or "" ), flags )
end