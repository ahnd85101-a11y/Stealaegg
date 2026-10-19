-- PURPLE MOVEMENT - FINAL
-- Speed Boost (1-9999) + Infinity Jump + Draggable
-- Tombol dijamin bisa diklik

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local speedOn = false
local jumpOn = false
local normalSpeed = 16
local boostSpeed = 50
local MIN_SPEED, MAX_SPEED = 1, 9999

-- ================== HELPER ==================
local function getHumanoid()
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = parent
    return c
end

-- ================== GUI ==================
local gui = Instance.new("ScreenGui")
gui.Name = "PurpleMovement"
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local placed = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not placed or not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.fromOffset(250, 340)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 20, 65)
frame.BorderSizePixel = 0
frame.Active = false
frame.Parent = gui
corner(frame, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 34)
title.BackgroundTransparency = 1
title.Text = "PURPLE MOVEMENT"
title.TextColor3 = Color3.fromRGB(210, 160, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.ZIndex = 10
title.Parent = frame

-- ================== TOMBOL ==================
local function makeButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 44)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(115, 55, 185)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = true
    b.Active = true
    b.Selectable = true
    b.Text = text
    b.ZIndex = 10
    b.Parent = frame
    corner(b, 8)
    return b
end

local speedButton = makeButton("Speed: OFF", 38)
local jumpButton  = makeButton("Jump: OFF", 88)

-- ================== LABEL ==================
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 22)
speedLabel.Position = UDim2.new(0.05, 0, 0, 138)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. boostSpeed
speedLabel.TextColor3 = Color3.fromRGB(210, 160, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.ZIndex = 10
speedLabel.Parent = frame

-- ================== TEXTBOX ==================
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.9, 0, 0, 32)
speedBox.Position = UDim2.new(0.05, 0, 0, 162)
speedBox.BackgroundColor3 = Color3.fromRGB(70, 35, 110)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.TextScaled = true
speedBox.Font = Enum.Font.Gotham
speedBox.Text = tostring(boostSpeed)
speedBox.PlaceholderText = "1 - 9999"
speedBox.ClearTextOnFocus = false
speedBox.ZIndex = 10
speedBox.Parent = frame
corner(speedBox, 8)

-- ================== SLIDER ==================
local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0.9, 0, 0, 12)
sliderBg.Position = UDim2.new(0.05, 0, 0, 208)
sliderBg.BackgroundColor3 = Color3.fromRGB(70, 35, 110)
sliderBg.BorderSizePixel = 0
sliderBg.ZIndex = 10
sliderBg.Parent = frame
corner(sliderBg, 6)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
sliderFill.BorderSizePixel = 0
sliderFill.ZIndex = 11
sliderFill.Parent = sliderBg
corner(sliderFill, 6)

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.fromOffset(20, 20)
sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
sliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
sliderKnob.BackgroundColor3 = Color3.fromRGB(230, 190, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.ZIndex = 12
sliderKnob.Parent = sliderBg
corner(sliderKnob, 10)

-- ================== LOGIC SPEED ==================
local function refreshSpeedUI()
    speedLabel.Text = "Speed: " .. boostSpeed
    local pct = (boostSpeed - MIN_SPEED) / (MAX_SPEED - MIN_SPEED)
    sliderFill.Size = UDim2.new(pct, 0, 1, 0)
    sliderKnob.Position = UDim2.new(pct, 0, 0.5, 0)
    speedBox.Text = tostring(boostSpeed)
    if speedOn then
        speedButton.Text = "Speed: ON (" .. boostSpeed .. ")"
    else
        speedButton.Text = "Speed: OFF"
    end
end

local function setSpeed(value)
    value = tonumber(value) or boostSpeed
    value = math.floor(value)
    value = math.clamp(value, MIN_SPEED, MAX_SPEED)
    boostSpeed = value
    refreshSpeedUI()
    if speedOn then
        local h = getHumanoid()
        if h then h.WalkSpeed = boostSpeed end
    end
end

speedBox.FocusLost:Connect(function()
    setSpeed(speedBox.Text)
end)

local sliderDragging = false
local function sliderFrom(input)
    local x = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
    x = math.clamp(x, 0, 1)
    setSpeed(MIN_SPEED + x * (MAX_SPEED - MIN_SPEED))
end

sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        sliderFrom(input)
    end
end)

-- ================== DRAG FRAME ==================
local frameDragging = false
local dragStart, dragOrigin

local dragBar = Instance.new("TextButton")
dragBar.Size = UDim2.new(1, 0, 0, 34)
dragBar.BackgroundTransparency = 1
dragBar.Text = ""
dragBar.ZIndex = 9
dragBar.Active = true
dragBar.Parent = frame

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        frameDragging = true
        dragStart = input.Position
        dragOrigin = frame.Position
    end
end)

-- ================== SATU LISTENER GLOBAL ==================
UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        if sliderDragging then
            pcall(sliderFrom, input)
        elseif frameDragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                dragOrigin.X.Scale, dragOrigin.X.Offset + delta.X,
                dragOrigin.Y.Scale, dragOrigin.Y.Offset + delta.Y
            )
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
        frameDragging = false
    end
end)

-- ================== CLICK BINDING ==================
local function onSpeedClick()
    speedOn = not speedOn
    local h = getHumanoid()
    if speedOn then
        if h then h.WalkSpeed = boostSpeed end
        speedButton.Text = "Speed: ON (" .. boostSpeed .. ")"
    else
        if h then h.WalkSpeed = normalSpeed end
        speedButton.Text = "Speed: OFF"
    end
end

local function onJumpClick()
    jumpOn = not jumpOn
    jumpButton.Text = jumpOn and "Jump: ON" or "Jump: OFF"
end

speedButton.MouseButton1Click:Connect(onSpeedClick)
jumpButton.MouseButton1Click:Connect(onJumpClick)

-- fallback untuk mobile
speedButton.Activated:Connect(onSpeedClick)
jumpButton.Activated:Connect(onJumpClick)

-- ================== INFINITY JUMP ==================
UIS.JumpRequest:Connect(function()
    if not jumpOn then return end
    local h = getHumanoid()
    if h then
        h:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ================== RESPAWN ==================
player.CharacterAdded:Connect(function(char)
    local h = char:WaitForChild("Humanoid")
    if speedOn then
        h.WalkSpeed = boostSpeed
    else
        h.WalkSpeed = normalSpeed
    end
    refreshSpeedUI()
    jumpButton.Text = jumpOn and "Jump: ON" or "Jump: OFF"
end)

-- init
refreshSpeedUI()
