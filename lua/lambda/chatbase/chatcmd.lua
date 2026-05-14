--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Chat command registeration library
--
--============================================================================--
LambdaMod.CreateTable( false, "ChatCmds" )
LambdaMod.CreateTable( false, "ChatCmdAliases" )
LambdaMod.CreateVar( true, "Prefix", "String", "!" )

local ChatCmds = LambdaMod.GetVar( "ChatCmds" ):GetTable()
local ChatCmdAliases = LambdaMod.GetVar( "ChatCmdAliases" ):GetTable()

LambdaMod.ChatCmd = {}
local ChatCmd = LambdaMod.ChatCmd

function ChatCmd.AddCommand( name, func, desc, aliases )
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
    
ChatCmd.AddCommand( "test", function( pPlayer, pArgs ) 
    return "Hi :)";
end )    