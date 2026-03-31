require( "concommand" )

local concommand = concommand

function concommand.Add( pName, pFn, pHelp, flags)
	concommand.Create( pName, pFn, ( pHelp or "" ), flags )
end