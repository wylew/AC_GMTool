-- 1. MAIN FRAME & MINIMAP BUTTON
local frame = CreateFrame("Frame", "AC_GMFrame", UIParent)
frame:SetSize(160, 560); frame:SetPoint("RIGHT", UIParent, -100, 0)
frame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=32, edgeSize=32, insets={8,8,8,8}})
frame:SetMovable(true); frame:EnableMouse(true); frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving); frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetFrameStrata("HIGH"); frame:Hide()

local mainClose = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
mainClose:SetPoint("TOPRIGHT", -2, -2)

local function ToggleTool() if frame:IsShown() then frame:Hide() else frame:Show() end end

local MinimapBtn = CreateFrame("Button", "AC_GMMinimapBtn", Minimap)
MinimapBtn:SetSize(31, 31); MinimapBtn:SetFrameLevel(20); MinimapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
local mIcon = MinimapBtn:CreateTexture(nil, "BACKGROUND"); mIcon:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-Blizz"); mIcon:SetSize(20, 20); mIcon:SetPoint("CENTER")
AC_GM_Angle = AC_GM_Angle or 45
local function UpdateMapPos()
local x = 80 * cos(rad(AC_GM_Angle)); local y = 80 * sin(rad(AC_GM_Angle))
MinimapBtn:SetPoint("CENTER", Minimap, "CENTER", x, y)
end
MinimapBtn:RegisterForDrag("LeftButton"); MinimapBtn:SetScript("OnDragStart", function(self) self.isDragging = true end); MinimapBtn:SetScript("OnDragStop", function(self) self.isDragging = false end)
MinimapBtn:SetScript("OnUpdate", function(self) if self.isDragging then local mx, my = Minimap:GetCenter(); local px, py = GetCursorPosition(); local scale = Minimap:GetEffectiveScale(); px, py = px / scale, py / scale; AC_GM_Angle = deg(atan2(py - my, px - mx)); UpdateMapPos() end end)
MinimapBtn:SetScript("OnClick", ToggleTool)
UpdateMapPos()

-- 2. UI HELPERS
local function FixScrolling(sf)
sf:EnableMouseWheel(true)
sf:SetScript("OnMouseWheel", function(self, delta)
local cur = self:GetVerticalScroll(); local step = 50
if delta > 0 then self:SetVerticalScroll(math.max(0, cur - step))
    else self:SetVerticalScroll(math.min(self:GetVerticalScrollRange(), cur + step)) end
        end)
end

local function CreateGMButton(text, y, cmd, parent, width)
local b = CreateFrame("Button", nil, parent or frame, "UIPanelButtonTemplate")
b:SetSize(width or 140, 30); b:SetPoint("TOP", 0, y); b:SetText(text)
if cmd then b:SetScript("OnClick", function() SendChatMessage(cmd, "SAY") end) end
    return b
    end

    local function AddListRow(id, type, parent, index)
    local row = CreateFrame("Frame", nil, parent); row:SetSize(210, 35); row:SetPoint("TOPLEFT", 0, -(index * 40))
    local icon = CreateFrame("Button", nil, row); icon:SetSize(30, 30); icon:SetPoint("LEFT", 5, 0)
    local tex = icon:CreateTexture(nil, "BACKGROUND"); tex:SetAllPoints()
    icon:SetScript("OnEnter", function(s) GameTooltip:SetOwner(s, "ANCHOR_RIGHT"); if type == "item" then GameTooltip:SetHyperlink("item:"..id) else GameTooltip:SetHyperlink("spell:"..id) end; GameTooltip:Show() end)
    icon:SetScript("OnLeave", function() GameTooltip:Hide() end)
    local name, _, iPath; if type == "item" then name, _, _, _, _, _, _, _, _, iPath = GetItemInfo(id) else name, _, iPath = GetSpellInfo(id) end
    tex:SetTexture(iPath or "Interface\\Icons\\INV_Misc_QuestionMark")
    local txt = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); txt:SetPoint("LEFT", 40, 5); txt:SetText((name or "Loading..."):sub(1,18))
    local btn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate"); btn:SetSize(55, 18); btn:SetPoint("LEFT", 40, -10); btn:SetText(type=="item" and "Add" or "Learn")
    btn:SetScript("OnClick", function() SendChatMessage((type=="item" and ".additem " or ".learn ")..id, "SAY") end)
    return row
    end

    local function CreatePop(title, w, h)
    local f = CreateFrame("Frame", nil, frame); f:SetSize(w, h); f:SetPoint("RIGHT", frame, "LEFT", -5, 0); f:Hide()
    f:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=16, edgeSize=16, insets={4,4,4,4}})
    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); t:SetPoint("TOP", 0, -10); t:SetText(title)
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton"); close:SetPoint("TOPRIGHT", -2, -2)
    local sf = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOPLEFT", 10, -30); sf:SetPoint("BOTTOMRIGHT", -30, 10)
    local c = CreateFrame("Frame", nil, sf); c:SetSize(w-40, 1); sf:SetScrollChild(c)
    FixScrolling(sf)
    return f, c, sf
    end

    -- 3. UPDATED TELEPORTATION FEATURE
    local tpFrame = CreateFrame("Frame", nil, frame)
    tpFrame:SetSize(140, 310); tpFrame:SetPoint("RIGHT", frame, "LEFT", -5, 0)
    tpFrame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=16, edgeSize=16, insets={4,4,4,4}}); tpFrame:Hide()
    local tpClose = CreateFrame("Button", nil, tpFrame, "UIPanelCloseButton"); tpClose:SetPoint("TOPRIGHT", -2, -2)

    -- Updated City names for commands
    local locs = {{"Dalaran", ".tele dalaran"}, {"Shattrath", ".tele shattrath"}, {"Stormwind", ".tele stormwind"}, {"Orgrimmar", ".tele orgrimmar"}, {"Ironforge", ".tele ironforge"}, {"Undercity", ".tele undercity"}}
    for i, v in ipairs(locs) do CreateGMButton(v[1], -30-((i-1)*30), v[2], tpFrame, 120) end

        -- Custom Teleport Input Box
        local customTPBox = CreateFrame("EditBox", nil, tpFrame, "InputBoxTemplate")
        customTPBox:SetSize(110, 20); customTPBox:SetPoint("TOP", 0, -220); customTPBox:SetAutoFocus(false)
        local customTPBtn = CreateGMButton("Teleport", -245, nil, tpFrame, 110)
        customTPBtn:SetScript("OnClick", function() local city = customTPBox:GetText(); if city ~= "" then SendChatMessage(".tele "..city, "SAY") end end)

        -- 4. OTHER FEATURES (INTACT)
        local itemPop, itemCont = CreatePop("Items", 230, 300)
        local spellPop, spellCont = CreatePop("Spells", 230, 300)
        local wikiPop, wikiCont, wikiSF = CreatePop("Wiki", 400, 500)
        local uI = { 23162, 43651, 17, 38301 }; for i,v in ipairs(uI) do AddListRow(v, "item", itemCont, i-1) end; itemCont:SetHeight(#uI * 40)
        local uS = { 31700, 32028, 24341, 26565 }; for i,v in ipairs(uS) do AddListRow(v, "spell", spellCont, i-1) end; spellCont:SetHeight(#uS * 40)

        local mountFrame = CreateFrame("Frame", nil, frame)
        mountFrame:SetSize(130, 260); mountFrame:SetPoint("RIGHT", frame, "LEFT", -5, 0)
        mountFrame:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", tile=true, tileSize=16, edgeSize=16, insets={4,4,4,4}}); mountFrame:Hide()
        local mtClose = CreateFrame("Button", nil, mountFrame, "UIPanelCloseButton"); mtClose:SetPoint("TOPRIGHT", -2, -2)
        local mounts = {{"Invincible", ".learn 63796"}, {"Mimiron's Head", ".learn 63970"}, {"Amani War Bear", ".learn 43688"}, {"Spectral Tiger", ".learn 42777"}, {"Deathcharger", ".learn 73313"}, {"Ashes of Al'ar", ".learn 31700"}}
        for i, v in ipairs(mounts) do CreateGMButton(v[1], -30-((i-1)*30), v[2], mountFrame, 110) end

            local GM_DATA = {{c=".account create", d="Syntax: .account create $name $pass"}, {c=".account delete", d="Syntax: .account delete $name"}, {c=".account set gmlevel", d="Syntax: .account set gmlevel $name #level #realm"}, {c=".additem", d="Syntax: .additem #id [#count]"}, {c=".announce", d="Syntax: .announce $msg"}, {c=".appear", d="Syntax: .appear $name"}, {c=".aura", d="Syntax: .aura #spellid"}, {c=".ban account", d="Syntax: .ban account $name $time $reason"}, {c=".char level", d="Syntax: .char level [$name] #level"}, {c=".cheat fly", d="Syntax: .cheat fly [on/off]"}, {c=".cometome", d="Syntax: .cometome $name"}, {c=".die", d="Syntax: .die"}, {c=".gm fly", d="Syntax: .gm fly [on/off]"}, {c=".learn all", d="Syntax: .learn all"}, {c=".lookup item", d="Syntax: .lookup item $name"}, {c=".lookup spell", d="Syntax: .lookup spell $name"}, {c=".modify money", d="Syntax: .modify money #copper"}, {c=".modify speed", d="Syntax: .modify speed #value"}, {c=".npc add", d="Syntax: .npc add #id"}, {c=".revive", d="Syntax: .revive [$name]"}, {c=".tele", d="Syntax: .tele $location"}}
            table.sort(GM_DATA, function(a, b) return a.c < b.c end)
            for i, data in ipairs(GM_DATA) do
                local r = CreateFrame("Frame", nil, wikiCont); r:SetSize(330, 75); r:SetPoint("TOPLEFT", 5, -((i-1)*75))
                local cmdTxt = r:CreateFontString(nil, "OVERLAY", "GameFontNormal"); cmdTxt:SetPoint("TOPLEFT", 10, -5); cmdTxt:SetText("|cffffd100"..data.c.."|r")
                local descTxt = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); descTxt:SetPoint("TOPLEFT", 10, -22); descTxt:SetWidth(250); descTxt:SetJustifyH("LEFT"); descTxt:SetText(data.d)
                local btn = CreateFrame("Button", nil, r, "UIPanelButtonTemplate"); btn:SetSize(50, 22); btn:SetPoint("TOPRIGHT", -5, -5); btn:SetText("Run")
                btn:SetScript("OnClick", function() if data.c:find(" ") then ChatFrame1EditBox:Show(); ChatFrame1EditBox:SetFocus(); ChatFrame1EditBox:SetText(data.c.." ") else SendChatMessage(data.c, "SAY") end end)
                end
                wikiCont:SetHeight(#GM_DATA * 75)

                -- 5. MAIN MENU
                local function HideAll() itemPop:Hide(); spellPop:Hide(); tpFrame:Hide(); mountFrame:Hide(); wikiPop:Hide() end
                CreateGMButton("Max Skills", -30, ".maxskill")
                CreateGMButton("Learn Recipes", -65):SetScript("OnClick", function() StaticPopup_Show("AC_RECIPE_PROMPT") end)
                CreateGMButton("Level 80", -100, ".char level 80")
                CreateGMButton("10,000 Gold", -135, ".mod money 100000000")
                CreateGMButton("Search DB", -170):SetScript("OnClick", function() StaticPopup_Show("AC_SEARCH_PROMPT") end)
                local spd = CreateGMButton("Speed: OFF", -205); spd:SetScript("OnClick", function(s) s.st = not s.st; SendChatMessage(".gm fly "..(s.st and "on" or "off"), "SAY"); SendChatMessage(".mod speed "..(s.st and "10" or "1"), "SAY"); s:SetText(s.st and "Speed: ON" or "Speed: OFF") end)
                CreateGMButton("Items <<", -240):SetScript("OnClick", function() local s = itemPop:IsShown(); HideAll(); if not s then itemPop:Show() end end)
                CreateGMButton("Spells <<", -275):SetScript("OnClick", function() local s = spellPop:IsShown(); HideAll(); if not s then spellPop:Show() end end)
                CreateGMButton("Wiki <<", -310):SetScript("OnClick", function() local s = wikiPop:IsShown(); HideAll(); if not s then wikiPop:Show() end end)
                CreateGMButton("Teleports <<", -345):SetScript("OnClick", function() local s = tpFrame:IsShown(); HideAll(); if not s then tpFrame:Show() end end)
                CreateGMButton("Mounts <<", -380):SetScript("OnClick", function() local s = mountFrame:IsShown(); HideAll(); if not s then mountFrame:Show() end end)

                -- 6. SEARCH SYSTEM
                local resFrame, resContent, resSF = CreatePop("Results", 350, 500); resFrame:SetPoint("CENTER", UIParent)
                local resultIdx = 0
                local function AddResultEntry(id, name, type)
                AddListRow(id, type, resContent, resultIdx); resultIdx = resultIdx + 1; resContent:SetHeight(resultIdx * 40); resSF:UpdateScrollChildRect()
                end
                local capture = CreateFrame("Frame"); capture:RegisterEvent("CHAT_MSG_SYSTEM")
                capture:SetScript("OnEvent", function(_, _, msg)
                local iID, iName = msg:match("item:(%d+):.-%[(.-)%]"); if iID then AddResultEntry(iID, iName, "item"); resFrame:Show() end
                local sID, sName = msg:match("spell:(%d+):.-%[(.-)%]"); if sID then AddResultEntry(sID, sName, "spell"); resFrame:Show() end
                end)
                StaticPopupDialogs["AC_SEARCH_PROMPT"] = { text = "Search DB:", button1 = "Search", hasEditBox = true, OnAccept = function(s) resultIdx = 0; local ch = {resContent:GetChildren()}; for _, c in ipairs(ch) do if c.SetParent then c:Hide(); c:SetParent(nil) end end; SendChatMessage(".lookup item "..s.editBox:GetText(), "SAY"); SendChatMessage(".lookup spell "..s.editBox:GetText(), "SAY") end, timeout = 0, whileDead = true, hideOnEscape = true }
                StaticPopupDialogs["AC_RECIPE_PROMPT"] = { text = "Profession Name:", button1 = "Learn", hasEditBox = true, OnAccept = function(s) SendChatMessage(".learn all recipes "..s.editBox:GetText(), "SAY") end, timeout = 0, whileDead = true, hideOnEscape = true }
                SLASH_ACGMTOOL1 = "/gmt"; SlashCmdList["ACGMTOOL"] = ToggleTool
