if vgui.HButton ~= nil then dbg.Warning("[SVGUI] Another instance detected.\n") return end

TEXT_ALIGN_LEFT		= 0
TEXT_ALIGN_CENTER	= 1
TEXT_ALIGN_RIGHT	= 2
TEXT_ALIGN_TOP		= 3
TEXT_ALIGN_BOTTOM	= 4

local PANEL = {}

//Re-implementation of vgui button

function PANEL:Init(parent, name)
	self:SetParent(parent)
	if not name ~= nil then
   	 self:SetName(name)
	end
	
    self:SetPaintBorderEnabled( true )
	self:SetPaintEnabled( true )
	self:SetPaintBackgroundEnabled( true )
	self:SetAutoDelete(false)

    self:SetTall( 22 )
	self:SetMouseInputEnabled( true )
	self:SetKeyBoardInputEnabled( true )
    self:SetDragEnabled(false)

    self.m_sText = "Text"
    self.m_nFont = "Default"
    self.m_colText = Color(255,255,255,255)
    self.m_colHoverText =  Color(171,227,253)
    self.m_outlineColor = Color(46,46,46)
    self.m_mainColor = Color(133,133,133)
    self.m_textAlignX = TEXT_ALIGN_LEFT
    self.m_textAlignY = TEXT_ALIGN_TOP
	self.m_bDown = false

	self.textX = 3 
	self.textY = -1
	self.m_bMoveText = false
	self.m_bHovered = false
	self.m_sDepressedSound = ""
	self.m_sReleasedSound = ""
	self.m_sHoverSound = ""
end

function PANEL:SetDepressedSound(snd)
	self.m_sDepressedSound = tostring(snd)
end

function PANEL:SetReleasedSound(snd)
	self.m_sReleasedSound = tostring(snd)
end

function PANEL:GetDepressedSound()
	return self.m_sDepressedSound
end

function PANEL:SetHoverSound(snd)
	self.m_sHoverSound = tostring(snd)
end

function PANEL:GetHoverSound()
	return self.m_sHoverSound
end

function PANEL:GetReleasedSound()
	return self.m_sReleasedSound
end

function PANEL:SetText(text)
    self.m_sText = text
end

function PANEL:GetText()
    return self.m_sText
end

function PANEL:SetFont(font)
    if font == nil then
        return
    end

    self.m_nFont = font
end 

function PANEL:GetFont()
    return self.m_nFont
end 

function PANEL:SetOutlineColor( clr )
	self.m_outlineColor = clr
end

function PANEL:GetOutlineColor( clr )
	return self.m_outlineColor
end

function PANEL:SetColor( clr )
	self.m_mainColor = clr
end

function PANEL:GetColor( clr )
	return self.m_mainColor
end

function PANEL:SetTextColor( clr )
	self.m_colText = clr
end

function PANEL:GetTextColor()
	return self.m_colText
end

function PANEL:SetTextHoverColor( clr )
	self.m_colHoverText = clr
end

function PANEL:GetTextHoverColor()
	return self.m_colHoverText
end

function PANEL:SetTextXAlign(num)
    self.m_textAlignX = num
end

function PANEL:SetTextYAlign(num)
    self.m_textAlignY = num
end

function PANEL:GetTextXAlign()
    return self.m_textAlignX
end

function PANEL:GetTextYAlign()
    return self.m_textAlignY
end

function PANEL:DrawText_INT(text)

	local pScheme = scheme.GetIScheme(scheme.GetScheme("SourceScheme"));  

	text		= tostring( text )
	font		= pScheme:GetFont(self:GetFont())
	local x		= self.textX				or 0
	local y		= self.textY 				+ (self:GetTall() / 2) - 8 or 0
	xalign		= self:GetTextXAlign()		or TEXT_ALIGN_LEFT
	yalign		= self:GetTextYAlign()		or TEXT_ALIGN_TOP
    

	surface.DrawSetTextFont( font )
	local w, h = surface.GetTextSize( font, text )

	if ( xalign == TEXT_ALIGN_CENTER ) then
		x = x + w * 2
	elseif ( xalign == TEXT_ALIGN_RIGHT ) then
		x = x + w
	end

	if ( yalign == TEXT_ALIGN_CENTER ) then
		y = y - h / 2
	elseif ( yalign == TEXT_ALIGN_BOTTOM ) then
		y = y - h
	end

	local color
	if self.m_bHovered == true then color = self.m_colHoverText else color = self.m_colText end

	surface.DrawSetTextPos( math.ceil( x ), math.ceil( y ) )

	surface.DrawSetTextColor( color:GetColor() )

	surface.DrawPrintText( text )

	return w, h
end

function PANEL:DrawButton_INT(x,y)
    surface.DrawSetColor(self:GetColor():GetColor())
    surface.DrawFilledRect(0,0,x,y)

    surface.DrawSetColor(self:GetOutlineColor():GetColor())
    surface.DrawOutlinedRect(0,0,x,y)
end

function PANEL:Paint()
	--if ToPanel(self) ~= INVALID_PANEL then
		local wide, tall = self:GetSize();

		self:DrawButton_INT(wide,tall)
		self:DrawText_INT(self.m_sText)
	--end
end

function PANEL:DoClick()
    self.DoClick = function() end
end

function PANEL:DoClickEffects()
	self.DoClickEffects = function() end
end

function PANEL:OnMousePressed(code)
	--if ToPanel(self) ~= INVALID_PANEL then
		self.m_bDown = true
		if self.m_bMoveText == false then
			self.m_bMoveText = true
			self:PressText()
		end
	--end
end

function PANEL:OnMouseReleased(code)
	--if ToPanel(self) ~= INVALID_PANEL then
		self:DoClick()
		self.m_bDown = false
		if self.m_bMoveText == true then
			self.m_bMoveText = false
			self:UnPressText()
		end
	--end
end

function PANEL:OnCursorEntered()
	self.m_bHovered = true
	if self.m_sHoverSound:len() >= 1 then
		--surface.PlaySound(self.m_sHoverSound) // CAUSES CRASH
	end
end

function PANEL:OnCursorExited()
	self.m_bHovered = false
end

function PANEL:PressText()
	self.textX = self.textX + 1
	self.textY = self.textY + 2
	// ok why not play sound here 
	if self.m_sDepressedSound:len() >= 1 then
		surface.PlaySound(self.m_sDepressedSound)
	end
end

function PANEL:UnPressText()
	self.textX = self.textX - 1
	self.textY = self.textY - 2
	// ok why not play sound here 
	if self.m_sReleasedSound:len() >= 1 then
		surface.PlaySound(self.m_sReleasedSound)
	end
end

vgui.register(PANEL, "HButton", "Panel")
