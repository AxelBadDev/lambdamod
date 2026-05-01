if( SERVER ) then return end

include "includes/extensions/table.lua" 
include "includes/extensions/keyvalues.lua" 
include "includes/extensions/vgui.lua" 
include "includes/extensions/panel.lua"
 
local vgui = vgui

local concommand = require "concommand" 

local hBaseTestPanel = INVALID_PANEL

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

local C_PanelSubMain = {}

function C_PanelSubMain:Init(parent)
	
end

function C_PanelSubMain:Paint()
    local w,h = self:GetSize()

    surface.DrawSetColor(255,255,255,255)
    surface.DrawFilledRect(0,0, w,h)
end

vgui.register( C_PanelSubMain, "C_PanelSubMain", "Panel" )

local CPanelSubSettings = {}

function C_PanelSubSettings:Init(parent)
	self.button_1 = vgui.Button( self, "", "Press me" )
	self.button_1:SetPos( 210, 30 )
	self.button_1.DoClick = function()
		dbg.Msg("hello\n")
	end
end

function C_PanelSubSettings:Paint()
    //local w,h = self:GetSize()
end

vgui.register( C_PanelSubSettings, "C_PanelSubSettings", "Panel" )

local C_TestPanel = {}

function C_TestPanel:Init()
	self:SetDeleteSelfOnClose( true )
	self:SetBounds(0, 0, 512, 406)
	self:SetSizeable( false )
	self:SetTitle("Panel test", true);
	
	self:AddPage(vgui.C_PanelSubMain(self, ""), "Main");
	self:AddPage(vgui.C_PanelSubSettings(self, ""), "Settings");

	self:SetApplyButtonVisible(false);
	self:SetCancelButtonVisible(false);
end

vgui.register( C_TestPanel, "C_TestPanel", "PropertyDialog" )

local function OnOpenModInfoDialog()
	if ( ToPanel( hBaseTestPanel ) == INVALID_PANEL ) then
		hBaseTestPanel = vgui.C_TestPanel(VGui_GetGameUIPanel(), "C_TestPanel");
		PositionDialog( hBaseTestPanel );
	end
	hBaseTestPanel:Activate();
end

concommand.Create( "OpenTestPanel", OnOpenModInfoDialog, "", _E.FCVAR.CLIENTDLL )