-- ============================================
-- LOADER ANALYZER v8 FIXED
-- Analyzer + Gameplay | Purple Neon
-- ============================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local char = player.Character or player.CharacterAdded:Wait()

-- ============================================
-- THEME
-- ============================================
local PURPLE = Color3.fromRGB(170, 75, 255)
local DARK = Color3.fromRGB(12, 10, 18)
local PANEL = Color3.fromRGB(22, 18, 32)
local FIELD = Color3.fromRGB(32, 26, 48)
local WHITE = Color3.fromRGB(245, 240, 255)
local MUTED = Color3.fromRGB(165, 150, 185)
local GREEN = Color3.fromRGB(80, 220, 130)
local RED = Color3.fromRGB(255, 90, 90)
local YELLOW = Color3.fromRGB(255, 200, 80)
local BLUE = Color3.fromRGB(75, 145, 255)

-- ============================================
-- DATA (RINGKAS - 20 entry)
-- ============================================
local places = {
    [114811916164834] = "ns82l.luau",
    [115893159267276] = "e92a24.luau",
    [135675416428111] = "02ewqias.luau",
    [109475655864288] = "sk2kc8.luau",
    [122278212262864] = "s3kpk4.luau",
    [76943966208523]  = "zqgwfe.luau",
    [119121637510344] = "we2ei9wd.luau",
    [88047783411976]  = "67ih7v.luau",
    [107778070777162] = "stealegg.luau",
}

local games = {
    [9190691]    = "hhukss.lua",
    [896806231]  = "97d5gt.lua",
    [526108378]  = "w8y59w.luau",
    [187288153]  = "37fjt9.luau",
    [479094425]  = "ea8fxc.luau",
    [719390069]  = "zqgwfe.luau",
    [425964032]  = "k6i3u9.luau",
    [194835716]  = "92a24a.luau",
    [1003211851] = "2a82a2.luau",
    [759078673]  = "e29e2a.luau",
    [10563114921] = "stealegg.luau",
}

-- ============================================
-- CONFIG GAMEPLAY
-- ============================================
local CONFIG = {
    basePosition = Vector3.new(0, 10, 0),
    autoSteal = false,
    antiRagdoll = false,
    speedBoost = false,
    speedValue = 100,
}

-- ============================================
-- CLEANUP
-- ============================================
for _, name in ipairs({"LoaderAnalyzerV8", "LoaderAnalyzerV7", "LoaderAnalyzerV6", "LoaderAnalyzerV5"}) do
    local old = playerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

-- ============================================
-- HELPERS
-- ============================================
local function round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
end

local function stroke(obj, color, t)
    local s = Instance.new("UIStroke")
    s.Color = color or PURPLE
    s.Thickness = t or 1.5
    s.Transparency = 0.2
    s.Parent = obj
end

-- ============================================
-- GUI UTAMA
-- ============================================
local gui = Instance.new("ScreenGui")
gui.Name = "LoaderAnalyzerV8"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(400, 560)
main.Position = UDim2.new(0.5, -200, 0.5, -280)
main.BackgroundColor3 = DARK
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui
round(main, 12)
stroke(main, PURPLE, 2)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = PANEL
titleBar.BorderSizePixel = 0
titleBar.Parent = main
round(titleBar, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.fromOffset(16, 0)
title.BackgroundTransparency = 1
title.Text = "🔮 LOADER ANALYZER v8"
title.TextColor3 = PURPLE
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Minimize Button
local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.fromOffset(30, 28)
btnMin.Position = UDim2.new(1, -74, 0, 7)
btnMin.BackgroundColor3 = FIELD
btnMin.Text = "—"
btnMin.TextColor3 = WHITE
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 14
btnMin.AutoButtonColor = false
btnMin.Parent = titleBar
round(btnMin, 6)

-- Close Button
local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.fromOffset(30, 28)
btnClose.Position = UDim2.new(1, -40, 0, 7)
btnClose.BackgroundColor3 = Color3.fromRGB(90, 35, 90)
btnClose.Text = "×"
btnClose.TextColor3 = WHITE
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 18
btnClose.AutoButtonColor = false
btnClose.Parent = titleBar
round(btnClose, 6)

-- Logo
local logo = Instance.new("TextButton")
logo.Size = UDim2.fromOffset(56, 56)
logo.Position = UDim2.new(0, 20, 0.5, 0)
logo.BackgroundColor3 = DARK
logo.BorderSizePixel = 0
logo.Text = "🔮"
logo.TextColor3 = PURPLE
logo.TextSize = 26
logo.Font = Enum.Font.GothamBold
logo.AutoButtonColor = false
logo.Visible = false
logo.Parent = gui
round(logo, 28)
stroke(logo, PURPLE, 2)

-- ============================================
-- TAB BAR
-- ============================================
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -24, 0, 32)
tabBar.Position = UDim2.fromOffset(12, 50)
tabBar.BackgroundColor3 = PANEL
tabBar.BorderSizePixel = 0
tabBar.Parent = main
round(tabBar, 6)

local btnAnalyzer = Instance.new("TextButton")
btnAnalyzer.Size = UDim2.new(0.5, -4, 1, -4)
btnAnalyzer.Position = UDim2.fromOffset(2, 2)
btnAnalyzer.BackgroundColor3 = PURPLE
btnAnalyzer.Text = "🔍 ANALYZER"
btnAnalyzer.TextColor3 = WHITE
btnAnalyzer.Font = Enum.Font.GothamBold
btnAnalyzer.TextSize = 11
btnAnalyzer.AutoButtonColor = false
btnAnalyzer.Parent = tabBar
round(btnAnalyzer, 6)

local btnGameplay = Instance.new("TextButton")
btnGameplay.Size = UDim2.new(0.5, -4, 1, -4)
btnGameplay.Position = UDim2.new(0.5, 2, 0, 2)
btnGameplay.BackgroundColor3 = FIELD
btnGameplay.Text = "🎮 GAMEPLAY"
btnGameplay.TextColor3 = WHITE
btnGameplay.Font = Enum.Font.GothamBold
btnGameplay.TextSize = 11
btnGameplay.AutoButtonColor = false
btnGameplay.Parent = tabBar
round(btnGameplay, 6)

-- ============================================
-- PAGE: ANALYZER
-- ============================================
local analyzerPage = Instance.new("Frame")
analyzerPage.Size = UDim2.new(1, 0, 1, -90)
analyzerPage.Position = UDim2.fromOffset(0, 90)
analyzerPage.BackgroundTransparency = 1
analyzerPage.Parent = main

-- Result Scroll
local resultScroll = Instance.new("ScrollingFrame")
resultScroll.Size = UDim2.new(1, -24, 0, 270)
resultScroll.Position = UDim2.fromOffset(12, 0)
resultScroll.BackgroundColor3 = PANEL
resultScroll.BorderSizePixel = 0
resultScroll.ScrollBarThickness = 4
resultScroll.ScrollBarImageColor3 = PURPLE
resultScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
resultScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
resultScroll.Parent = analyzerPage
round(resultScroll, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = resultScroll

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 8)
pad.PaddingLeft = UDim.new(0, 8)
pad.PaddingRight = UDim.new(0, 8)
pad.PaddingBottom = UDim.new(0, 8)
pad.Parent = resultScroll

-- Result function
local function clearResults()
    for _, c in ipairs(resultScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
end

local function addResult(label, value, color)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundColor3 = FIELD
    row.BorderSizePixel = 0
    row.Parent = resultScroll
    round(row, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.42, 0, 1, 0)
    lbl.Position = UDim2.fromOffset(8, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = MUTED
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(0.55, -8, 1, 0)
    val.Position = UDim2.new(0.42, 0, 0, 0)
    val.BackgroundTransparency = 1
    val.Text = tostring(value)
    val.TextColor3 = color or WHITE
    val.Font = Enum.Font.GothamBold
    val.TextSize = 10
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.TextTruncate = Enum.TextTruncate.AtEnd
    val.Parent = row
end

-- Input PlaceId
local placeInput = Instance.new("TextBox")
placeInput.Size = UDim2.new(1, -24, 0, 32)
placeInput.Position = UDim2.fromOffset(12, 278)
placeInput.BackgroundColor3 = FIELD
placeInput.BorderSizePixel = 0
placeInput.PlaceholderText = "PlaceId (contoh: 107778070777162)"
placeInput.PlaceholderColor3 = MUTED
placeInput.Text = ""
placeInput.TextColor3 = WHITE
placeInput.Font = Enum.Font.Gotham
placeInput.TextSize = 11
placeInput.ClearTextOnFocus = false
placeInput.Parent = analyzerPage
round(placeInput, 6)
stroke(placeInput, PURPLE, 1)

-- Analyze Button
local analyzeBtn = Instance.new("TextButton")
analyzeBtn.Size = UDim2.new(0.48, -12, 0, 34)
analyzeBtn.Position = UDim2.fromOffset(12, 318)
analyzeBtn.BackgroundColor3 = PURPLE
analyzeBtn.Text = "⚡ ANALYZE"
analyzeBtn.TextColor3 = WHITE
analyzeBtn.Font = Enum.Font.GothamBold
analyzeBtn.TextSize = 12
analyzeBtn.AutoButtonColor = false
analyzeBtn.Parent = analyzerPage
round(analyzeBtn, 6)

-- Game Ini Button
local gameBtn = Instance.new("TextButton")
gameBtn.Size = UDim2.new(0.48, -12, 0, 34)
gameBtn.Position = UDim2.new(0.52, 0, 0, 318)
gameBtn.BackgroundColor3 = BLUE
gameBtn.Text = "🎯 GAME INI"
gameBtn.TextColor3 = WHITE
gameBtn.Font = Enum.Font.GothamBold
gameBtn.TextSize = 12
gameBtn.AutoButtonColor = false
gameBtn.Parent = analyzerPage
round(gameBtn, 6)

-- Reset Button
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(1, -24, 0, 30)
resetBtn.Position = UDim2.fromOffset(12, 358)
resetBtn.BackgroundColor3 = FIELD
resetBtn.Text = "↻ RESET"
resetBtn.TextColor3 = WHITE
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 11
resetBtn.AutoButtonColor = false
resetBtn.Parent = analyzerPage
round(resetBtn, 6)

-- Analyze logic
local function analyze(placeId, creatorId)
    clearResults()
    local mapped = false

    if placeId then
        addResult("PlaceId", tostring(placeId), WHITE)
        if places[placeId] then
            addResult("Mapping", places[placeId], GREEN)
            addResult("Status", "✅ DITEMUKAN", GREEN)
            mapped = true
        else
            addResult("Mapping", "❌ Tidak ada", RED)
        end

        local ok, info = pcall(function()
            return MarketplaceService:GetProductInfo(placeId)
        end)
        if ok and info then
            addResult("Nama Game", info.Name or "Unknown", YELLOW)
        end
    else
        addResult("PlaceId", "❌ Kosong", RED)
    end

    if creatorId and games[creatorId] then
        addResult("Creator", games[creatorId], GREEN)
        mapped = true
    end

    if mapped then
        addResult("Kesimpulan", "🎯 ADA DI DAFTAR", GREEN)
    else
        addResult("Kesimpulan", "❌ TIDAK ADA", RED)
    end
end

analyzeBtn.MouseButton1Click:Connect(function()
    analyze(tonumber(placeInput.Text), nil)
end)

gameBtn.MouseButton1Click:Connect(function()
    placeInput.Text = tostring(game.PlaceId)
    analyze(game.PlaceId, game.CreatorId)
end)

resetBtn.MouseButton1Click:Connect(function()
    placeInput.Text = ""
    clearResults()
    addResult("Status", "✅ Direset", GREEN)
end)

-- ============================================
-- PAGE: GAMEPLAY
-- ============================================
local gameplayPage = Instance.new("Frame")
gameplayPage.Size = UDim2.new(1, 0, 1, -90)
gameplayPage.Position = UDim2.fromOffset(0, 90)
gameplayPage.BackgroundTransparency = 1
gameplayPage.Visible = false
gameplayPage.Parent = main

-- Set Base
local setBaseBtn = Instance.new("TextButton")
setBaseBtn.Size = UDim2.new(1, -24, 0, 36)
setBaseBtn.Position = UDim2.fromOffset(12, 5)
setBaseBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
setBaseBtn.Text = "📍 SET BASE POSITION"
setBaseBtn.TextColor3 = WHITE
setBaseBtn.Font = Enum.Font.GothamBold
setBaseBtn.TextSize = 12
setBaseBtn.AutoButtonColor = false
setBaseBtn.Parent = gameplayPage
round(setBaseBtn, 6)

-- Info
local gpInfo = Instance.new("TextLabel")
gpInfo.Size = UDim2.new(1, -24, 0, 20)
gpInfo.Position = UDim2.fromOffset(12, 46)
gpInfo.BackgroundTransparency = 1
gpInfo.Text = "Status: Siap"
gpInfo.TextColor3 = MUTED
gpInfo.Font = Enum.Font.Gotham
gpInfo.TextSize = 10
gpInfo.TextXAlignment = Enum.TextXAlignment.Left
gpInfo.Parent = gameplayPage

-- Auto Steal
local autoStealBtn = Instance.new("TextButton")
autoStealBtn.Size = UDim2.new(1, -24, 0, 38)
autoStealBtn.Position = UDim2.fromOffset(12, 72)
autoStealBtn.BackgroundColor3 = FIELD
autoStealBtn.Text = "🎯 AUTO STEAL : OFF"
autoStealBtn.TextColor3 = WHITE
autoStealBtn.Font = Enum.Font.GothamBold
autoStealBtn.TextSize = 12
autoStealBtn.AutoButtonColor = false
autoStealBtn.Parent = gameplayPage
round(autoStealBtn, 6)

-- Instant Steal
local instantBtn = Instance.new("TextButton")
instantBtn.Size = UDim2.new(1, -24, 0, 40)
instantBtn.Position = UDim2.fromOffset(12, 116)
instantBtn.BackgroundColor3 = Color3.fromRGB(190, 30, 45)
instantBtn.Text = "⚡ INSTANT STEAL"
instantBtn.TextColor3 = WHITE
instantBtn.Font = Enum.Font.GothamBold
instantBtn.TextSize = 13
instantBtn.AutoButtonColor = false
instantBtn.Parent = gameplayPage
round(instantBtn, 6)

-- Anti Ragdoll
local ragdollBtn = Instance.new("TextButton")
ragdollBtn.Size = UDim2.new(1, -24, 0, 38)
ragdollBtn.Position = UDim2.fromOffset(12, 162)
ragdollBtn.BackgroundColor3 = FIELD
ragdollBtn.Text = "🛡️ ANTI RAGDOLL : OFF"
ragdollBtn.TextColor3 = WHITE
ragdollBtn.Font = Enum.Font.GothamBold
ragdollBtn.TextSize = 12
ragdollBtn.AutoButtonColor = false
ragdollBtn.Parent = gameplayPage
round(ragdollBtn, 6)

-- Speed Boost
local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(1, -24, 0, 38)
speedBtn.Position = UDim2.fromOffset(12, 206)
speedBtn.BackgroundColor3 = FIELD
speedBtn.Text = "💨 SPEED BOOST : OFF"
speedBtn.TextColor3 = WHITE
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextSize = 12
speedBtn.AutoButtonColor = false
speedBtn.Parent = gameplayPage
round(speedBtn, 6)

-- ============================================
-- GAMEPLAY FUNCTIONS
-- ============================================
local function findEgg()
    local ch = player.Character
    if not ch or not ch:FindFirstChild("HumanoidRootPart") then return nil end
    local nearest, nearestDist = nil, math.huge
    local myPos = ch.HumanoidRootPart.Position

    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if not (name:find("telur") or name:find("egg")) then continue end

            local skip = {"treadmill", "base", "spawn", "zone", "portal", "shop", "index", "pet", "inventory", "display", "decor", "sign", "ui"}
            local shouldSkip = false
            for _, w in ipairs(skip) do
                if name:find(w) then shouldSkip = true; break end
            end
            if shouldSkip then continue end

            local hasPrompt = false
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("ProximityPrompt") or child:IsA("ClickDetector") then
                    hasPrompt = true; break
                end
            end
            if not hasPrompt and obj.Parent then
                for _, child in pairs(obj.Parent:GetChildren()) do
                    if child:IsA("ProximityPrompt") or child:IsA("ClickDetector") then
                        hasPrompt = true; break
                    end
                end
            end
            if not hasPrompt then continue end

            local dist = (obj.Position - myPos).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = obj
            end
        end
    end
    return nearest
end

local function doSteal()
    local ch = player.Character
    if not ch or not ch:FindFirstChild("HumanoidRootPart") then return false end
    local hrp = ch.HumanoidRootPart
    local egg = findEgg()
    if not egg then return false end

    hrp.CFrame = CFrame.new(egg.Position)
    task.wait(0.05)
    pcall(function()
        if firetouchinterest then
            firetouchinterest(hrp, egg, 0)
            task.wait(0.03)
            firetouchinterest(hrp, egg, 1)
        end
    end)
    pcall(function()
        for _, c in pairs(egg:GetChildren()) do
            if c:IsA("ProximityPrompt") and fireproximityprompt then
                fireproximityprompt(c)
            end
        end
    end)
    task.wait(0.05)
    hrp.CFrame = CFrame.new(CONFIG.basePosition)
    return true
end

-- Events
setBaseBtn.MouseButton1Click:Connect(function()
    local ch = player.Character
    if ch and ch:FindFirstChild("HumanoidRootPart") then
        CONFIG.basePosition = ch.HumanoidRootPart.Position
        setBaseBtn.Text = "📍 TERSIMPAN!"
        gpInfo.Text = "Base: " .. math.floor(CONFIG.basePosition.X) .. "," .. math.floor(CONFIG.basePosition.Z)
        gpInfo.TextColor3 = GREEN
        task.wait(1)
        setBaseBtn.Text = "📍 SET BASE POSITION"
    end
end)

autoStealBtn.MouseButton1Click:Connect(function()
    CONFIG.autoSteal = not CONFIG.autoSteal
    autoStealBtn.Text = CONFIG.autoSteal and "🎯 AUTO STEAL : ON" or "🎯 AUTO STEAL : OFF"
    autoStealBtn.BackgroundColor3 = CONFIG.autoSteal and GREEN or FIELD
end)

instantBtn.MouseButton1Click:Connect(function()
    gpInfo.Text = "Status: INSTANT STEAL..."
    gpInfo.TextColor3 = YELLOW
    task.spawn(function()
        local ok = doSteal()
        gpInfo.Text = ok and "Status: ✅ Berhasil!" or "Status: ❌ Gak ada telur!"
        gpInfo.TextColor3 = ok and GREEN or RED
        task.wait(1.5)
        gpInfo.Text = "Status: Siap"
        gpInfo.TextColor3 = MUTED
    end)
end)

ragdollBtn.MouseButton1Click:Connect(function()
    CONFIG.antiRagdoll = not CONFIG.antiRagdoll
    ragdollBtn.Text = CONFIG.antiRagdoll and "🛡️ ANTI RAGDOLL : ON" or "🛡️ ANTI RAGDOLL : OFF"
    ragdollBtn.BackgroundColor3 = CONFIG.antiRagdoll and GREEN or FIELD
end)

speedBtn.MouseButton1Click:Connect(function()
    CONFIG.speedBoost = not CONFIG.speedBoost
    speedBtn.Text = CONFIG.speedBoost and "💨 SPEED BOOST : ON" or "💨 SPEED BOOST : OFF"
    speedBtn.BackgroundColor3 = CONFIG.speedBoost and GREEN or FIELD
    local ch = player.Character
    if ch and ch:FindFirstChild("Humanoid") then
        ch.Humanoid.WalkSpeed = CONFIG.speedBoost and CONFIG.speedValue or 16
    end
end)

-- Loops
task.spawn(function()
    while task.wait(0.5) do
        if CONFIG.autoSteal then pcall(doSteal) end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if CONFIG.antiRagdoll then
            local ch = player.Character
            if ch and ch:FindFirstChild("Humanoid") then
                ch.Humanoid.PlatformStand = false
                ch.Humanoid.Sit = false
            end
        end
    end
end)

-- ============================================
-- TAB SWITCHING
-- ============================================
btnAnalyzer.MouseButton1Click:Connect(function()
    analyzerPage.Visible = true
    gameplayPage.Visible = false
    btnAnalyzer.BackgroundColor3 = PURPLE
    btnGameplay.BackgroundColor3 = FIELD
end)

btnGameplay.MouseButton1Click:Connect(function()
    analyzerPage.Visible = false
    gameplayPage.Visible = true
    btnAnalyzer.BackgroundColor3 = FIELD
    btnGameplay.BackgroundColor3 = PURPLE
end)

-- ============================================
-- MINIMIZE / RESTORE
-- ============================================
local minimized = false

local function showLogo()
    if minimized then return end
    minimized = true
    main.Visible = false
    logo.Visible = true
end

local function showMenu()
    minimized = false
    logo.Visible = false
    main.Visible = true
end

btnMin.MouseButton1Click:Connect(showLogo)
btnClose.MouseButton1Click:Connect(showLogo)
logo.MouseButton1Click:Connect(showMenu)

-- ============================================
-- DRAG (FIXED)
-- ============================================
local dragging = false
local dragStart = nil
local startPos = nil

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = main.Position
end

local function updateDrag(input)
    if not dragging then return end
    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

local function stopDrag()
    dragging = false
end

-- Header drag
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        stopDrag()
    end
end)

-- Logo drag
local logoDragging = false
local logoDragStart = nil
local logoStartPos = nil

logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        logoDragging = true
        logoDragStart = input.Position
        logoStartPos = logo.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if logoDragging then
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - logoDragStart
            logo.Position = UDim2.new(
                logoStartPos.X.Scale,
                logoStartPos.X.Offset + delta.X,
                logoStartPos.Y.Scale,
                logoStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        logoDragging = false
    end
end)
-- ============================================
-- INITIAL
-- ============================================
addResult("Versi", "v8 Fixed", PURPLE)
addResult("Mode", "Analyzer + Gameplay", GREEN)
addResult("PlaceId", tostring(game.PlaceId), WHITE)
addResult("CreatorId", tostring(game.CreatorId), WHITE)
addResult("Status", "Siap digunakan", MUTED)

print("[LOADER ANALYZER v8] Loaded OK!")
