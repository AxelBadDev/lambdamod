function RunConsoleCommand(cmd, ...)
    if not cmd then return end

    local args = {...}
    if #args > 0 then
        cmd = cmd .. " " .. table.concat(args, " ")
    end

    if ( CLIENT ) then
        engine.ClientCmd(cmd)
    elseif ( SERVER ) then
        engine.ServerCommand( cmd .. "\n" )
    end        
end