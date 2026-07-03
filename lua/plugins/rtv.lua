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

local TIMER_NAME = "rtv_endVote"

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

function math_Round( num, idp )
	local mult = 10 ^ ( idp or 0 )
	return math.floor( num * mult + 0.5 ) / mult
end


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

local g_Cvar_needed
local g_Cvar_time
local g_Cvar_changeTime

function PLUGIN:PrePluginStart() 
    g_Cvar_needed = ConVar( "lambda_rtv_needed", "0.60", concmd_bor { FCVAR.NOTIFY, FCVAR.REPLICATED }, "Percentage of players needed to rockthevote (Def 60%)" )
    g_Cvar_time = ConVar( "lambda_rtv_time", "30", concmd_bor { FCVAR.NOTIFY, FCVAR.REPLICATED }, "How many seconds the vote will take" )
    g_Cvar_changeTime = ConVar( "lambda_rtv_changetime", "120.0", concmd_bor { FCVAR.NOTIFY, FCVAR.REPLICATED }, "Timer (in seconds) before map changing (Def 120 seconds)" )
end

local MapVote = {}
MapVote.choices = {}
MapVote.votes = {}
MapVote.callback = nil

function MapVote:Start(choices, time, callback)
    if ( #choices == 1 ) then
        if ( callback != nil ) then
            callback(choices[1])
         end
         return
    end
    
    if ( Timer.timers[ TIMER_NAME ] ) then
        Timer.Remove( TIMER_NAME )
    end    
    
    self.callback = callback
    self.choices = choices 
    self.votes = {}
      
    Timer.Add( TIMER_NAME, time + 1, 0, function()
        local choiceID = self:GetWinningChoiceID()
        self:End(choiceID)
    end )  
end

function MapVote:End(choiceID)
    if ( Timer.timers[ TIMER_NAME ] ) then
        Timer.Remove( TIMER_NAME )
    end  
    if choiceID != nil then
        if self.callback != nil then
            Timer.Simple(2, function() 
                local choice = self.choices[choiceID]
                self.callback(choice)
            end )
             
        end
    else
        UTIL.ClientPrintAll( 3, "[RTV] Vote is ended")    
    end
end      

function MapVote:GetWinningChoiceID()
    local count = {
        -- choiceID = numOfVotes
    }
    local choices = {}  -- Choices that equal the highest vote
    local highest = 0   -- Highest vote count

    for ply, choice in pairs(self.votes) do
        if IsValid(ply) then
            -- Increasing the count
            if count[choice] == nil then
                count[choice] = 1
            else
                count[choice] = count[choice] + 1
            end
            -- Checking if the choice is higher
            if count[choice] == highest then
                -- Count is equal, insert it into choices
                table.insert(choices, choice)
            elseif count[choice] > highest then
                -- Count is higher, reset choices and highest
                choices = {choice}
                highest = count[choice]
            end
        end
    end
    if #choices == 0 then
        return math.random(1, #self.choices)
    end
    return choices[math.random(1, #choices)]
end  

function MapVote:Vote(ply, choiceID)
    -- Checking to make sure the vote is valid
    if not IsValid(ply) or MapVote.choices[choiceID] == nil then
        return
    end

    -- Setting the vote
    self.votes[ply] = choiceID
end
     
local RTV = {}
RTV.maps = {}
RTV.g_Voted = {}
RTV.votes = {}
RTV.selectedMap = {}
RTV.totalVotes = 0
RTV.voteCountdown = 300
RTV.voteInProgress = false

local function CleanText( str )
    local mapList = {}
    for word in str:gmatch("[^\n]+") do 
        word = word:gsub("//.+", "")
        if ( word ~= "" ) then
            table.insert( mapList, word )
        end
    end 
    
    return mapList       
end  
  
function RTV:LoadConfig()
    local config = LambdaMod.LoadConfig( "RTV", "rtv" )
    local mapfile_ref = config:GetString( "MapList", "config/lambdamod/rtv_maps.txt" )
    
    if ( mapfile_ref == NULL_KEYVALUES ) then
        config:SetString( "MapList", "config/lambdamod/rtv_maps.txt" )
        mapfile_ref = config:GetString( "MapList" )
        config:SaveToFile( LambdaMod.ConfigFormattedPath( "rtv" ) )
    end    
    
    local mapFile = easyfs.Read( mapfile_ref )
    RTV.maps = CleanText( mapFile )
    
    config:deleteThis()
end   

function RTV:TotalVotes()
    local count = 0
    for ply, v in pairs(self.votes) do
        -- Making sure the player didn't disconnect
        if IsValid(ply) and v then
            count = count + 1
        else
            -- Player disconnected, set it to false just incase they reconnect
            RTV.votes[ply] = false
        end
    end
    return count
end

function RTV:GetCurrentSelectedMap()
    for k, v in pairs( self['selectedMap'] ) do
        if ( v != nil ) then
            return k
        end  
    end
    return nil
end   

function RTV:RequiredVotes()
    return math_Round(#UTIL.GetAllPlayers() * g_Cvar_needed:GetFloat())
end

function RTV:CheckVotes()
    return self:TotalVotes() >= self:RequiredVotes() and self.voteInProgress == false
end
 

function RTV:AddVote( ply, choiceID ) 
    if RTV.votes[ply] == true then
        return false
    else
        RTV.votes[ ply ] = true
        return true
    end         
end
     
function RTV:Start(forced)
    local check = forced or self:CheckVotes()
    if !check then return end     
    
    self.voteInProgress = true
    UTIL.ClientPrintAll( 3, 
        "Maps:\n\t"
        .. table.concat( forced, "\n\t" )
    )
    
    local choices = forced
    MapVote:Start( choices, g_Cvar_time:GetInt(), function(choice)
        self.voteInProgress = false 
        engine.ServerCommand( "changelevel " .. choice .. "\n" )
    end )
end    
     
function RTV:End()
    self.voteInProgress = false
    self.votes = {}
    MapVote:End()
end  
   
local function RTV_Start()
    RTV:Start({
        "gm_construct",
        "gm_bigcity",
        "dm_lockdown"
    })
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
    RTV:AddVote( pPlayer, pArgs )
end  

local function ResetRTV()
    RTV['votes'] = {}
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
    RTV:LoadConfig()
    UTIL.ClientPrintAll( 3, "RTV has been loaded!" )
    self.LambdaMod.RegConsoleCmd( "lambda_rtv", function( ply, cmd, arg ) 
        if !RTV.voteInProgress then return end
        RTV:AddVote( ply, arg ) 
        UTIL.ClientPrintAll(3, "'" .. ply:GetPlayerName() .. "' voted for " .. arg )
    end, "" )
    self.ChatCmd.AddCmd( "rtv", RTV_ChatCmd, "rtv <choice>" )
    self.LambdaMod.RegAdminCmd( "lambda_rtv_list", map_list, "" )
    self.LambdaMod.RegConsoleCmd( "lambda_rtv_votemap", function() end, "RTV voting map" )
    self.LambdaMod.RegAdminCmd( "lambda_rtv_start", RTV_Start, "RTV starts map vote." )
end  