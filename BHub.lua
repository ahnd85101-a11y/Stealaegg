-- NEXUS ADMIN - MOBILE (Fly pakai analog Roblox)
-- Fly: aktifkan lalu gerakkan analog, arah ikut kamera
-- Noclip + Infinite Jump + Walk Speed (1-9999)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local states = {
    Fly = false,
    Noclip = false,
    ["Infinite Jump"] = false,
    ["Walk Speed"] = false,
}
local walkSpeed = 50
local MIN_SPEED, MAX_SPEED = 1, 9999
local NORMAL_SPEED = 16

local function getChar() return player.Character end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ================== GUI ==================
local gui = Instance.new("ScreenGui")
gui.Name = "NexusAdmin"
gui.ResetOnSpawn = false
gui.DisplayOrder = 2147483647
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not ok or not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.fromOffset(50, 50)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(85, 35, 130)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Text = "☰"
toggleBtn.TextSize = 26
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Active = true
toggleBtn.ZIndex = 100
toggleBtn.Parent = gui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(280, 400)
main.Position = UDim2.new(0.5, -140, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(13, 10, 21)
main.BorderSizePixel = 0
main.Active = false
main.Visible = false
main.ZIndex = 50
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

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
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 10
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(40, 38)
close.Position = UDim2.new(1, -48, 0, 6)
close.Text = "✕"
close.TextSize = 22
close.Font = Enum.Font.GothamBold
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(85, 35, 130)
close.Active = true
close.ZIndex = 10
close.Parent = main
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

local holder = Instance.new("ScrollingFrame")
holder.Position = UDim2.fromOffset(12, 58)
holder.Size = UDim2.new(1, -24, 1, -70)
holder.BackgroundTransparency = 1
holder.BorderSizePixel = 0
holder.ScrollBarThickness = 4
holder.CanvasSize = UDim2.new(0, 0, 0, 0)
holder.AutomaticCanvasSize = Enum.AutomaticSize.Y
holder.ZIndex = 10
holder.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = holder

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        main.Visible = not main.Visible
    end
end)

close.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        main.Visible = false
    end
end)

-- ================== FLY (pakai analog Roblox) ==================
local flyBV, flyBG, flyConn

local function startFly()
    local root = getRoot()
    local hum = getHum()
    if not root or not hum then return end

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = root

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBG.P = 1000
    flyBG.D = 50
    flyBG.CFrame = root.CFrame
    flyBG.Parent = root

    -- Fly mengikuti arah analog + kamera
    flyConn = RunService.RenderStepped:Connect(function()
        if not states.Fly then return end
        local r = getRoot()
        local h = getHum()
        if not r or not h or not flyBV or not flyBG then return end

        -- MoveDirection = arah analog (sudah relatif kamera)
        local moveDir = h.MoveDirection
        if moveDir.Magnitude < 0.05 then
            flyBV.Velocity = Vector3.zero
        else
            flyBV.Velocity = moveDir * 60
        end
        flyBG.CFrame = workspace.CurrentCamera.CFrame
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
end

-- ================== NOCLIP ==================
RunService.Stepped:Connect(function()
    if not states.Noclip then return end
    local char = getChar()
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide then
            v.CanCollide = false
        end
    end
end)

-- ================== INFINITE JUMP ==================
UIS.JumpRequest:Connect(function()
    if not states["Infinite Jump"] then return end
    local h = getHum()
    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- ================== WALK SPEED ==================
RunService.Heartbeat:Connect(function()
    if not states["Walk Speed"] then return end
    local h = getHum()
    if h and h.WalkSpeed ~= walkSpeed then
        h.WalkSpeed = walkSpeed
    end
end)

-- ================== TOGGLE UI ==================
local function makeToggle(name)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 48)
    button.BackgroundColor3 = Color3.fromRGB(35, 24, 49)
    button.Text = name .. "   [OFF]"
    button.TextColor3 = Color3.fromRGB(235, 220, 255)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 15
    button.Active = true
    button.Selectable = true
    button.ZIndex = 10
    button.Parent = holder
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(104, 55, 150)
    outline.Thickness = 1
    outline.Parent = button

    local cd = false
    button.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if cd then return end
        cd = true
        task.delay(0.2, function() cd = false end)

        states[name] = not states[name]
        button.Text = name .. (states[name] and "   [ON]" or "   [OFF]")
        button.BackgroundColor3 = states[name]
            and Color3.fromRGB(91, 39, 145)
            or Color3.fromRGB(35, 24, 49)

        if name == "Fly" then
            if states.Fly then startFly() else stopFly() end
        elseif name == "Noclip" then
            if not states.Noclip then
                local char = getChar()
                if char then
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = true end
                    end
                end
            end
        elseif name == "Walk Speed" then
            local h = getHum()
            if h then
                h.WalkSpeed = states["Walk Speed"] and walkSpeed or NORMAL_SPEED
            end
        end
    end)
end

makeToggle("Fly")
makeToggle("Noclip")
makeToggle("Infinite Jump")
makeToggle("Walk Speed")

-- ================== SPEED SLIDER ==================
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 22)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. walkSpeed
speedLabel.TextColor3 = Color3.fromRGB(210, 170, 255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.ZIndex = 10
speedLabel.Parent = holder

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, 0, 0, 36)
speedBox.BackgroundColor3 = Color3.fromRGB(35, 24, 49)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 16
speedBox.Text = tostring(walkSpeed)
speedBox.PlaceholderText = "1 - 9999"
speedBox.ClearTextOnFocus = false
speedBox.ZIndex = 10
speedBox.Parent = holder
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(1, 0, 0, 14)
sliderBg.BackgroundColor3 = Color3.fromRGB(50, 35, 70)
sliderBg.BorderSizePixel = 0
sliderBg.ZIndex = 10
sliderBg.Parent = holder
Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 7)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
sliderFill.BorderSizePixel = 0
sliderFill.ZIndex = 11
sliderFill.Parent = sliderBg
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 7)

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.fromOffset(24, 24)
sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
sliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
sliderKnob.BackgroundColor3 = Color3.fromRGB(230, 190, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.ZIndex = 12
sliderKnob.Parent = sliderBg
Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(0, 12)

local function applySpeed()
    speedLabel.Text = "Speed: " .. walkSpeed
    local pct = (walkSpeed - MIN_SPEED) / (MAX_SPEED - MIN_SPEED)
    sliderFill.Size = UDim2.new(pct, 0, 1, 0)
    sliderKnob.Position = UDim2.new(pct, 0, 0.5, 0)
    speedBox.Text = tostring(walkSpeed)
    local h = getHum()
    if h and states["Walk Speed"] then
        h.WalkSpeed = walkSpeed
    end
end

local function setSpeed(v)
    v = math.floor(tonumber(v) or walkSpeed)
    walkSpeed = math.clamp(v, MIN_SPEED, MAX_SPEED)
    applySpeed()
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

-- ================== DRAG PANEL ==================
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        if sliderDragging then
            pcall(sliderFrom, input)
        elseif dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        sliderDragging = false
    end
end)

-- ================== RESPAWN ==================
player.CharacterAdded:Connect(function()
    stopFly()
    states.Fly = false
    task.wait(0.5)
    local h = getHum()
    if h then h.WalkSpeed = NORMAL_SPEED end
    applySpeed()
end)

applySpeed()
