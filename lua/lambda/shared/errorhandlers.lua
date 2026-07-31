--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LambdaMod.ErrorHandlers = {}
local ErrorHandlers = LambdaMod.ErrorHandlers

function ErrorHandlers.throwBadArg( argnum, fnName, expected, data, throwLevel )
    throwLevel = throwLevel or 3

    local str = "bad argument"
    if argnum then
        str = str .. " #" .. tostring( argnum )
    end
    if fnName then
        str = str .. " to " .. fnName
    end
    if expected or data then
        str = str .. " ("
        if expected then
            str = str .. expected .. " expected"
        end
        if expected and data then
            str = str .. ", "
        end
        if data then
            str = str .. "got " .. type( data )
        end
        str = str .. ")"
    end

    error( str, throwLevel )
end

function LambdaMod.ProtectedCall( name, fn, ... ) 
    name = name or "?"
    local ok, out = pcall( fn, ... )
    if ( !ok ) then
        LambdaMod.error( "Runtime error in " .. name .. ": " .. out )
        return false, out
    else
        return true, out
    end        
end