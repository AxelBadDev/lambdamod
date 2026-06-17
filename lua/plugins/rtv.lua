--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

PLUGIN:myinfo {
    name = "RTV",
    description = "Rock the Vote for HL2SB++",
    version = "1.0",
    api = LAMBDAMOD_API_VERSION,
    author = "AxelBadDev",
    url = ""
}

PLUGIN:Import( "LambdaMod" )
PLUGIN:Import( "ChatCmd" )

local function concmd_bor( t )
    assert( type( t ) == "table", "bad argument #1 'concmd_bor' (table expected got " .. type( t ) .. ")" )
    local flags = 0
    
    for _, v in ipairs( t ) do
        flags = bitty.bor( flags, v )
    end 
    
    return flags
end

function round( value )
  return math.floor(value + 0.5)
end  


local g_Cvar_needed
local g_Cvar_changeTime

function PLUGIN:PrePluginStart() 
    g_Cvar_needed = ConVar( "lambda_rtv_needed", "0.60", concmd_bor { FCVAR.NOTIFY, FCVAR.REPLICATED }, "Percentage of players needed to rockthevote (Def 60%)" )
    g_Cvar_changeTime = ConVar( "lambda_rtv_changetime", "120.0", concmd_bor { FCVAR.NOTIFY, FCVAR.REPLICATED }, "Timer (in seconds) before map changing (Def 120 seconds)" )
end

local RTV = {}
RTV['maps'] = {}
RTV['g_Voted'] = {}
RTV['selectedMap'] = {}
RTV['totalVotes'] = 0
RTV['voteCountdown'] = 300
RTV['voteInProgress'] = false

function table_count( t )
	local i = 0
	for k in pairs( t ) do i = i + 1 end
	return i
end

function table_random( t )
	local rk = math.random( 1, table_count( t ) )
	local i = 1
	for k, v in pairs( t ) do
		if ( i == rk ) then return v, k end
		i = i + 1
	end
end

function RTV:LoadMap()
    local maps = easyfs.Find( "maps/*.bsp", "GAME" )
    
    for _, map in ipairs(maps) do
        map = map:sub(1, -5);
        dbg.Msg( "Loaded map: " .. map .. "\n" )
        table.insert( self['maps'], map )
    end
    
    table.sort( self['maps'] )
end   

function RTV:GetCurrentSelectedMap()
    for k, v in pairs( self['selectedMap'] ) do
        if ( v != nil ) then
            return k
        end  
    end
    return nil
end    
     
local function admin_StartVoteMap( pPlayer, pCmd, pArg )
    if RTV[ 'voteInProgress' ] then
        UTIL.ClientPrint( pPlayer, 2, "[RTV] Vote is already started." )
        return
    end
    
    local mapName = pArg or table_random( RTV['maps'] )
    
    if mapName == "" then
        dbg.Warning( "Map name is an empty string!!!!\n" )
        return
    end
        
        
    RTV['voteInProgress'] = true
        
    UTIL.ClientPrintAll( 3, "[RTV] server voted for '" .. tostring( mapName ) .. "'" )
    UTIL.ClientPrintAll( 3, "[RTV] Use rtv_votemap in console" )
    UTIL.ClientPrintAll( 3, "[RTV] rtv_votemap Yes/No" )
    dbg.DevMsg( "Randomized map: " .. mapName .. "\n")
    RTV['selectedMap'][ mapName ] = {
        yes = 0,
        no = 0
    }
    Timer.Simple( tonumber( g_Cvar_changeTime:GetFloat() ), function() 
        local yes = RTV['selectedMap'][ mapName ][ 'yes' ]
        local no = RTV['selectedMap'][ mapName ][ 'no' ]
        
        if ( yes > no && ( yes >= round(LambdaMod.LibAdmin.CountPlayerInServer() * g_Cvar_needed:GetFloat() ) )) then
            UTIL.ClientPrintAll( 3, "[RTV] Sucessfully voted map '" .. mapName .."'" )
            engine.ServerCommand( "changelevel " .. mapName .. "\n" )
        else
            UTIL.ClientPrintAll( 3, "[RTV] Not enough player voted 'Yes'." )    
        end    
    end )
end  

local function map_list()
    for _, v in ipairs( RTV['maps'] ) do
        dbg.Msg( "(STRING) " .. v .. "\n" )
    end
end        

local function vote_map( pPlayer, pCmd, pArgs ) 
    if !RTV[ 'voteInProgress' ] then
        UTIL.ClientPrint( pPlayer, 2, "[RTV] Vote is not started." )
        return
    end 
    
    if RTV['g_Voted'][ pPlayer:GetPlayerName() ] then
        UTIL.ClientPrint( pPlayer, 2, "[RTV] Already voted.")
        return
    end    
    
    if ( pArgs:upper() == "YES" ) then
        RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ][ 'yes' ] = RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ]['yes'] + 1
        RTV['totalVotes'] = RTV['totalVotes'] + 1
        RTV['g_Voted'][ pPlayer:GetPlayerName() ] = true
        UTIL.ClientPrint( pPlayer, 3, "[RTV] You voted yes.")
   elseif ( pArgs:upper() == "NO" ) then
        RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ][ 'no' ] = RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ]['no'] + 1
        RTV['totalVotes'] = RTV['totalVotes'] + 1
        RTV['g_Voted'][ pPlayer:GetPlayerName() ] = true     
        UTIL.ClientPrint( pPlayer, 3, "[RTV] You voted no.")
   else
       UTIL.ClientPrint( pPlayer, 3, "[RTV] Unknown answer, please use either yes or no." )
   end
   UTIL.ClientPrintAll( 3, "Yes: " .. tostring( RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ][ 'yes' ] ))
   UTIL.ClientPrintAll( 3, "No: " .. tostring( RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ][ 'no' ] ))
   UTIL.ClientPrintAll( 3, "Total vote: " .. tostring( RTV['totalVotes'] ) )
end  

local function ResetRTV()
    RTV['g_Voted'] = {}
    RTV['selectedMap'] = {}
    RTV['totalVotes'] = 0
    RTV['voteInProgress'] = false
end    

local function RTV_ChatCmd( pPlayer, pArgs ) 
    if !RTV[ 'voteInProgress' ] then
        return "[RTV] Vote is not started" 
    end 
    
    local choice = pArgs[ 1 ]
    
    if RTV['g_Voted'][ pPlayer:GetPlayerName() ] then
        return "[RTV] Already voted."
    end    
    
    if ( choice:upper() == "YES" ) then
        RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ][ 'yes' ] = RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ]['yes'] + 1
        RTV['totalVotes'] = RTV['totalVotes'] + 1
        RTV['g_Voted'][ pPlayer:GetPlayerName() ] = true
        return "[RTV] You voted yes."
    elseif ( choice:upper() == "NO" ) then
        RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ][ 'no' ] = RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ]['no'] + 1
        RTV['totalVotes'] = RTV['totalVotes'] + 1
        RTV['g_Voted'][ pPlayer:GetPlayerName() ] = true     
        return "[RTV] You voted no."
    else
        return "[RTV] Unknown answer, please use either yes or no." 
    end
    UTIL.ClientPrintAll( 3, "Yes: " .. tostring( RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ][ 'yes' ] ))
    UTIL.ClientPrintAll( 3, "No: " .. tostring( RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ][ 'no' ] ))
    UTIL.ClientPrintAll( 3, "Total vote: " .. tostring( RTV['totalVotes'] ) )
--[[    
    return ( "[RTV]: Vote count:\n\t" 
            .. "Yes: " ..  RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ][ 'yes' ] .. "\n\t"
            .. "No: " ..  RTV['selectedMap'][ RTV:GetCurrentSelectedMap() ][ 'no' ] .. "\n\t"
            .. "Total: " ..  RTV['totalVotes'] 
           ) 
]]           
end
    

function PLUGIN:OnPluginStart()
    RTV:LoadMap()
    UTIL.ClientPrintAll( 3, "RTV has been loaded!" )
    self.LambdaMod.RegConsoleCmd( "lambda_rtv", function( ply, cmd, arg ) end, "" )
    self.ChatCmd.AddCmd( "rtv", RTV_ChatCmd, "rtv <choice>" )
    self.LambdaMod.RegAdminCmd( "lambda_rtv_list", map_list, "" )
    self.LambdaMod.RegConsoleCmd( "lambda_rtv_votemap", vote_map, "RTV voting map" )
    self.LambdaMod.RegAdminCmd( "lambda_rtv_mapvote", admin_StartVoteMap, "RTV starts voting." )
end    