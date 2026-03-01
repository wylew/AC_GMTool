-- 1. MAIN FRAME SETUP (Movable)
local frame = CreateFrame("Frame", "AC_GMFrame", UIParent)
frame:SetSize(160, 480); frame:SetPoint("RIGHT", UIParent, "RIGHT", -100, 0)
frame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=32, edgeSize=32, insets={8,8,8,8}})
frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving); frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetFrameStrata("HIGH"); frame:Hide()
local mainClose = CreateFrame("Button", nil, frame, "UIPanelCloseButton"); mainClose:SetPoint("TOPRIGHT", 0, 0)

-- 2. COMMAND WIKI DATA & UI
local GM_CATEGORIES = {
    ["Account"] = {
        {c=".account create", d="Create account: .account create name pass"},
        {c=".account set gmlevel", d="Set GM rank (0-4)"},
        {c=".account password", d="Change password"},
    },
    ["Character"] = {
        {c=".char level", d="Set level: .char level 80"},
        {c=".char customize", d="Force customization on login"},
        {c=".char rename", d="Force rename"},
        {c=".char titles", d="Add title: .char titles add #id"},
    },
    ["Cheat/Mod"] = {
        {c=".cheat god", d="God Mode: .cheat god on/off"},
        {c=".cheat fly", d="Fly Mode: .cheat fly on/off"},
        {c=".modify hp", d="Set Health"},
        {c=".modify speed", d="Set Speed (1-50)"},
        {c=".modify money", d="Add Money (in copper)"},
    },
    ["Server"] = {
        {c=".server info", d="Show uptime/players"},
        {c=".server shutdown", d="Shutdown in #sec"},
        {c=".notify", d="Global system message"},
    }
}

local wikiFrame = CreateFrame("Frame", "AC_GMWiki", UIParent)
wikiFrame:SetSize(380, 500); wikiFrame:SetPoint("CENTER")
wikiFrame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=32, edgeSize=32, insets={8,8,8,8}})
wikiFrame:Hide(); wikiFrame:SetMovable(true); wikiFrame:EnableMouse(true); wikiFrame:RegisterForDrag("LeftButton")
wikiFrame:SetScript("OnDragStart", wikiFrame.StartMoving); wikiFrame:SetScript("OnDragStop", wikiFrame.StopMovingOrSizing)
local wikiClose = CreateFrame("Button", nil, wikiFrame, "UIPanelCloseButton"); wikiClose:SetPoint("TOPRIGHT", -2, -2)

local searchBar = CreateFrame("EditBox", nil, wikiFrame, "InputBoxTemplate")
searchBar:SetSize(250, 25); searchBar:SetPoint("TOPLEFT", 20, -15); searchBar:SetAutoFocus(false)

local wikiScroll = CreateFrame("ScrollFrame", "AC_WikiScroll", wikiFrame, "UIPanelScrollFrameTemplate")
wikiScroll:SetPoint("TOPLEFT", 15, -45); wikiScroll:SetPoint("BOTTOMRIGHT", -35, 15)
local wikiContent = CreateFrame("Frame", nil, wikiScroll); wikiContent:SetSize(310, 1); wikiScroll:SetScrollChild(wikiContent)

local function UpdateWiki(filter)
local children = {wikiContent:GetChildren()}
for _, child in ipairs(children) do child:Hide(); child:SetParent(nil) end
    local count, filter = 0, (filter and filter:lower() or "")
    for catName, commands in pairs(GM_CATEGORIES) do
        local header = wikiContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        header:SetText("--- " .. catName:upper() .. " ---"); header:SetPoint("TOPLEFT", 10, -(count * 45)); count = count + 0.6
        for _, data in ipairs(commands) do
            if filter == "" or data.c:lower():find(filter) or data.d:lower():find(filter) then
                local row = CreateFrame("Frame", nil, wikiContent); row:SetSize(300, 40); row:SetPoint("TOPLEFT", 5, -(count * 45))
                local cmdText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                cmdText:SetPoint("TOPLEFT", 5, 0); cmdText:SetText("|cffffd100"..data.c.."|r")
                local descText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                descText:SetPoint("TOPLEFT", 5, -12); descText:SetWidth(230); descText:SetJustifyH("LEFT"); descText:SetText(data.d)
                local runBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                runBtn:SetSize(45, 20); runBtn:SetPoint("TOPRIGHT", -5, 0); runBtn:SetText("Run")
                runBtn:SetScript("OnClick", function()
                if data.c:find(" ") then ChatFrame1EditBox:Show(); ChatFrame1EditBox:SetFocus(); ChatFrame1EditBox:SetText(data.c .. " ")
                    else SendChatMessage(data.c, "SAY") end
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

                -- 3. SEARCH RESULTS (RESTORED)
                local resFrame = CreateFrame("Frame", "AC_GMResults", UIParent)
                resFrame:SetSize(350, 500); resFrame:SetPoint("CENTER")
                resFrame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=32, edgeSize=32, insets={8,8,8,8}})
                resFrame:Hide(); resFrame:SetMovable(true); resFrame:EnableMouse(true); resFrame:RegisterForDrag("LeftButton")
                resFrame:SetScript("OnDragStart", resFrame.StartMoving); resFrame:SetScript("OnDragStop", resFrame.StopMovingOrSizing)
                local resClose = CreateFrame("Button", nil, resFrame, "UIPanelCloseButton"); resClose:SetPoint("TOPRIGHT", -2, -2)

                local scrollFrame = CreateFrame("ScrollFrame", "AC_GMScroll", resFrame, "UIPanelScrollFrameTemplate")
                scrollFrame:SetPoint("TOPLEFT", 15, -45); scrollFrame:SetPoint("BOTTOMRIGHT", -35, 15)
                local content = CreateFrame("Frame", nil, scrollFrame); content:SetSize(280, 1); scrollFrame:SetScrollChild(content)
                local itemHeader = content:CreateFontString(nil, "OVERLAY", "GameFontNormal"); itemHeader:SetText("--- ITEMS ---"); itemHeader:SetPoint("TOPLEFT", 10, 0)
                local spellHeader = content:CreateFontString(nil, "OVERLAY", "GameFontNormal"); spellHeader:SetText("--- SPELLS ---"); spellHeader:SetPoint("TOPLEFT", 10, -20)
                local itemIdx, spellIdx = 0, 0

                local function AddResultEntry(id, name, type)
                if not id then return end
                    local row = CreateFrame("Frame", nil, content); row:SetSize(270, 35)
                    local btnIcon = CreateFrame("Button", nil, row); btnIcon:SetSize(30, 30); btnIcon:SetPoint("LEFT", 5, 0)
                    local tex = btnIcon:CreateTexture(nil, "BACKGROUND"); tex:SetAllPoints()
                    btnIcon:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); if type == "item" then GameTooltip:SetHyperlink("item:"..id) else GameTooltip:SetHyperlink("spell:"..id) end; GameTooltip:Show() end)
                    btnIcon:SetScript("OnLeave", function() GameTooltip:Hide() end)
                    btnIcon:SetScript("OnClick", function() if IsControlKeyDown() and type == "item" then DressUpItemLink("item:"..id) end end)
                    local _, _, iconPath
                    if type == "item" then _, _, _, _, _, _, _, _, _, iconPath = GetItemInfo(id) else _, _, iconPath = GetSpellInfo(id) end
                        tex:SetTexture(iconPath or "Interface\\Icons\\INV_Misc_QuestionMark")
                        local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); nameText:SetPoint("LEFT", 40, 5); nameText:SetText(((type == "item") and "|cff0070dd" or "|cff1eff00")..name.."|r")
                        local act = CreateFrame("Button", nil, row, "UIPanelButtonTemplate"); act:SetSize(60, 18); act:SetPoint("LEFT", 40, -10); act:SetText(type == "item" and "Add" or "Learn")
                        act:SetScript("OnClick", function() SendChatMessage(((type=="item") and ".additem " or ".learn ")..id, "SAY") end)
                        if type == "item" then itemIdx = itemIdx + 1; row:SetPoint("TOPLEFT", 0, -20 - (itemIdx * 40)); spellHeader:SetPoint("TOPLEFT", 10, -30 - ((itemIdx+1) * 40))
                            else spellIdx = spellIdx + 1; row:SetPoint("TOPLEFT", 0, spellHeader:GetTop() - content:GetTop() - (spellIdx * 40)) end
                                content:SetHeight(math.abs(-30 - ((itemIdx+1) * 40) - ((spellIdx+1) * 40)))
                                end

                                -- 4. TOGGLE LOGIC
                                local function ToggleTool()
                                if frame:IsShown() then
                                    frame:Hide(); tpFrame:Hide(); mountFrame:Hide(); wikiFrame:Hide(); resFrame:Hide()
                                    else frame:Show() end
                                        end
                                        SLASH_ACGMTOOL1, SLASH_ACGMTOOL2 = "/gmtool", "/gmt"; SlashCmdList["ACGMTOOL"] = ToggleTool

                                        -- 5. HELPER & SUB-MENUS (Your Left-Sided Logic)
                                        local function CreateGMButton(text, yOffset, command, parent, width)
                                        local btn = CreateFrame("Button", nil, parent or frame, "UIPanelButtonTemplate")
                                        btn:SetSize(width or 140, 30); btn:SetPoint("TOP", 0, yOffset); btn:SetText(text)
                                        if command then btn:SetScript("OnClick", function() SendChatMessage(command, "SAY") end) end
                                            return btn
                                            end

                                            local tpFrame = CreateFrame("Frame", nil, frame)
                                            tpFrame:SetSize(130, 240); tpFrame:SetPoint("RIGHT", frame, "LEFT", -5, 0)
                                            tpFrame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=16, edgeSize=16, insets={4,4,4,4}}); tpFrame:Hide()
                                            local locs = {{"Dalaran", ".tele dal"}, {"Shattrath", ".tele sha"}, {"Stormwind", ".tele sw"}, {"Orgrimmar", ".tele org"}, {"Ironforge", ".tele iron"}, {"Undercity", ".tele under"}}
                                            for i, v in ipairs(locs) do CreateGMButton(v[1], -10-((i-1)*30), v[2], tpFrame, 110) end
                                                CreateGMButton("Custom...", -195, nil, tpFrame, 110):SetScript("OnClick", function() StaticPopup_Show("AC_CUSTOM_TELE") end)

                                                local mountFrame = CreateFrame("Frame", nil, frame)
                                                mountFrame:SetSize(130, 260); mountFrame:SetPoint("RIGHT", frame, "LEFT", -5, 0)
                                                mountFrame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=16, edgeSize=16, insets={4,4,4,4}}); mountFrame:Hide()
                                                local mounts = {{"Invincible", ".learn 63796"}, {"Mimiron's Head", ".learn 63970"}, {"Amani War Bear", ".learn 43688"}, {"Spectral Tiger", ".learn 42777"}, {"Deathcharger", ".learn 73313"}, {"Firefly", ".learn 31700"}}
                                                for i, v in ipairs(mounts) do CreateGMButton(v[1], -10-((i-1)*30), v[2], mountFrame, 110) end
                                                    CreateGMButton("Custom ID...", -220, nil, mountFrame, 110):SetScript("OnClick", function() StaticPopup_Show("AC_CUSTOM_MOUNT") end)

                                                    -- 6. MINIMAP BUTTON
                                                    local MinimapBtn = CreateFrame("Button", "AC_GMMinimapButton", Minimap)
                                                    MinimapBtn:SetSize(31, 31); MinimapBtn:SetFrameLevel(20); MinimapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
                                                    local mIcon = MinimapBtn:CreateTexture(nil, "BACKGROUND"); mIcon:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-Blizz"); mIcon:SetSize(20, 20); mIcon:SetPoint("CENTER")
                                                    AC_GM_Angle = AC_GM_Angle or 45
                                                    local function UpdateMapPos() MinimapBtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(AC_GM_Angle)), (80 * sin(AC_GM_Angle)) - 52) end
                                                    MinimapBtn:RegisterForDrag("LeftButton"); MinimapBtn:SetScript("OnDragStart", function(self) self.isDragging = true end); MinimapBtn:SetScript("OnDragStop", function(self) self.isDragging = false end)
                                                    MinimapBtn:SetScript("OnUpdate", function(self) if self.isDragging then local x, y = GetCursorPosition(); local scale = Minimap:GetEffectiveScale(); local cx, cy = Minimap:GetCenter(); AC_GM_Angle = deg(atan2(y/scale - cy, x/scale - cx)); UpdateMapPos() end end)
                                                    MinimapBtn:SetScript("OnMouseUp", function(self) if not self.isDragging then ToggleTool() end end)
                                                    UpdateMapPos()

                                                    -- 7. MAIN MENU BUTTONS
                                                    CreateGMButton("Max Prof Skills", -30, ".maxskill")
                                                    CreateGMButton("Max Recipes", -65):SetScript("OnClick", function() StaticPopup_Show("AC_RECIPE_PROMPT") end)
                                                    CreateGMButton("Max Weapons", -100, ".setskill 95 450\n.setskill 162 450\n.setskill 43 450\n.setskill 55 450\n.setskill 44 450\n.setskill 172 450\n.setskill 54 450\n.setskill 160 450\n.setskill 136 450\n.setskill 173 450\n.setskill 229 450")
                                                    CreateGMButton("Level 80", -135, ".char level 80")
                                                    CreateGMButton("10,000 Gold", -170, ".mod money 100000000")
                                                    CreateGMButton("Search DB", -205):SetScript("OnClick", function() itemIdx, spellIdx = 0, 0; local ch = {content:GetChildren()}; for _, c in ipairs(ch) do if c:IsObjectType("Frame") then c:Hide(); c:SetParent(nil) end end; StaticPopup_Show("AC_SEARCH_PROMPT") end)
                                                    local speedBtn = CreateGMButton("Speed: OFF", -240)
                                                    speedBtn:SetScript("OnClick", function(self) self.state = not self.state; SendChatMessage(".gm fly "..(self.state and "on" or "off"), "SAY"); SendChatMessage(".mod speed "..(self.state and "10" or "1"), "SAY"); self:SetText(self.state and "Speed: ON" or "Speed: OFF") end)
                                                    CreateGMButton("Teleports <<", -275):SetScript("OnClick", function() mountFrame:Hide(); wikiFrame:Hide(); if tpFrame:IsShown() then tpFrame:Hide() else tpFrame:Show() end end)
                                                    CreateGMButton("Mounts <<", -310):SetScript("OnClick", function() tpFrame:Hide(); wikiFrame:Hide(); if mountFrame:IsShown() then mountFrame:Hide() else mountFrame:Show() end end)
                                                    CreateGMButton("Command Wiki", -345):SetScript("OnClick", function() tpFrame:Hide(); mountFrame:Hide(); if wikiFrame:IsShown() then wikiFrame:Hide() else wikiFrame:Show() end end)

                                                    -- 8. CAPTURE ENGINE & POPUPS
                                                    local capture = CreateFrame("Frame"); capture:RegisterEvent("CHAT_MSG_SYSTEM")
                                                    capture:SetScript("OnEvent", function(_, _, msg)
                                                    local iID, iName = msg:match("item:(%d+):.-%[(.-)%]"); if iID then AddResultEntry(iID, iName, "item"); resFrame:Show(); return end
                                                    local sID, sName = msg:match("spell:(%d+):.-%[(.-)%]"); if sID then AddResultEntry(sID, sName, "spell"); resFrame:Show(); return end
                                                    end)

                                                    StaticPopupDialogs["AC_CUSTOM_MOUNT"] = { text = "Enter Mount Spell ID:", button1 = "Learn", button2 = "Cancel", hasEditBox = true, OnAccept = function(self) SendChatMessage(".learn "..self.editBox:GetText(), "SAY") end, timeout = 0, whileDead = true, hideOnEscape = true }
                                                    StaticPopupDialogs["AC_CUSTOM_TELE"] = { text = "Teleport to:", button1 = "Go", button2 = "Cancel", hasEditBox = true, OnAccept = function(self) SendChatMessage(".tele "..self.editBox:GetText(), "SAY") end, timeout = 0, whileDead = true, hideOnEscape = true }
                                                    StaticPopupDialogs["AC_SEARCH_PROMPT"] = { text = "Search Name:", button1 = "Search", button2 = "Cancel", hasEditBox = true, OnAccept = function(self) SendChatMessage(".lookup item "..self.editBox:GetText(), "SAY"); SendChatMessage(".lookup spell "..self.editBox:GetText(), "SAY") end, timeout = 0, whileDead = true, hideOnEscape = true }
                                                    StaticPopupDialogs["AC_RECIPE_PROMPT"] = { text = "Enter Profession Name:", button1 = "Learn", button2 = "Cancel", hasEditBox = true, OnAccept = function(self) SendChatMessage(".learn all recipes "..self.editBox:GetText(), "SAY") end, timeout = 0, whileDead = true, hideOnEscape = true }
