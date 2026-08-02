--[[
    EZUI — Premium Minimalist Roblox UI Library
    
    Features:
    - Fixed Left-Side Position (No Dragging)
    - Full Theme & Accent Color Customization (Presets: Green, Purple, Blue, Red, Cyan, Amber, Dark)
    - Hold-to-Repeat Navigation & Slider adjustment
    - Non-intrusive input sinking (WASD movement & Mouse Look preserved)
    - Clean Separator & Sub-menu support
]]

local Players              = game:GetService("Players")
local UserInputService     = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService         = game:GetService("TweenService")
local CoreGui              = game:GetService("CoreGui")
local LocalPlayer          = Players.LocalPlayer

----------------------------------------------------------------
-- DEFAULT THEMES & PRESETS
----------------------------------------------------------------
local PRESET_THEMES = {
    Green = {
        WindowBg       = Color3.fromRGB(15, 15, 15),
        HeaderBg       = Color3.fromRGB(18, 18, 18),
        TabBarBg       = Color3.fromRGB(18, 18, 18),
        HighlightBg    = Color3.fromRGB(24, 58, 31),
        TextWhite      = Color3.fromRGB(255, 255, 255),
        TextGray       = Color3.fromRGB(150, 150, 150),
        AccentColor    = Color3.fromRGB(46, 180, 74),
        ToggleOff      = Color3.fromRGB(50, 50, 50),
        SliderTrack    = Color3.fromRGB(60, 60, 60),
        BorderGray     = Color3.fromRGB(30, 30, 30),
    },
    Purple = {
        WindowBg       = Color3.fromRGB(15, 15, 18),
        HeaderBg       = Color3.fromRGB(18, 18, 22),
        TabBarBg       = Color3.fromRGB(18, 18, 22),
        HighlightBg    = Color3.fromRGB(45, 25, 65),
        TextWhite      = Color3.fromRGB(255, 255, 255),
        TextGray       = Color3.fromRGB(150, 150, 150),
        AccentColor    = Color3.fromRGB(147, 51, 234),
        ToggleOff      = Color3.fromRGB(50, 50, 50),
        SliderTrack    = Color3.fromRGB(60, 60, 60),
        BorderGray     = Color3.fromRGB(30, 30, 30),
    },
    Blue = {
        WindowBg       = Color3.fromRGB(14, 16, 20),
        HeaderBg       = Color3.fromRGB(18, 20, 26),
        TabBarBg       = Color3.fromRGB(18, 20, 26),
        HighlightBg    = Color3.fromRGB(20, 45, 75),
        TextWhite      = Color3.fromRGB(255, 255, 255),
        TextGray       = Color3.fromRGB(150, 150, 150),
        AccentColor    = Color3.fromRGB(37, 99, 235),
        ToggleOff      = Color3.fromRGB(50, 50, 50),
        SliderTrack    = Color3.fromRGB(60, 60, 60),
        BorderGray     = Color3.fromRGB(30, 30, 30),
    },
    Red = {
        WindowBg       = Color3.fromRGB(18, 14, 14),
        HeaderBg       = Color3.fromRGB(22, 18, 18),
        TabBarBg       = Color3.fromRGB(22, 18, 18),
        HighlightBg    = Color3.fromRGB(65, 25, 25),
        TextWhite      = Color3.fromRGB(255, 255, 255),
        TextGray       = Color3.fromRGB(150, 150, 150),
        AccentColor    = Color3.fromRGB(225, 29, 72),
        ToggleOff      = Color3.fromRGB(50, 50, 50),
        SliderTrack    = Color3.fromRGB(60, 60, 60),
        BorderGray     = Color3.fromRGB(30, 30, 30),
    },
    Cyan = {
        WindowBg       = Color3.fromRGB(14, 18, 20),
        HeaderBg       = Color3.fromRGB(18, 22, 24),
        TabBarBg       = Color3.fromRGB(18, 22, 24),
        HighlightBg    = Color3.fromRGB(20, 60, 70),
        TextWhite      = Color3.fromRGB(255, 255, 255),
        TextGray       = Color3.fromRGB(150, 150, 150),
        AccentColor    = Color3.fromRGB(6, 182, 212),
        ToggleOff      = Color3.fromRGB(50, 50, 50),
        SliderTrack    = Color3.fromRGB(60, 60, 60),
        BorderGray     = Color3.fromRGB(30, 30, 30),
    },
    Dark = {
        WindowBg       = Color3.fromRGB(12, 12, 12),
        HeaderBg       = Color3.fromRGB(16, 16, 16),
        TabBarBg       = Color3.fromRGB(16, 16, 16),
        HighlightBg    = Color3.fromRGB(35, 35, 35),
        TextWhite      = Color3.fromRGB(255, 255, 255),
        TextGray       = Color3.fromRGB(150, 150, 150),
        AccentColor    = Color3.fromRGB(200, 200, 200),
        ToggleOff      = Color3.fromRGB(50, 50, 50),
        SliderTrack    = Color3.fromRGB(60, 60, 60),
        BorderGray     = Color3.fromRGB(30, 30, 30),
    }
}

local ROW_HEIGHT = 28
local MAX_VISIBLE = 9

----------------------------------------------------------------
-- UTILITIES
----------------------------------------------------------------
local function tween(obj, time, props)
    local t = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

----------------------------------------------------------------
-- EZUI LIBRARY CLASS
----------------------------------------------------------------
local EZUI = {}
EZUI.__index = EZUI
EZUI.Presets = PRESET_THEMES

function EZUI.new(config)
    config = config or {}
    local self = setmetatable({}, EZUI)
    
    self.Title = config.Title or "EZUI"
    self.LogoText = config.LogoText or "EZ"
    self.FooterText = config.FooterText or "EZUI Library | discord.gg/ezui"
    self.ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift
    
    -- Theme Setup
    if type(config.Theme) == "string" and PRESET_THEMES[config.Theme] then
        self.Theme = table.clone(PRESET_THEMES[config.Theme])
    elseif type(config.Theme) == "table" then
        self.Theme = table.clone(config.Theme)
    else
        self.Theme = table.clone(PRESET_THEMES.Green)
    end

    if config.AccentColor then
        self.Theme.AccentColor = config.AccentColor
    end

    self.Screens = {}
    self.CurrentScreen = "main"
    self.CurrentTabIndex = 1
    self.SelectedIndex = 1
    self.ScrollOffset = 0
    self.MenuVisible = true
    self.RowInstances = {}
    self.ActiveHeldKey = nil
    self.HoldThread = nil
    
    self:_buildGui()
    self:_setupInputs()
    
    return self
end

function EZUI:SetTheme(themePresetOrTable)
    if type(themePresetOrTable) == "string" and PRESET_THEMES[themePresetOrTable] then
        self.Theme = table.clone(PRESET_THEMES[themePresetOrTable])
    elseif type(themePresetOrTable) == "table" then
        self.Theme = table.clone(themePresetOrTable)
    end
    self:_applyTheme()
end

function EZUI:SetAccentColor(color3)
    self.Theme.AccentColor = color3
    self:_applyTheme()
end

function EZUI:_applyTheme()
    local theme = self.Theme
    self.Window.BackgroundColor3 = theme.WindowBg
    self.Banner.BackgroundColor3 = theme.HeaderBg
    self.BannerFiller.BackgroundColor3 = theme.HeaderBg
    self.EzLogo.TextColor3 = theme.AccentColor
    self.TitleText.TextColor3 = theme.AccentColor
    self.TabBar.BackgroundColor3 = theme.TabBarBg
    self.HighlightBox.BackgroundColor3 = theme.HighlightBg
    self.FooterBar.BackgroundColor3 = theme.HeaderBg
    self.FooterFiller.BackgroundColor3 = theme.HeaderBg
    self.FooterLeft.TextColor3 = theme.TextGray
    self.FooterCounter.TextColor3 = theme.TextGray
    self.SidePanel.BackgroundColor3 = theme.WindowBg
    self.SideTopAccent.BackgroundColor3 = theme.AccentColor
    
    self:_buildHeaders()
    self:_buildTabContent()
end

function EZUI:_buildGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "EZUI_Library"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999
    pcall(function() gui.Parent = CoreGui end)
    if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    self.Gui = gui

    -- Fixed Position to Left Side (No Dragging)
    local window = Instance.new("Frame")
    window.Size = UDim2.fromOffset(320, 388)
    window.Position = UDim2.new(0, 25, 0.5, -194)
    window.BackgroundColor3 = self.Theme.WindowBg
    window.BackgroundTransparency = 0.15 
    window.BorderSizePixel = 0
    window.Parent = gui
    self.Window = window

    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = UDim.new(0, 6)
    windowCorner.Parent = window

    -- Banner Header
    local banner = Instance.new("Frame")
    banner.Size = UDim2.new(1, 0, 0, 80)
    banner.BackgroundColor3 = self.Theme.HeaderBg
    banner.BorderSizePixel = 0
    banner.ClipsDescendants = true
    banner.Parent = window
    self.Banner = banner

    local bannerCorner = Instance.new("UICorner")
    bannerCorner.CornerRadius = UDim.new(0, 6)
    bannerCorner.Parent = banner

    local bannerFiller = Instance.new("Frame")
    bannerFiller.Size = UDim2.new(1, 0, 0, 6)
    bannerFiller.Position = UDim2.new(0, 0, 1, -6)
    bannerFiller.BackgroundColor3 = self.Theme.HeaderBg
    bannerFiller.BorderSizePixel = 0
    bannerFiller.Parent = banner
    self.BannerFiller = bannerFiller

    local bannerImage = Instance.new("ImageLabel")
    bannerImage.Size = UDim2.new(1, 0, 1, 6) 
    bannerImage.Position = UDim2.new(0, 0, 0, 0)
    bannerImage.BackgroundTransparency = 1
    bannerImage.Image = ""
    bannerImage.ScaleType = Enum.ScaleType.Crop
    bannerImage.ZIndex = 1
    bannerImage.Parent = banner
    self.BannerImage = bannerImage

    local bannerImgCorner = Instance.new("UICorner")
    bannerImgCorner.CornerRadius = UDim.new(0, 6)
    bannerImgCorner.Parent = bannerImage

    local ezLogo = Instance.new("TextLabel")
    ezLogo.Size = UDim2.fromOffset(56, 46)
    ezLogo.Position = UDim2.fromOffset(16, 16)
    ezLogo.BackgroundTransparency = 1
    ezLogo.Text = self.LogoText
    ezLogo.Font = Enum.Font.GothamBlack
    ezLogo.TextSize = 36
    ezLogo.TextColor3 = self.Theme.AccentColor
    ezLogo.TextStrokeTransparency = 0.7 
    ezLogo.ZIndex = 2
    ezLogo.Parent = banner
    self.EzLogo = ezLogo

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.fromOffset(150, 30)
    titleText.Position = UDim2.new(1, -166, 0, 25)
    titleText.BackgroundTransparency = 1
    titleText.Text = self.Title
    titleText.Font = Enum.Font.GothamBlack
    titleText.TextSize = 24
    titleText.TextXAlignment = Enum.TextXAlignment.Right
    titleText.TextColor3 = self.Theme.AccentColor
    titleText.TextStrokeTransparency = 0.7
    titleText.ZIndex = 2
    titleText.Parent = banner
    self.TitleText = titleText

    -- Tab Bar
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.Position = UDim2.new(0, 0, 0, 80)
    tabBar.BackgroundColor3 = self.Theme.TabBarBg
    tabBar.BorderSizePixel = 0
    tabBar.Parent = window
    self.TabBar = tabBar

    local tabBorder = Instance.new("Frame")
    tabBorder.Size = UDim2.new(1, 0, 0, 1)
    tabBorder.Position = UDim2.new(0, 0, 1, 0)
    tabBorder.BackgroundColor3 = self.Theme.BorderGray
    tabBorder.BorderSizePixel = 0
    tabBorder.Parent = tabBar

    local activeLine = Instance.new("Frame")
    activeLine.AnchorPoint = Vector2.new(0, 1)
    activeLine.Position = UDim2.new(0, 0, 1, 0)
    activeLine.BackgroundColor3 = self.Theme.TextWhite
    activeLine.BorderSizePixel = 0
    activeLine.Parent = tabBar
    self.ActiveLine = activeLine

    -- Body Area
    local bodyContainer = Instance.new("Frame")
    bodyContainer.Size = UDim2.new(1, 0, 0, MAX_VISIBLE * ROW_HEIGHT)
    bodyContainer.Position = UDim2.new(0, 0, 0, 110)
    bodyContainer.BackgroundTransparency = 1
    bodyContainer.BorderSizePixel = 0
    bodyContainer.ClipsDescendants = true
    bodyContainer.Parent = window

    local innerScroll = Instance.new("Frame")
    innerScroll.Size = UDim2.fromScale(1, 1)
    innerScroll.BackgroundTransparency = 1
    innerScroll.Parent = bodyContainer
    self.InnerScroll = innerScroll

    -- Highlight Selection (Fixed Left Position, No Vertical Accent Strip)
    local highlightBox = Instance.new("Frame")
    highlightBox.Size = UDim2.new(1, 0, 0, ROW_HEIGHT)
    highlightBox.Position = UDim2.new(0, 0, 0, 0)
    highlightBox.BackgroundColor3 = self.Theme.HighlightBg
    highlightBox.BorderSizePixel = 0
    highlightBox.Parent = innerScroll
    self.HighlightBox = highlightBox

    -- Footer Bar
    local footerBar = Instance.new("Frame")
    footerBar.Size = UDim2.new(1, 0, 0, 26)
    footerBar.Position = UDim2.new(0, 0, 1, -26)
    footerBar.BackgroundColor3 = self.Theme.HeaderBg
    footerBar.BorderSizePixel = 0
    footerBar.Parent = window
    self.FooterBar = footerBar

    local footerCorner = Instance.new("UICorner")
    footerCorner.CornerRadius = UDim.new(0, 6)
    footerCorner.Parent = footerBar

    local footerFiller = Instance.new("Frame")
    footerFiller.Size = UDim2.new(1, 0, 0, 6)
    footerFiller.Position = UDim2.new(0, 0, 0, 0)
    footerFiller.BackgroundColor3 = self.Theme.HeaderBg
    footerFiller.BorderSizePixel = 0
    footerFiller.Parent = footerBar
    self.FooterFiller = footerFiller

    local footerLeft = Instance.new("TextLabel")
    footerLeft.Size = UDim2.new(0.7, 0, 1, 0)
    footerLeft.Position = UDim2.fromOffset(12, 0)
    footerLeft.BackgroundTransparency = 1
    footerLeft.Text = self.FooterText
    footerLeft.TextColor3 = self.Theme.TextGray
    footerLeft.Font = Enum.Font.Gotham
    footerLeft.TextSize = 10
    footerLeft.TextXAlignment = Enum.TextXAlignment.Left
    footerLeft.Parent = footerBar
    self.FooterLeft = footerLeft

    local footerCounter = Instance.new("TextLabel")
    footerCounter.Size = UDim2.fromOffset(60, 26)
    footerCounter.Position = UDim2.new(1, -72, 0, 0)
    footerCounter.BackgroundTransparency = 1
    footerCounter.Font = Enum.Font.Gotham
    footerCounter.TextSize = 10
    footerCounter.TextColor3 = self.Theme.TextGray
    footerCounter.TextXAlignment = Enum.TextXAlignment.Right
    footerCounter.Parent = footerBar
    self.FooterCounter = footerCounter

    -- Side Panel (Preview Window)
    local sidePanel = Instance.new("Frame")
    sidePanel.Size = UDim2.fromOffset(180, 110)
    sidePanel.Position = UDim2.new(1, 10, 0, 0)
    sidePanel.BackgroundColor3 = self.Theme.WindowBg
    sidePanel.BackgroundTransparency = 0.15
    sidePanel.BorderSizePixel = 0
    sidePanel.Visible = false
    sidePanel.Parent = window 
    self.SidePanel = sidePanel

    local sideCorner = Instance.new("UICorner")
    sideCorner.CornerRadius = UDim.new(0, 6)
    sideCorner.Parent = sidePanel

    local sideTitle = Instance.new("TextLabel")
    sideTitle.Size = UDim2.new(1, -20, 0, 26)
    sideTitle.Position = UDim2.fromOffset(10, 0)
    sideTitle.BackgroundTransparency = 1
    sideTitle.Text = "Banner Preview"
    sideTitle.Font = Enum.Font.GothamMedium
    sideTitle.TextSize = 11
    sideTitle.TextColor3 = self.Theme.TextWhite
    sideTitle.TextXAlignment = Enum.TextXAlignment.Left
    sideTitle.Parent = sidePanel

    local sideTopAccent = Instance.new("Frame")
    sideTopAccent.Size = UDim2.new(1, 0, 0, 2)
    sideTopAccent.Position = UDim2.new(0, 0, 0, 26)
    sideTopAccent.BackgroundColor3 = self.Theme.AccentColor
    sideTopAccent.BorderSizePixel = 0
    sideTopAccent.Parent = sidePanel
    self.SideTopAccent = sideTopAccent

    local previewImage = Instance.new("ImageLabel")
    previewImage.Size = UDim2.new(1, -20, 1, -40)
    previewImage.Position = UDim2.fromOffset(10, 32)
    previewImage.BackgroundTransparency = 1
    previewImage.ScaleType = Enum.ScaleType.Crop
    previewImage.Parent = sidePanel
    self.PreviewImage = previewImage

    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 4)
    previewCorner.Parent = previewImage
end

----------------------------------------------------------------
-- SCREEN & ITEM BUILDERS
----------------------------------------------------------------
function EZUI:CreateScreen(id, data)
    data = data or {}
    self.Screens[id] = {
        parent = data.parent,
        tabs = data.tabs or {},
        initialTab = data.initialTab or 1,
        initialSelected = data.initialSelected or 1
    }
    return self.Screens[id]
end

function EZUI:AddTab(screenId, name)
    local screen = self.Screens[screenId]
    if not screen then
        screen = self:CreateScreen(screenId)
    end
    local tab = { name = name, items = {} }
    table.insert(screen.tabs, tab)
    return tab
end

function EZUI:AddToggle(tab, name, default, onChange)
    local item = { type = "toggle", name = name, value = default or false, onChange = onChange }
    table.insert(tab.items, item)
    return item
end

function EZUI:AddSlider(tab, name, min, max, default, step, onChange)
    local item = { type = "slider", name = name, min = min, max = max, value = default or min, inc = step or 1, onChange = onChange }
    table.insert(tab.items, item)
    return item
end

function EZUI:AddSelector(tab, name, options, default, onChange)
    local item = { type = "selector", name = name, options = options, value = default or 1, onChange = onChange }
    table.insert(tab.items, item)
    return item
end

function EZUI:AddButton(tab, name, onClick)
    local item = { type = "button", name = name, onClick = onClick }
    table.insert(tab.items, item)
    return item
end

function EZUI:AddSeparator(tab, name)
    local item = { type = "sep", name = name or "" }
    table.insert(tab.items, item)
    return item
end

function EZUI:AddNav(tab, name, targetScreen)
    local item = { type = "nav", name = name, target = targetScreen }
    table.insert(tab.items, item)
    return item
end

----------------------------------------------------------------
-- RENDER LOGIC
----------------------------------------------------------------
function EZUI:GetScreen()
    return self.Screens[self.CurrentScreen]
end

function EZUI:GetTab()
    local s = self:GetScreen()
    return s and s.tabs[self.CurrentTabIndex]
end

function EZUI:GetItems()
    local t = self:GetTab()
    return t and t.items or {}
end

function EZUI:_updateSidePanel()
    local items = self:GetItems()
    local item = items[self.SelectedIndex]
    if item and item.name == "Banner" and item.options then
        self.SidePanel.Visible = true
        local opt = item.options[item.value]
        if opt and opt.id ~= "" then
            self.PreviewImage.Image = opt.id
        else
            self.PreviewImage.Image = ""
        end
    else
        self.SidePanel.Visible = false
    end
end

function EZUI:_updateHighlightAndScroll()
    local items = self:GetItems()
    if #items == 0 then self.HighlightBox.Visible = false; return end
    
    if self.SelectedIndex > #items then self.SelectedIndex = #items end
    if self.SelectedIndex < 1 then self.SelectedIndex = 1 end

    local item = items[self.SelectedIndex]
    self.HighlightBox.Visible = not (item and item.type == "sep")

    if self.SelectedIndex > self.ScrollOffset + MAX_VISIBLE then
        self.ScrollOffset = self.SelectedIndex - MAX_VISIBLE
    elseif self.SelectedIndex <= self.ScrollOffset then
        self.ScrollOffset = self.SelectedIndex - 1
    end
    if self.ScrollOffset < 0 then self.ScrollOffset = 0 end

    tween(self.InnerScroll, 0.2, {Position = UDim2.new(0, 0, 0, -self.ScrollOffset * ROW_HEIGHT)})
    tween(self.HighlightBox, 0.2, {Position = UDim2.new(0, 0, 0, (self.SelectedIndex - 1) * ROW_HEIGHT)})
    
    self.FooterCounter.Text = tostring(self.SelectedIndex).." / "..tostring(#items)

    for i, inst in pairs(self.RowInstances) do
        local isSel = (i == self.SelectedIndex)
        if inst.Label then
            tween(inst.Label, 0.2, {TextColor3 = isSel and self.Theme.TextWhite or self.Theme.TextGray})
        end
        if inst.SelectorLabel then
            tween(inst.SelectorLabel, 0.2, {TextColor3 = isSel and self.Theme.TextWhite or self.Theme.TextGray})
        end
        if inst.Chevron1 then
            tween(inst.Chevron1, 0.2, {BackgroundColor3 = isSel and self.Theme.TextWhite or self.Theme.TextGray})
            tween(inst.Chevron2, 0.2, {BackgroundColor3 = isSel and self.Theme.TextWhite or self.Theme.TextGray})
        end
    end
    
    self:_updateSidePanel()
end

local function createChevron(parent, theme)
    local c = Instance.new("Frame")
    c.Size = UDim2.fromOffset(12, 12)
    c.BackgroundTransparency = 1
    c.Parent = parent
    local t1 = Instance.new("Frame")
    t1.Size = UDim2.fromOffset(7, 1)
    t1.AnchorPoint = Vector2.new(0.5, 0.5)
    t1.Position = UDim2.fromScale(0.4, 0.35)
    t1.Rotation = 45
    t1.BackgroundColor3 = theme.TextGray
    t1.BorderSizePixel = 0
    t1.Parent = c
    local t2 = t1:Clone()
    t2.Position = UDim2.fromScale(0.4, 0.65)
    t2.Rotation = -45
    t2.Parent = c
    return c
end

function EZUI:_buildTabContent()
    for _, child in ipairs(self.InnerScroll:GetChildren()) do
        if child ~= self.HighlightBox then child:Destroy() end
    end
    table.clear(self.RowInstances)
    
    local items = self:GetItems()
    self.InnerScroll.Size = UDim2.new(1, 0, 0, #items * ROW_HEIGHT)

    for i, item in ipairs(items) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, ROW_HEIGHT)
        row.Position = UDim2.new(0, 0, 0, (i - 1) * ROW_HEIGHT)
        row.BackgroundTransparency = 1
        row.Parent = self.InnerScroll
        
        self.RowInstances[i] = {Frame = row, Type = item.type}

        if item.type == "sep" then
            local sepFrame = Instance.new("Frame")
            sepFrame.Size = UDim2.fromScale(1, 1)
            sepFrame.BackgroundTransparency = 1
            sepFrame.Parent = row

            if item.name ~= "" then
                local lineLeft = Instance.new("Frame")
                lineLeft.Size = UDim2.new(0.2, 0, 0, 1)
                lineLeft.Position = UDim2.new(0.05, 0, 0.5, 0)
                lineLeft.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                lineLeft.BorderSizePixel = 0
                lineLeft.Parent = sepFrame

                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(0.5, 0, 1, 0)
                txt.Position = UDim2.new(0.25, 0, 0, 0)
                txt.BackgroundTransparency = 1
                txt.Text = item.name
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 10
                txt.TextColor3 = Color3.fromRGB(120, 120, 120)
                txt.Parent = sepFrame

                local lineRight = Instance.new("Frame")
                lineRight.Size = UDim2.new(0.2, 0, 0, 1)
                lineRight.Position = UDim2.new(0.75, 0, 0.5, 0)
                lineRight.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                lineRight.BorderSizePixel = 0
                lineRight.Parent = sepFrame
            else
                local fullLine = Instance.new("Frame")
                fullLine.Size = UDim2.new(0.9, 0, 0, 1)
                fullLine.Position = UDim2.new(0.05, 0, 0.5, 0)
                fullLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                fullLine.BorderSizePixel = 0
                fullLine.Parent = sepFrame
            end
        else
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -130, 1, 0)
            label.Position = UDim2.fromOffset(16, 0)
            label.BackgroundTransparency = 1
            label.Text = item.type == "slider" and (item.name..": "..tostring(item.value)) or item.name
            label.Font = Enum.Font.GothamMedium
            label.TextSize = 11
            label.TextColor3 = self.Theme.TextGray
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = row
            
            self.RowInstances[i].Label = label

            if item.type == "toggle" then
                local bg = Instance.new("Frame")
                bg.Size = UDim2.fromOffset(30, 14)
                bg.AnchorPoint = Vector2.new(1, 0.5)
                bg.Position = UDim2.new(1, -12, 0.5, 0)
                bg.BackgroundColor3 = item.value and self.Theme.AccentColor or self.Theme.ToggleOff
                bg.BorderSizePixel = 0
                bg.Parent = row
                local bgCorner = Instance.new("UICorner")
                bgCorner.CornerRadius = UDim.new(1, 0)
                bgCorner.Parent = bg
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.fromOffset(10, 10)
                knob.Position = item.value and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2)
                knob.BackgroundColor3 = self.Theme.TextWhite
                knob.BorderSizePixel = 0
                knob.Parent = bg
                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = knob
                
                self.RowInstances[i].ToggleBg = bg
                self.RowInstances[i].ToggleKnob = knob

            elseif item.type == "slider" then
                local track = Instance.new("Frame")
                track.Size = UDim2.fromOffset(110, 4)
                track.AnchorPoint = Vector2.new(1, 0.5)
                track.Position = UDim2.new(1, -12, 0.5, 0)
                track.BackgroundColor3 = self.Theme.SliderTrack
                track.BorderSizePixel = 0
                track.Parent = row
                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = track
                
                local pct = (item.value - item.min)/(item.max - item.min)
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(pct, 0, 1, 0)
                fill.BackgroundColor3 = self.Theme.TextWhite
                fill.BorderSizePixel = 0
                fill.Parent = track
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = fill
                
                local thumb = Instance.new("Frame")
                thumb.Size = UDim2.fromOffset(10, 10)
                thumb.AnchorPoint = Vector2.new(0.5, 0.5)
                thumb.Position = UDim2.new(1, 0, 0.5, 0)
                thumb.BackgroundColor3 = self.Theme.TextWhite
                thumb.BorderSizePixel = 0
                thumb.Parent = fill
                local thumbCorner = Instance.new("UICorner")
                thumbCorner.CornerRadius = UDim.new(1, 0)
                thumbCorner.Parent = thumb
                
                self.RowInstances[i].Track = track
                self.RowInstances[i].Fill = fill
                self.RowInstances[i].Thumb = thumb

            elseif item.type == "selector" then
                local valLabel = Instance.new("TextLabel")
                valLabel.Size = UDim2.new(0, 120, 1, 0)
                valLabel.Position = UDim2.new(1, -132, 0, 0)
                valLabel.BackgroundTransparency = 1
                valLabel.Text = "< " .. item.options[item.value].name .. " >"
                valLabel.Font = Enum.Font.GothamMedium
                valLabel.TextSize = 11
                valLabel.TextColor3 = self.Theme.TextGray
                valLabel.TextXAlignment = Enum.TextXAlignment.Right
                valLabel.Parent = row
                
                self.RowInstances[i].SelectorLabel = valLabel

            elseif item.type == "nav" then
                local chev = createChevron(row, self.Theme)
                chev.Position = UDim2.new(1, -20, 0.5, -6)
                local chChildren = chev:GetChildren()
                self.RowInstances[i].Chevron1 = chChildren[1]
                self.RowInstances[i].Chevron2 = chChildren[2]
            end
        end
    end

    self.InnerScroll.Position = UDim2.new(0, 15, 0, -self.ScrollOffset * ROW_HEIGHT)
    self:_updateHighlightAndScroll()
end

function EZUI:_buildHeaders()
    for _, c in ipairs(self.TabBar:GetChildren()) do 
        if c:IsA("TextButton") then c:Destroy() end 
    end
    
    local s = self:GetScreen()
    if not s then return end
    local n = #s.tabs
    if n == 0 then return end

    self.ActiveLine.Size = UDim2.new(1/n, 0, 0, 2)
    tween(self.ActiveLine, 0.25, {Position = UDim2.new((self.CurrentTabIndex-1)/n, 0, 1, 0)})

    for idx, tab in ipairs(s.tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/n, 0, 1, 0)
        btn.Position = UDim2.new((idx-1)/n, 0, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = tab.name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.TextColor3 = (idx == self.CurrentTabIndex) and self.Theme.TextWhite or self.Theme.TextGray
        btn.Parent = self.TabBar
    end
end

function EZUI:_activateItem()
    local items = self:GetItems()
    local item = items[self.SelectedIndex]
    local inst = self.RowInstances[self.SelectedIndex]
    if not item or item.type == "sep" then return end

    if item.type == "toggle" then
        item.value = not item.value
        tween(inst.ToggleBg, 0.15, {BackgroundColor3 = item.value and self.Theme.AccentColor or self.Theme.ToggleOff})
        tween(inst.ToggleKnob, 0.15, {Position = item.value and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2)})
        if item.onChange then item.onChange(item.value, item) end
    elseif item.type == "button" then
        if item.onClick then item.onClick(item) end
    elseif item.type == "nav" then
        self.CurrentScreen = item.target
        local targetScr = self:GetScreen()
        self.CurrentTabIndex = targetScr and targetScr.initialTab or 1
        self.SelectedIndex = targetScr and targetScr.initialSelected or 1
        self.ScrollOffset = 0
        self:_buildHeaders()
        self:_buildTabContent()
    end
end

function EZUI:_updateSliderOrSelector(amount)
    local items = self:GetItems()
    local item = items[self.SelectedIndex]
    local inst = self.RowInstances[self.SelectedIndex]
    if not item then return end

    if item.type == "slider" then
        item.value = math.clamp(item.value + (amount * item.inc), item.min, item.max)
        inst.Label.Text = item.name..": "..tostring(item.value)
        local pct = (item.value - item.min)/(item.max - item.min)
        tween(inst.Fill, 0.1, {Size = UDim2.new(pct, 0, 1, 0)})
        if item.onChange then item.onChange(item.value, item) end
    
    elseif item.type == "selector" then
        item.value = item.value + amount
        if item.value > #item.options then item.value = 1 end
        if item.value < 1 then item.value = #item.options end
        
        inst.SelectorLabel.Text = "< " .. item.options[item.value].name .. " >"
        if item.onChange then item.onChange(item.value, item) end
        self:_updateSidePanel()
    end
end

function EZUI:Init()
    for _, screen in pairs(self.Screens) do
        for _, tab in pairs(screen.tabs) do
            for _, item in pairs(tab.items) do
                if item.onChange then
                    item.onChange(item.value, item)
                end
            end
        end
    end
    self:_buildHeaders()
    self:_buildTabContent()
    self:_bindKeys()
end

----------------------------------------------------------------
-- INPUT BLOCKING & HOLD-TO-REPEAT HANDLING
----------------------------------------------------------------
local BLOCK_NAME = "EZKeyBlock_Final"

local blockedKeys = {
    [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Right] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true,
    [Enum.KeyCode.Tab] = true,
    [Enum.KeyCode.Return] = true,
    [Enum.KeyCode.KeypadEnter] = true,
    [Enum.KeyCode.Backspace] = true,
    [Enum.KeyCode.Delete] = true,
}

-- Executor IsKeyDown Hook to prevent game scripts from reading navigation keys
pcall(function()
    if hookmetamethod then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and (method == "IsKeyDown" or method == "isKeyDown") then
                local key = ...
                if blockedKeys[key] then return false end
            end
            return oldNamecall(self, ...)
        end)
    end
end)

pcall(function()
    if hookfunction and UserInputService.IsKeyDown then
        local oldIsKeyDown
        oldIsKeyDown = hookfunction(UserInputService.IsKeyDown, function(self, key, ...)
            if not checkcaller() then
                if blockedKeys[key] then return false end
            end
            return oldIsKeyDown(self, key, ...)
        end)
    end
end)

local function sinkInput(actionName, inputState, inputObject)
    return Enum.ContextActionResult.Sink
end

function EZUI:_bindKeys()
    ContextActionService:BindActionAtPriority(
        BLOCK_NAME, 
        sinkInput, 
        false, 
        2147483647, 
        Enum.KeyCode.Left, Enum.KeyCode.Right, 
        Enum.KeyCode.Up, Enum.KeyCode.Down,
        Enum.KeyCode.Tab, Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter,
        Enum.KeyCode.Backspace, Enum.KeyCode.Delete
    )
end

function EZUI:_unbindKeys()
    ContextActionService:UnbindAction(BLOCK_NAME)
end

function EZUI:_stopKeyHold()
    self.ActiveHeldKey = nil
    if self.HoldThread then
        task.cancel(self.HoldThread)
        self.HoldThread = nil
    end
end

function EZUI:_processKeyAction(keyCode)
    local items = self:GetItems()
    if keyCode == Enum.KeyCode.Up then
        if #items == 0 then return end
        repeat
            self.SelectedIndex = self.SelectedIndex - 1
            if self.SelectedIndex < 1 then self.SelectedIndex = #items end
        until items[self.SelectedIndex].type ~= "sep"
        self:_updateHighlightAndScroll()

    elseif keyCode == Enum.KeyCode.Down then
        if #items == 0 then return end
        repeat
            self.SelectedIndex = self.SelectedIndex + 1
            if self.SelectedIndex > #items then self.SelectedIndex = 1 end
        until items[self.SelectedIndex].type ~= "sep"
        self:_updateHighlightAndScroll()

    elseif keyCode == Enum.KeyCode.Left then
        self:_updateSliderOrSelector(-1)

    elseif keyCode == Enum.KeyCode.Right then
        self:_updateSliderOrSelector(1)
    end
end

function EZUI:_startKeyHold(keyCode)
    self:_stopKeyHold()
    self.ActiveHeldKey = keyCode
    self:_processKeyAction(keyCode)
    
    self.HoldThread = task.spawn(function()
        task.wait(0.25)
        while self.ActiveHeldKey == keyCode and self.MenuVisible do
            self:_processKeyAction(keyCode)
            task.wait(0.04)
        end
    end)
end

function EZUI:_setupInputs()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == self.ToggleKey then
            self.MenuVisible = not self.MenuVisible
            self.Window.Visible = self.MenuVisible
            if self.MenuVisible then self:_bindKeys() else self:_unbindKeys(); self:_stopKeyHold() end
            return
        end

        if not self.MenuVisible then return end

        if input.KeyCode == Enum.KeyCode.Tab then
            local s = self:GetScreen()
            if s and #s.tabs > 0 then
                self.CurrentTabIndex = (self.CurrentTabIndex % #s.tabs) + 1
                self.SelectedIndex = 1
                self.ScrollOffset = 0
                self:_buildHeaders()
                self:_buildTabContent()
            end
        elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
            local s = self:GetScreen()
            if s and s.parent then
                self.CurrentScreen = s.parent
                self.CurrentTabIndex = 1; self.SelectedIndex = 1; self.ScrollOffset = 0
                self:_buildHeaders()
                self:_buildTabContent()
            end
        elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
            self:_activateItem()
        elseif input.KeyCode == Enum.KeyCode.Up or input.KeyCode == Enum.KeyCode.Down 
            or input.KeyCode == Enum.KeyCode.Left or input.KeyCode == Enum.KeyCode.Right then
            self:_startKeyHold(input.KeyCode)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == self.ActiveHeldKey then
            self:_stopKeyHold()
        end
    end)
end

return EZUI
