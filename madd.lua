-- SPEED BOOST + INFINITY JUMP | Draggable + Speed 1-9999
-- Fixed version

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local speedOn, jumpOn = false, false
local normalSpeed = 16
local boostSpeed = 50
local MIN_SPEED, MAX_SPEED = 1, 9999

------------------------------------------------------------
-- HELPER (dideklarasikan paling atas)
------------------------------------------------------------
local function getHumanoid()
    local char = player.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function newCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = parent
    return c
end

------------------------------------------------------------
-- GUI
------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "PurpleMovementGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not ok or not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(240, 330)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 20, 65)
frame.Active = true
frame.BorderSizePixel = 0
frame.Parent = gui
newCorner(frame, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "PURPLE MOVEMENT"
title.TextColor3 = Color3.fromRGB(210, 160, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(115, 55, 185)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = true
    b.Text = text
    b.Parent = frame
    newCorner(b, 8)
    return b
end

local speedButton = createButton("Speed Boost: OFF", 40)
local jumpButton  = createButton("Infinity Jump: OFF", 90)

-- Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 22)
speedLabel.Position = UDim2.new(0.05, 0, 0, 140)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. boostSpeed
speedLabel.TextColor3 = Color3.fromRGB(210, 160, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = frame

-- TextBox
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.9, 0, 0, 32)
speedBox.Position = UDim2.new(0.05, 0, 0, 165)
speedBox.BackgroundColor3 = Color3.fromRGB(70, 35, 110)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.TextScaled = true
speedBox.Font = Enum.Font.Gotham
speedBox.Text = tostring(boostSpeed)
speedBox.PlaceholderText = "1 - 9999"
speedBox.ClearTextOnFocus = false
speedBox.Parent = frame
newCorner(speedBox, 8)

-- Slider
local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0.9, 0, 0, 10)
sliderBg.Position = UDim2.new(0.05, 0, 0, 212)
sliderBg.BackgroundColor3 = Color3.fromRGB(70, 35, 110)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = frame
newCorner(sliderBg, 5)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBg
newCorner(sliderFill, 5)

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.fromOffset(18, 18)
sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
sliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
sliderKnob.BackgroundColor3 = Color3.fromRGB(230, 190, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.ZIndex = 2
sliderKnob.Parent = sliderBg
newCorner(sliderKnob, 9)

------------------------------------------------------------
-- SPEED LOGIC
------------------------------------------------------------
local function applySpeed()
    speedLabel.Text = "Speed: " .. boostSpeed
    if speedOn then
        local h = getHumanoid()
        if h then h.WalkSpeed = boostSpeed end
        speedButton.Text = "Speed Boost: ON ("..boostSpeed..")"
    end
end

local function setSpeed(value)
    value = tonumber(value) or boostSpeed
    value = math.floor(value)
    value = math.clamp(value, MIN_SPEED, MAX_SPEED)
    boostSpeed = value

    local pct = (boostSpeed - MIN_SPEED) / (MAX_SPEED - MIN_SPEED)
    sliderFill.Size = UDim2.new(pct, 0, 1, 0)
    sliderKnob.Position = UDim2.new(pct, 0, 0.5, 0)
    speedBox.Text = tostring(boostSpeed)
    applySpeed()
end

speedBox.FocusLost:Connect(function()
    setSpeed(speedBox.Text)
end)

-- Slider drag (pakai flag terpisah)
local sliderDragging = false
local function sliderFromInput(input)
    local relX = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
    relX = math.clamp(relX, 0, 1)
    setSpeed(MIN_SPEED + relX * (MAX_SPEED - MIN_SPEED))
end

sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        sliderFromInput(input)
    end
end)

------------------------------------------------------------
-- DRAG FRAME (flag terpisah)
------------------------------------------------------------
local frameDragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        frameDragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

------------------------------------------------------------
-- SATU listener global untuk kedua drag
------------------------------------------------------------
UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        if sliderDragging then
            sliderFromInput(input)
        elseif frameDragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
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

------------------------------------------------------------
-- BUTTONS (pakai Activated + fallback)
------------------------------------------------------------
local function bindClick(button, callback)
    button.Activated:Connect(callback)
    button.MouseButton1Click:Connect(callback)
end

bindClick(speedButton, function()
    speedOn = not speedOn
    if speedOn then
        speedButton.Text = "Speed Boost: ON ("..boostSpeed..")"
        local h = getHumanoid()
        if h then h.WalkSpeed = boostSpeed end
    else
        speedButton.Text = "Speed Boost: OFF"
        local h = getHumanoid()
        if h then h.WalkSpeed = normalSpeed end
    end
end)

bindClick(jumpButton, function()
    jumpOn = not jumpOn
    jumpButton.Text = jumpOn and "Infinity Jump: ON" or "Infinity Jump: OFF"
end)

UIS.JumpRequest:Connect(function()
    if jumpOn then
        local h = getHumanoid()
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    local h = char:WaitForChild("Humanoid")
    h.WalkSpeed = speedOn and boostSpeed or normalSpeed
    if speedOn then
        speedButton.Text = "Speed Boost: ON ("..boostSpeed..")"
    end
end)

-- init
setSpeed(boostSpeed)
