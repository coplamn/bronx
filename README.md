# UI Library

A clean, modern UI library for Roblox scripts.

## Quick Load

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/coplamn/bronx/refs/heads/main/uil.lua"))()
```

## Basic Usage

After loading, create your window:

```lua
local Bronx = getgenv().Bronx

local Window = Bronx:Window({
    Title = "My Script",
    Subtitle = "v1.0",
    Logo = "132745745021065",  -- Optional: Asset ID for logo (set to "" to hide)
    Size = UDim2.new(0, 520, 0, 380)

    -- use Size = UDim2.fromOffset(720, 500) for fixed size
})
```

## Creating Tabs


```lua
local MainTab = Window:Tab({
    Name = "Main",
    Icon = "10734943306"  -- Asset ID or rbxassetid://... or rbxthumb://type=Asset&id=YOURID&w=150&h=150
})

local SettingsTab = Window:Tab({
    Name = "Settings",
    Icon = "10734950309"  -- Asset ID or rbxassetid://... or rbxthumb://type=Asset&id=YOURID&w=150&h=150
})
```

## Creating Sections

Sections hold your UI elements. You can place them on the Left or Right side:

```lua
local Section = MainTab:Section({
    Name = "Features",
    Side = "Left"  -- or "Right"
})
```

## UI Elements

### Toggle

```lua
Section:Toggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Auto Farm:", state)
    end
})
```

### Button

```lua
Section:Button({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```

### Slider

```lua
Section:Slider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Suffix = " studs",
    Callback = function(value)
        print("Speed:", value)
    end
})
```

### Dropdown

```lua
Section:Dropdown({
    Name = "Select Option",
    Items = {"Option 1", "Option 2", "Option 3"},
    Callback = function(value)
        print("Selected:", value)
    end
})
```

### Input

```lua
Section:Input({
    Name = "Enter Text",
    Placeholder = "Type here...",
    Callback = function(value)
        print("Input:", value)
    end
})
```

### Keybind

```lua
Section:Keybind({
    Name = "Toggle Key",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Keybind pressed!")
    end
})
```

### Color Picker

```lua
Section:ColorPicker({
    Name = "Pick Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Color:", color)
    end
})
```

## Features

- **Dark Theme**: Easy on the eyes with a professional look
- **Mobile Support**: Auto toggle button for touch devices
- **Draggable Window**: Move the UI anywhere on screen
- **Resizable**: Drag the corner to resize
- **Smooth Animations**: Nice transitions and effects
- **Left Sidebar Tabs**: Clean tab layout on the left side

## Tips

- Use `getgenv().Bronx` to access the library after loading
- The window is draggable by the header
- Mobile users get a floating toggle button automatically
- All callbacks receive the current value/state

## Example Full Script

```lua
-- Load the library
loadstring(game:HttpGet("https://raw.githubusercontent.com/coplamn/bronx/refs/heads/main/uil.lua"))()

-- Wait for it to load
repeat task.wait() until getgenv().Bronx

local Bronx = getgenv().Bronx

-- Create window
local Window = Bronx:Window({
    Title = "My Script",
    Subtitle = "v1.0", -- can be version of your script or wtv blah blah negus
    Logo = "132745745021065",  -- Optional: Set to "" to hide logo
    Size = UDim2.new(0, 520, 0, 380)
})

-- Create tab
local MainTab = Window:Tab({
    Name = "Main",
    Icon = "10734943306"
})

-- Create section
local Section = MainTab:Section({
    Name = "Features",
    Side = "Left"
})

-- Add elements
Section:Toggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(state)
        print("Auto Farm:", state)
    end
})

Section:Button({
    Name = "Print Hello",
    Callback = function()
        print("Hello!")
    end
})
```
