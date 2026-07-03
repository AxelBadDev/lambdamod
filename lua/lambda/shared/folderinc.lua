--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--
LambdaMod.__mod_includes = {}

function LambdaMod.AddInclude( path )
    table.insert( LambdaMod.__mod_includes, path )
end  

function LambdaMod._INCLUDEALL()  
    for _, path in ipairs(LambdaMod.__mod_includes) do
        includeC( path )
    end
end
        
function LambdaMod.IncludeFolder( path )
    local state
    if(SERVER) then
        state = "Server"
    elseif (CLIENT) then
        state = "Client"
    end
    
    local fullPath = "lua/" .. path .. "/"
    local fullPath_2 = path .. "/"
    
    local files = easyfs.Find( fullPath .. "*.lua", "MOD" )
    
    if( !files && #files == 0 ) then
        dbg.Warning( "No files found in '"..fullPath.."'\n" )
        return
     end 
       
    for _, v in ipairs( files ) do
        LambdaMod.CPrintf( 4, "[LM] %s ", state )
        LambdaMod.CPrintf( 0, "included %s.\n", ( fullPath_2 .. v ) )
        include(  fullPath_2 ..  v )
    end
end        