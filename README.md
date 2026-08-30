# EzUI Documentation

EzUI is a lightweight, customizable, and keyboard-navigable UI library for Roblox scripts. It is designed around clean visual hierarchy, smooth navigation, and ease of use.

When you attach EzUI to your script in LuaProtect, the `UI` global variable is injected automatically at runtime. You do not need to add any `loadstring` or `require` statements to your code—simply start configuring and building your interface.

---

## Navigation & Controls

EzUI is designed for keyboard and controller navigation:
- **Up / Down Arrows**: Navigate between menu items.
- **Left / Right Arrows**: Adjust sliders and cycle selector options.
- **Enter / Return**: Toggle checkboxes, trigger buttons, or enter sub-menus.
- **Backspace / Delete**: Go back to the parent screen.
- **Tab**: Cycle through top tabs.
- **Right Shift** (Default): Toggle menu visibility.

---

## Quick Example

Here is a complete example demonstrating how to set up screens, tabs, controls, player lists, and theme selectors.

```lua
-- When EzUI is attached in LuaProtect, the 'UI' global is available automatically.

-- 1. Create the UI Window
local ui = UI.new({
    Title = "Hub Name",
    Theme = "Purple",              -- Options: "Purple", "Green", "Blue", "Red", "Cyan", "Dark"
    Font = "Montserrat",           -- Default font family
    Position = "TopMiddle",        -- "TopMiddle", "Left", "Center", "Right", "TopLeft", "TopRight"
    CornerRadius = 10,             -- 0 (Sharp), 10 (Rounded), 16 (Soft)
    PreviewPosition = "Right",     -- "Right", "Left", or "Bottom"
    PreviewShape = "Circle",       -- Avatar preview shape: "Circle", "Square", "Rounded"
    NotifyPosition = "TopRight",   -- "TopRight", "TopLeft", "BottomRight", "BottomLeft"
    NotifyDuration = 4,            -- Default toast duration in seconds
    ToggleKey = Enum.KeyCode.RightShift,
    AutoSave = true,               -- Automatically saves user preferences to workspace
    AutoLoad = true                -- Automatically restores user preferences on start
})

-- 2. Define the Main Screen and Tabs
ui:CreateScreen("main")
local mainTab = ui:AddTab("main", "Main", UI.Icons.Home)
local playersTab = ui:AddTab("main", "Players", UI.Icons.Users)
local settingsTab = ui:AddTab("main", "Settings", UI.Icons.Settings)

-- 3. Add Controls to the Main Tab

-- Toggle Example
ui:AddToggle(mainTab, "Infinite Stamina", false, function(enabled)
    print("Stamina toggle state:", enabled)
    ui:Notify({
        Title = "Stamina",
        Text = enabled and "Infinite stamina active." or "Infinite stamina disabled.",
        Type = enabled and "Info" or "Warning",
        Duration = 3
    })
end, UI.Icons.Shield)

-- Slider Example
ui:AddSlider(mainTab, "WalkSpeed", 16, 150, 16, 2, function(value)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        character.Humanoid.WalkSpeed = value
    end
end, UI.Icons.Speed)

-- Button Example
ui:AddButton(mainTab, "Respawn Character", function()
    local character = game.Players.LocalPlayer.Character
    if character then
        character:BreakJoints()
    end
end, UI.Icons.Cross)

-- 4. Server Player List Tab
ui:AddPlayerList(playersTab, function(selectedPlayer)
    ui:Notify({
        Title = "Player Selected",
        Text = selectedPlayer.DisplayName .. " (@" .. selectedPlayer.Name .. ")",
        Type = "Info",
        Duration = 3
    })
end)

-- 5. Settings Tab (Theme & Appearance)
local themeOptions = {
    { name = "Purple", id = "Purple" },
    { name = "Green", id = "Green" },
    { name = "Blue", id = "Blue" },
    { name = "Red", id = "Red" },
    { name = "Cyan", id = "Cyan" },
    { name = "Dark", id = "Dark" }
}

ui:AddSelector(settingsTab, "Theme Preset", themeOptions, 1, function(index, item)
    ui:SetTheme(item.options[index].id)
end, UI.Icons.Wrench)

-- Opacity Slider
ui:AddSlider(settingsTab, "Menu Opacity", 20, 100, 90, 5, function(val)
    ui:SetOpacity(val)
end, UI.Icons.Eye)

-- 6. Initialize the Interface
ui:Init()
```

---

## API Reference

### `UI.new(config)`
Initializes a new interface window.

| Option | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `Title` | string | `"EZUI"` | The title text displayed in the header. |
| `Logo` / `LogoText` | string | `"EZ"` | Text logo or Roblox asset ID (`"rbxassetid://..."`). |
| `FooterText` | string | `"EZUI Library"` | Description text rendered in the bottom footer. |
| `Theme` | string \| table | `"Purple"` | Preset theme name or a custom color table. |
| `Font` | string \| Enum.Font | `"Montserrat"` | Font used across all labels and controls. |
| `Position` | string | `"TopMiddle"` | Anchor location on screen (`"TopMiddle"`, `"Left"`, `"Center"`, `"Right"`, `"TopLeft"`, `"TopRight"`). |
| `CornerRadius` | number | `10` | Corner rounding amount in pixels (`0` for sharp, `10` for rounded). |
| `PreviewPosition` | string | `"Right"` | Side preview panel placement (`"Right"`, `"Left"`, `"Bottom"`). |
| `PreviewLayout` | string | `"Horizontal"` | Layout direction of the preview card (`"Horizontal"`, `"Vertical"`). |
| `PreviewShape` | string | `"Circle"` | Avatar crop style (`"Circle"`, `"Square"`, `"Rounded"`). |
| `NotifyPosition` | string | `"TopRight"` | Toast corner anchor (`"TopRight"`, `"TopLeft"`, `"BottomRight"`, `"BottomLeft"`). |
| `NotifyDuration` | number | `4` | Default duration in seconds before toasts fade out. |
| `ToggleKey` | Enum.KeyCode | `RightShift` | Keybind used to show and hide the window. |
| `KeySystem` | table \| string | `nil` | Native key system configuration or Key Flow slug. |
| `AutoSave` | boolean | `true` | Persists user theme/font selections to the executor workspace. |
| `AutoLoad` | boolean | `true` | Restores saved settings on execution. |

---

### Built-in Key System

EzUI includes a fully automated Key System integrated directly into the normal window layout using native `AddInput` and button rows. When configured, EzUI displays a dedicated key tab, handles validation via LuaProtect's public API, auto-saves valid keys to workspace, and automatically unlocks the main menu once verified.

#### Simple Usage
```lua
local ui = UI.new({
    Title = "My Hub",
    Theme = "Cyan",
    KeySystem = "528718" -- Your Flow ID or slug
})
```

#### Full Customization Options
```lua
local ui = UI.new({
    Title = "My Hub",
    Theme = "Cyan",
    KeySystem = {
        Flow = "528718",                       -- Your LuaProtect Key Flow slug / ID
        Title = "License",                     -- Tab name (default: "License")
        Icon = UI.Icons.Lock,                  -- Tab icon
        Note = "Join discord.gg/myhub for key",-- Subtitle separator note
        InputLabel = "Key",                    -- Label on input row
        InputPlaceholder = "Paste key here...",-- Placeholder text
        SubmitText = "Submit Key",             -- Text on submit button
        GetKeyText = "Get Key (Copy Link)",    -- Text on copy link button
        GetKeyUrl = "https://key.luaprotect.dev/lp/528718", -- Link copied
        SaveKey = true,                        -- Auto-saves validated key to workspace (default: true)
        FileName = "myhub_key.txt",            -- Custom key cache file name
        OnSuccess = function(key)
            print("Access granted with key:", key)
        end,
        OnFailure = function(reason)
            print("Key failed:", reason)
        end
    }
})

-- Define your screens and tabs as usual...
ui:CreateScreen("main")
local mainTab = ui:AddTab("main", "Home", UI.Icons.Home)
ui:AddToggle(mainTab, "Godmode", false, function(v) end)

-- Init handles file checks, input bindings, and auto-unlocking:
ui:Init()
```

---

### Screens & Tabs

#### `ui:CreateScreen(screenId, [options])`
Creates a container screen. Root menus use `"main"`. Sub-screens can provide `{ parent = "main" }` to enable automatic Backspace navigation.

```lua
ui:CreateScreen("main")
ui:CreateScreen("teleports", { parent = "main" })
```

#### `ui:AddTab(screenId, title, [icon])`
Appends a tab to the specified screen and returns the tab reference.

```lua
local combatTab = ui:AddTab("main", "Combat", UI.Icons.Sword)
```

---

### UI Controls

#### `ui:AddToggle(tab, label, defaultState, callback, [icon])`
Creates a binary on/off switch.
- `defaultState` *(boolean)*: Initial state (`true` or `false`).
- `callback` *(function(state: boolean))*: Triggered when state changes.

```lua
ui:AddToggle(tab, "Auto Collect", false, function(state)
    print("Auto Collect is now", state)
end, UI.Icons.Check)
```

#### `ui:AddSlider(tab, label, min, max, default, step, callback, [icon])`
Creates a stepped numeric slider.
- `min` / `max` *(number)*: Value range bounds.
- `default` *(number)*: Starting value.
- `step` *(number)*: Step increment when pressing Left/Right.
- `callback` *(function(value: number))*: Triggered on value adjustment.

```lua
ui:AddSlider(tab, "FOV", 70, 120, 90, 1, function(value)
    workspace.CurrentCamera.FieldOfView = value
end, UI.Icons.Eye)
```

#### `ui:AddInput(tab, label, placeholder, [defaultValue], [onEnterCallback], [icon])`
Creates an inline text input box. When selected or clicked, keyboard navigation is automatically paused so users can type or paste freely without triggering menu keys.
- `placeholder` *(string)*: Ghost placeholder text.
- `defaultValue` *(string)*: Initial text value.
- `onEnterCallback` *(function(text: string, item: table, enterPressed: boolean))*: Triggered when user finishes typing or presses Enter.

```lua
ui:AddInput(tab, "License Key", "Paste key here...", "", function(text)
    print("Entered key:", text)
end, UI.Icons.Key)
```

#### `ui:AddButton(tab, label, callback, [icon])`
Creates a clickable action button.

```lua
ui:AddButton(tab, "Clear Inventory", function()
    print("Inventory cleared")
end, UI.Icons.Trash)
```

#### `ui:AddSelector(tab, label, options, defaultIndex, callback, [icon])`
Creates a multi-option selector that can be cycled using the arrow keys.
- `options` *(table)*: Array of `{ name = "Label", id = "value" }` or string names.
- `defaultIndex` *(number)*: Starting selection index (1-based).
- `callback` *(function(index: number, item: table))*: Triggered when an option is selected.

```lua
local targets = {
    { name = "Nearest", id = "near" },
    { name = "Lowest HP", id = "low_hp" },
    { name = "Crosshair", id = "mouse" }
}

ui:AddSelector(tab, "Target Priority", targets, 1, function(index, item)
    print("Selected target:", item.options[index].name)
end, UI.Icons.Sliders)
```

#### `ui:AddNav(tab, label, targetScreenId, [icon])`
Creates a navigation row that switches to another screen when pressed.

```lua
ui:AddNav(mainTab, "Visual Settings", "visual_screen", UI.Icons.Eye)
```

#### `ui:AddSeparator(tab, [label])`
Inserts a non-interactive divider row with an optional label.

```lua
ui:AddSeparator(tab, "Danger Zone")
```

#### `ui:AddPlayerList(tab, onPlayerClick)`
Builds a real-time list of all players currently in the server, with player avatars, display names, usernames, and click callbacks.

```lua
ui:AddPlayerList(playersTab, function(player)
    print("Clicked on player:", player.Name)
end)
```

---

### Side-Panel Previews

You can attach a side preview window to any item. When that item is highlighted in the menu, the preview panel automatically opens.

#### `ui:SetSidePreview(item, config)`
- **Text Preview**:
```lua
local nav = ui:AddNav(mainTab, "ESP Options", "esp_screen", UI.Icons.Eye)
ui:SetSidePreview(nav, {
    title = "ESP Settings",
    text = "Customize bounding boxes, player tracers, names, and health bars."
})
```

- **Image Preview**:
```lua
local bannerItem = ui:AddButton(tab, "Custom Theme", function() end)
ui:SetSidePreview(bannerItem, {
    title = "Preview",
    image = "rbxthumb://type=Asset&id=76802492834754&w=420&h=420"
})
```

---

### Notifications (`ui:Notify`)

Displays animated toast notifications with customizable durations and icons.

```lua
ui:Notify({
    Title = "Configuration Saved",
    Text = "Your settings were written to disk.",
    Type = "Info",       -- "Info", "Warning", or "Error"
    Duration = 4,        -- Duration in seconds before dismissing
    Position = "TopRight", -- "TopRight", "TopLeft", "BottomRight", "BottomLeft"
    Icon = UI.Icons.Check -- Custom icon
})
```

---

### Live Customization Methods

These methods allow dynamic updates without needing to rebuild or restart the interface.

| Method | Argument | Description |
| :--- | :--- | :--- |
| `ui:SetTheme(nameOrTable)` | `"Purple"`, `"Green"`, `"Blue"`, `"Red"`, `"Cyan"`, `"Dark"`, or RGB table | Updates colors and accent highlights in real-time. |
| `ui:SetFont(font)` | `"Montserrat"`, `"Gotham"`, `"Roboto"`, `"SourceSans"`, `"Ubuntu"`, etc. | Updates typography across all text elements. |
| `ui:SetOpacity(percentage)` | number (`0` to `100`) | Adjusts transparency for the entire window. |
| `ui:SetBanner(assetId)` | string asset ID or URL | Updates the header banner image. |
| `ui:SetLogo(textOrId)` | string text or asset ID | Updates the header logo icon. |
| `ui:SetTitle(text)` | string | Updates the header title text. |
| `ui:SetFooterText(text)` | string | Updates the footer bar label. |

---

### Lifecycle & Teardown

- **`ui:Init()`**: Call this after setting up your screens and controls to render the interface.
- **`ui:Uninject()`**: Completely destroys the interface, unbinds all key listeners, restores standard player movement, and cleans up memory.
- **`ui:OnUninject(callback)`**: Registers a cleanup callback that will be triggered when the UI is uninstalled or closed.

```lua
ui:OnUninject(function()
    print("Script cleaned up successfully.")
end)
```

---

### Built-in Icons

You can pass icons via `UI.Icons.<Name>` or by lowercase name string:
- `UI.Icons.Home`, `UI.Icons.User`, `UI.Icons.Users`, `UI.Icons.Shield`, `UI.Icons.Settings`, `UI.Icons.Sliders`, `UI.Icons.Wrench`, `UI.Icons.Eye`, `UI.Icons.Lock`, `UI.Icons.Check`, `UI.Icons.Cross`, `UI.Icons.Speed`, `UI.Icons.Sword`, `UI.Icons.Heart`, `UI.Icons.Car`, `UI.Icons.Bell`, `UI.Icons.Info`, `UI.Icons.Warning`, `UI.Icons.Trash`, `UI.Icons.Search`, `UI.Icons.Palette`, and more.
