if(SERVER) then return end

LambdaMod = LambdaMod or {}

local function PositionDialog(dlg)
  if not IsValid(dlg) then
    return
  end

  local w, h = surface.GetScreenSize()
  if not w or not h or w == 0 or h == 0 then
    return
  end

  -- double check
  if not IsValid(dlg) then
    return
  end

  local pw, ph = dlg:GetSize()
  if not pw or not ph then
    return
  end

  dlg:SetPos((w - pw) / 2, (h - ph) / 2)
end

local hAdminKickPanel = INVALID_PANEL
--[[
local function getKeys( tbl )

	local keys = {}

	for k in pairs( tbl ) do
		table.insert( keys, k )
	end

	return keys

end


local function SortedPairs( pTable, Desc )

	local keys = getKeys( pTable )

	if ( Desc ) then
		table.sort( keys, function( a, b )
			return a > b
		end )
	else
		table.sort( keys, function( a, b )
			return a < b
		end )
	end

	local i, key
	return function()
		i, key = next( keys, i )
		return key, pTable[ key ]
	end

end
]]

local menu = 
{
    "nillerusr";
    "Garry";
    "Rubat";
    "ThePixelMoon";
    "YourLocalSunny";
    "SourceTest";
    "libRubicate";
}

local PANEL = {}

local function MakeList( def )
    
    for _, v in ipairs( UTIL.GetAllPlayers() ) do
        def:AddItem( v:GetPlayerName() )
    end    
end
    
function PANEL:Init()
    self:SetDeleteSelfOnClose( true )
    self:SetBounds( 0, 0, 300, 250 )
    
    self:SetSizeable( false )
    self:SetTitle( "Select player to kick", true )
    
    self.pPlayerNameList = vgui.ComboBox( self, "", 2, true )
    self.pPlayerNameList:SetPos( 5, 30 )
    MakeList( self.pPlayerNameList )
    
    self.pApplyButton = vgui.Button( self, "", "Kick", self, "_kickplayer")
    self.pApplyButton:SetPos( 5, 45 )
end

function PANEL:OnCommand( cmd )
    if ( cmd == "_kickplayer" ) then
        engine.ClientCmd_Unrestricted( "kick " .. self.pPlayerNameList:GetText() .. "\n" )
    end    
end    

vgui.register( PANEL, "CKickMenu", "Frame" )    

local function C_OpenClientKick(ply, cmd, arg)
        
    if ( ToPanel( hAdminKickPanel ) == INVALID_PANEL ) then
		hAdminKickPanel = vgui.CKickMenu(VGui_GetGameUIPanel(), "CKickMenu");
		PositionDialog( hAdminKickPanel );
	end
	hAdminKickPanel:Activate();     
end    

concommand.Create( "lambda_admin_kickmenu", C_OpenClientKick, "", _E.FCVAR.CLIENTDLL )