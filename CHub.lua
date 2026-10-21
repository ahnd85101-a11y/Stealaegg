-- ==========================================
-- PURPLE MOVEMENT ULTIMATE (BHUB EDITION) - FIXED
-- ==========================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local speedOn = false
local jumpOn = false
local godModeOn = false
local normalSpeed = 16
local boostSpeed = 100
local powerValue = 100

-- UI Setup
local oldGui = game.CoreGui:FindFirstChild("PurpleMovementGUI") or player.PlayerGui:FindFirstChild("PurpleMovementGUI")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "PurpleMovementGUI"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = game.CoreGui end)
if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(250, 350)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 15, 55)
-- FIX #1: frame.Active dihapus, gak usah ada (biar gak nahan klik button)
frame.Active = false
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(170, 85, 255)
stroke.Thickness = 2

-- Header (Drag Area)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(55, 25, 85)
header.Parent = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

-- FIX #2: header butuh Active = true biar drag tetap jalan
header.Active = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "PURPLE ULTIMATE"
title.TextColor3 = Color3.fromRGB(210, 160, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.Activated:Connect(function() gui:Destroy() end)

-- Fungsi Bikin Tombol
local function createButton(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 40)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(100, 50, 160)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.Text = text
    -- FIX #3: pastiin button aktif & di atas
    b.Active = true
    b.Selectable = false
    b.ZIndex = 2
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    -- FIX #4: pakai Activated (lebih reliable dari MouseButton1Click)
    b.Activated:Connect(function()
        callback()
    end)
    return b
end

-- Fungsi Bikin Slider
local function createSlider(text, y, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0, 0, 45)
    container.Position = UDim2.new(0.05, 0, 0, y)
    container.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
    container.Parent = frame
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -10, 0, 5)
    barBg.Position = UDim2.new(0, 5, 1, -12)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 15, 45)
    barBg.Parent = container
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
    fill.Parent = barBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dragger = Instance.new("TextButton")
    dragger.Size = UDim2.new(0, 15, 0, 15)
    dragger.Position = UDim2.new((default-min)/(max-min), -7, 0.5, -7)
    dragger.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dragger.Text = ""
    dragger.ZIndex = 3
    dragger.Parent = barBg
    Instance.new("UICorner", dragger).CornerRadius = UDim.new(1, 0)

    local dragging = false
    dragger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = input.Position.X
            local barAbsPos = barBg.AbsolutePosition.X
            local barAbsSize = barBg.AbsoluteSize.X
            local percent = math.clamp((mouseX - barAbsPos) / barAbsSize, 0, 1)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            dragger.Position = UDim2.new(percent, -7, 0.5, -7)
            local val = math.floor(min + ((max - min) * percent))
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- SUSUNAN MENU
createSlider("WalkSpeed", 45, 16, 500, 100, function(val)
    boostSpeed = val
    if speedOn then
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = val end
    end
end)

createSlider("Power / Damage", 95, 1, 1000, 100, function(val)
    powerValue = val
    local char = player.Character
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Damage") then
                tool.Damage.Value = val
            end
        end
    end
end)

local speedButton = createButton("Speed Boost: OFF", 150, function()
    speedOn = not speedOn
    speedButton.Text = speedOn and "Speed Boost: ON" or "Speed Boost: OFF"
    speedButton.BackgroundColor3 = speedOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 50, 160)
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = speedOn and boostSpeed or normalSpeed end
end)

local jumpButton = createButton("Infinity Jump: OFF", 195, function()
    jumpOn = not jumpOn
    jumpButton.Text = jumpOn and "Infinity Jump: ON" or "Infinity Jump: OFF"
    jumpButton.BackgroundColor3 = jumpOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 50, 160)
end)

local godButton = createButton("God Mode: OFF", 240, function()
    godModeOn = not godModeOn
    godButton.Text = godModeOn and "God Mode: ON" or "God Mode: OFF"
    godButton.BackgroundColor3 = godModeOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(100, 50, 160)
    
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.MaxHealth = godModeOn and math.huge or 100
        h.Health = godModeOn and math.huge or 100
    end
end)

-- LOGIKA BACKGROUND
UIS.JumpRequest:Connect(function()
    if jumpOn then
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if godModeOn then
            local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if h then
                h.MaxHealth = math.huge
                h.Health = math.huge
            end
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    local h = char:WaitForChild("Humanoid", 5)
    if h then
        h.WalkSpeed = speedOn and boostSpeed or normalSpeed
        if godModeOn then
            h.MaxHealth = math.huge
            h.Health = math.huge
        end
    end
end)

-- FITUR DRAG UI
local dragging, dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("[PURPLE ULTIMATE] Loaded! Buttons fixed.")
