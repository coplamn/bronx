-- Auto Dupe GUI
-- Custom themed GUI library
-- Load via: loadstring(game:HttpGet("https://raw.githubusercontent.com/coplamn/bronx/refs/heads/main/dupeUI.lua"))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Color helpers
local function rgb(r, g, b)
    return Color3.fromRGB(r, g, b)
end

local function hex(hexString)
    hexString = hexString:gsub("#", "")
    local r = tonumber(hexString:sub(1, 2), 16)
    local g = tonumber(hexString:sub(3, 4), 16)
    local b = tonumber(hexString:sub(5, 6), 16)
    return Color3.fromRGB(r, g, b)
end

-- Theme configuration
local Theme = {
    accent = hex("0000cd"),
    background = rgb(8, 8, 12),
    section = rgb(18, 18, 28),
    element = rgb(28, 28, 42),
    outline = hex("0000cd"),
    text = rgb(255, 255, 255),
    subtext = rgb(130, 150, 190),
    tab_active = hex("0000cd"),
    tab_inactive = rgb(22, 22, 35),
}

local LogoId = "rbxassetid://132745745021065"

-- Library table
local AutoDupe = {}
AutoDupe.Flags = {}

-- Utility functions
local function create(instance, properties)
    local obj = Instance.new(instance)
    for prop, val in pairs(properties) do
        obj[prop] = val
    end
    return obj
end

local function tween(obj, properties, duration)
    duration = duration or 0.3
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, tweenInfo, properties)
    tween:Play()
    return tween
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragInput = nil
    local startPos = nil
    local startInputPos = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragInput = input
            startInputPos = input.Position
            startPos = frame.Position
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if input == dragInput then
                dragging = false
                dragInput = nil
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragInput then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startInputPos
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function safeParent(gui)
    if syn and syn.protect_gui then
        pcall(function()
            syn.protect_gui(gui)
        end)
        gui.Parent = CoreGui
        return
    end
    if gethui then
        gui.Parent = gethui()
        return
    end
    gui.Parent = CoreGui
end

-- Main Window
function AutoDupe:Window(options)
    options = options or {}
    local Name = options.Name or "Auto Dupe"
    local Subtitle = options.Subtitle or ""
    local Size = options.Size or UDim2.new(0, 600, 0, 450)

    -- ScreenGui
    local ScreenGui = create("ScreenGui", {
        Name = "AutoDupe",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    safeParent(ScreenGui)

    -- Main Frame
    local Main = create("Frame", {
        Name = "Main",
        Size = Size,
        Position = UDim2.new(0.5, -Size.X.Offset / 2, 0.5, -Size.Y.Offset / 2),
        BackgroundColor3 = Theme.background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Main})
    create("UIStroke", {
        Color = Theme.outline,
        Thickness = 2,
        Parent = Main
    })

    -- Top Bar
    local TopBar = create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.section,
        BorderSizePixel = 0,
        Parent = Main
    })
    create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = TopBar})

    -- Mask for topbar corners
    local TopBarMask = create("Frame", {
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = Theme.section,
        BorderSizePixel = 0,
        Parent = TopBar
    })

    -- Logo
    local Logo = create("ImageLabel", {
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0, 10, 0.5, -18),
        BackgroundColor3 = Theme.element,
        BackgroundTransparency = 0,
        Image = LogoId,
        ZIndex = 10,
        Parent = TopBar
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Logo})
    create("UIStroke", {
        Color = Theme.outline,
        Thickness = 1,
        Parent = Logo
    })

    -- Title
    local Title = create("TextLabel", {
        Size = UDim2.new(1, -160, 1, 0),
        Position = UDim2.new(0, 52, 0, 0),
        BackgroundTransparency = 1,
        Text = Name,
        TextColor3 = Theme.text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })

    -- Subtitle
    if Subtitle ~= "" then
        local SubtitleLabel = create("TextLabel", {
            Size = UDim2.new(1, -160, 0, 14),
            Position = UDim2.new(0, 52, 0, 32),
            BackgroundTransparency = 1,
            Text = Subtitle,
            TextColor3 = Theme.subtext,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TopBar
        })
    end

    -- Close Button
    local CloseBtn = create("TextButton", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -40, 0.5, -16),
        BackgroundColor3 = Theme.element,
        BackgroundTransparency = 0,
        Text = "×",
        TextColor3 = Theme.text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = TopBar
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = CloseBtn})

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    CloseBtn.MouseEnter:Connect(function()
        tween(CloseBtn, {BackgroundColor3 = Theme.accent})
    end)
    CloseBtn.MouseLeave:Connect(function()
        tween(CloseBtn, {BackgroundColor3 = Theme.element})
    end)

    makeDraggable(Main, TopBar)

    -- Sidebar
    local Sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = Theme.section,
        BorderSizePixel = 0,
        Parent = Main
    })

    -- Content Area
    local Content = create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -150, 1, -50),
        Position = UDim2.new(0, 150, 0, 50),
        BackgroundColor3 = Theme.background,
        BorderSizePixel = 0,
        Parent = Main
    })

    -- Tab Container
    local TabContainer = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Sidebar
    })
    create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = TabContainer
    })
    create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabContainer
    })

    -- Pages Container
    local Pages = create("Frame", {
        Name = "Pages",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = Content
    })

    local Window = {
        ScreenGui = ScreenGui,
        Main = Main,
        TabContainer = TabContainer,
        Pages = Pages,
        Tabs = {},
        CurrentTab = nil
    }

    function Window:AddTab(name)
        local TabBtn = create("TextButton", {
            Name = name,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.tab_inactive,
            Text = name,
            TextColor3 = Theme.subtext,
            TextSize = 13,
            Font = Enum.Font.GothamSemibold,
            Parent = TabContainer
        })
        create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabBtn})

        local Page = create("ScrollingFrame", {
            Name = name .. "Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = Pages
        })
        create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            Parent = Page
        })
        create("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Page
        })

        local Tab = {
            Button = TabBtn,
            Page = Page,
            Name = name,
            Sections = {}
        }

        TabBtn.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)

        TabBtn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                tween(TabBtn, {BackgroundColor3 = Theme.element})
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                tween(TabBtn, {BackgroundColor3 = Theme.tab_inactive})
            end
        end)

        table.insert(Window.Tabs, Tab)

        function Tab:AddSection(name)
            local Section = create("Frame", {
                Name = name,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Theme.section,
                Parent = Page
            })
            Section.AutomaticSize = Enum.AutomaticSize.Y
            create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Section})
            create("UIStroke", {
                Color = Theme.outline,
                Thickness = 1,
                Parent = Section
            })
            create("UIPadding", {
                PaddingTop = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
                Parent = Section
            })
            create("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Section
            })

            local SectionTitle = create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = string.upper(name),
                TextColor3 = Theme.accent,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Section
            })

            local SectionObj = {
                Frame = Section,
                Elements = {}
            }

            function SectionObj:AddToggle(options)
                options = options or {}
                local name = options.Name or "Toggle"
                local default = options.Default or false
                local callback = options.Callback or function() end
                local flag = options.Flag

                local ToggleFrame = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Parent = Section
                })

                local ToggleLabel = create("TextLabel", {
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ToggleFrame
                })

                local ToggleBtn = create("TextButton", {
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -40, 0.5, -10),
                    BackgroundColor3 = Theme.element,
                    Text = "",
                    Parent = ToggleFrame
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleBtn})
                create("UIStroke", {
                    Color = Theme.outline,
                    Thickness = 1,
                    Parent = ToggleBtn
                })

                local ToggleDot = create("Frame", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0, 3, 0.5, -7),
                    BackgroundColor3 = Theme.subtext,
                    Parent = ToggleBtn
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleDot})

                local state = default

                local function updateToggle()
                    if state then
                        tween(ToggleBtn, {BackgroundColor3 = Theme.accent})
                        tween(ToggleDot, {Position = UDim2.new(1, -17, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                    else
                        tween(ToggleBtn, {BackgroundColor3 = Theme.element})
                        tween(ToggleDot, {Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = Theme.subtext})
                    end
                end

                updateToggle()

                ToggleBtn.MouseButton1Click:Connect(function()
                    state = not state
                    updateToggle()
                    callback(state)
                    if flag then AutoDupe.Flags[flag] = state end
                end)

                if flag then AutoDupe.Flags[flag] = state end

                return {
                    Set = function(self, value)
                        state = value
                        updateToggle()
                        callback(state)
                        if flag then AutoDupe.Flags[flag] = state end
                    end,
                    Get = function()
                        return state
                    end
                }
            end

            function SectionObj:AddButton(options)
                options = options or {}
                local name = options.Name or "Button"
                local callback = options.Callback or function() end

                local Button = create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Theme.element,
                    Text = name,
                    TextColor3 = Theme.text,
                    TextSize = 14,
                    Font = Enum.Font.GothamSemibold,
                    Parent = Section
                })
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Button})
                create("UIStroke", {
                    Color = Theme.outline,
                    Thickness = 1,
                    Parent = Button
                })

                Button.MouseButton1Click:Connect(function()
                    callback()
                end)

                Button.MouseEnter:Connect(function()
                    tween(Button, {BackgroundColor3 = Theme.accent})
                end)
                Button.MouseLeave:Connect(function()
                    tween(Button, {BackgroundColor3 = Theme.element})
                end)
            end

            function SectionObj:AddSlider(options)
                options = options or {}
                local name = options.Name or "Slider"
                local min = options.Min or 0
                local max = options.Max or 100
                local default = options.Default or 50
                local callback = options.Callback or function() end
                local flag = options.Flag

                local SliderFrame = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 45),
                    BackgroundTransparency = 1,
                    Parent = Section
                })

                local SliderLabel = create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = name .. ": " .. tostring(default),
                    TextColor3 = Theme.text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SliderFrame
                })

                local SliderBg = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 8),
                    Position = UDim2.new(0, 0, 0, 25),
                    BackgroundColor3 = Theme.element,
                    Parent = SliderFrame
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderBg})

                local SliderFill = create("Frame", {
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = Theme.accent,
                    Parent = SliderBg
                })
                create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderFill})

                local SliderBtn = create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = SliderBg
                })

                local value = default

                local function updateSlider()
                    local percent = (value - min) / (max - min)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderLabel.Text = name .. ": " .. tostring(math.floor(value))
                end

                SliderBtn.MouseButton1Down:Connect(function()
                    local input = SliderBtn.MouseEnter:Connect(function()
                        local mousePos = UserInputService:GetMouseLocation()
                        local relativePos = (mousePos.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X
                        relativePos = math.clamp(relativePos, 0, 1)
                        value = min + (relativePos * (max - min))
                        updateSlider()
                        callback(value)
                        if flag then AutoDupe.Flags[flag] = value end
                    end)

                    local release
                    release = UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            input:Disconnect()
                            release:Disconnect()
                        end
                    end)
                end)

                if flag then AutoDupe.Flags[flag] = value end

                return {
                    Set = function(self, val)
                        value = math.clamp(val, min, max)
                        updateSlider()
                        callback(value)
                        if flag then AutoDupe.Flags[flag] = value end
                    end,
                    Get = function()
                        return value
                    end
                }
            end

            function SectionObj:AddDropdown(options)
                options = options or {}
                local name = options.Name or "Dropdown"
                local list = options.List or {}
                local default = options.Default or list[1]
                local callback = options.Callback or function() end
                local flag = options.Flag

                local DropdownFrame = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1,
                    Parent = Section
                })

                local DropdownBtn = create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Theme.element,
                    Text = name .. ": " .. tostring(default),
                    TextColor3 = Theme.text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownFrame
                })
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DropdownBtn})
                create("UIStroke", {
                    Color = Theme.outline,
                    Thickness = 1,
                    Parent = DropdownBtn
                })
                create("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    Parent = DropdownBtn
                })

                local Arrow = create("TextLabel", {
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -25, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "▼",
                    TextColor3 = Theme.subtext,
                    TextSize = 10,
                    Parent = DropdownBtn
                })

                local DropdownList = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 35),
                    BackgroundColor3 = Theme.section,
                    Parent = DropdownFrame
                })
                DropdownList.Visible = false
                DropdownList.AutomaticSize = Enum.AutomaticSize.Y
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DropdownList})
                create("UIStroke", {
                    Color = Theme.outline,
                    Thickness = 1,
                    Parent = DropdownList
                })
                create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = DropdownList
                })

                local expanded = false
                local selected = default

                local function toggleDropdown()
                    expanded = not expanded
                    DropdownList.Visible = expanded
                    Arrow.Text = expanded and "▲" or "▼"
                    Arrow.Rotation = expanded and 180 or 0
                end

                DropdownBtn.MouseButton1Click:Connect(function()
                    toggleDropdown()
                end)

                for _, option in ipairs(list) do
                    local OptionBtn = create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = Theme.element,
                        Text = tostring(option),
                        TextColor3 = Theme.text,
                        TextSize = 13,
                        Font = Enum.Font.Gotham,
                        Parent = DropdownList
                    })
                    create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = OptionBtn})

                    OptionBtn.MouseButton1Click:Connect(function()
                        selected = option
                        DropdownBtn.Text = name .. ": " .. tostring(option)
                        toggleDropdown()
                        callback(option)
                        if flag then AutoDupe.Flags[flag] = option end
                    end)

                    OptionBtn.MouseEnter:Connect(function()
                        tween(OptionBtn, {BackgroundColor3 = Theme.accent})
                    end)
                    OptionBtn.MouseLeave:Connect(function()
                        tween(OptionBtn, {BackgroundColor3 = Theme.element})
                    end)
                end

                if flag then AutoDupe.Flags[flag] = default end

                return {
                    Set = function(self, value)
                        selected = value
                        DropdownBtn.Text = name .. ": " .. tostring(value)
                        callback(value)
                        if flag then AutoDupe.Flags[flag] = value end
                    end,
                    Get = function()
                        return selected
                    end
                }
            end

            function SectionObj:AddInput(options)
                options = options or {}
                local name = options.Name or "Input"
                local placeholder = options.PlaceText or "Enter text..."
                local callback = options.Callback or function() end
                local flag = options.Flag

                local InputFrame = create("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1,
                    Parent = Section
                })

                local InputLabel = create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 18),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = Theme.text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = InputFrame
                })

                local InputBox = create("TextBox", {
                    Size = UDim2.new(1, 0, 0, 28),
                    Position = UDim2.new(0, 0, 0, 18),
                    BackgroundColor3 = Theme.element,
                    Text = "",
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = Theme.subtext,
                    TextColor3 = Theme.text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    ClearTextOnFocus = false,
                    Parent = InputFrame
                })
                create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = InputBox})
                create("UIStroke", {
                    Color = Theme.outline,
                    Thickness = 1,
                    Parent = InputBox
                })
                create("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    Parent = InputBox
                })

                InputBox.FocusLost:Connect(function(enterPressed)
                    callback(InputBox.Text, enterPressed)
                    if flag then AutoDupe.Flags[flag] = InputBox.Text end
                end)

                return {
                    Set = function(self, text)
                        InputBox.Text = text
                        if flag then AutoDupe.Flags[flag] = text end
                    end,
                    Get = function()
                        return InputBox.Text
                    end
                }
            end

            function SectionObj:AddLabel(text)
                local Label = create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = text or "Label",
                    TextColor3 = Theme.subtext,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Section
                })

                return {
                    Set = function(self, newText)
                        Label.Text = newText
                    end
                }
            end

            table.insert(Tab.Sections, SectionObj)
            return SectionObj
        end

        return Tab
    end

    function Window:SelectTab(tab)
        if self.CurrentTab == tab then return end

        if self.CurrentTab then
            self.CurrentTab.Page.Visible = false
            tween(self.CurrentTab.Button, {
                BackgroundColor3 = Theme.tab_inactive,
                TextColor3 = Theme.subtext
            })
        end

        self.CurrentTab = tab
        tab.Page.Visible = true
        tween(tab.Button, {
            BackgroundColor3 = Theme.tab_active,
            TextColor3 = Theme.text
        })
    end

    -- Update canvas size
    TabContainer:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabContainer.UIListLayout.AbsoluteContentSize.Y + 20)
    end)

    return Window
end

return AutoDupe
