-- 1. EXTENDED COMMAND DATA (Categorized for Performance)
local GM_CATEGORIES = {
    ["Account"] = {
        {c=".account", d="Base account command"},
        {c=".account create", d="Create new account: .account create name pass"},
        {c=".account delete", d="Delete account by name"},
        {c=".account lock", d="Lock account to IP: .account lock on/off"},
        {c=".account onlinelist", d="List all online accounts"},
        {c=".account password", d="Change account password"},
        {c=".account set addon", d="Set expansion level (0,1,2)"},
        {c=".account set gmlevel", d="Set GM rank (0-4)"},
    },
    ["Character"] = {
        {c=".char level", d="Set level: .char level 80"},
        {c=".char customize", d="Force character customization on next login"},
        {c=".char rename", d="Force rename on next login"},
        {c=".char race", d="Force race change"},
        {c=".char faction", d="Force faction change"},
        {c=".char titles", d="Add title: .char titles add #id"},
        {c=".char setskill", d="Set skill: .char setskill #id #val #max"},
        {c=".char pinfo", d="Show player info by name"},
    },
    ["Cheat/Modify"] = {
        {c=".cheat god", d="God Mode: .cheat god on/off"},
        {c=".cheat fly", d="Fly Mode: .cheat fly on/off"},
        {c=".cheat explore", d="Reveal all maps: .cheat explore 1"},
        {c=".modify hp", d="Set Health"},
        {c=".modify mana", d="Set Mana"},
        {c=".modify speed", d="Set Speed: .modify speed #val (1-50)"},
        {c=".modify swim", d="Set Swim Speed"},
        {c=".modify money", d="Add Money (in copper)"},
        {c=".modify scale", d="Change size: .modify scale #val"},
    },
    ["NPC/Go"] = {
        {c=".npc add", d="Spawn NPC by ID"},
        {c=".npc delete", d="Delete targeted NPC"},
        {c=".npc info", d="Show targeted NPC info"},
        {c=".npc move", d="Move NPC to your location"},
        {c=".gobject add", d="Spawn Object by ID"},
        {c=".gobject delete", d="Delete targeted Object"},
        {c=".gobject move", d="Move Object to your location"},
    },
    ["Lookup"] = {
        {c=".lookup item", d="Search Item ID"},
        {c=".lookup spell", d="Search Spell ID"},
        {c=".lookup creature", d="Search NPC ID"},
        {c=".lookup object", d="Search Object ID"},
        {c=".lookup quest", d="Search Quest ID"},
        {c=".lookup tele", d="Search Teleport location"},
    },
    ["Server"] = {
        {c=".server info", d="Show server uptime/player count"},
        {c=".server shutdown", d="Shutdown in #sec: .server shutdown 60"},
        {c=".server restart", d="Restart in #sec"},
        {c=".server set motd", d="Change Message of the Day"},
        {c=".reannounce", d="Send scrolling center screen message"},
        {c=".notify", d="Send system message to all"},
    }
}

-- 2. WIKI UI SETUP
local wikiFrame = CreateFrame("Frame", "AC_GMWiki", UIParent)
wikiFrame:SetSize(400, 500); wikiFrame:SetPoint("CENTER")
wikiFrame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=32, edgeSize=32, insets={8,8,8,8}})
wikiFrame:Hide(); wikiFrame:SetMovable(true); wikiFrame:EnableMouse(true); wikiFrame:RegisterForDrag("LeftButton")
wikiFrame:SetScript("OnDragStart", wikiFrame.StartMoving); wikiFrame:SetScript("OnDragStop", wikiFrame.StopMovingOrSizing)
local wikiClose = CreateFrame("Button", nil, wikiFrame, "UIPanelCloseButton"); wikiClose:SetPoint("TOPRIGHT", -2, -2)

local searchBar = CreateFrame("EditBox", nil, wikiFrame, "InputBoxTemplate")
searchBar:SetSize(250, 25); searchBar:SetPoint("TOPLEFT", 20, -15); searchBar:SetAutoFocus(false)

local wikiScroll = CreateFrame("ScrollFrame", "AC_WikiScroll", wikiFrame, "UIPanelScrollFrameTemplate")
wikiScroll:SetPoint("TOPLEFT", 15, -45); wikiScroll:SetPoint("BOTTOMRIGHT", -35, 15)
local wikiContent = CreateFrame("Frame", nil, wikiScroll); wikiContent:SetSize(330, 1); wikiScroll:SetScrollChild(wikiContent)

local function UpdateWiki(filter)
    local children = {wikiContent:GetChildren()}
    for _, child in ipairs(children) do child:Hide(); child:SetParent(nil) end
    
    local count = 0
    filter = filter and filter:lower() or ""
    
    -- Iterate through categories
    for catName, commands in pairs(GM_CATEGORIES) do
        local header = wikiContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        header:SetText("--- " .. catName:upper() .. " ---")
        header:SetPoint("TOPLEFT", 10, -(count * 45))
        count = count + 0.6

        for _, data in ipairs(commands) do
            if filter == "" or data.c:lower():find(filter) or data.d:lower():find(filter) then
                local row = CreateFrame("Frame", nil, wikiContent); row:SetSize(320, 40); row:SetPoint("TOPLEFT", 5, -(count * 45))
                
                local cmdText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                cmdText:SetPoint("TOPLEFT", 5, 0); cmdText:SetText("|cffffd100"..data.c.."|r")
                
                local descText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                descText:SetPoint("TOPLEFT", 5, -12); descText:SetWidth(250); descText:SetJustifyH("LEFT")
                descText:SetText(data.d)
                
                local runBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                runBtn:SetSize(45, 20); runBtn:SetPoint("TOPRIGHT", -5, 0); runBtn:SetText("Run")
                runBtn:SetScript("OnClick", function() 
                    if data.c:find(" ") then -- If it needs params, put it in edit box
                        ChatFrame1EditBox:Show(); ChatFrame1EditBox:SetFocus(); ChatFrame1EditBox:SetText(data.c .. " ")
                    else
                        SendChatMessage(data.c, "SAY") 
                    end
                end)
                count = count + 1
            end
        end
        count = count + 0.5
    end
    wikiContent:SetHeight(count * 45)
end

searchBar:SetScript("OnTextChanged", function(self) UpdateWiki(self:GetText()) end)
UpdateWiki("")

-- 3. MAIN TOOL FRAME & BUTTONS (The Sidebar)
local frame = CreateFrame("Frame", "AC_GMFrame", UIParent)
frame:SetSize(160, 450); frame:SetPoint("RIGHT", UIParent, "RIGHT", -100, 0)
frame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=32, edgeSize=32, insets={8,8,8,8}})
frame:Hide()

local function CreateGMButton(text, yOffset, command, parent, width)
    local btn = CreateFrame("Button", nil, parent or frame, "UIPanelButtonTemplate")
    btn:SetSize(width or 140, 30); btn:SetPoint("TOP", 0, yOffset); btn:SetText(text)
    if command then btn:SetScript("OnClick", function() SendChatMessage(command, "SAY") end) end
    return btn
end

-- Sidebar Navigation
CreateGMButton("Max Prof Skills", -30, ".maxskill")
CreateGMButton("Max Recipes", -65):SetScript("OnClick", function() StaticPopup_Show("AC_RECIPE_PROMPT") end)
CreateGMButton("Max Weapons", -100, ".setskill 95 450\n.setskill 162 450\n.setskill 43 450\n.setskill 55 450\n.setskill 44 450\n.setskill 172 450\n.setskill 54 450\n.setskill 160 450\n.setskill 136 450\n.setskill 173 450\n.setskill 229 450")
CreateGMButton("Level 80", -135, ".char level 80")
CreateGMButton("10,000 Gold", -170, ".mod money 100000000")
CreateGMButton("Search DB", -205):SetScript("OnClick", function() StaticPopup_Show("AC_SEARCH_PROMPT") end)
CreateGMButton("Teleports >>", -240)
CreateGMButton("Mounts >>", -275)
CreateGMButton("Command Wiki", -310):SetScript("OnClick", function() if wikiFrame:IsShown() then wikiFrame:Hide() else wikiFrame:Show() end end)

-- Minimap Icon
local MinimapBtn = CreateFrame("Button", "AC_GMMinimapButton", Minimap)
MinimapBtn:SetSize(31, 31); MinimapBtn:SetFrameLevel(20)
local mIcon = MinimapBtn:CreateTexture(nil, "BACKGROUND"); mIcon:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-Blizz"); mIcon:SetSize(20, 20); mIcon:SetPoint("CENTER")
AC_GM_Angle = AC_GM_Angle or 45
local function UpdateMapPos() MinimapBtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(AC_GM_Angle)), (80 * sin(AC_GM_Angle)) - 52) end
MinimapBtn:SetScript("OnMouseUp", function() if frame:IsShown() then frame:Hide() else frame:Show() end end)
UpdateMapPos()

-- Static Popups
StaticPopupDialogs["AC_SEARCH_PROMPT"] = { text = "Search Name:", button1 = "Search", button2 = "Cancel", hasEditBox = true, OnAccept = function(self) SendChatMessage(".lookup item "..self.editBox:GetText(), "SAY"); SendChatMessage(".lookup spell "..self.editBox:GetText(), "SAY") end, timeout = 0, whileDead = true, hideOnEscape = true }
StaticPopupDialogs["AC_RECIPE_PROMPT"] = { text = "Enter Profession Name:", button1 = "Learn", button2 = "Cancel", hasEditBox = true, OnAccept = function(self) SendChatMessage(".learn all recipes "..self.editBox:GetText(), "SAY") end, timeout = 0, whileDead = true, hideOnEscape = true }
