--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Admib command argument parser
--
--============================================================================--
LambdaMod.LibAdmin = {}
local LibAdmin = LambdaMod.LibAdmin

function LibAdmin.CheckCommandAccess( pPlayer, pCmd, flag ) end

--- Parse player commands
---@param arg string
---@param caller CBasePlayer
---@return CBasePlayer[]
function LibAdmin.ParseTargets( arg, caller )
    local results = {}

    if not arg or arg == "" then
        return results
    end

    local lowerArg = string.lower( arg )

    -- helper to add if not already present
    local addIfUnique = function( p )
        for _, existing in ipairs( results ) do
            if existing == p then return end
        end
        table.insert( results, p )
    end

    -- quick special words
    if lowerArg == "me" then
        if caller then addIfUnique( caller ) end
        return results
    end

    if lowerArg == "all" then
        for i = 1, gpGlobals.maxClients() do
            local ply = UTIL.PlayerByIndex( i )
            if ply then addIfUnique( ply ) end
        end
        return results
    end

    if lowerArg == "others" then
        for i = 1, gpGlobals.maxClients() do
            local ply = UTIL.PlayerByIndex( i )
            if ply and ply ~= caller then addIfUnique( ply ) end
        end
        return results
    end
    
    if ( lowerArg == "bots" ) then
        for i = 1, gpGlobals.maxClients() do
            local ply = UTIL.PlayerByIndex( i )
            if ( ply && ply:IsBot() ) then addIfUnique( ply ) end
        end
        return results
    end    
    
    if ( lowerArg == "alive" ) then
        for i = 1, gpGlobals.maxClients() do
            local ply = UTIL.PlayerByIndex( i )
            if ( ply && ply:IsAlive() ) then addIfUnique( ply ) end
        end
        return results
    end 
    
    if ( lowerArg == "dead" ) then
        for i = 1, gpGlobals.maxClients() do
            local ply = UTIL.PlayerByIndex( i )
            if ( ply && !ply:IsAlive() ) then addIfUnique( ply ) end
        end
        return results
    end    

    -- numeric index e.g. "!target 3"
    local idx = tonumber( arg )
    if idx then
        local ply = UTIL.PlayerByIndex( idx )
        if ply then addIfUnique( ply ) end
        return results
    end

    -- name matching: prefer exact match, else collect partial matches
    local partialMatches = {}

    for i = 1, gpGlobals.maxClients() do
        local ply = UTIL.PlayerByIndex( i )
        if ply then
            local pname = ply:GetPlayerName() or ""
            local lowerName = string.lower( pname )

            if lowerName == lowerArg then
                -- exact match: return immediately (most likely desired)
                addIfUnique( ply )
                return results
            end

            if string.find( lowerName, lowerArg, 1, true ) then
                table.insert( partialMatches, ply )
            end
        end
    end

    -- return partial matches (may be zero or multiple)
    for _, p in ipairs( partialMatches ) do addIfUnique( p ) end
    return results
end

