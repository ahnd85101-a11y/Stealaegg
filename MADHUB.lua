-- ============================================
-- TITLE BAR BUTTONS
-- ============================================
local btnMin = createButton(titleBar, "—", Theme.Field)
btnMin.Size = UDim2.new(0, 30, 0, 28)
btnMin.Position = UDim2.new(1, -74, 0, 7)

local btnClose = createButton(titleBar, "×", Color3.fromRGB(90, 35, 90))
btnClose.Size = UDim2.new(0, 30, 0, 28)
btnClose.Position = UDim2.new(1, -40, 0, 7)

-- ============================================
-- FLOATING LOGO
-- ============================================
local logo = Instance.new("TextButton")
logo.Name = "FloatingLogo"
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

-- ============================================
-- BODY
-- ============================================
local body = Instance.new("Frame")
body.Name = "Body"
body.Size = UDim2.new(1, 0, 1, -42)
body.Position = UDim2.new(0, 0, 0, 42)
body.BackgroundTransparency = 1
body.Parent = main

-- ============================================
-- RESULT SCROLL
-- ============================================
local resultScroll = Instance.new("ScrollingFrame")
resultScroll.Name = "ResultScroll"
resultScroll.Size = UDim2.new(1, -24, 0, 300)
resultScroll.Position = UDim2.new(0, 12, 0, 12)
resultScroll.BackgroundColor3 = Theme.Panel
resultScroll.BorderSizePixel = 0
resultScroll.ScrollBarThickness = 4
resultScroll.ScrollBarImageColor3 = Theme.Purple
resultScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
resultScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
resultScroll.Parent = body
round(resultScroll, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = resultScroll

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 10)
pad.PaddingLeft = UDim.new(0, 10)
pad.PaddingRight = UDim.new(0, 10)
pad.PaddingBottom = UDim.new(0, 10)
pad.Parent = resultScroll

-- ============================================
-- RESULT FUNCTIONS
-- ============================================
local function clearResults()
    for _, child in ipairs(resultScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

local function addResult(label, value, color, copyable)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
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
        val.MouseButton1Click:Connect(function()
            copy(value)
        end)
    end

    return row
end

-- ============================================
-- INFO LABEL
-- ============================================
local infoLabel = createLabel(body, "Masukkan PlaceId / CreatorId, atau tekan GAME INI.", 11, Theme.Muted, Enum.Font.Gotham)
infoLabel.Size = UDim2.new(1, -24, 0, 18)
infoLabel.Position = UDim2.new(0, 12, 0, 320)

-- ============================================
-- PLACE ID INPUT
-- ============================================
local placeInput = Instance.new("TextBox")
placeInput.Size = UDim2.new(1, -24, 0, 36)
placeInput.Position = UDim2.new(0, 12, 0, 340)
placeInput.BackgroundColor3 = Theme.Field
placeInput.BorderSizePixel = 0
placeInput.PlaceholderText = "PlaceId (contoh: 107778070777162)"
placeInput.PlaceholderColor3 = Theme.Muted
placeInput.Text = ""
placeInput.TextColor3 = Theme.White
placeInput.Font = Enum.Font.Gotham
placeInput.TextSize = 12
placeInput.ClearTextOnFocus = false
placeInput.Parent = body
round(placeInput, 6)
stroke(placeInput, Theme.Purple, 1)

-- ============================================
-- CREATOR ID INPUT
-- ============================================
local creatorInput = Instance.new("TextBox")
creatorInput.Size = UDim2.new(1, -24, 0, 36)
creatorInput.Position = UDim2.new(0, 12, 0, 384)
creatorInput.BackgroundColor3 = Theme.Field
creatorInput.BorderSizePixel = 0
creatorInput.PlaceholderText = "CreatorId (opsional)"
creatorInput.PlaceholderColor3 = Theme.Muted
creatorInput.Text = ""
creatorInput.TextColor3 = Theme.White
creatorInput.Font = Enum.Font.Gotham
creatorInput.TextSize = 12
creatorInput.ClearTextOnFocus = false
creatorInput.Parent = body
round(creatorInput, 6)
stroke(creatorInput, Theme.Purple, 1)

-- ============================================
-- BUTTONS
-- ============================================
local analyzeBtn = createButton(body, "⚡ ANALYZE", Theme.Purple)
analyzeBtn.Size = UDim2.new(0.48, -12, 0, 38)
analyzeBtn.Position = UDim2.new(0, 12, 0, 428)

local gameBtn = createButton(body, "🎯 GAME INI", Theme.Blue)
gameBtn.Size = UDim2.new(0.48, -12, 0, 38)
gameBtn.Position = UDim2.new(0.52, 0, 0, 428)

local resetBtn = createButton(body, "↻ RESET HASIL", Theme.Field)
resetBtn.Size = UDim2.new(1, -24, 0, 34)
resetBtn.Position = UDim2.new(0, 12, 0, 472)

-- ============================================
-- ANALYZE FUNCTION
-- ============================================
local busy = false

local function analyze(placeId, creatorId)
    if busy then return end
    busy = true

    clearResults()

    local mapped = false

    -- PlaceId check
    if placeId then
        addResult("PlaceId", tostring(placeId), Theme.White, true)

        local file = places[placeId]
        if file then
            addResult("Local Mapping", file, Theme.Green, true)
            addResult("Mapping Status", "✅ ADA DI DAFTAR", Theme.Green)
            mapped = true
        else
            addResult("Local Mapping", "❌ Tidak ditemukan", Theme.Red)
        end

        -- Metadata dari Marketplace
        local ok, info = pcall(function()
            return MarketplaceService:GetProductInfo(placeId)
        end)

        if ok and info then
            addResult("Nama Game", info.Name or "Tidak diketahui", Theme.Yellow, true)
            if info.Creator then
                addResult("Creator ID", tostring(info.Creator.Id or "-"), Theme.White, true)
                addResult("Creator Type", tostring(info.Creator.CreatorType or "-"), Theme.Muted)
            end
        else
            addResult("Metadata", "❌ Tidak tersedia", Theme.Red)
        end
    else
        addResult("PlaceId", "❌ Kosong", Theme.Red)
    end

    -- CreatorId check
    if creatorId then
        addResult("Input CreatorId", tostring(creatorId), Theme.White, true)

        local file = games[creatorId]
        if file then
            addResult("Creator Mapping", file, Theme.Green, true)
            addResult("Mapping Status", "✅ ADA DI DAFTAR", Theme.Green)
            mapped = true
        else
            addResult("Creator Mapping", "❌ Tidak ada", Theme.Muted)
        end
    end

    -- Kesimpulan
    if mapped then
        addResult("Kesimpulan", "🎯 Ada di daftar loader", Theme.Green)
        addResult("Catatan", "Bukan bukti script aman/aktif", Theme.Yellow)
    else
        addResult("Kesimpulan", "❌ Tidak ada di daftar", Theme.Red)
    end

    busy = false
end

-- ============================================
-- BUTTON EVENTS
-- ============================================
analyzeBtn.MouseButton1Click:Connect(function()
    local text = placeInput.Text
    local id = tonumber(text)
    local cid = tonumber(creatorInput.Text)

    if text ~= "" and (not id or id <= 0 or id % 1 ~= 0) then
        clearResults()
        addResult("Input", "❌ ID harus bilangan bulat positif", Theme.Red)
        return
    end

    analyze(id, cid)
end)

gameBtn.MouseButton1Click:Connect(function()
    placeInput.Text = tostring(game.PlaceId)
    creatorInput.Text = tostring(game.CreatorId)
    analyze(game.PlaceId, game.CreatorId)
end)

resetBtn.MouseButton1Click:Connect(function()
    if busy then return end
    placeInput.Text = ""
    creatorInput.Text = ""
    clearResults()
    addResult("Status", "✅ Hasil direset", Theme.Green)
end)

-- ============================================
-- MINIMIZE / RESTORE
-- ============================================
local minimized = false

local function showLogo()
    if minimized then return end
    minimized = true

    TweenService:Create(main, TweenInfo.new(0.15), {
        BackgroundTransparency = 1
    }):Play()

    task.delay(0.16, function()
        if minimized then
            main.Visible = false
            main.BackgroundTransparency = 0
            logo.Visible = true
        end
    end)
end

local function showMenu()
    minimized = false
    logo.Visible = false
    main.Visible = true
    main.BackgroundTransparency = 1

    TweenService:Create(main, TweenInfo.new(0.18), {
        BackgroundTransparency = 0
    }):Play()
end

btnMin.MouseButton1Click:Connect(showLogo)
btnClose.MouseButton1Click:Connect(showLogo)
logo.MouseButton1Click:Connect(showMenu)

-- ============================================
-- DRAG SYSTEM
-- ============================================
local function makeDraggable(handle, target)
    local activeInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            activeInput = input
            dragStart = input.Position
            startPos = target.Position
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            if input == activeInput then
                local delta = input.Position - dragStart
                target.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == activeInput then
            activeInput = nil
        end
    end)
end

makeDraggable(titleBar, main)
makeDraggable(logo, logo)

-- ============================================
-- INITIAL STATUS
-- ============================================
addResult("Versi", "Loader Analyzer v7", Theme.Purple)
addResult("Mode", "Safe Metadata", Theme.Green)
addResult("PlaceId Saat Ini", tostring(game.PlaceId), Theme.White, true)
addResult("CreatorId Saat Ini", tostring(game.CreatorId), Theme.White, true)
addResult("Petunjuk", "Tap nilai untuk copy", Theme.Muted)

print("[LOADER ANALYZER v7] Loaded!")
