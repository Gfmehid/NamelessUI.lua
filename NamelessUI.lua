-- ============================================================
-- NAMELESS UI LIBRARY V2 (PREMIUM & ANIMATED)
-- COMPLETE SOURCE CODE
-- ============================================================
local NamelessUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Paleta de Cores Premium (Dark/Purple)
local T_BG = Color3.fromRGB(11, 8, 16)         
local T_CARD = Color3.fromRGB(18, 14, 26)      
local T_ACCENT = Color3.fromRGB(140, 70, 255)  
local T_ACCENT_HOVER = Color3.fromRGB(170, 100, 255)
local C_TEXT = Color3.fromRGB(245, 240, 255)
local C_MUTED = Color3.fromRGB(125, 115, 140)

-- Funções Utilitárias Internas
local function ApplyCorner(parent, radius)
    local corner = Instance.new("UICorner", parent)
    corner.CornerRadius = UDim.new(0, radius)
    return corner
end

local function ApplyStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke", parent)
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    return stroke
end

local function Animate(obj, prop, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), prop):Play()
end

-- ==========================================
-- CRIAR JANELA PRINCIPAL
-- ==========================================
function NamelessUI:CreateWindow(titleText, subtitleText)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Nameless_Hub"
    ScreenGui.ResetOnSpawn = false
    
    -- Se já existe um, deleta para evitar duplicatas na tela
    local oldGui = Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Nameless_Hub")
    if oldGui then oldGui:Destroy() end
    ScreenGui.Parent = Players.LocalPlayer.PlayerGui

    -- Frame Principal
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 550, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
    MainFrame.BackgroundColor3 = T_BG
    MainFrame.ClipsDescendants = true
    ApplyCorner(MainFrame, 8)
    ApplyStroke(MainFrame, T_ACCENT, 1.5, 0.2)

    -- Barra de Título
    local TitleBar = Instance.new("Frame", MainFrame)
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = T_BG
    TitleBar.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", TitleBar)
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = titleText or "Nameless UI"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 14
    Title.TextColor3 = C_TEXT
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local SubTitle = Instance.new("TextLabel", TitleBar)
    SubTitle.Size = UDim2.new(1, -20, 1, 0)
    SubTitle.Position = UDim2.new(0, Title.TextBounds.X + 25, 0, 0)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = subtitleText or "Premium Edition"
    SubTitle.Font = Enum.Font.GothamSemibold
    SubTitle.TextSize = 11
    SubTitle.TextColor3 = T_ACCENT
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left

    local DivLine = Instance.new("Frame", MainFrame)
    DivLine.Size = UDim2.new(1, 0, 0, 1)
    DivLine.Position = UDim2.new(0, 0, 0, 45)
    DivLine.BackgroundColor3 = T_ACCENT
    DivLine.BorderSizePixel = 0
    DivLine.Transparency = 0.5

    -- Container de Abas (Lado Esquerdo)
    local TabContainer = Instance.new("ScrollingFrame", MainFrame)
    TabContainer.Size = UDim2.new(0, 140, 1, -55)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0

    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 6)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Container de Conteúdo (Lado Direito)
    local ContentContainer = Instance.new("Frame", MainFrame)
    ContentContainer.Size = UDim2.new(1, -165, 1, -55)
    ContentContainer.Position = UDim2.new(0, 155, 0, 50)
    ContentContainer.BackgroundColor3 = T_CARD
    ApplyCorner(ContentContainer, 6)
    ApplyStroke(ContentContainer, T_ACCENT, 1, 0.8)

    -- Sistema de Arrastar Janela (Smooth Drag)
    local dragging, dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Window = {CurrentTab = nil}
    local isFirstTab = true

    -- ==========================================
    -- ADICIONAR ABA (TAB)
    -- ==========================================
    function Window:AddTab(tabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = T_CARD
        TabBtn.Text = tabName
        TabBtn.TextColor3 = C_MUTED
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12
        ApplyCorner(TabBtn, 4)
        local TabStroke = ApplyStroke(TabBtn, T_ACCENT, 1, 1)

        local Page = Instance.new("ScrollingFrame", ContentContainer)
        Page.Size = UDim2.new(1, -16, 1, -16)
        Page.Position = UDim2.new(0, 8, 0, 8)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = T_ACCENT
        Page.Visible = false
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 8)
        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 10)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, child in ipairs(ContentContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in ipairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then 
                    Animate(child, {BackgroundColor3 = T_CARD})
                    Animate(child, {TextColor3 = C_MUTED})
                end
            end
            Page.Visible = true
            Animate(TabBtn, {BackgroundColor3 = T_ACCENT})
            Animate(TabBtn, {TextColor3 = C_TEXT})
        end)

        if isFirstTab then
            Page.Visible = true
            TabBtn.BackgroundColor3 = T_ACCENT
            TabBtn.TextColor3 = C_TEXT
            isFirstTab = false
        end

        local Elements = {}

        -- ==========================================
        -- COMPONENTES DA UI
        -- ==========================================
        
        function Elements:AddLabel(text)
            local Lbl = Instance.new("TextLabel", Page)
            Lbl.Size = UDim2.new(1, 0, 0, 20)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = T_ACCENT
            Lbl.Font = Enum.Font.GothamBlack
            Lbl.TextSize = 11
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Elements:AddButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, 0, 0, 34)
            Btn.BackgroundColor3 = T_BG
            Btn.Text = text
            Btn.TextColor3 = C_TEXT
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 12
            ApplyCorner(Btn, 6)
            ApplyStroke(Btn, T_ACCENT, 1, 0.5)

            Btn.MouseEnter:Connect(function() Animate(Btn, {BackgroundColor3 = T_ACCENT_HOVER}) end)
            Btn.MouseLeave:Connect(function() Animate(Btn, {BackgroundColor3 = T_BG}) end)
            Btn.MouseButton1Click:Connect(function()
                Animate(Btn, {Size = UDim2.new(0.95, 0, 0, 30)}, 0.1)
                task.wait(0.1)
                Animate(Btn, {Size = UDim2.new(1, 0, 0, 34)}, 0.1)
                pcall(callback)
            end)
        end

        function Elements:AddToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame", Page)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 34)
            ToggleFrame.BackgroundColor3 = T_BG
            ApplyCorner(ToggleFrame, 6)
            ApplyStroke(ToggleFrame, T_ACCENT, 1, 0.8)

            local Lbl = Instance.new("TextLabel", ToggleFrame)
            Lbl.Size = UDim2.new(1, -50, 1, 0)
            Lbl.Position = UDim2.new(0, 10, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = C_TEXT
            Lbl.Font = Enum.Font.GothamSemibold
            Lbl.TextSize = 12
            Lbl.TextXAlignment = Enum.TextXAlignment.Left

            local Btn = Instance.new("TextButton", ToggleFrame)
            Btn.Size = UDim2.new(0, 36, 0, 18)
            Btn.Position = UDim2.new(1, -46, 0.5, -9)
            Btn.BackgroundColor3 = default and T_ACCENT or Color3.fromRGB(40, 30, 50)
            Btn.Text = ""
            ApplyCorner(Btn, 9)

            local Dot = Instance.new("Frame", Btn)
            Dot.Size = UDim2.new(0, 14, 0, 14)
            Dot.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            Dot.BackgroundColor3 = Color3.new(1,1,1)
            ApplyCorner(Dot, 7)

            local state = default
            Btn.MouseButton1Click:Connect(function()
                state = not state
                Animate(Btn, {BackgroundColor3 = state and T_ACCENT or Color3.fromRGB(40, 30, 50)})
                Animate(Dot, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
                pcall(callback, state)
            end)
        end

        function Elements:AddSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame", Page)
            SliderFrame.Size = UDim2.new(1, 0, 0, 45)
            SliderFrame.BackgroundColor3 = T_BG
            ApplyCorner(SliderFrame, 6)
            ApplyStroke(SliderFrame, T_ACCENT, 1, 0.8)

            local Lbl = Instance.new("TextLabel", SliderFrame)
            Lbl.Size = UDim2.new(1, -10, 0, 20)
            Lbl.Position = UDim2.new(0, 10, 0, 5)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text .. " : " .. tostring(default)
            Lbl.TextColor3 = C_TEXT
            Lbl.Font = Enum.Font.GothamSemibold
            Lbl.TextSize = 11
            Lbl.TextXAlignment = Enum.TextXAlignment.Left

            local Track = Instance.new("Frame", SliderFrame)
            Track.Size = UDim2.new(1, -20, 0, 6)
            Track.Position = UDim2.new(0, 10, 0, 28)
            Track.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
            ApplyCorner(Track, 3)

            local Fill = Instance.new("Frame", Track)
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = T_ACCENT
            ApplyCorner(Fill, 3)

            local Btn = Instance.new("TextButton", Track)
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = ""

            local dragging = false
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + ((max - min) * pos))
                Animate(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                Lbl.Text = text .. " : " .. tostring(val)
                pcall(callback, val)
            end

            Btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true; updateSlider(input)
                end
            end)
            Btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
            end)
        end

        function Elements:AddTextbox(text, placeholder, callback)
            local BoxFrame = Instance.new("Frame", Page)
            BoxFrame.Size = UDim2.new(1, 0, 0, 34)
            BoxFrame.BackgroundColor3 = T_BG
            ApplyCorner(BoxFrame, 6)
            ApplyStroke(BoxFrame, T_ACCENT, 1, 0.8)

            local Lbl = Instance.new("TextLabel", BoxFrame)
            Lbl.Size = UDim2.new(0.5, 0, 1, 0)
            Lbl.Position = UDim2.new(0, 10, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = C_TEXT
            Lbl.Font = Enum.Font.GothamSemibold
            Lbl.TextSize = 12
            Lbl.TextXAlignment = Enum.TextXAlignment.Left

            local InputBox = Instance.new("TextBox", BoxFrame)
            InputBox.Size = UDim2.new(0.45, 0, 0, 24)
            InputBox.Position = UDim2.new(0.5, 0, 0.5, -12)
            InputBox.BackgroundColor3 = T_CARD
            InputBox.Text = ""
            InputBox.PlaceholderText = placeholder or "Enter text..."
            InputBox.TextColor3 = T_ACCENT_HOVER
            InputBox.Font = Enum.Font.GothamBold
            InputBox.TextSize = 11
            ApplyCorner(InputBox, 4)
            ApplyStroke(InputBox, T_ACCENT, 1, 0.6)

            InputBox.FocusLost:Connect(function()
                pcall(callback, InputBox.Text)
            end)
        end

        -- ==========================================
        -- DROPDOWN SIMPLES (Seleção Única)
        -- ==========================================
        function Elements:AddDropdown(text, options, callback)
            local DropFrame = Instance.new("Frame", Page)
            DropFrame.Size = UDim2.new(1, 0, 0, 34)
            DropFrame.BackgroundColor3 = T_BG
            DropFrame.ClipsDescendants = true
            ApplyCorner(DropFrame, 6)
            ApplyStroke(DropFrame, T_ACCENT, 1, 0.8)

            local MainBtn = Instance.new("TextButton", DropFrame)
            MainBtn.Size = UDim2.new(1, 0, 0, 34)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = "  " .. text .. " : Select ▼"
            MainBtn.TextColor3 = C_TEXT
            MainBtn.Font = Enum.Font.GothamSemibold
            MainBtn.TextSize = 12
            MainBtn.TextXAlignment = Enum.TextXAlignment.Left

            local DropContainer = Instance.new("ScrollingFrame", DropFrame)
            DropContainer.Size = UDim2.new(1, -20, 1, -40)
            DropContainer.Position = UDim2.new(0, 10, 0, 35)
            DropContainer.BackgroundTransparency = 1
            DropContainer.ScrollBarThickness = 2
            DropContainer.ScrollBarImageColor3 = T_ACCENT
            
            local DropList = Instance.new("UIListLayout", DropContainer)
            DropList.Padding = UDim.new(0, 4)

            local isOpen = false
            MainBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local maxVisibleItems = math.min(#options, 5) 
                local targetSize = isOpen and UDim2.new(1, 0, 0, 34 + (maxVisibleItems * 26)) or UDim2.new(1, 0, 0, 34)
                if isOpen then DropContainer.CanvasSize = UDim2.new(0,0,0,DropList.AbsoluteContentSize.Y) end
                Animate(DropFrame, {Size = targetSize}, 0.2)
            end)

            for _, opt in ipairs(options) do
                local OptBtn = Instance.new("TextButton", DropContainer)
                OptBtn.Size = UDim2.new(1, -8, 0, 22)
                OptBtn.BackgroundColor3 = T_CARD
                OptBtn.Text = opt
                OptBtn.TextColor3 = C_MUTED
                OptBtn.Font = Enum.Font.GothamSemibold
                OptBtn.TextSize = 11
                ApplyCorner(OptBtn, 4)

                OptBtn.MouseButton1Click:Connect(function()
                    MainBtn.Text = "  " .. text .. " : " .. opt
                    isOpen = false
                    Animate(DropFrame, {Size = UDim2.new(1, 0, 0, 34)}, 0.2)
                    pcall(callback, opt)
                end)
            end
        end

        -- ==========================================
        -- MULTI-SELECT DROPDOWN (Seleção Múltipla)
        -- ==========================================
        function Elements:AddMultiDropdown(text, options, callback)
            local DropFrame = Instance.new("Frame", Page)
            DropFrame.Size = UDim2.new(1, 0, 0, 34)
            DropFrame.BackgroundColor3 = T_BG
            DropFrame.ClipsDescendants = true
            ApplyCorner(DropFrame, 6)
            ApplyStroke(DropFrame, T_ACCENT, 1, 0.8)

            local MainBtn = Instance.new("TextButton", DropFrame)
            MainBtn.Size = UDim2.new(1, 0, 0, 34)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = "  " .. text .. " : Select ▼"
            MainBtn.TextColor3 = C_TEXT
            MainBtn.Font = Enum.Font.GothamSemibold
            MainBtn.TextSize = 12
            MainBtn.TextXAlignment = Enum.TextXAlignment.Left

            local DropContainer = Instance.new("ScrollingFrame", DropFrame)
            DropContainer.Size = UDim2.new(1, -20, 1, -40)
            DropContainer.Position = UDim2.new(0, 10, 0, 35)
            DropContainer.BackgroundTransparency = 1
            DropContainer.ScrollBarThickness = 2
            DropContainer.ScrollBarImageColor3 = T_ACCENT
            
            local DropList = Instance.new("UIListLayout", DropContainer)
            DropList.Padding = UDim.new(0, 4)

            local isOpen = false
            MainBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local maxVisibleItems = math.min(#options, 5) 
                local targetHeight = 34 + (maxVisibleItems * 26)
                local targetSize = isOpen and UDim2.new(1, 0, 0, targetHeight) or UDim2.new(1, 0, 0, 34)
                if isOpen then DropContainer.CanvasSize = UDim2.new(0,0,0,DropList.AbsoluteContentSize.Y) end
                Animate(DropFrame, {Size = targetSize}, 0.2)
            end)

            local selectedItems = {}

            for _, opt in ipairs(options) do
                local OptBtn = Instance.new("TextButton", DropContainer)
                OptBtn.Size = UDim2.new(1, -8, 0, 22)
                OptBtn.BackgroundColor3 = T_CARD
                OptBtn.Text = opt
                OptBtn.TextColor3 = C_MUTED
                OptBtn.Font = Enum.Font.GothamSemibold
                OptBtn.TextSize = 11
                ApplyCorner(OptBtn, 4)

                local isSelected = false
                OptBtn.MouseButton1Click:Connect(function()
                    isSelected = not isSelected
                    
                    if isSelected then
                        table.insert(selectedItems, opt)
                        Animate(OptBtn, {BackgroundColor3 = T_ACCENT})
                        Animate(OptBtn, {TextColor3 = C_TEXT})
                    else
                        for i, v in ipairs(selectedItems) do
                            if v == opt then table.remove(selectedItems, i) break end
                        end
                        Animate(OptBtn, {BackgroundColor3 = T_CARD})
                        Animate(OptBtn, {TextColor3 = C_MUTED})
                    end

                    if #selectedItems == 0 then MainBtn.Text = "  " .. text .. " : Select ▼"
                    elseif #selectedItems == 1 then MainBtn.Text = "  " .. text .. " : " .. selectedItems[1]
                    else MainBtn.Text = "  " .. text .. " : " .. tostring(#selectedItems) .. " Selected" end

                    pcall(callback, selectedItems)
                end)
            end
        end

        return Elements
    end

    return Window
end

return NamelessUI
