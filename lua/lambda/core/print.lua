--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Console print wrapper
--
--============================================================================--

local ConsoleColor = LambdaMod.ConsoleColor

function LambdaMod.LogAction(...)
    dbg.Log( "Action: " .. string.format(...) .. "\n")
end           

---Prints colored text
---@param pMode? number
---@vararg any
function LambdaMod.CPrint(pMode, ...)

	pMode = pMode or 0
    
    local text = ""
    local args = {...}
    if #args > 0 then
        text = text .. table.concat(args, " ")
    end

	if ( pMode == ConsoleColor.CONSOLE_DEFAULT ) then  
        dbg.ConMsg( tostring( text ) .. "\n" )
	elseif ( pMode == ConsoleColor.CONSOLE_CYAN ) then 
        dbg.ConColorMsg(LambdaMod.COLOR.CYAN, tostring( text ) .. "\n")
	elseif ( pMode == ConsoleColor.CONSOLE_WARNING ) then 
        dbg.ConColorMsg(LambdaMod.COLOR.WARNING, tostring( text ) .. "\n")
	elseif ( pMode == ConsoleColor.CONSOLE_ERROR ) then 
        dbg.ConColorMsg(LambdaMod.COLOR.RED, tostring( text ) .. "\n")
	elseif ( pMode == ConsoleColor.CONSOLE_LUAPLUS ) then 
        dbg.ConColorMsg(LambdaMod.COLOR.LUAPLUS, tostring( text ) .. "\n")
	elseif ( pMode == ConsoleColor.CONSOLE_GREEN ) then 
        dbg.ConColorMsg(LambdaMod.COLOR.GREEN, tostring( text ) .. "\n")
	elseif ( pMode == ConsoleColor.CONSOLE_BLUE ) then 
        dbg.ConColorMsg(LambdaMod.COLOR.BLUE, tostring( text ) .. "\n" )	
    elseif ( pMode == ConsoleColor.CONSOLE_ORANGE ) then 
        dbg.ConColorMsg(LambdaMod.COLOR.ORANGE, tostring( text ) .. "\n" )	    
    else 
        dbg.Warning( string.format( "UNDEFINED COLOR TABLE (%s)\n", tostring( pMode ) )) 
        return       
	end
end

---Prints formatted colored text
---@param pMode? number
---@vararg any
function LambdaMod.CPrintf(pMode, ...)

	pMode = pMode or 0
    
    local text = string.format( ... )

	if ( pMode == ConsoleColor.CONSOLE_DEFAULT ) then 
        dbg.ConMsg( text )
	elseif ( pMode == ConsoleColor.CONSOLE_CYAN ) then 
        dbg.ConColorMsg( LambdaMod.COLOR.CYAN, text )
	elseif ( pMode == ConsoleColor.CONSOLE_WARNING ) then 
        dbg.ConColorMsg( LambdaMod.COLOR.WARNING, text  )
	elseif ( pMode == ConsoleColor.CONSOLE_ERROR ) then 
        dbg.ConColorMsg( LambdaMod.COLOR.RED, text )
	elseif ( pMode == ConsoleColor.CONSOLE_LUAPLUS ) then 
        dbg.ConColorMsg( LambdaMod.COLOR.LUAPLUS, text )
	elseif ( pMode == ConsoleColor.CONSOLE_GREEN ) then 
        dbg.ConColorMsg( LambdaMod.COLOR.GREEN, text )
	elseif ( pMode == ConsoleColor.CONSOLE_BLUE ) then 
        dbg.ConColorMsg( LambdaMod.COLOR.BLUE, text )
    elseif ( pMode == ConsoleColor.CONSOLE_ORANGE ) then 
        dbg.ConColorMsg( LambdaMod.COLOR.ORANGE, text )    
    else 
        dbg.Warning( string.format( "UNDEFINED COLOR TABLE (%s)\n", tostring( pMode ) )) 
        return   
	end
end

--- Prints error text
---@vararg any
function LambdaMod.Error(...)
    local text = ""
    local args = {...}
    if #args > 0 then
        text = text .. table.concat(args, " ")
    end
    dbg.ConColorMsg( LambdaMod[ "COLOR" ].RED, tostring( text ) .. "\n" )
end  
  
---Prints cyan text
---@vararg any
function LambdaMod.SCprint(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].CYAN, tostring(...) .. "\n")
end

---Prints yellow text
---@vararg any
function LambdaMod.SYprint(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].WARNING, tostring(...) .. "\n")
end

---Prints red text
---@vararg any
function LambdaMod.SRprint(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].RED, tostring(...) .. "\n")
end

---Prints formatted cyan text
---@vararg any
function LambdaMod.SCprintf(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].CYAN, string.format(...))
end

---Prints formatted yellow text
---@vararg any
function LambdaMod.SYprintf(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].WARNING, string.format(...))
end

---@deprecated 
---Use CPrintf instead
---Prints formatted red text
---@vararg any
function LambdaMod.SRPrintf(...)
	dbg.ConColorMsg(LambdaMod["COLOR"].RED, string.format(...))
end

local function tobool( val )
	if ( val == nil || val == false || val == 0 || val == "0" || val == "false" ) then return false end
	return true
end

local state
if(SERVER) then
	state = "Server"
else
	state = "Client"
end

function LambdaMod.StatePrintf(pColor, ...) 
    pColor = pColor or LAMBDAMOD_CONSOLE_DEFAULT
    LambdaMod.CPrintf( 4, "%s \r", state );
    LambdaMod.CPrintf( pColor, ... );
end

LambdaMod.Printc = LambdaMod.CPrint
LambdaMod.Printfc = LambdaMod.CPrintf

LambdaMod.printc = LambdaMod.CPrint
LambdaMod.printfc = LambdaMod.CPrintf