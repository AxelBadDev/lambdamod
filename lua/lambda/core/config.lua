--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Configuration loader for LambdaMod
--
--============================================================================--

local easyfs = require( "easyfs" )
local tempPath = "config/lambdamod"

filesystem.CreateDirHierarchy( tempPath, "MOD" )

local function formattedPath( name )
    if not name or name == "" then return nil end
    return string.format( tostring( tempPath .. "/%s.cfg" ), tostring( name ) )
end

function LambdaMod.CreateNewConfig( name )
    if ( !name || name == "" ) then return end
    if ( easyfs.Exists( tempPath .. "/" .. name:lower() ) ) then
        LambdaMod.CPrintf( 3, "Config '%s' already exists.\n", name )
        return
    end
    
    local name_lower = name:lower()
        
    local config = KeyValues( name )
    config:SaveToFile( formattedPath( name_lower ) );
    config:deleteThis();
end        

function LambdaMod.WriteConfig( name, key, value )
    if ( !name || name == "" ) then return end
    if ( !easyfs.Exists( tempPath .. "/" .. name:lower() ) ) then
        LambdaMod.CPrintf( 3, "File '%s' doesn't exists.\n", name )
        return
    end
    
    local name_lower = name:lower()
    local config = KeyValues( name )
    config:LoadFromFile( formattedPath( name_lower ) )
    if ( type( value ) == "table" ) then
        config:AddSubKey( table.tokeyvalues( value, key ) );
    elseif ( type( value ) == "string" ) then
        config:SetString( key, value );
    elseif ( type( value ) == "number" ) then
        config:SetFloat( key, value );
    elseif ( type( value ) == "color" ) then 
        config:SetColor( key, value )
    else
        config:SetString( key, tostring( value ) )
    end
    
    config:SaveToFile( formattedPath( name_lower ) )
    config:deleteThis();
end                      
        
function LambdaMod.WriteAdminLegacyConfig( name, set )
    --assert( type( set ) == "table", "bad argument #1 to 'WriteAdminConfig' (table expected got "..type( set )..")")
    --UTF8 Encoded
    local buffer = {}
    buffer[name] = set 
    local KV = KeyValues( "Admins" );
    KV:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" );
    for cv, data in pairs( buffer ) do
        local admin_kv = KeyValues( tostring( name ) );
        admin_kv:SetString( "admin", data );
        if ( KV:FindKey(tostring( name )) != NULL_KEYVALUES ) then 
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

function LambdaMod.AddAdmin( name, permission, group )
    permission = permission or 0
    group = group or 0
    local admins = KeyValues( "Admins" );
    admins:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" );
    local admin = admins:FindKey( name )
        
    if ( admin != NULL_KEYVALUES ) then
        dbg.Warning("Admin already exist.\n")
        return
    else
        local admin = KeyValues(name)
        admin:SetString("admin", "1")
        admin:SetString("permission", tostring(permission))
        admin:SetString("group", tostring(group))
        admins:AddSubKey( admin )    
    end
    
    admins:SaveToFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" );
    admins:deleteThis();
    
    LambdaMod.LoadAdminConfig() -- Refresh
end    

function LambdaMod.RemoveAdmin( name )
    local admins = KeyValues( "Admins" );
    admins:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" );
    local admin = admins:FindKey( name )
        
    if ( admin != NULL_KEYVALUES ) then
        admins:RemoveSubKey( admin )
    else
        dbg.Warning("Admin '" .. name .. "' doesn't exist.\n")
    end
    
    admins:SaveToFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" );
    admins:deleteThis();
    
    LambdaMod.LoadAdminConfig()
end    
    
function LambdaMod.WriteAdminConfig( name, key, set )
    local admins = KeyValues( "Admins" );
    admins:LoadFromFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ), "MOD" )
        
    local admin = admins:FindKey( name )
    
    if ( admin != NULL_KEYVALUES ) then
        admin:SetString( key, tostring(set) )
    else
        local admin = KeyValues( tostring(name) )
        admin:SetString( "admin", "1" )
        admin:SetString( "permission", "0" )
        admin:SetString( "group", "0" )
        admins:AddSubKey( admin )    
    end   
        
    --if ( admins:FindKey( tostring( name ) ) != NULL_KEYVALUES ) then 
        --admins:RemoveSubKey( AdminsKV:FindKey( tostring( name ) ) ) 
    --end
    --AdminsKV:AddSubKey( admin_info );
    admins:SaveToFile( string.format( tostring( tempPath .. "/%s.cfg" ), "admins" ));
    admins:deleteThis(); 
    
    LambdaMod.LoadAdminConfig();   
end    

function LambdaMod.GetAdminTable()
    return LambdaMod.AdminCFG
end    

function LambdaMod.GetConfig()
    return LambdaMod.CConfig
end    
    
LambdaMod.LoadConfig()    
LambdaMod.LoadAdminConfig()   