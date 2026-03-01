-- 1. MAIN FRAME SETUP
local frame = CreateFrame("Frame", "AC_GMFrame", UIParent)
frame:SetSize(160, 520); frame:SetPoint("RIGHT", UIParent, "RIGHT", -100, 0)
frame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=32, edgeSize=32, insets={8,8,8,8}})
frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving); frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetFrameStrata("HIGH"); frame:Hide()
local mainClose = CreateFrame("Button", nil, frame, "UIPanelCloseButton"); mainClose:SetPoint("TOPRIGHT", 0, 0)

-- 2. HELPER: CREATE BUTTONS
local function CreateGMButton(text, yOffset, command, parent, width)
local btn = CreateFrame("Button", nil, parent or frame, "UIPanelButtonTemplate")
btn:SetSize(width or 140, 30); btn:SetPoint("TOP", 0, yOffset); btn:SetText(text)
if command then btn:SetScript("OnClick", function() SendChatMessage(command, "SAY") end) end
    return btn
    end

    -- 3. REUSABLE LIST ROW BUILDER
    local function AddListRow(id, type, parentContent, index)
    local row = CreateFrame("Frame", nil, parentContent); row:SetSize(210, 35)
    row:SetPoint("TOPLEFT", 0, -(index * 40))
    local btnIcon = CreateFrame("Button", nil, row); btnIcon:SetSize(30, 30); btnIcon:SetPoint("LEFT", 5, 0)
    local tex = btnIcon:CreateTexture(nil, "BACKGROUND"); tex:SetAllPoints()
    btnIcon:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    if type == "item" then GameTooltip:SetHyperlink("item:"..id) else GameTooltip:SetHyperlink("spell:"..id) end
        GameTooltip:Show()
        end)
    btnIcon:SetScript("OnLeave", function() GameTooltip:Hide() end)
    local name, _, iconPath
    if type == "item" then name, _, _, _, _, _, _, _, _, iconPath = GetItemInfo(id) else name, _, iconPath = GetSpellInfo(id) end
        tex:SetTexture(iconPath or "Interface\\Icons\\INV_Misc_QuestionMark")
        local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        nameText:SetPoint("LEFT", 40, 5); nameText:SetText((name or "Loading..."):sub(1,20))
        local act = CreateFrame("Button", nil, row, "UIPanelButtonTemplate"); act:SetSize(55, 18); act:SetPoint("LEFT", 40, -10); act:SetText(type == "item" and "Add" or "Learn")
        act:SetScript("OnClick", function() SendChatMessage(((type=="item") and ".additem " or ".learn ")..id, "SAY") end)
        return row
        end

        -- 4. POPOUT WINDOWS (Useful Items / Spells)
        local function CreatePopoutList(title, width, height)
        local f = CreateFrame("Frame", nil, frame)
        f:SetSize(width, height); f:SetPoint("RIGHT", frame, "LEFT", -5, 0)
        f:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=16, edgeSize=16, insets={4,4,4,4}}); f:Hide()
        local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); t:SetPoint("TOP", 0, -10); t:SetText(title)
        local sf = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
        sf:SetPoint("TOPLEFT", 10, -30); sf:SetPoint("BOTTOMRIGHT", -30, 10)
        local c = CreateFrame("Frame", nil, sf); c:SetSize(width-40, 1); sf:SetScrollChild(c)
        return f, c
        end

        local itemPop, itemCont = CreatePopoutList("Useful Items", 230, 300)
        local spellPop, spellCont = CreatePopoutList("Useful Spells", 230, 300)

        -- HAND POPULATE (Verified via wotlkdb.com)
        -- Items: 23162 (Foror's Crate), 43651 (Crafty's Pole), 17 (Martin Fury), 38301 (D.I.S.C.O.)
        local usefulItems = { 23162, 43651, 17, 38301 }
        for i, id in ipairs(usefulItems) do AddListRow(id, "item", itemCont, i-1) end

            -- Spells: 31700 (Black Qiraji), 32028 (Elune's Embrace), 24341 (Revive), 26565 (Heal Brethren)
            local usefulSpells = { 31700, 32028, 24341, 26565 }
            for i, id in ipairs(usefulSpells) do AddListRow(id, "spell", spellCont, i-1) end

                -- 5. TELEPORT & MOUNT MENUS (Custom Hand-Updates Integrated)
                local tpFrame = CreateFrame("Frame", nil, frame)
                tpFrame:SetSize(130, 240); tpFrame:SetPoint("RIGHT", frame, "LEFT", -5, 0)
                tpFrame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=16, edgeSize=16, insets={4,4,4,4}}); tpFrame:Hide()
                local locs = {{"Dalaran", ".tele dal"}, {"Shattrath", ".tele sha"}, {"Stormwind", ".tele sw"}, {"Orgrimmar", ".tele org"}, {"Ironforge", ".tele iron"}, {"Undercity", ".tele under"}}
                for i, v in ipairs(locs) do CreateGMButton(v[1], -10-((i-1)*30), v[2], tpFrame, 110) end

                    local mountFrame = CreateFrame("Frame", nil, frame)
                    mountFrame:SetSize(130, 260); mountFrame:SetPoint("RIGHT", frame, "LEFT", -5, 0)
                    mountFrame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=16, edgeSize=16, insets={4,4,4,4}}); mountFrame:Hide()
                    local mounts = {{"Invincible", ".learn 63796"}, {"Mimiron's Head", ".learn 63970"}, {"Amani War Bear", ".learn 43688"}, {"Spectral Tiger", ".learn 42777"}, {"Deathcharger", ".learn 73313"}, {"Ashes of Al'ar", ".learn 31700"}}
                    for i, v in ipairs(mounts) do CreateGMButton(v[1], -10-((i-1)*30), v[2], mountFrame, 110) end

                        -- 6. SEARCH RESULTS WINDOW
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
                            local row = AddListRow(id, type, content, (type == "item" and itemIdx or (itemIdx + spellIdx + 1)))
                            if type == "item" then itemIdx = itemIdx + 1 else spellIdx = spellIdx + 1 end
                                end

                                -- 7. TOGGLE & SLASH COMMANDS
                                local function HideAll() tpFrame:Hide(); mountFrame:Hide(); itemPop:Hide(); spellPop:Hide() end
                                local function ToggleTool() if frame:IsShown() then frame:Hide(); HideAll(); resFrame:Hide() else frame:Show() end end
                                SLASH_ACGMTOOL1, SLASH_ACGMTOOL2 = "/gmtool", "/gmt"; SlashCmdList["ACGMTOOL"] = ToggleTool

                                -- 8. MINIMAP BUTTON
                                local MinimapBtn = CreateFrame("Button", "AC_GMMinimapButton", Minimap)
                                MinimapBtn:SetSize(31, 31); MinimapBtn:SetFrameLevel(20); MinimapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
                                local mIcon = MinimapBtn:CreateTexture(nil, "BACKGROUND"); mIcon:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-Blizz"); mIcon:SetSize(20, 20); mIcon:SetPoint("CENTER")
                                AC_GM_Angle = AC_GM_Angle or 45
                                local function UpdateMapPos() MinimapBtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(AC_GM_Angle)), (80 * sin(AC_GM_Angle)) - 52) end
                                MinimapBtn:RegisterForDrag("LeftButton"); MinimapBtn:SetScript("OnDragStart", function(self) self.isDragging = true end); MinimapBtn:SetScript("OnDragStop", function(self) self.isDragging = false end)
                                MinimapBtn:SetScript("OnUpdate", function(self) if self.isDragging then local x, y = GetCursorPosition(); local scale = Minimap:GetEffectiveScale(); local cx, cy = Minimap:GetCenter(); AC_GM_Angle = deg(atan2(y/scale - cy, x/scale - cx)); UpdateMapPos() end end)
                                MinimapBtn:SetScript("OnMouseUp", function(self) if not self.isDragging then ToggleTool() end end)
                                UpdateMapPos()

                                -- 9. MAIN MENU BUTTONS
                                CreateGMButton("Max Prof Skills", -30, ".maxskill")
                                CreateGMButton("Max Recipes", -65):SetScript("OnClick", function() StaticPopup_Show("AC_RECIPE_PROMPT") end)
                                CreateGMButton("Max Weapons", -100, ".setskill 95 450\n.setskill 162 450\n.setskill 43 450\n.setskill 55 450\n.setskill 44 450\n.setskill 172 450\n.setskill 54 450\n.setskill 160 450\n.setskill 136 450\n.setskill 173 450\n.setskill 229 450")
                                CreateGMButton("Level 80", -135, ".char level 80")
                                CreateGMButton("10,000 Gold", -170, ".mod money 100000000")
                                CreateGMButton("Search DB", -205):SetScript("OnClick", function() itemIdx, spellIdx = 0, 0; local ch = {content:GetChildren()}; for _, c in ipairs(ch) do if c:IsObjectType("Frame") then c:Hide(); c:SetParent(nil) end end; StaticPopup_Show("AC_SEARCH_PROMPT") end)
                                local speedBtn = CreateGMButton("Speed: OFF", -240)
                                speedBtn:SetScript("OnClick", function(self) self.state = not self.state; SendChatMessage(".gm fly "..(self.state and "on" or "off"), "SAY"); SendChatMessage(".mod speed "..(self.state and "10" or "1"), "SAY"); self:SetText(self.state and "Speed: ON" or "Speed: OFF") end)
                                CreateGMButton("Useful Items <<", -275):SetScript("OnClick", function() local s = itemPop:IsShown(); HideAll(); if not s then itemPop:Show() end end)
                                CreateGMButton("Useful Spells <<", -310):SetScript("OnClick", function() local s = spellPop:IsShown(); HideAll(); if not s then spellPop:Show() end end)
                                CreateGMButton("Teleports <<", -345):SetScript("OnClick", function() local s = tpFrame:IsShown(); HideAll(); if not s then tpFrame:Show() end end)
                                CreateGMButton("Mounts <<", -380):SetScript("OnClick", function() local s = mountFrame:IsShown(); HideAll(); if not s then mountFrame:Show() end end)

                                -- 10. CAPTURE & POPUPS
                                local capture = CreateFrame("Frame"); capture:RegisterEvent("CHAT_MSG_SYSTEM")
                                capture:SetScript("OnEvent", function(_, _, msg)
                                local iID, iName = msg:match("item:(%d+):.-%[(.-)%]"); if iID then AddResultEntry(iID, iName, "item"); resFrame:Show(); return end
                                local sID, sName = msg:match("spell:(%d+):.-%[(.-)%]"); if sID then AddResultEntry(sID, sName, "spell"); resFrame:Show(); return end
                                end)
                                StaticPopupDialogs["AC_CUSTOM_MOUNT"] = { text = "Enter Mount Spell ID:", button1 = "Learn", button2 = "Cancel", hasEditBox = true, OnAccept = function(self) SendChatMessage(".learn "..self.editBox:GetText(), "SAY") end, timeout = 0, whileDead = true, hideOnEscape = true }
                                StaticPopupDialogs["AC_SEARCH_PROMPT"] = { text = "Search Name:", button1 = "Search", button2 = "Cancel", hasEditBox = true, OnAccept = function(self) SendChatMessage(".lookup item "..self.editBox:GetText(), "SAY"); SendChatMessage(".lookup spell "..self.editBox:GetText(), "SAY") end, timeout = 0, whileDead = true, hideOnEscape = true }
                                StaticPopupDialogs["AC_RECIPE_PROMPT"] = { text = "Enter Profession Name:", button1 = "Learn", button2 = "Cancel", hasEditBox = true, OnAccept = function(self) SendChatMessage(".learn all recipes "..self.editBox:GetText(), "SAY") end, timeout = 0, whileDead = true, hideOnEscape = true }
