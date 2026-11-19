local ADDON_NAME, RPGTF = ...

function RPGTF:RefreshDisplay()
    if not self.frame then
        return
    end
    if self.testing then
        self:ShowTest()
    else
        self:UpdateUnit()
    end
end

function RPGTF:ApplyAppearance()
    if not self.frame or not self.db then
        return
    end

    self:ApplyFramePlacement()
    self:RefreshFonts()

    local function Paint(bar)
        if not bar then
            return
        end
        self:ApplyArt(bar.health_bar, bar.width, bar.height)
        self:ApplyHealthFill(bar.health_bar)
        self:ApplyBackgroundTexture(bar.background)
        self:ApplyBackgroundTexture(bar.power_background)
    end

    Paint(self.bar)
    Paint(self.tot)
    if self.ApplyCastBorder then
        self:ApplyCastBorder()
    end
    self:RefreshDisplay()
    if self.RefreshSettingsPanel then
        self:RefreshSettingsPanel()
    end
end

local function AddChooser(panel, label, y, list_fn, get_fn, set_fn)
    local caption = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    caption:SetPoint("TOPLEFT", 16, y)
    caption:SetText(label)

    local button = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    button:SetSize(230, 22)
    button:SetPoint("LEFT", caption, "RIGHT", 12, 0)

    local function CurrentText()
        local value = get_fn()
        if type(value) ~= "string" or value == "" then
            return "None"
        end
        return value
    end

    button:SetScript("OnClick", function(self)
        local list = list_fn()
        if MenuUtil and MenuUtil.CreateContextMenu then
            MenuUtil.CreateContextMenu(self, function(_, root)
                for index = 1, #list do
                    local name = list[index]
                    root:CreateRadio(name, function()
                        return get_fn() == name
                    end, function()
                        set_fn(name)
                        self:SetText(name)
                    end)
                end
            end)
            return
        end

        local current = get_fn()
        local next_index = 1
        for index = 1, #list do
            if list[index] == current then
                next_index = index % #list + 1
                break
            end
        end
        if list[next_index] then
            set_fn(list[next_index])
            self:SetText(list[next_index])
        end
    end)

    button.Refresh = function(self)
        self:SetText(CurrentText())
    end
    button:SetText(CurrentText())
    return button
end

function RPGTF:CreateSettingsPanel()
    if self.settings_panel then
        return self.settings_panel
    end

    local panel = CreateFrame("Frame", "RPGTargetFrameSettings", UIParent, "BackdropTemplate")
    panel:SetSize(460, 292)
    panel:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
    panel:SetFrameStrata("DIALOG")
    panel:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 },
    })
    panel:Hide()
    panel:SetMovable(true)
    panel:EnableMouse(true)
    panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart", panel.StartMoving)
    panel:SetScript("OnDragStop", panel.StopMovingOrSizing)

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -18)
    title:SetText("RPG Target Frame")

    local close = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)

    local check = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    check:SetPoint("TOPLEFT", 16, -48)
    check:SetScript("OnClick", function(self)
        RPGTF.db.frame.show_target_of_target = self:GetChecked() and true or false
        RPGTF:RefreshDisplay()
    end)
    local check_label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    check_label:SetPoint("LEFT", check, "RIGHT", 2, 0)
    check_label:SetText("Target of target")

    local slider = CreateFrame("Slider", "RPGTargetFrameScale", panel, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", 24, -100)
    slider:SetWidth(200)
    slider:SetMinMaxValues(0.5, 2)
    slider:SetValueStep(0.05)
    slider:SetObeyStepOnDrag(true)
    if slider.Low then
        slider.Low:SetText("0.5")
    end
    if slider.High then
        slider.High:SetText("2")
    end
    slider:SetScript("OnValueChanged", function(self, value)
        local stepped = math.floor((value * 20) + 0.5) / 20
        if self.Text then
            self.Text:SetText(string.format("Scale: %.2f", stepped))
        end
        if RPGTF.settings_refreshing then
            return
        end
        RPGTF.db.frame.scale = stepped
        RPGTF:ApplyFramePlacement()
    end)

    local controls = {
        check = check,
        slider = slider,
    }
    controls.skin = AddChooser(panel, "Skin", -148, function()
        return RPGTF:SkinNames()
    end, function()
        local skin = RPGTF:FindSkin(RPGTF.db.frame.skin)
        return skin and skin.name or "Vigor Dark"
    end, function(name)
        RPGTF:SelectSkin(name)
    end)
    controls.font = AddChooser(panel, "Font", -180, function()
        return RPGTF:MediaList("font")
    end, function()
        return RPGTF.db.frame.font
    end, function(name)
        RPGTF.db.frame.font = name
        RPGTF:ApplyAppearance()
    end)
    controls.border = AddChooser(panel, "Border", -212, function()
        return RPGTF:MediaList("border")
    end, function()
        return RPGTF.db.frame.border
    end, function(name)
        RPGTF.db.frame.border = name
        RPGTF:ApplyAppearance()
    end)
    controls.background = AddChooser(panel, "Background", -244, function()
        return RPGTF:MediaList("background")
    end, function()
        return RPGTF.db.frame.background
    end, function(name)
        RPGTF.db.frame.background = name
        RPGTF:ApplyAppearance()
    end)

    self.settings_controls = controls
    self.settings_panel = panel
    panel:SetScript("OnShow", function()
        RPGTF:RefreshSettingsPanel()
    end)
    return panel
end

function RPGTF:RefreshSettingsPanel()
    local controls = self.settings_controls
    if not controls or not self.db then
        return
    end
    self.settings_refreshing = true
    controls.check:SetChecked(self.db.frame.show_target_of_target ~= false)
    controls.slider:SetValue(self.db.frame.scale or 1)
    if controls.slider.Text then
        controls.slider.Text:SetText(string.format("Scale: %.2f", self.db.frame.scale or 1))
    end
    controls.skin:Refresh()
    controls.font:Refresh()
    controls.border:Refresh()
    controls.background:Refresh()
    self.settings_refreshing = false
end

function RPGTF:RegisterSettingsCategory()
    self:CreateSettingsPanel()
    if self.settings_category or not Settings or not Settings.RegisterCanvasLayoutCategory then
        return
    end
    local category, layout = Settings.RegisterCanvasLayoutCategory(self.settings_panel, "RPG Target Frame")
    Settings.RegisterAddOnCategory(category)
    self.settings_category = category
    self.settings_layout = layout
end

function RPGTF:ToggleSettings()
    self:CreateSettingsPanel()
    if Settings and Settings.OpenToCategory and self.settings_category then
        local category = self.settings_category
        local id = category.GetID and category:GetID() or category
        Settings.OpenToCategory(id)
        return
    end
    if self.settings_panel:IsShown() then
        self.settings_panel:Hide()
    else
        self.settings_panel:Show()
    end
end
