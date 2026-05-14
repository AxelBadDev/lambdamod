--============== Copyright (C) 2026 AxelBadDev, All Rights Reserved ==========--
--
-- Purpose: 
--
--============================================================================--
if ( !CLIENT ) then return end

require( "spaint" )

local spaint = spaint
local hook = hook
local surface = surface

spaint.CreateFont("NotificationFont", {
  font = "Roboto",
  size = 14,
  weight = 500,
  antialias = true,
})

local NOTIFY_GENERIC = 0
local NOTIFY_ERROR = 1
local NOTIFY_UNDO = 2
local NOTIFY_CLEANUP = 3
local NOTIFY_HINT = 4

local NOTIFY_ICONS = {
  [NOTIFY_GENERIC] = "vgui/notices/generic",
  [NOTIFY_ERROR] = "vgui/notices/error",
  [NOTIFY_UNDO] = "vgui/notices/undo",
  [NOTIFY_CLEANUP] = "vgui/notices/cleanup",
  [NOTIFY_HINT] = "vgui/notices/hint",
}

local MAX_HINTS = 7
local m_Notices = {}
local m_Scheduled = {}
local m_Processed = {}

local function NoticePanel_New(text, ntype, length)
  local scrW, scrH = surface.GetScreenSize()

  return {
    text = text,
    ntype = ntype,
    icon = NOTIFY_ICONS[ntype] or NOTIFY_ICONS[NOTIFY_GENERIC],
    length = length,
    startTime = gpGlobals.curtime(),
    w = 300,
    h = 36,
    fx = scrW + 300,
    fy = scrH - 150,
    VelX = 0,
    VelY = 0,
    dead = false,
    progress = false,
    progressFrac = 0,
  }
end

local notification = {}


return notification