local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

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

local AutoDupe = {}
AutoDupe.Flags = {}

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

function AutoDupe:Window(options)
    options = options or {}
    local Name = options.Name or "Auto Dupe"
    local Subtitle = options.Subtitle or ""
    local Size = options.Size or UDim2.new(0, 600, 0, 450)

    local ScreenGui = create("ScreenGui", {
        Name = "AutoDupe",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    safeParent(ScreenGui)

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

    local TopBar = create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.section,
        BorderSizePixel = 0,
        Parent = Main
    })
    create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = TopBar})

    local Logo = create("ImageLabel", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 8, 0, 5),
        BackgroundTransparency = 1,
        Image = LogoId,
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 10,
        Parent = TopBar
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Logo})

    local TopBarMask = create("Frame", {
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = Theme.section,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = TopBar
    })

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

    if Subtitle ~= "" then
        create("TextLabel", {
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

    local CloseBtn = create("TextButton", {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(1, -40, 0.5, -16),
        BackgroundColor3 = Theme.element,
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

    local Sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = Theme.section,
        BorderSizePixel = 0,
        Parent = Main
    })

    local Content = create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -150, 1, -50),
        Position = UDim2.new(0, 150, 0, 50),
        BackgroundColor3 = Theme.background,
        BorderSizePixel = 0,
        Parent = Main
    })

    local TabContainer = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
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
    local TabLayout = create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabContainer
    })

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

        local Tab = {Button = TabBtn, Page = Page}

        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Page.Visible = false
                tween(Window.CurrentTab.Button, {
                    BackgroundColor3 = Theme.tab_inactive,
                    TextColor3 = Theme.subtext
                })
            end
            Window.CurrentTab = Tab
            Page.Visible = true
            tween(TabBtn, {
                BackgroundColor3 = Theme.tab_active,
                TextColor3 = Theme.text
            })
        end)

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    TabContainer:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 20)
    end)

    return Window
end

return AutoDupe
