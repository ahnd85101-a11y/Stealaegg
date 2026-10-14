-- ============================================
-- LOADER ANALYZER v8 - MIX EDITION
-- GUI v7 + Fitur Gameplay v6
-- Purple Neon | Draggable | Minimize | Reset
-- ============================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local MarketplaceService= game:GetService("MarketplaceService")
local TweenService      = game:GetService("TweenService")
local StarterGui        = game:GetService("StarterGui")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local char      = player.Character or player.CharacterAdded:Wait()

-- ============================================
-- THEME
-- ============================================
local Theme = {
    Purple   = Color3.fromRGB(170, 75, 255),
    Dark     = Color3.fromRGB(12, 10, 18),
    Panel    = Color3.fromRGB(22, 18, 32),
    Field    = Color3.fromRGB(32, 26, 48),
    White    = Color3.fromRGB(245, 240, 255),
    Muted    = Color3.fromRGB(165, 150, 185),
    Green    = Color3.fromRGB(80, 220, 130),
    Red      = Color3.fromRGB(255, 90, 90),
    Yellow   = Color3.fromRGB(255, 200, 80),
    Blue     = Color3.fromRGB(75, 145, 255),
}

-- ============================================
-- DATA PLACES (ringkas)
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
}

-- ============================================
-- DATA GAMES (ringkas - 20 entry utama)
-- ============================================
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
    [321320844]  = "23aw2a.luau",
    [405200953]  = "4ed92d.luau",
    [890792071]  = "929a2a2.luau",
    [339569612]  = "2edas23q.luau",
    [532212340]  = "22a5a2.luau",
    [3281836]    = "e2809a2.luau",
    [1045333476] = "e92adw2.luau",
    [715536036]  = "e2a224a.luau",
    [66185505]   = "2ee2aq92.luau",
    [783156756]  = "e92wa.luau",
}

-- ============================================
-- CONFIG GAMEPLAY
-- ============================================
local CONFIG = {
    basePosition = Vector3.new(0, 10, 0),
    autoSteal = false,
    instantSteal = false,
    antiRagdoll = false,
    speedBoost = false,
    speedValue = 100,
    loopDelay = 0.5,
}

-- ============================================
-- CLEANUP
-- ============================================
for _, name in ipairs({"LoaderAnalyzerV5", "LoaderAnalyzerV6", "LoaderAnalyzerV7", "LoaderAnalyzerV8"}) do
    local old = playerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

-- ============================================
-- HELPERS
-- ============================================
local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Purple
    s.Thickness = thickness or 1.5
    s.Transparency = 0.2
    s.Parent = obj
    return s
end

local function createLabel(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextColor3 = color or Theme.White
    l.TextSize = size or 14
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

local function createButton(parent, text, bg)
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = bg or Theme.Field
    b.Text = text
    b.TextColor3 = Theme.White
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = parent
    round(b, 6)
    stroke(b, Theme.Purple, 1)
    return b
end

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = 3
        })
    end)
end

local function copy(text)
    if setclipboard then
        setclipboard(tostring(text))
        notify("Copied", tostring(text))
    end
end

-- ============================================
-- GUI UTAMA
-- ============================================
local gui = Instance.new("ScreenGui")
gui.Name = "LoaderAnalyzerV8"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 420, 0, 620)
main.Position = UDim2.new(0.5, -210, 0.5, -310)
main.BackgroundColor3 = Theme.Dark
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui
round(main, 12)
stroke(main, Theme.Purple, 2)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Theme.Panel
titleBar.BorderSizePixel = 0
titleBar.Parent = main
round(titleBar, 12)

local title = createLabel(titleBar, "🔮 LOADER ANALYZER v8", 15, Theme.Purple, Enum.Font.GothamBold)
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 16, 0, 0)

-- Title Buttons
local btnMin = createButton(titleBar, "—", Theme.Field)
btnMin.Size = UDim2.new(0, 30, 0, 28)
btnMin.Position = UDim2.new(1, -74, 0, 7)

local btnClose = createButton(titleBar, "×", Color3.fromRGB(90, 35, 90))
btnClose.Size = UDim2.new(0, 30, 0, 28)
btnClose.Position = UDim2.new(1, -40, 0, 7)

-- Floating Logo
local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0, 56, 0, 56)
logo.Position = UDim2.new(0, 20, 0.5, 0)
logo.BackgroundColor3 = Theme.Dark
logo.BorderSizePixel = 0
logo.Text = "🔮"
logo.TextColor3 = Theme.Purple
logo.TextSize = 26
logo.Font = Enum.Font.GothamBold
logo.AutoButtonColor = false
logo.Visible = false
logo.Active = true
logo.Parent = gui
round(logo, 28)
stroke(logo, Theme.Purple, 2)

-- Body
local body = Instance.new("Frame")
body.Size = UDim2.new(1, 0, 1, -42)
body.Position = UDim2.new(0, 0, 0, 42)
body.BackgroundTransparency = 1
body.Parent = main

-- ============================================
-- TAB SYSTEM
-- ============================================
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -24, 0, 32)
tabBar.Position = UDim2.new(0, 12, 0, 8)
tabBar.BackgroundColor3 = Theme.Panel
tabBar.BorderSizePixel = 0
tabBar.Parent = body
round(tabBar, 6)

local btnAnalyzer = createButton(tabBar, "🔍 ANALYZER", Theme.Purple)
btnAnalyzer.Size = UDim2.new(0.5, -4, 1, -4)
btnAnalyzer.Position = UDim2.new(0, 2, 0, 2)

local btnGameplay = createButton(tabBar, "🎮 GAMEPLAY", Theme.Field)
btnGameplay.Size = UDim2.new(0.5, -4, 1, -4)
btnGameplay.Position = UDim2.new(0.5, 2, 0, 2)

-- ============================================
-- ANALYZER PAGE
-- ============================================
local analyzerPage = Instance.new("Frame")
analyzerPage.Size = UDim2.new(1, 0, 1, -48)
analyzerPage.Position = UDim2.new(0, 0, 0, 48)
analyzerPage.BackgroundTransparency = 1
analyzerPage.Parent = body

local resultScroll = Instance.new("ScrollingFrame")
resultScroll.Size = UDim2.new(1, -24, 0, 290)
resultScroll.Position = UDim2.new(0, 12, 0, 8)
resultScroll.BackgroundColor3 = Theme.Panel
resultScroll.BorderSizePixel = 0
resultScroll.ScrollBarThickness = 4
resultScroll.ScrollBarImageColor3 = Theme.Purple
resultScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
resultScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
resultScroll.Parent = analyzerPage
round(resultScroll, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = resultScroll

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 10)
pad.PaddingLeft = UDim.new(0, 10)
pad.PaddingRight = UDim.new(0, 10)
pad.PaddingBottom = UDim.new(0, 10)
pad.Parent = resultScroll

-- ============================================
-- ANALYZER FUNCTIONS
-- ============================================
local function clearResults()
    for _, child in ipairs(resultScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local function addResult(label, value, color, copyable)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = Theme.Field
    row.BorderSizePixel = 0
    row.Parent = resultScroll
    round(row, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.42, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Theme.Muted
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local val = Instance.new("TextButton")
    val.Size = UDim2.new(0.55, -10, 1, 0)
    val.Position = UDim2.new(0.42, 0, 0, 0)
    val.BackgroundTransparency = 1
    val.Text = tostring(value)
    val.TextColor3 = color or Theme.White
    val.Font = Enum.Font.GothamBold
    val.TextSize = 11
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.TextTruncate = Enum.TextTruncate.AtEnd
    val.AutoButtonColor = false
    val.Parent = row

    if copyable then
        val.MouseButton1Click:Connect(function() copy(value) end)
    end
end

-- Input
local placeInput = Instance.new("TextBox")
placeInput.Size = UDim2.new(1, -24, 0, 34)
placeInput.Position = UDim2.new(0, 12, 0, 306)
placeInput.BackgroundColor3 = Theme.Field
placeInput.BorderSizePixel = 0
placeInput.PlaceholderText = "PlaceId (contoh: 107778070777162)"
placeInput.PlaceholderColor3 = Theme.Muted
placeInput.Text = ""
placeInput.TextColor3 = Theme.White
placeInput.Font = Enum.Font.Gotham
placeInput.TextSize = 11
placeInput.ClearTextOnFocus = false
placeInput.Parent = analyzerPage
round(placeInput, 6)
stroke(placeInput, Theme.Purple, 1)

local creatorInput = Instance.new("TextBox")
creatorInput.Size = UDim2.new(1, -24, 0, 34)
creatorInput.Position = UDim2.new(0, 12, 0, 346)
creatorInput.BackgroundColor3 = Theme.Field
creatorInput.BorderSizePixel = 0
creatorInput.PlaceholderText = "CreatorId (opsional)"
creatorInput.PlaceholderColor3 = Theme.Muted
creatorInput.Text = ""
creatorInput.TextColor3 = Theme.White
creatorInput.Font = Enum.Font.Gotham
creatorInput.TextSize = 11
creatorInput.ClearTextOnFocus = false
creatorInput.Parent = analyzerPage
round(creatorInput, 6)
stroke(creatorInput, Theme.Purple, 1)

local analyzeBtn = createButton(analyzerPage, "⚡ ANALYZE", Theme.Purple)
analyzeBtn.Size = UDim2.new(0.48, -12, 0, 34)
analyzeBtn.Position = UDim2.new(0, 12, 0, 388)

local gameBtn = createButton(analyzerPage, "🎯 GAME INI", Theme.Blue)
gameBtn.Size = UDim2.new(0.48, -12, 0, 34)
gameBtn.Position = UDim2.new(0.52, 0, 0, 388)

local resetBtn = createButton(analyzerPage, "↻ RESET HASIL", Theme.Field)
resetBtn.Size = UDim2.new(1, -24, 0, 32)
resetBtn.Position = UDim2.new(0, 12, 0, 428)

-- ============================================
-- ANALYZE LOGIC
-- ============================================
local busy = false

local function analyze(placeId, creatorId)
    if busy then return end
    busy = true
    clearResults()
    local mapped = false

    if placeId then
        addResult("PlaceId", tostring(placeId), Theme.White, true)
        local file = places[placeId]
        if file then
            addResult("Local Mapping", file, Theme.Green, true)
            addResult("Status", "✅ DITEMUKAN", Theme.Green)
            mapped = true
        else
            addResult("Local Mapping", "❌ Tidak ditemukan", Theme.Red)
        end

        local ok, info = pcall(function()
            return MarketplaceService:GetProductInfo(placeId)
        end)
        if ok and info then
            addResult("Nama Game", info.Name or "Unknown", Theme.Yellow, true)
            if info.Creator then
                addResult("Creator ID", tostring(info.Creator.Id or "-"), Theme.White, true)
            end
        else
            addResult("Metadata", "❌ Tidak tersedia", Theme.Red)
        end
    else
        addResult("PlaceId", "❌ Kosong", Theme.Red)
    end

    if creatorId then
        addResult("Input CreatorId", tostring(creatorId), Theme.White, true)
        local file = games[creatorId]
        if file then
            addResult("Creator Mapping", file, Theme.Green, true)
            mapped = true
        else
            addResult("Creator Mapping", "❌ Tidak ada", Theme.Muted)
        end
    end

    if mapped then
        addResult("Kesimpulan", "🎯 ADA DI DAFTAR", Theme.Green)
    else
        addResult("Kesimpulan", "❌ TIDAK ADA", Theme.Red)
    end

    busy = false
end

analyzeBtn.MouseButton1Click:Connect(function()
    analyze(tonumber(placeInput.Text), tonumber(creatorInput.Text))
end)

gameBtn.MouseButton1Click:Connect(function()
    placeInput.Text = tostring(game.PlaceId)
    creatorInput.Text = tostring(game.CreatorId)
    analyze(game.PlaceId, game.CreatorId)
end)

resetBtn.MouseButton1Click:Connect(function()
    placeInput.Text = ""
    creatorInput.Text = ""
    clearResults()
    addResult("Status", "✅ Direset", Theme.Green)
end)

-- ============================================
-- GAMEPLAY PAGE
-- ============================================
local gameplayPage = Instance.new("Frame")
gameplayPage.Size = UDim2.new(1, 0, 1, -48)
gameplayPage.Position = UDim2.new(0, 0, 0, 48)
gameplayPage.BackgroundTransparency = 1
gameplayPage.Visible = false
gameplayPage.Parent = body

-- Set Base
local setBaseBtn = createButton(gameplayPage, "📍 SET BASE POSITION", Color3.fromRGB(255, 150, 0))
setBaseBtn.Size = UDim2.new(1, -24, 0, 36)
setBaseBtn.Position = UDim2.new(0, 12, 0, 10)

-- Info Label
local gpInfo = createLabel(gameplayPage, "Status: Siap", 11, Theme.Muted, Enum.Font.Gotham)
gpInfo.Size = UDim2.new(1, -24, 0, 18)
gpInfo.Position = UDim2.new(0, 12, 0, 52)

-- Auto Steal Toggle
local autoStealBtn = createButton(gameplayPage, "🎯 AUTO STEAL : OFF", Theme.Field)
autoStealBtn.Size = UDim2.new(1, -24, 0, 38)
autoStealBtn.Position = UDim2.new(0, 12, 0, 76)

-- Instant Steal Button
local instantBtn = createButton(gameplayPage, "⚡ INSTANT STEAL", Color3.fromRGB(190, 30, 45))
instantBtn.Size = UDim2.new(1, -24, 0, 40)
instantBtn.Position = UDim2.new(0, 12, 0, 120)

-- Anti Ragdoll
local ragdollBtn = createButton(gameplayPage, "🛡️ ANTI RAGDOLL : OFF", Theme.Field)
ragdollBtn.Size = UDim2.new(1, -24, 0, 38)
ragdollBtn.Position = UDim2.new(0, 12, 0, 166)

-- Speed Boost
local speedBtn = createButton(gameplayPage, "💨 SPEED BOOST : OFF", Theme.Field)
speedBtn.Size = UDim2.new(1, -24, 0, 38)
speedBtn.Position = UDim2.new(0, 12, 0, 210)

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
    return nearest, nearestDist
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

-- ============================================
-- GAMEPLAY EVENTS
-- ============================================
setBaseBtn.MouseButton1Click:Connect(function()
    local ch = player.Character
    if ch and ch:FindFirstChild("HumanoidRootPart") then
        CONFIG.basePosition = ch.HumanoidRootPart.Position
        setBaseBtn.Text = "📍 BASE TERSIMPAN!"
        gpInfo.Text = "Status: Base diset di " .. math.floor(CONFIG.basePosition.X) .. "," .. math.floor(CONFIG.basePosition.Z)
        gpInfo.TextColor3 = Theme.Green
        task.wait(1)
        setBaseBtn.Text = "📍 SET BASE POSITION"
    end
end)

autoStealBtn.MouseButton1Click:Connect(function()
    CONFIG.autoSteal = not CONFIG.autoSteal
    if CONFIG.autoSteal then
        autoStealBtn.BackgroundColor3 = Theme.Green
        autoStealBtn.Text = "🎯 AUTO STEAL : ON"
    else
        autoStealBtn.BackgroundColor3 = Theme.Field
        autoStealBtn.Text = "🎯 AUTO STEAL : OFF"
    end
end)

instantBtn.MouseButton1Click:Connect(function()
    gpInfo.Text = "Status: INSTANT STEAL..."
    gpInfo.TextColor3 = Theme.Yellow
    task.spawn(function()
        local ok = doSteal()
        if ok then
            gpInfo.Text = "Status: ✅ Berhasil!"
            gpInfo.TextColor3 = Theme.Green
        else
            gpInfo.Text = "Status: ❌ Gak ada telur!"
            gpInfo.TextColor3 = Theme.Red
        end
        task.wait(1.5)
        gpInfo.Text = "Status: Siap"
        gpInfo.TextColor3 = Theme.Muted
    end)
end)

ragdollBtn.MouseButton1Click:Connect(function()
    CONFIG.antiRagdoll = not CONFIG.antiRagdoll
    if CONFIG.antiRagdoll then
        ragdollBtn.BackgroundColor3 = Theme.Green
        ragdollBtn.Text = "🛡️ ANTI RAGDOLL : ON"
    else
        ragdollBtn.BackgroundColor3 = Theme.Field
        ragdollBtn.Text = "🛡️ ANTI RAGDOLL : OFF"
    end
end)

speedBtn.MouseButton1Click:Connect(function()
    CONFIG.speedBoost = not CONFIG.speedBoost
    if CONFIG.speedBoost then
        speedBtn.BackgroundColor3 = Theme.Green
        speedBtn.Text = "💨 SPEED BOOST : ON"
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = CONFIG.speedValue
        end
    else
        speedBtn.BackgroundColor3 = Theme.Field
        speedBtn.Text = "💨 SPEED BOOST : OFF"
        if char a
