--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose:
--]]
if _G.__LIBCLAMBDA then return end
_G.__LIBCLAMBDA = true

include( "lambda/core/defines.lua" )
include( "lambda/core/shared.lua" )

LambdaMod = _G.LambdaMod or {}

CLambda = _G.CLambda or {}
CLambda.cvar = {}
CLambda.cvar.Registered = {}

local concommand = require( "concommand" )

function CLambda.cvar.RegClientCmd( pName, pFn, pHelp, flags )
	if CLambda.cvar.Registered[ pName ] then 
		LambdaMod.printfc( 0, "RegClientCmd: Command already registered! (%s)\n", pName )
		return
	end
	
	CLambda.cvar.Registered[ pName ] = true
	concommand.Create( pName, pFn, pHelp, flags )
end
	
function CLambda.cvar.RemoveConsoleCmd( pName )
	if not CLambda.cvar.Registered[ pName ] then
		LambdaMod.printfc( 0, "RemoveConsoleCmd: Unknown command! (%s)\n", pName )
		return
	end
	
	CLambda.cvar.Registered[ pName ] = nil
	concommand.Remove( pName )
end
