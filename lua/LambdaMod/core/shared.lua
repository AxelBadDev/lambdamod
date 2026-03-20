if _G.__LM_CShared then return end
_G.__LM_CShared = true

include( "LambdaMod/shared/defines.lua" )
include( "LambdaMod/config/admins.lua" )

LambdaMod = LambdaMod or {}
LambdaMod._INTERNAL = {}

LambdaMod.INFO = 
{
	_VERSION     = _G. _DEFINES._VERSION or "fallback-alpha",  --"1.5",
	_BRANCH      = _G._DEFINES._BRANCH or "Unknown",
	_DEVELOPMENT = _G._DEFINES._DEVELOPMENT or true,
	_BUILD       = _G._DEFINES._BUILD or "0",

	_BUILD_DATE  = string.format( 
		"%s %s %s",	
		tostring(( _G._DEFINES._BUILD_DATA.month or "Jan" )), 
		tostring(( _G._DEFINES._BUILD_DATA.day or "1" )), 
		tostring(( _G._DEFINES._BUILD_DATA.year or "1970" )) 
	)
}

LambdaMod._COLOR = {}

LambdaMod._COLOR.CYAN    = Color(0, 255, 255, 255)
LambdaMod._COLOR.WARNING = Color(255, 255, 0, 255)
LambdaMod._COLOR.ERR     = Color(255, 0, 0, 255)
LambdaMod._COLOR.LUAPLUS = Color(255, 120, 255, 255)
LambdaMod._COLOR.GREEN   = Color(0, 255, 0, 255)
LambdaMod._COLOR.INFO    = Color(0, 100, 255, 255)

function LambdaMod.printc(pMode, ...)

	if not pMode or pMode == nil then return end

	if pMode == 0 then  dbg.ConMsg( tostring( ... ) .. "\n" )
	elseif pMode == 1 then dbg.ConColorMsg(LambdaMod._COLOR.CYAN, tostring(...) .. "\n")
	elseif pMode == 2 then dbg.ConColorMsg(LambdaMod._COLOR.WARNING, tostring(...) .. "\n")
	elseif pMode == 3 then dbg.ConColorMsg(LambdaMod._COLOR.ERR, tostring(...) .. "\n")
	elseif pMode == 4 then dbg.ConColorMsg(LambdaMod._COLOR.LUAPLUS, tostring(...) .. "\n")
	elseif pMode == 5 then dbg.ConColorMsg(LambdaMod._COLOR.GREEN, tostring(...) .. "\n")
	elseif pMode == 6 then dbg.ConColorMsg(LambdaMod._COLOR.INFO, "[INFO] " .. tostring(...) .. "\n" )	
	end
end
--[[

	0 == CYAN
	1 == YELLOW
	2 == RED
	3 == RED
	4 == PURPLE/LUAPLUS

]]
function LambdaMod.printfc(pMode, ...)

	if not pMode or pMode == nil then return end

	if pMode == 0 then dbg.ConMsg( string.format( ... ) )
	elseif pMode == 1 then dbg.ConColorMsg(LambdaMod._COLOR.CYAN, string.format(...))
	elseif pMode == 2 then dbg.ConColorMsg(LambdaMod._COLOR.WARNING, string.format(...) )
	elseif pMode == 3 then dbg.ConColorMsg(LambdaMod._COLOR.ERR, string.format(...) )
	elseif pMode == 4 then dbg.ConColorMsg(LambdaMod._COLOR.LUAPLUS, string.format(...))
	elseif pMode == 5 then dbg.ConColorMsg(LambdaMod._COLOR.GREEN, string.format(...))
	elseif pMode == 6 then dbg.ConColorMsg(LambdaMod._COLOR.INFO, "[INFO] " .. string.format(...))
	end
end

function LambdaMod.SanitizeCommandName(name)
    name = string.lower(name or "plugin")
    name = string.gsub(name, "%s+", "_")
    name = string.gsub(name, "[^a-z0-9_]", "")
    return "sm_" .. name
end


function LambdaMod.SCprint(...)
	dbg.ConColorMsg(LambdaMod._COLOR.CYAN, tostring(...) .. "\n")
end

SCprint = LambdaMod.SCprint

function LambdaMod.SYprint(...)
	dbg.ConColorMsg(LambdaMod._COLOR.WARNING, tostring(...) .. "\n")
end

SYprint = LambdaMod.SYprint

function LambdaMod.SRprint(...)
	dbg.ConColorMsg(LambdaMod._COLOR.ERR, tostring(...) .. "\n")
end

SRprint = LambdaMod.SYprint

--======= printf

function LambdaMod.SCprintf(...)
	dbg.ConColorMsg(LambdaMod._COLOR.CYAN, string.format(...))
end

SCprintf = LambdaMod.SCprintf

function LambdaMod.SYprintf(...)
	dbg.ConColorMsg(LambdaMod._COLOR.WARNING, string.format(...))
end

SYprintf = LambdaMod.SYprintf

function LambdaMod.SRPrintf(...)
	dbg.ConColorMsg(LambdaMod._COLOR.ERR, string.format(...))
end

SRprintf = LambdaMod.SRprintf

function LambdaMod.GPrint(cMode, ...)
	if(_CLIENT) then LambdaMod.printc(cMode, "[LM][CLIENT]: " .. string.format(...) )
	elseif(_SERVER) then SRprintf("[LM][SERVER]: '%s' is already registered\n", tostring(pName))
	end
end
--return LambdaMod