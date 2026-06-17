--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LIBRARY:RegLibrary {
    name = "Vote",
    author = "AxelBadDev",
    description = "Voting library",
    version = LAMBDAMOD_VERSION,
    api = LAMBDAMOD_API_VERSION,
    url = "https://github.com/AxelBadDev/lambdamod/"
}

LIBRARY.isVoteStarted = false

local votemaps = {}

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


function LIBRARY:StartVote() 
    local maps = easyfs.Find( "maps/*.bsp", "GAME" )
    
    for _, map in ipairs( maps ) do
        map = map:sub( 1, -5 )
        table.insert( votemap, map )
    end
    
    table.sort( votemaps )    
end

function LIBRARY.SendVotetoServer( pPlayer, pBool )
    if ( !self.isVoteStarted ) then dbg.Warning( "Voting hasn't started\n" ) return end
    net.Start( "cl_lambda_votemap" )
        net.WriteString( ( pBool and "YES" or "NO" ) )
    net.SendToServer()
end    