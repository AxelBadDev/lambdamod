-- Hook extension

require( "hook" )

local hook = hook

function hook.Add( eventName, hookName, pFn )
	hook.add( eventName, hookName, pFn )
end

function hook.Call( name, gm, ... )
	hook.call( name, gm, ...)
end