--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Chat command registeration library
--
--============================================================================--
LambdaMod.CreateTable( false, "ChatCmds" )
LambdaMod.CreateTable( false, "ChatCmdAliases" )
LambdaMod.CreateVar( true, "String", "Prefix", "!" )

includeC "hook/chatcmdhook.lua"

local ChatCmds = LambdaMod.GetVar( "ChatCmds" ):GetTable()
local ChatCmdAliases = LambdaMod.GetVar( "ChatCmdAliases" ):GetTable()
local Prefix = LambdaMod.GetVar( "Prefix" ):GetString()

LambdaMod.ChatCmd = {}
local ChatCmd = LambdaMod.ChatCmd

function ChatCmd.AddCommand( name, func, desc, aliases )
    if ( ChatCmds[ name ] ) then
        LambdaMod.CPrintf( LambdaMod.ConsoleColor.CONSOLE_ERROR, "[LM] Warning! '%s' already registered!\n", name )
        return
    end    
    ChatCmds[ name ] = 
    {
       run = func,
       description = desc or "",
       admin = false
    };
    if aliases then
        for _, alias in ipairs( aliases ) do
            ChatCmdAliases[ string.lower( alias ) ] = name
        end
    end
end    

function ChatCmd.AddAdminCommand( name, func, desc, aliases )
    if ( ChatCmds[ name ] ) then
        LambdaMod.CPrintf( LambdaMod.ConsoleColor.CONSOLE_ERROR, "[LM] Warning! '%s' already registered!\n", name )
        return
    end    
    ChatCmds[ name ] = 
    {
       run = func,
       description = desc or "" ,
       admin = true
    };
    if aliases then
        for _, alias in ipairs( aliases ) do
            ChatCmdAliases[ string.lower( alias ) ] = name
        end
    end
end    
    
ChatCmd.AddCommand( "test", function( pPlayer, pCmd, pArgs ) 
    return "Hi :)";
end )    

ChatCmd.AddCommand( "help", function( pPlayer, pCmd, pArgs )
    local ply_name = pPlayer:GetPlayerName()
    
    local text = "Available commands:\n"
    for cmd, data in pairs( ChatCmds ) do
        if ( !LambdaMod.AdminCFG[ ply_name ] && !data.admin ) then
            text = text .. Prefix .. cmd .. " - " .. data.description .. "\n"
        else
            text = text .. Prefix .. cmd .. " - " .. data.description .. "\n"
        end
    end
    return text           
        
end, "List of all chat commands" )