--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: Plugin/library registeration
--
--============================================================================--

LambdaMod.__plugins = {}
LambdaMod.__libraries = {}

local PLUGIN_ID = 0

local function PrintTable(t, bOrdered, i)
  i = i or 0
  local indent = ""
  for j = 1, i do
    indent = indent .. "\t"
  end
  if not bOrdered then
    for k, v in pairs(t) do
      if type(v) == "table" then
        dbg.ConMsg( indent .. k .. "\n" )
        PrintTable(v, false, i + 1)
      else
        dbg.ConMsg( indent .. k .. "   " .. tostring( v ) .. "\n" )
      end
    end
  else
    for j, pair in ipairs(t) do
      if type(pair.value) == "table" then
        dbg.ConMsg( indent .. pair.key .. "\n" )
        PrintTable( pair.value, true, i + 1)
      else
        dbg.ConMsg( indent .. pair.key .. "   " ..  tostring( pair.value ) .. "\n" )
      end
    end
  end
end

local function Normalize( base )
    --local _, _, name = string.find( base, "([%w_]*).lua" )
    local name = base
    --name = name:lower()
    name = string.gsub(name, "%s+", "")
    --name = string.gsub(name, "[^a-z0-9_]", "")
    
    return name
end

--- Register a plugin called by loader
---@param pluginData table
function LambdaMod.RegPlugin( pluginData )
    local name = pluginData.myinfo.name
    local path = pluginData.path
    if ( !LambdaMod.__plugins[ name ] ) then
        PLUGIN_ID = PLUGIN_ID + 1
        pluginData.m_Id = PLUGIN_ID
        LambdaMod.__plugins[ name ] = pluginData
    else    
        table.merge( LambdaMod.__plugins[ name ], pluginData )
        pluginData = LambdaMod.__plugins[ name ] 
    end    
end         

--- Register a library called by loader
---@param pluginData table
function LambdaMod.RegLibrary( pluginData )
    local temp = pluginData 
    local name = temp.name
    name = Normalize( name )
    LambdaMod.__libraries[ name ] = temp
end 

--- Gets library name from path
---@param path string
function LambdaMod.LibraryNameFromPath( path )
    for k, v in pairs( LambdaMod.__libraries ) do
        if ( v.path == path ) then
            return k
         end
    end
    return nil
end            

--- Gets plugin name from path
---@param path string
function LambdaMod.PluginNameFromPath( path )
    for k, v in pairs( LambdaMod.__plugins ) do
        if ( v.path == path ) then
            return k
         end
    end
    return nil
end            
 
--- Is plugin registered
---@param path string
---@return boolean
function LambdaMod.isRegistered( path )
    if ( !LambdaMod.__plugins[ path ] ) then return false end
    return true
end      
    
function LambdaMod.PrintDetailedPlugin() 
    PrintTable( LambdaMod.__plugins )
end

LambdaMod.AddCommand( "plugins", function( ply, args )
    
  if( !args[ 1 ] || args[ 1 ] == "" ) then 
	LambdaMod.CPrintf(0, "Usage: lambda plugins <commands> [arguments]\n" )
    LambdaMod.CPrintf(0, "    lambda plugins list        - Lists all plugins\n" )
    LambdaMod.CPrintf(0, "    lambda plugins status      - Gets status for plugin\n" )
    return
  end
  
  if ( args[ 1 ] == "list" ) then
    if ( !LambdaMod.__plugins && #LambdaMod.__plugins == 0 ) then 
        LambdaMod.CPrintf( 3, "Error! No plugin loaded\n" )
        return
    end   
    LambdaMod.CPrintf( 0, "%-2s %-15s %-25s %-26s %-27s\n", "-Id-", "Name", "Version", "Author", "Status")
    
    for name, data in pairs( LambdaMod.__plugins ) do
        local status = LambdaMod.Enum.statePluginName[ data:GetState() ]
	    LambdaMod.CPrintf( 0, "[%02d] %-15s %-25s %-26s %-27s\n", data.m_Id, tostring( name ), data.myinfo.version, data.myinfo.author, tostring( status ) )
	end
  elseif ( args[ 1 ] == "status" ) then
      if ( !LambdaMod.__plugins && #LambdaMod.__plugins == 0 ) then 
          LambdaMod.CPrintf( 3, "Error! No plugin loaded\n" )
          return
      end   
      
      LambdaMod.CPrintf(0, "%-40s %-25s\n", "Path", "Status")
      
      if ( args[ 2 ] ) then
          local pluginData = LambdaMod.__plugins[ args[ 2 ] ]
          if ( pluginData ) then
             local status = LambdaMod.Enum.statePluginName[ pluginData:GetState() ]
             LambdaMod.CPrintf(0, "%-40s %-25s\n", tostring( pluginData.path ), tostring( status ))  
          else
              LambdaMod.CPrintf( 3, "Unknown plugin: %s\n", args[ 2 ] )  
          end
      else  
          for name, data in pairs( LambdaMod.__plugins ) do
            local status = LambdaMod.Enum.statePluginName[ data:GetState() ]
            LambdaMod.CPrintf(0, "%-40s %-25s\n", tostring( data.path ), tostring( status ))
          end
      end    
  end
end, "Plugin control command", "" )    