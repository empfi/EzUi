local EZUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/empfi/ezui/refs/heads/main/library.lua"))()

-- Define Custom Banners
local myCustomBanners = {
    {name = "None", id = ""},
    {name = "Scooby", id = "rbxthumb://type=Asset&id=76117265881255&w=420&h=420"},
    {name = "Abstract", id = "rbxthumb://type=Asset&id=76802492834754&w=420&h=420"}
}

-- Icons (via EZUI built-in Lucide set)
local ICONS = {
    User = EZUI.Icons.User,
    Shield = EZUI.Icons.Shield,
    Settings = EZUI.Icons.Settings,
    Speed = EZUI.Icons.Speed,
    Eye = EZUI.Icons.Eye,
    Wrench = EZUI.Icons.Wrench,
    Cross = EZUI.Icons.Error,
}

-- Create Window with Custom Logo, Title, Font, and Theme
local ui = EZUI.new({
    Title = "LuaUI",             -- Script Name on top right
    Logo = "rbxassetid://132927367732055", -- Left Logo Text or Image Asset ID
    FooterText = "EZUI Library | Built for Roblox",
    Font = Enum.Font.GothamMedium, -- Custom Font: Gotham, Roboto, SourceSans, etc.
    Theme = "Green",
    ToggleKey = Enum.KeyCode.RightShift
})

local themePresets = {
    {name = "Green", id = "Green"},
    {name = "Purple", id = "Purple"},
    {name = "Blue", id = "Blue"},
    {name = "Red", id = "Red"},
    {name = "Cyan", id = "Cyan"},
    {name = "Dark", id = "Dark"}
}

local fontPresets = {
    {name = "Gotham", id = "GothamMedium"},
    {name = "Roboto", id = "RobotoMedium"},
    {name = "SourceSans", id = "SourceSansBold"},
    {name = "Ubuntu", id = "Ubuntu"}
}

-- -------------------------------------------------------------
-- MAIN SCREEN
-- -------------------------------------------------------------
ui:CreateScreen("main")

local mainTab = ui:AddTab("main", "Main", ICONS.User)

local navSelf = ui:AddNav(mainTab, "Self Options", "self", ICONS.Shield)
ui:SetSidePreview(navSelf, {
    title = "Self Options",
    text = "Access player health, armor, movement speed, and proof settings."
})

ui:AddNav(mainTab, "Visual Options", "placeholder", ICONS.Eye)
ui:AddNav(mainTab, "Online Options", "placeholder", ICONS.User)

local settingsTab = ui:AddTab("main", "Settings", ICONS.Settings)

-- Banner Selector using user-defined banners
ui:AddBannerSelector(settingsTab, "Banner", myCustomBanners, 1, nil, ICONS.Eye)

-- Theme Selector
local themeSelector = ui:AddSelector(settingsTab, "Theme Preset", themePresets, 1, function(valIndex, item)
    ui:SetTheme(item.options[valIndex].id)
end, ICONS.Wrench)
ui:SetSidePreview(themeSelector, {
    title = "Theme Switcher",
    text = "Instantly re-skin the UI with built-in color themes."
})

-- Font Selector
local fontSelector = ui:AddSelector(settingsTab, "Font Family", fontPresets, 1, function(valIndex, item)
    ui:SetFont(item.options[valIndex].id)
end, ICONS.Wrench)
ui:SetSidePreview(fontSelector, {
    title = "Font Customization",
    text = "Dynamically change font family across the entire user interface."
})

-- Global Opacity Slider using native ui:SetOpacity(val)
local opacitySlider = ui:AddSlider(settingsTab, "Menu Opacity", 0, 100, 85, 5, function(val)
    ui:SetOpacity(val)
end, ICONS.Settings)
ui:SetSidePreview(opacitySlider, {
    title = "Menu Opacity",
    text = "Adjusts global transparency across all UI windows, headers, banners, and highlights."
})

ui:AddToggle(settingsTab, "Show Watermark", true, function(val)
    ui:SetWatermarkVisible(val)
end, ICONS.Eye)

ui:AddSeparator(settingsTab, "Uninject Script")

local uninjectBtn = ui:AddButton(settingsTab, "Uninject UI", function()
    ui:Uninject()
end, ICONS.Cross)
ui:SetSidePreview(uninjectBtn, {
    title = "Uninject UI",
    text = "Safely destroys the UI, unbinds key locks, resets humanoid speed, and cleans up all resources."
})

-- -------------------------------------------------------------
-- SELF OPTIONS SCREEN
-- -------------------------------------------------------------
ui:CreateScreen("self", { parent = "main" })

local healthTab = ui:AddTab("self", "Health", ICONS.Shield)

local godmodeToggle = ui:AddToggle(healthTab, "Godmode", false, function(state) print("Godmode:", state) end, ICONS.Shield)
ui:SetSidePreview(godmodeToggle, {
    title = "Godmode",
    text = "Prevents your character from taking damage from weapons, fall damage, or explosions."
})

ui:AddToggle(healthTab, "Auto Revive", false, nil, ICONS.Shield)
ui:AddButton(healthTab, "Revive Player", function() print("Revived!") end, ICONS.Wrench)
ui:AddSlider(healthTab, "Health", 0, 100, 100, 1, nil, ICONS.Shield)
ui:AddSlider(healthTab, "Armor", 0, 100, 100, 1, nil, ICONS.Shield)

ui:AddSeparator(healthTab, "Player Proofs")
ui:AddToggle(healthTab, "Bullet Proof", false, nil, ICONS.Shield)
ui:AddToggle(healthTab, "Fire Proof", false, nil, ICONS.Shield)
ui:AddToggle(healthTab, "Explosion Proof", false, nil, ICONS.Shield)

local movementTab = ui:AddTab("self", "Movement", ICONS.Speed)
ui:AddToggle(movementTab, "Speed Boost", false, nil, ICONS.Speed)

local speedSlider = ui:AddSlider(movementTab, "Walk Speed", 16, 150, 16, 2, function(val)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end, ICONS.Speed)
ui:SetSidePreview(speedSlider, {
    title = "Walk Speed",
    text = "Increases your player's movement velocity. Default speed is 16."
})

ui:AddSlider(movementTab, "Jump Power", 50, 300, 50, 5, nil, ICONS.Speed)

-- Placeholder Screen
ui:CreateScreen("placeholder", { parent = "main" })
local infoTab = ui:AddTab("placeholder", "Info", ICONS.Wrench)
ui:AddSeparator(infoTab, "Work In Progress")

-- Initialize & Show UI
ui:Init()
