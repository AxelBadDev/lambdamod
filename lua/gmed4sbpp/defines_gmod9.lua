-- GMod 9 partial compatibilty layer

function _PrintMessage( pPlayer, pType, pMsg )
	UTIL.ClientPrint( pPlayer, pType, pMsg )
end

function _PrintMessageAll( pType, pMsg )
	UTIL.ClientPrintAll( pType, pMsg )
end

function _ServerCommand(cmd)
	engine.ServerCommand(cmd)
end