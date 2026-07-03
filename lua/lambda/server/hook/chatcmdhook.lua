--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: (LunarAdmin fork)
--
--============================================================================--

local ChatCmds = LambdaMod.GetVar( "ChatCmds" ):GetTable()
local ChatCmdAliases = LambdaMod.GetVar( "ChatCmdAliases" ):GetTable()
local Prefix = LambdaMod.GetVar( "Prefix" ):GetString()

local PrintMessage = LambdaMod.Usermsg.PrintMessage
local HUD_PRINTCONSOLE = LambdaMod.Enum.HUD.PRINTCONSOLE
local HUD_PRINTTALK = LambdaMod.Enum.HUD.PRINTTALK

local fmt = string.format

local function tobool( val )
	if ( val == nil || val == false || val == 0 || val == "0" || val == "false" ) then return false end
	return true
end

hook.add( "Host_Say", "LambdaModHandleCommand", function( pPlayer, msg, teamonly )
	msg = msg:gsub( '^"(.*)"$', '%1' )

    if ( !msg || msg:sub( 1, #Prefix ) != Prefix ) then
        --print( "[LunarAdmin] parsing message \"" .. msg .. "\" but not command." )
		--print( "if you're a server owner, you can safely ignore this." )

		-- we return true for the code to continue sending the message
        return true
    end

	-- TODO: think of a more secure way of do this since we do not have steam id's
    local parts = {}
    for word in msg:sub( #Prefix + 1 ):gmatch( "%S+" ) do
        table.insert( parts, word )
    end

    local cmdName = string.lower( parts[1] or "" )
    table.remove( parts, 1 )

    if ChatCmdAliases[ cmdName ] then
        cmdName = ChatCmdAliases[ cmdName ]
    end

    local cmd = ChatCmds[ cmdName ]
    
    if cmd then
        LambdaMod.Hook.Run( "OnChatCommand", pPlayer, cmdName, parts )
        local name = pPlayer:GetPlayerName()
        LambdaMod.LogAction( "%s ran command %s", name, cmdName  )
        if ( cmd.admin && !tobool( LambdaMod.AdminCFG[ name ].admin ) ) then
            LambdaMod.LogAction( "%s tried to use an admin command but isn't an admin", name )
            UTIL.ClientPrint(pPlayer, 3, "[LM] You don't have permission to use this command")
        end
    
        local ok, result = pcall( cmd.run, pPlayer, parts )
        
        if ( !ok ) then
            PrintMessage( pPlayer, HUD_PRINTTALK, fmt("[LM] Error! Failed to run '%s' : %s\n", tostring( cmdName ), tostring( result )))
            PrintMessage( pPlayer, HUD_PRINTRALK, "If you see this, please report to the server administrator.")
            return false
        end
        
        if result then
            LambdaMod.LogAction( "[LM] %s", tostring( result ))
            if #result > 255 then
            	UTIL.ClientPrint( pPlayer, 3, "[LM] Message is over 255 bytes. Please open console.")
                dbg.Msg( tostring( result ) .. "\n" )
                --return ""
            else
            	UTIL.ClientPrint( pPlayer, 3, fmt("[LM] %s", tostring( result ) ))
                --return 
            end
            --return ""
        end
    else
        UTIL.ClientPrint( pPlayer, 3, fmt("[LM] Unknown command: %s", tostring( cmdName ) ) )
        --return ""
    end
end )