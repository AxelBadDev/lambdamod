LambdaMod.__REG_PLUGINS = {}
LambdaMod.__REG_LIBRARIES = {}
LambdaMod.__REG_LIBRARIES_PATH = {}
--PLUGIN.myinfo = 
--{
--	name = "Example",
--	author = "hedv948-source",
--	description = "Example",
--	version = LambdaMod.INFO._VERSION,
--	api = LambdaMod.Loader.api.version,
--	url = "https://github.com/hedv948-source"
--}

local function Normalize( base )
    --local _, _, name = string.find( base, "([%w_]*).lua" )
    local name = base
    --name = name:lower()
    name = string.gsub(name, "%s+", "")
    --name = string.gsub(name, "[^a-z0-9_]", "")
    
    return name
end

function LambdaMod.RegPlugin( path, pluginData )
    if ( !LambdaMod.__REG_PLUGINS[ path ] ) then
        LambdaMod.__REG_PLUGINS[ path ] = pluginData
    else
        table.merge( LambdaMod.__REG_PLUGINS[ path ], pluginData )   
        pluginData = LambdaMod.__REG_PLUGINS[ path ]
    end
end         

function LambdaMod.RegLibrary( pluginData )
    local temp = table.copy( pluginData )
    local name = temp.name
    name = Normalize( name )
    LambdaMod.__REG_LIBRARIES[ name ] = temp
end         
    
function LambdaMod.isRegistered( path )
    if ( !LambdaMod.__REG_PLUGINS[ path ] ) then return false end
    return true
end      

function LambdaMod.GetClass( pName ) 
    if ( !LambdaMod.__REG_LIBRARIES[ pName ] ) then return end
    return LambdaMod.__REG_LIBRARIES[ pName ]
end    
    
LambdaMod.AddCommand( "plugins", function( ply, args )
    
  if !args[2] then 
	LambdaMod.CPrintf(0, "Usage: lambda plugins <version|refresh|list|detail>\n")
  end
  
  if ( args[2] == "list" ) then
    if ( !LambdaMod.__REG_PLUGINS && #LambdaMod.__REG_PLUGINS == 0 ) then 
        LambdaMod.CPrintf( 3, "Error! No plugin loaded\n" )
        return
    end   
    LambdaMod.CPrintf(0, "%-40s %-35s %-30s %-25s\n", "Name", "Version", "Author", "Status")
    
    for k, v in pairs( LambdaMod.__REG_PLUGINS ) do
        local status
        if ( v.__LOAD_STATUS == LAMBDAMOD_PLUGIN_RUNNING ) then status = "RUN" 
        elseif ( v.__LOAD_STATUS == LAMBDAMOD_PLUGIN_BADLOAD ) then status = "BAD"
        elseif ( v.__LOAD_STATUS == LAMBDAMOD_PLUGIN_ERROR ) then status = "ERROR"
        elseif ( v.__LOAD_STATUS == LAMBDAMOD_PLUGIN_FAILED ) then status = "FAIL" 
        end             
	    LambdaMod.CPrintf(0, "%-40s %-35s %-30s %-25s\n", v.name, v.version, v.author, tostring( status ))
	end
  elseif ( args[2] == "detail" ) then
      if ( !LambdaMod.__REG_PLUGINS && #LambdaMod.__REG_PLUGINS == 0 ) then 
          LambdaMod.CPrintf( 3, "Error! No plugin loaded\n" )
          return
      end   
      
      LambdaMod.CPrintf(0, "%-40s %-25s\n", "Path", "Status")
    
      for k, v in pairs( LambdaMod.__REG_PLUGINS ) do
          local status
          if ( v.__LOAD_STATUS == LAMBDAMOD_PLUGIN_RUNNING ) then status = "RUN" 
          elseif  ( v.__LOAD_STATUS == LAMBDAMOD_PLUGIN_BADLOAD ) then status = "BAD"
          elseif  ( v.__LOAD_STATUS == LAMBDAMOD_PLUGIN_ERROR ) then status = "ERROR"
          elseif ( v.__LOAD_STATUS == LAMBDAMOD_PLUGIN_FAILED ) then status = "FAIL" 
          end             
	      LambdaMod.CPrintf(0, "%-40s %-25s\n", tostring( k ), tostring( status ))
	  end
  end
end, "", "<version|refresh|list|detail>" )    