-- SPEED BOOST + INFINITY JUMP (Draggable GUI + Speed Slider 1-9999)
-- Delta Executor | Client-side Lua

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local speedOn = false
local jumpOn = false
local normalSpeed = 16
local boostSpeed = 50        -- default
local MIN_SPEED = 1
local MAX_SPEED = 9999

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "PurpleMovementGUI"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(240, 320)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 20, 65)
frame.Active = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "PURPLE MOVEMENT"
title.TextColor3 = Color3.fromRGB(210, 160, 255)
title.TextScaled = true
title.Parent = frame

-- helper
local function newCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = parent
    return c
end

local function createButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(115, 55, 185)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Text = text
    b.Parent = frame
    newCorner(b, 8)
    return b
end

local speedButton = createButton("Speed Boost: OFF", 40)
local jumpButton  = createButton("Infinity Jump: OFF", 90)

-- ===== LABEL SPEED =====
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 22)
speedLabel.Position = UDim2.new(0.05, 0, 0, 140)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. boostSpeed
speedLabel.TextColor3 = Color3.fromRGB(210, 160, 255)
speedLabel.TextScaled = true
speedLabel.Parent = frame

-- ===== TEXTBOX =====
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.9, 0, 0, 32)
speedBox.Position = UDim2.new(0.05, 0, 0, 165)
speedBox.BackgroundColor3 = Color3.fromRGB(70, 35, 110)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.TextScaled = true
speedBox.Text = tostring(boostSpeed)
speedBox.PlaceholderText = "1 - 9999"
speedBox.ClearTextOnFocus = false
speedBox.Parent = frame
newCorner(speedBox, 8)

-- ===== SLIDER =====
local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0.9, 0, 0, 10)
sliderBg.Position = UDim2.new(0.05, 0, 0, 210)
sliderBg.BackgroundColor3 = Color3.fromRGB(70, 35, 110)
sliderBg.Parent = frame
newCorner(sliderBg, 5)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
sliderFill.Parent = sliderBg
newCorner(sliderFill, 5)

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.fromOffset(18, 18)
sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
sliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
sliderKnob.BackgroundColor3 = Color3.fromRGB(230, 190, 255)
sliderKnob.Parent = sliderBg
newCorner(sliderKnob, 9)

-- ===== LOGIC: Update speed =====
local function applySpeed()
    speedLabel.Text = "Speed: " .. boostSpeed
    local h = humanoid()
    if h and speedOn then
        h.WalkSpeed = boostSpeed
    end
end

local function setSpeed(value, fromSlider)
    value = math.floor(tonumber(value) or boostSpeed)
    value = math.clamp(value, MIN_SPEED, MAX_SPEED)
    boostSpeed = value

    -- sinkron UI
    local pct = (boostSpeed - MIN_SPEED) / (MAX_SPEED - MIN_SPEED)
    sliderFill.Size = UDim2.new(pct, 0, 1, 0)
    sliderKnob.Position = UDim2.new(pct, 0, 0.5, 0)
    if not fromSlider then
        speedBox.Text = tostring(boostSpeed)
    end
    applySpeed()
end

-- TextBox: commit saat focus lost / Enter
speedBox.FocusLost:Connect(function(enterPressed)
    setSpeed(speedBox.Text, false)
    speedBox.Text = tostring(boostSpeed)  -- normalize
end)

-- Slider drag
local sliderDragging = false
local function setFromInput(input)
    local relX = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
    relX = math.clamp(relX, 0, 1)
    local value = MIN_SPEED + relX * (MAX_SPEED - MIN_SPEED)
    setSpeed(value, false)
end

sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        setFromInput(input)
    end
end)

UIS.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        setFromInput(input)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

-- init slider pos
setSpeed(boostSpeed, false)

-- ===== DRAG FRAME =====
local dragging, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

-- ===== HUMANOID =====
local function humanoid()
    local char = player.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- ===== BUTTONS =====
speedButton.Activated:Connect(function()
    speedOn = not speedOn
    speedButton.Text = speedOn and ("Speed Boost: ON ("..boostSpeed..")") or "Speed Boost: OFF"
    local h = humanoid()
    if h then
        h.WalkSpeed = speedOn and boostSpeed or normalSpeed
    end
end)

jumpButton.Activated:Connect(function()
    jumpOn = not jumpOn
    jumpButton.Text = jumpOn and "Infinity Jump: ON" or "Infinity Jump: OFF"
end)

UIS.JumpRequest:Connect(function()
    if jumpOn then
        local h = humanoid()
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    local h = char:WaitForChild("Humanoid")
    h.WalkSpeed = speedOn and boostSpeed or normalSpeed
end)
