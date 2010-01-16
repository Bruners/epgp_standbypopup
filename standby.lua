epgpstandbyDB = {}
local EPGP_TRIGGER = "epgp standby"
local TEXT_REMOVED_LIST = "You have been removed from the award list by"
local TEXT_ADD_TO_LIST = "Add me again"
local TEXT_CLOSE = "Raiding sucks"
local EPGP_REMOVED_STRING = "%s is now removed from the award list"
local leader, player, db
local backdrop = {
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 10
}
local f = CreateFrame("Frame")

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

function f:PLAYER_ENTERING_WORLD()
	player = UnitName("player")
	local name = string.format("%s - %s", player, GetRealmName())

	if not _G.epgpstandbyDB[name] then
		_G.epgpstandbyDB[name] = { main = player }
		db = _G.epgpstandbyDB[name]
	else
		db = _G.epgpstandbyDB[name]
	end

	f:RegisterEvent("CHAT_MSG_WHISPER")
end

function f:CHAT_MSG_WHISPER(event, msg, author, ...)
	if msg == (string.format(EPGP_REMOVED_STRING, player)) then
		leader = author
		f:Show()
		f.font:SetText(TEXT_REMOVED_LIST)
		f.bywho:SetText(leader)
		f.time:SetText(date"%H:%M:%S")
		f.name:SetText(db.main)
	end
format(date"%H%M.%S", text)
end

function f:ButtonClick()
	f:Hide()
	if leader then
		if player == db.main then
			SendChatMessage(EPGP_TRIGGER, "WHISPER", nil, leader)
		else
			SendChatMessage(string.format("%s %s",EPGP_TRIGGER, db.main), "WHISPER", nil, leader)
		end
	end
end

f:Hide()
f:SetWidth(350)
f:SetHeight(150)
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

local addme = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
addme:SetHeight(20)
addme:SetWidth(140)
addme:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 30, 20)
addme:SetText(TEXT_ADD_TO_LIST)
addme:RegisterForClicks("AnyUp")
addme:SetScript("OnClick", f.ButtonClick)

f.addme = addme

local close = CreateFrame("Button", "CloseButton", f, "UIPanelButtonTemplate")
close:SetHeight(20)
close:SetWidth(140)
close:SetPoint("LEFT", addme, "RIGHT", 10, 0)
close:SetText(TEXT_CLOSE)
close:SetScript("OnClick", function() f:Hide() end )

f.close = close

local name = CreateFrame("EditBox", nil, f)
name:SetPoint("CENTER", f, "CENTER", 0, -15)
name:SetWidth(130)
name:SetHeight(19)
name:SetFontObject(GameFontHighlight)
name:SetTextInsets(8,8,8,8)
name:SetBackdrop(backdrop)
name:SetBackdropColor(.1,.1,.1,.3)
name:SetMultiLine(false)
name:SetAutoFocus(false)
name:SetText("")
name:SetScript("OnEditFocusLost", function()
	local newname = name:GetText()
	if newname and newname ~= nil or newname ~= "" then
		db.main = newname
	end
end)
name:SetScript("OnEscapePressed", name.ClearFocus)

f.name = name
