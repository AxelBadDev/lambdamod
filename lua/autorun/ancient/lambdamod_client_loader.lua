--[[
if _CLIENT then
include( "lambda/core/defines.lua" )
include( "lambda/core/shared.lua" )

include( "lambda/core/client/libCLambda.lua" )
include( "lambda/core/client/libClientLoader.lua" )

local CLIENT_LAMBDAMOD_LOADER_PATH = "lua/scripting/client/"

local function LoadAll()
	local files = file.Find( CLIENT_LAMBDAMOD_LOADER_PATH .. "*.lua", "MOD" )
	
	if not files or #files == 0 then
		_G.LambdaMod.printfc( 3, "No plugin found\n" )
	end
	
	for _, name in ipairs( files ) do
		_G.LambdaMod.printfc( 1, "(Client) Loading: %s\n", ( CLIENT_LAMBDAMOD_LOADER_PATH .. name ) )
		_G.CLambda.Loader.Load( CLIENT_LAMBDAMOD_LOADER_PATH .. name )
	end
end

LoadAll()
end
]]