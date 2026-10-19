-- SPEED BOOST + INFINITY JUMP
-- Delta Executor | Client-side Lua

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local speedOn = false
local jumpOn = false
local normalSpeed = 16
local boostSpeed = 40

local gui = Instance.new("ScreenGui")
gui.Name = "PurpleMovementGUI"
gui.ResetOnSpawn = false

pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)

if not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(230, 175)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 20, 65)
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "PURPLE MOVEMENT"
title.TextColor3 = Color3.fromRGB(210, 160, 255)
title.TextScaled = true
title.Parent = frame

local function createButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 45)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(115, 55, 185)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Text = text
    b.Parent = frame

    Instance.new("UICorner", b).CornerRadius =
        UDim.new(0, 8)

    return b
end

local speedButton = createButton("Speed Boost: OFF", 45)
local jumpButton = createButton("Infinity Jump: OFF", 100)

local function humanoid()
    local char = player.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

speedButton.Activated:Connect(function()
    speedOn = not speedOn
    speedButton.Text = speedOn
        and "Speed Boost: ON"
        or "Speed Boost: OFF"

    local h = humanoid()
    if h then
        h.WalkSpeed = speedOn and boostSpeed or normalSpeed
    end
end)

jumpButton.Activated:Connect(function()
    jumpOn = not jumpOn
    jumpButton.Text = jumpOn
        and "Infinity Jump: ON"
        or "Infinity Jump: OFF"
end)

UIS.JumpRequest:Connect(function()
    if jumpOn then
        local h = humanoid()
        if h then
            h:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    local h = char:WaitForChild("Humanoid")
    h.WalkSpeed = speedOn and boostSpeed or normalSpeed
end)
