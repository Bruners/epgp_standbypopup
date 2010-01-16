epgpstandbyDB = {}
local L = setmetatable(GetLocale() == "deDE" and {
    ["%s is now removed from the award list"] = "%s wurde von der Belohnungsliste entfernt",
} or GetLocale() == "esES" and {
    ["%s is now removed from the award list"] = "%s ha sido eliminado de la lista de recompensas",
} or GetLocale() == "esMX" and {
    ["%s is now removed from the award list"] = "%s se ha quitado de la lista de asignaciones",
} or GetLocale() == "frFR" and {
    ["%s is now removed from the award list"] = "%s est \195\160 pr\195\169sent supprim\195\169 de la liste des gains",
} or GetLocale == "koKR" and {
    ["%s is now removed from the award list"] = "%s \235\138\148 \236\157\180\236\160\156 \235\179\180\236\131\129 \235\170\169\235\161\157\236\151\144\236\132\156 \236\160\156\234\177\176\235\144\152\236\151\136\236\138\181\235\139\136\235\139\164.",
} or GetLocale() == "ruRU" and {
    ["%s is now removed from the award list"] = "%s \209\131\208\180\208\176\208\187\209\145\208\189 \208\184\208\183 \209\129\208\191\208\184\209\129\208\186\208\176 \208\189\208\176\208\179\209\128\208\176\208\182\208\180\208\181\208\189\208\184\209\143",
} or GetLocale() == "zhCN" and {
    ["%s is now removed from the award list"] = "\229\183\178\228\187\142\229\165\150\229\138\177\229\144\141\229\141\149\228\184\173\231\167\187\233\153\164\228\186\134 %s",
} or GetLocale() == "zhTW" and {
    ["%s is now removed from the award list"] = "%s \229\183\178\229\190\158\231\141\142\229\139\181\229\136\151\232\161\168\228\184\173\231\167\187\233\153\164",
} or {}, {__index=function(t,i) return i end})

local EPGP_TRIGGER = L["epgp standby"]
local EPGP_REMOVED_STRING = L["%s is now removed from the award list"]
local TEXT_REMOVED_LIST = L["You have been removed from the award list by"]
local BUTTON_TEXT_ADD = L["Add me again"]
local BUTTON_TEXT_CLOSE = L["Raiding sucks"]
local TOOLTIP_ALT_NICKNAME = L["Nickname to be added to if you are on an alternative character"]
local TOOLTIP_BUTTON_CLOSE = L["Close this window"]
local TOOLTIP_BUTTON_ADD = L["Add yourself to the epgp standby list"]
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

local function HideTooltip() GameTooltip:Hide() end 
local function ShowTooltip(self)
	if self.tiptext then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
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
addme:SetText(BUTTON_TEXT_ADD)
addme.tiptext = TOOLTIP_BUTTON_ADD
addme:RegisterForClicks("AnyUp")
addme:SetScript("OnClick", f.ButtonClick)
addme:SetScript("OnEnter", ShowTooltip)
addme:SetScript("OnLeave", HideTooltip)

f.addme = addme

local close = CreateFrame("Button", "CloseButton", f, "UIPanelButtonTemplate")
close:SetHeight(20)
close:SetWidth(140)
close:SetPoint("LEFT", addme, "RIGHT", 10, 0)
close:SetText(BUTTON_TEXT_CLOSE)
close.tiptext = TOOLTIP_BUTTON_CLOSE
close:SetScript("OnClick", function() f:Hide() end )
close:SetScript("OnEnter", ShowTooltip)
close:SetScript("OnLeave", HideTooltip)
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
name.tiptext = TOOLTIP_ALT_NICKNAME
name:SetScript("OnEscapePressed", name.ClearFocus)
name:SetScript("OnEnter", ShowTooltip)
name:SetScript("OnLeave", HideTooltip)

f.name = name
