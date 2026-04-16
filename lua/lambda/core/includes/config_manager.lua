--=== Copyright (C) 2026 hedv948-source, All rights reserved. ===--
--
-- Purpose: Read/Write configuration.
--
--===============================================================--
local tempPath = "config/lambdamod"

filesystem.CreateDirHierarchy( tempPath, "MOD" )

function LambdaMod.WriteAdminConfig( name, set )
    --assert( type( set ) == "table", "bad argument #1 to 'WriteAdminConfig' (table expected got "..type( set )..")")
    --UTF8 Encoded
    local buffer = {}
    buffer[name] = set;
    local KV = KeyValues( "Admins" );
    KV:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" );
    for name, data in pairs( buffer ) do
        local admin_kv = KeyValues( tostring( name ) );
        admin_kv:SetString( "admin", data );
        if ( KV:FindKey(tostring(cv)) != NULL_KEYVALUES ) then 
            KV:RemoveSubKey( KV:FindKey( tostring( name ) ) ) 
        end
        KV:AddSubKey( admin_kv );
    end    
    KV:SaveToFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ));
    KV:deleteThis();    
end    

function LambdaMod.LoadAdminConfig()
    local AdminCFG = KeyValues( "Admins" )
    AdminCFG:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" )
    
    LambdaMod.AdminCFG = AdminCFG:ToTable()
end    

function LambdaMod.LoadConfig()
    local Config = KeyValues( "LambdaMod" )
    Config:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "config" ), "MOD" )
    
    LambdaMod.CConfig = Config:ToTable()
end    

function LambdaMod.GetAdminTable()
    return LambdaMod.AdminCFG
end    
    
LambdaMod.LoadConfig()    
LambdaMod.LoadAdminConfig()    
    
    
    
    