local EPGP_TRIGGER = "epgp standby"
local TEXT_REMOVED_LIST = "You have been removed from the award list by"
local TEXT_ADD_TO_LIST = "Add me again"
local TEXT_CLOSE = "Raiding sucks"
local leader, minute, seconds
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

function f:PLAYER_LOGIN()
	f:RegisterEvent("CHAT_MSG_WHISPER")
end

function f:CHAT_MSG_WHISPER(event, msg, author, ...)
	local player = UnitName("player")
	if msg == (string.format("%s is now removed from the award list", player)) then
		minute, seconds = GetGameTime()
		leader = author
		f:Show()
		f.font:SetText(TEXT_REMOVED_LIST)
		f.bywho:SetText(leader)
		f.time:SetText(string.format("%s:%s", minute, seconds))
	end
end

function f:ButtonClick()
	f:Hide()
	if leader then
		SendChatMessage(EPGP_TRIGGER, "WHISPER", nil, leader)
	end
end

f:Hide()
f:Show()
f:SetWidth(350)
f:SetHeight(120)
f:SetPoint("CENTER")
f:EnableMouse(true)
f:SetMovable(true)
f:SetUserPlaced(true)
f:SetClampedToScreen(true)
f:SetScript("OnMouseDown", f.StartMoving)
f:SetScript("OnMouseUp", f.StopMovingOrSizing)
f:SetBackdrop(StaticPopup1:GetBackdrop())

local font = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
font:SetText(TEXT_REMOVED_LIST)
font:SetPoint("TOP", f, "TOP", 0, -20)

f.font = font

local bywho = f:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
bywho:SetText("")
bywho:SetPoint("TOP", font, "BOTTOM", 0, -5)

f.bywho = bywho

local time = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
time:SetText("0:00")
time:SetPoint("TOP", bywho, "BOTTOM", 0, -5)

f.time = time

local button = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
button:SetHeight(20)
button:SetWidth(140)
button:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 30, 20)
button:SetText(TEXT_ADD_TO_LIST)
button:RegisterForClicks("AnyUp")
button:SetScript("OnClick", f.ButtonClick)

f.button = button

local close = CreateFrame("Button", "CloseButton", f, "UIPanelButtonTemplate")
close:SetHeight(20)
close:SetWidth(140)
close:SetPoint("LEFT", button, "RIGHT", 10, 0)
close:SetText(TEXT_CLOSE)
close:SetScript("OnClick", function() f:Hide() end )

f.close = close
