--=== Copyright (C) 2026 hedv948-source, All rights reserved. ===--

local tempPath = "config/lambdamod"

filesystem.CreateDirHierarchy( tempPath, "MOD" )

function LambdaMod.WriteAdminConfig( name, set )
    return;
end    

function LambdaMod.LoadAdminConfig()
    local AdminCFG = KeyValues( "Admins" )
    AdminCFG:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admin" ), "MOD" )
    
    LambdaMod.AdminCFG = AdminCFG:ToTable()
end    
    
LambdaMod.LoadAdminConfig()    
    
    
    
    