
-- NEXUS ADMIN | BLACK & PURPLE NEON
-- Roblox Studio - LocalScript
-- Letakkan di StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NexusAdmin"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "MainPanel"
main.Size = UDim2.fromOffset(300, 310)
main.Position = UDim2.new(0.5, -150, 0.5, -155)
main.BackgroundColor3 = Color3.fromRGB(13, 10, 21)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(153, 69, 255)
stroke.Thickness = 2
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 0, 48)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "NEXUS ADMIN"
title.TextColor3 = Color3.fromRGB(210, 170, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(36, 32)
close.Position = UDim2.new(1, -44, 0, 8)
close.Text = "—"
close.TextSize = 20
close.Font = Enum.Font.GothamBold
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(85, 35, 130)
close.Parent = main

Instance.new("UICorner", close).CornerRadius =
    UDim.new(0, 8)

local holder = Instance.new("Frame")
holder.Position = UDim2.fromOffset(12, 58)
holder.Size = UDim2.new(1, -24, 1, -70)
holder.BackgroundTransparency = 1
holder.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = holder

local states = {}

local function makeToggle(name, description)
    local button = Instance.new("TextButton")
    button.Name = name:gsub("%s+", "") .. "Toggle"
    button.Size = UDim2.new(1, 0, 0, 42)
    button.BackgroundColor3 = Color3.fromRGB(35, 24, 49)
    button.Text = name .. "   [OFF]"
    button.TextColor3 = Color3.fromRGB(235, 220, 255)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.Parent = holder

    Instance.new("UICorner", button).CornerRadius =
        UDim.new(0, 8)

    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(104, 55, 150)
    outline.Thickness = 1
    outline.Parent = button

    states[name] = false

    button.Activated:Connect(function()
        states[name] = not states[name]
        button.Text = name ..
            (states[name] and "   [ON]" or "   [OFF]")

        button.BackgroundColor3 = states[name]
            and Color3.fromRGB(91, 39, 145)
            or Color3.fromRGB(35, 24, 49)

        print(name, states[name] and "ON" or "OFF")
    end)

    return button
end

makeToggle("Fly", "Flight")
makeToggle("Noclip", "Collision")
makeToggle("Infinite Jump", "Repeated jumping")
makeToggle("Walk Speed", "Movement speed")

close.Activated:Connect(function()
    main.Visible = false
end)

-- RightShift untuk membuka/menutup panel
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- Drag panel dengan mouse atau sentuhan
local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
