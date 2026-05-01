if(!CLIENT) then return end

local hBaseTestFrame = INVALID_PANEL

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



local CPanelConfig = {}

local pNetGraph

function CPanelConfig:Init( parent, panelName, showTaskbarIcon )
    
	self:SetDeleteSelfOnClose( true )
	self:SetBounds(0, 0, 512, 406)
    self:SetSizeable( false )
	self:SetTitle("Settings", true);
    
    self.m_pCvarNet_graph = cvar.FindVar( "net_graph" )
	
	self.m_pNetGraph = vgui.CheckButton( self, "", "Net Graph" )
    self.m_pNetGraph:SetPos( 200, 45 )
    self.m_pNetGraph:AddActionSignalTarget( self )
    --self.m_pNetGraph:SetRange( 0, 3 )
    --self.m_pNetGraph:SetValue( self.m_pCvarNet_graph:GetInt() )
    
    --pNetGraph = self.m_pNetGraph:GetValue()
    
    --self.m_pApply = vgui.Button( self, "", "Apply", self, "apply")
    --self.m_pApply:SetPos( 220, 60 )
    
end

function CPanelConfig:OnCommand( cmd )
end

function CPanelConfig:PerformLayout()
    --local wide, tall
    
end    

vgui.register( CPanelConfig, "CPanelConfig", "Frame" )

local function OnOpenModInfoDialog()
	if ( ToPanel( hBaseTestFrame ) == INVALID_PANEL ) then
		hBaseTestFrame = vgui.CPanelConfig(VGui_GetGameUIPanel(), "CPanelConfig");
		PositionDialog( hBaseTestFrame );
	end
	hBaseTestFrame:Activate();
end
 
concommand.Create( "OpenConfigUI", OnOpenModInfoDialog, "", _E.FCVAR.CLIENTDLL )