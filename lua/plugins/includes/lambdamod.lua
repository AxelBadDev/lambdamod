--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--

LIBRARY:RegLibrary( {
    name = "LambdaMod",
    author = "hedv948-source",
    description = "LambdaMod interface",
    version = LAMBDAMOD_VERSION,
    api = LAMBDAMOD_API_VERSION,
    url = "https://github.com/hedv948-source/lambdamod/"
} )

function LIBRARY:Damage( pCaller, pPlayer, pDamage )
      local dmg = CTakeDamageInfo()
      dmg:SetAttacker( pCaller )
      dmg:SetInflictor( pCaller )
      dmg:SetDamage( pDamage )
      dmg:SetDamageType( DMG_GENERIC )
	  AddMultiDamage( dmg, pPlayer )
end  

function LIBRARY:Changelevel( pszMap )
    engine.ServerCommand( "changelevel " .. pszMap .. "\n" )
end    

function LIBRARY:RegConsoleCmd( pName, func, pHelp, pFlags )
    LambdaMod.cvar.RegConsoleCmd( pName, func, pHelp, pFlags )
end

function LIBRARY:RegAdminCmd( pName, func, pHelp, pFlags )
    LambdaMod.cvar.RegAdminCmd( pName, func, pHelp, pFlags )
end


function LIBRARY:RegServerCmd( pName, func, pHelp, pFlags )
    LambdaMod.cvar.RegServerCmd( pName, func, pHelp, pFlags )
end
    
function LIBRARY:ParseTargets( pArgs, pCaller )
    return LambdaMod.LibAdmin.ParseTargets( pArgs, pCaller )  
end

function LIBRARY:ConColorMsg( color, text )
    dbg.ConColorMsg( color, text )
end    

function LIBRARY:PrintCenterHint( pPlayer, text )
    net.Start( "LambdaModCenterHintText" )
        net.WriteString( tostring( text ) )
    net.Send( pPlayer )
end  

function LIBRARY:PrintCenterHintAll( text )
    net.Start( "LambdaModCenterHintText" )
        net.WriteString( tostring( text ) )
    net.Broadcast()
end              

function LIBRARY:LogAction(...)
    local text
    local args =  {...}
    if ( #args > 0 ) then
        text = table.concat( args, " " )
    end
    dbg.Log( tostring( text ) .. "\n" )
end    