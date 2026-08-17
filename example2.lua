local EZUI = loadstring(game:HttpGet("http://127.0.0.1:3002/library.lua"))()

-- Define Custom Banners
local myBanners = {
    {name = "None", id = ""},
    {name = "Grass", id = "rbxthumb://type=Asset&id=76117265881255&w=420&h=420"},
    {name = "Money", id = "rbxthumb://type=Asset&id=76802492834754&w=420&h=420"},
    {name = "Minion", id = "rbxthumb://type=Asset&id=113952267112088&w=420&h=420"}
}

-- Create Window with full custom options
local ui = EZUI.new({
    Title = "LuaUI",                       -- Script Name on top right
    Logo = "rbxassetid://132927367732055", -- Left Logo Text or Image Asset ID
    FooterText = "EZUI Library | Built for Roblox",    
    NotifyPosition = "TopRight",
    NotifyDuration = 5,
    Theme = "Purple",
    Font = "Montserrat",                   -- Standard font: Montserrat
    Position = "TopMiddle",                -- Window Position: "TopMiddle", "Left", "Center", "Right", "TopLeft", "TopRight"
    CornerRadius = 10,                     -- Window Shape: 0 ("Sharp"), 10 ("Rounded"), 16 ("Soft")
    PreviewPosition = "Right",            -- Preview Panel: "Right", "Left", "Bottom"
    PreviewLayout = "Horizontal",          -- Preview Layout: "Horizontal", "Vertical"
    PreviewShape = "Circle",              -- Avatar Shape: "Circle", "Square", "Rounded"
    AutoSave = true,                       -- Auto-save themeconfig to disk
    AutoLoad = true,                       -- Auto-load saved themeconfig on startup
    ToggleKey = Enum.KeyCode.RightShift    
})

-- Main screen
ui:CreateScreen("main")

local mainTab = ui:AddTab("main", "Main", "home")

ui:AddToggle(mainTab, "Toggle Example", false, function(state)
    ui:Notify({
        Title = "Toggle Updated",
        Text = "State is now: " .. tostring(state),
        Type = "Info",
        Duration = 3
    })
end, "check")

ui:AddSlider(mainTab, "Slider Example", 0, 100, 50, 5, function(value)
    print("Slider value:", value)
end, "sliders")

-- New Player Profile Preview option in Main tab
ui:AddPlayerPreview(mainTab, "Preview", "eye")

ui:AddButton(mainTab, "Test Info Notify (6s)", function()
    ui:Notify({
        Title = "Info Notification",
        Text = "This notification stays visible for 6 seconds.",
        Type = "Info",
        Duration = 6
    })
end, "info")

ui:AddButton(mainTab, "Test Warning Notify (8s)", function()
    ui:Notify({
        Title = "Warning Notification",
        Text = "Warning: Speed value is high!",
        Type = "Warning",
        Duration = 8
    })
end, "alert-triangle")

ui:AddButton(mainTab, "Test Error Notify (10s)", function()
    ui:Notify({
        Title = "Error Notification",
        Text = "Error: Action failed to execute.",
        Type = "Error",
        Duration = 10
    })
end, "x-circle")

-- Players Tab (Live Server Player List)
local playersTab = ui:AddTab("main", "Players", "users")

ui:AddPlayerList(playersTab, function(selectedPlayer)
    ui:Notify({
        Title = "Player Selected",
        Text = selectedPlayer.DisplayName .. " (@" .. selectedPlayer.Name .. ")",
        Type = "Info",
        Duration = 3
    })
end)

-- Settings tab
local settingsTab = ui:AddTab("main", "Settings", "settings")

local themePresets = {
    {name = "Purple", id = "Purple"},
    {name = "Green", id = "Green"},
    {name = "Blue", id = "Blue"},
    {name = "Red", id = "Red"},
    {name = "Cyan", id = "Cyan"},
    {name = "Dark", id = "Dark"}
}

local fontPresets = {
    {name = "Inter", id = "Inter"},
    {name = "Poppins", id = "Poppins"},
    {name = "Montserrat", id = "Montserrat"},
    {name = "FiraSans", id = "FiraSans"},
    {name = "GothamMedium", id = "GothamMedium"},
    {name = "BuilderSans", id = "BuilderSans"},
    {name = "Ubuntu", id = "Ubuntu"},
    {name = "Michroma", id = "Michroma"},
    {name = "Code", id = "Code"},
    {name = "FredokaOne", id = "FredokaOne"}
}

local notifyPosOptions = {
    {name = "Top Right", id = "TopRight"},
    {name = "Top Left", id = "TopLeft"},
    {name = "Bottom Right", id = "BottomRight"},
    {name = "Bottom Left", id = "BottomLeft"}
}

-- Notification position
ui:AddSelector(settingsTab, "Notify Position", notifyPosOptions, 1, function(valIndex, item)
    local pos = item.options[valIndex].id
    ui:SetNotifyPosition(pos)
    ui:Notify({
        Title = "Position Changed",
        Text = "Notifications will now show in " .. pos,
        Type = "Info",
        Position = pos,
        Duration = 4
    })
end, "bell")

-- Banner
ui:AddBannerSelector(settingsTab, "Banner", myBanners, 1, nil, "image")

-- Theme
ui:AddSelector(settingsTab, "Theme Preset", themePresets, 1, function(valIndex, item)
    ui:SetTheme(item.options[valIndex].id)
end, "palette")

-- Font
ui:AddSelector(settingsTab, "Font Family", fontPresets, 1, function(valIndex, item)
    ui:SetFont(item.options[valIndex].id)
end, "font")

-- Menu opacity
ui:AddSlider(settingsTab, "Menu Opacity", 0, 100, 85, 5, function(val)
    ui:SetOpacity(val)
end, "sliders")

-- Watermark
ui:AddToggle(settingsTab, "Show Watermark", true, function(val)
    ui:SetWatermarkVisible(val)
end, "eye")

ui:AddSeparator(settingsTab, "Uninject")

-- Uninject button
ui:AddButton(settingsTab, "Uninject UI", function()
    ui:Notify({ Title = "Uninjecting", Text = "Cleaning up UI resources...", Type = "Warning", Duration = 3 })
    task.wait(0.5)
    ui:Uninject()
end, "power")

ui:Init()

-- Welcome note
ui:Notify({
    Title = "LuaUI Loaded",
    Text = "Press RightShift to hide/show the menu.",
    Type = "Info",
    Duration = 5
})
