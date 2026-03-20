--[[ 
   * Copyright (C) 2026 hedv948-source, All Rights Reserved
   * Purpose: Extenable Library
--]]
if _G.__LM_CExtend then return end
_G.__LM_CExtend = true

LambdaMod = LambdaMod or {}
LambdaMod.libExtend = {}
local libExtend = LambdaMod.libExtend

function libExtend.Extend( pLib, pName, pFn )
	if not pLib then
		LambdaMod.printfc( 3, "Library didn't specify\n" )
		return 
	end 
	if not LambdaMod[ pLib ] then 
		LambdaMod.printfc( 3, "Unknown Library: %s\n", tostring( pLib ) )
		return 
	end
	
	if LambdaMod[ pLib ][ pName ] ~= nil then 
		LambdaMod.printfc( 3, "%s already exist in %s\n", tostring( pName ), tostring( pLib ) )
		return
	end
	LambdaMod[ pLib ][ pName ] = pFn
end