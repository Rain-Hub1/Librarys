local Lib = {}
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Temas disponíveis
local Themes = {
    Darker = {
        Background = Color3.fromRGB(20, 20, 30),
        Foreground = Color3.fromRGB(35, 35, 45),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 150, 255),
        Secondary = Color3.fromRGB(50, 50, 60),
        Success = Color3.fromRGB(0, 180, 80),
        Warning = Color3.fromRGB(255, 160, 0),
        Error = Color3.fromRGB(255, 50, 50)
    },
    Dark = {
        Background = Color3.fromRGB(30, 30, 40),
        Foreground = Color3.fromRGB(45, 45, 55),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 170, 255),
        Secondary = Color3.fromRGB(60, 60, 70)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Foreground = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(0, 120, 215),
        Secondary = Color3.fromRGB(230, 230, 230)
    }
}

function Lib:Window(Info)
    local Info = Info or {}
    local windowTitle = Info.Title or "Interface"
    local themeName = Info.Theme or "Darker"
    local currentTheme = Themes[themeName] or Themes.Darker
    
    local Window = {}
    local elements = {}
    
    -- Criar ScreenGui principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SabLibUI_" .. math.random(1000, 9999)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    -- Botão para abrir/fechar (se habilitado)
    local OpenButton
    if Info.OpenButton then
        OpenButton = Instance.new("TextButton")
        OpenButton.Name = "OpenButton"
        OpenButton.Size = UDim2.new(0, 50, 0, 50)
        OpenButton.Position = UDim2.new(0, 20, 0, 20)
        OpenButton.BackgroundColor3 = currentTheme.Accent
        OpenButton.Text = "☰"
        OpenButton.TextColor3 = currentTheme.Text
        OpenButton.TextSize = 20
        OpenButton.Font = Enum.Font.GothamBold
        OpenButton.ZIndex = 10
        OpenButton.Parent = ScreenGui

        local OpenButtonCorner = Instance.new("UICorner")
        OpenButtonCorner.CornerRadius = UDim.new(0, 8)
        OpenButtonCorner.Parent = OpenButton
    end
    
    -- Frame principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 420, 0, 370)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = currentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- Barra de título
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = currentTheme.Foreground
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -40, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowTitle
    TitleLabel.TextColor3 = currentTheme.Text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundColor3 = currentTheme.Error or Color3.fromRGB(255, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = currentTheme.Text
    CloseButton.TextSize = 12
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar

    -- Container de conteúdo
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = currentTheme.Accent
    ContentFrame.Parent = MainFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentFrame

    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Sistema de arrastar
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
    
    -- Funções da Window
    function Window:Toggle()
        MainFrame.Visible = not MainFrame.Visible
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end

    function Window:SetTheme(themeName)
        if Themes[themeName] then
            currentTheme = Themes[themeName]
            MainFrame.BackgroundColor3 = currentTheme.Background
            TitleBar.BackgroundColor3 = currentTheme.Foreground
            TitleLabel.TextColor3 = currentTheme.Text
            ContentFrame.ScrollBarImageColor3 = currentTheme.Accent
            CloseButton.BackgroundColor3 = currentTheme.Error or Color3.fromRGB(255, 60, 60)
            
            if OpenButton then
                OpenButton.BackgroundColor3 = currentTheme.Accent
                OpenButton.TextColor3 = currentTheme.Text
            end
            
            -- Atualizar elementos existentes
            for _, element in pairs(elements) do
                if element.UpdateTheme then
                    element:UpdateTheme(currentTheme)
                end
            end
        end
    end

    -- Botão de abrir/fechar
    if OpenButton then
        OpenButton.MouseButton1Click:Connect(function()
            Window:Toggle()
        end)
    end
    
    CloseButton.MouseButton1Click:Connect(function()
        Window:Toggle()
    end)

    -- Função Paragraph
    function Window:Paragraph(Info)
        local Info = Info or {}
        
        local ParagraphFrame = Instance.new("Frame")
        ParagraphFrame.Name = "ParagraphFrame"
        ParagraphFrame.Size = UDim2.new(1, -20, 0, 70)
        ParagraphFrame.BackgroundColor3 = currentTheme.Secondary
        ParagraphFrame.BorderSizePixel = 0
        ParagraphFrame.Parent = ContentFrame
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = ParagraphFrame
        
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Name = "NameLabel"
        NameLabel.Size = UDim2.new(1, -20, 0, 20)
        NameLabel.Position = UDim2.new(0, 10, 0, 5)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = Info.Name or "Paragraph"
        NameLabel.TextColor3 = currentTheme.Text
        NameLabel.TextSize = 14
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = ParagraphFrame
        
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Name = "DescLabel"
        DescLabel.Size = UDim2.new(1, -20, 0, 40)
        DescLabel.Position = UDim2.new(0, 10, 0, 25)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = Info.Desc or "Description"
        DescLabel.TextColor3 = currentTheme.Text
        DescLabel.TextSize = 12
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextWrapped = true
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.TextYAlignment = Enum.TextYAlignment.Top
        DescLabel.Parent = ParagraphFrame

        local ParagraphObject = {}
        
        function ParagraphObject:SetName(newName)
            NameLabel.Text = newName or "Paragraph"
        end
        
        function ParagraphObject:SetDesc(newDesc)
            DescLabel.Text = newDesc or "Description"
        end
        
        function ParagraphObject:UpdateTheme(theme)
            ParagraphFrame.BackgroundColor3 = theme.Secondary
            NameLabel.TextColor3 = theme.Text
            DescLabel.TextColor3 = theme.Text
        end
        
        table.insert(elements, ParagraphObject)
        return ParagraphObject
    end

    -- Função Button
    function Window:Button(Info)
        local Info = Info or {}
        local buttonColor = Info.Color or currentTheme.Accent
        
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Name = "ButtonFrame"
        ButtonFrame.Size = UDim2.new(1, -20, 0, 60)
        ButtonFrame.BackgroundColor3 = currentTheme.Secondary
        ButtonFrame.BorderSizePixel = 0
        ButtonFrame.Parent = ContentFrame

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = ButtonFrame
        
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Name = "NameLabel"
        NameLabel.Size = UDim2.new(1, -20, 0, 20)
        NameLabel.Position = UDim2.new(0, 10, 0, 5)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = Info.Name or "Button"
        NameLabel.TextColor3 = currentTheme.Text
        NameLabel.TextSize = 14
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = ButtonFrame
        
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Name = "DescLabel"
        DescLabel.Size = UDim2.new(1, -20, 0, 15)
        DescLabel.Position = UDim2.new(0, 10, 0, 25)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = Info.Desc or "Description"
        DescLabel.TextColor3 = currentTheme.Text
        DescLabel.TextSize = 11
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = ButtonFrame
        
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Size = UDim2.new(0, 120, 0, 25)
        Button.Position = UDim2.new(1, -130, 0, 30)
        Button.BackgroundColor3 = buttonColor
        Button.BorderSizePixel = 0
        Button.Text = "Executar"
        Button.TextColor3 = currentTheme.Text
        Button.TextSize = 12
        Button.Font = Enum.Font.Gotham
        Button.Parent = ButtonFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            if Info.Callback then
                Info.Callback()
            end
        end)
        
        -- Efeito hover
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(
                math.min(buttonColor.R * 255 + 20, 255),
                math.min(buttonColor.G * 255 + 20, 255),
                math.min(buttonColor.B * 255 + 20, 255)
            )}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = buttonColor}):Play()
        end)

        local ButtonObject = {}
        
        function ButtonObject:SetName(newName)
            NameLabel.Text = newName or "Button"
        end
        
        function ButtonObject:SetDesc(newDesc)
            DescLabel.Text = newDesc or "Description"
        end
        
        function ButtonObject:SetColor(newColor)
            buttonColor = newColor or currentTheme.Accent
            Button.BackgroundColor3 = buttonColor
        end
        
        function ButtonObject:UpdateTheme(theme)
            ButtonFrame.BackgroundColor3 = theme.Secondary
            NameLabel.TextColor3 = theme.Text
            DescLabel.TextColor3 = theme.Text
            Button.TextColor3 = theme.Text
        end
        
        table.insert(elements, ButtonObject)
        return ButtonObject
    end

    -- Função Toggle
    function Window:Toggle(Info)
        local Info = Info or {}
        local Toggled = Info.Default or false
        local toggleColor = Info.Color or currentTheme.Success
        
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = "ToggleFrame"
        ToggleFrame.Size = UDim2.new(1, -20, 0, 60)
        ToggleFrame.BackgroundColor3 = currentTheme.Secondary
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = ContentFrame
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = ToggleFrame
        
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Name = "NameLabel"
        NameLabel.Size = UDim2.new(1, -20, 0, 20)
        NameLabel.Position = UDim2.new(0, 10, 0, 5)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = Info.Name or "Toggle"
        NameLabel.TextColor3 = currentTheme.Text
        NameLabel.TextSize = 14
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = ToggleFrame
        
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Name = "DescLabel"
        DescLabel.Size = UDim2.new(1, -20, 0, 15)
        DescLabel.Position = UDim2.new(0, 10, 0, 25)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = Info.Desc or "Description"
        DescLabel.TextColor3 = currentTheme.Text
        DescLabel.TextSize = 11
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = ToggleFrame
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Size = UDim2.new(0, 50, 0, 25)
        ToggleButton.Position = UDim2.new(1, -60, 0, 30)
        ToggleButton.BackgroundColor3 = currentTheme.Secondary
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Text = ""
        ToggleButton.Parent = ToggleFrame
        
        local ToggleSwitch = Instance.new("Frame")
        ToggleSwitch.Name = "ToggleSwitch"
        ToggleSwitch.Size = UDim2.new(1, 0, 1, 0)
        ToggleSwitch.BackgroundColor3 = currentTheme.Foreground
        ToggleSwitch.BorderSizePixel = 0
        ToggleSwitch.Parent = ToggleButton
        
        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = ToggleSwitch
        
        local ToggleDot = Instance.new("Frame")
        ToggleDot.Name = "ToggleDot"
        ToggleDot.Size = UDim2.new(0, 19, 0, 19)
        ToggleDot.Position = UDim2.new(0, 3, 0.5, -9.5)
        ToggleDot.BackgroundColor3 = currentTheme.Text
        ToggleDot.BorderSizePixel = 0
        ToggleDot.Parent = ToggleSwitch
        
        local DotCorner = Instance.new("UICorner")
        DotCorner.CornerRadius = UDim.new(1, 0)
        DotCorner.Parent = ToggleDot
        
        local function UpdateToggle()
            if Toggled then
                TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = toggleColor}):Play()
                TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 28, 0.5, -9.5)}):Play()
            else
                TweenService:Create(ToggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = currentTheme.Foreground}):Play()
                TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9.5)}):Play()
            end
            
            if Info.Callback then
                Info.Callback(Toggled)
            end
        end
        
        ToggleButton.MouseButton1Click:Connect(function()
            Toggled = not Toggled
            UpdateToggle()
        end)
        
        UpdateToggle()

        local ToggleObject = {}
        
        function ToggleObject:SetName(newName)
            NameLabel.Text = newName or "Toggle"
        end
        
        function ToggleObject:SetDesc(newDesc)
            DescLabel.Text = newDesc or "Description"
        end
        
        function ToggleObject:SetColor(newColor)
            toggleColor = newColor or currentTheme.Success
            UpdateToggle()
        end
        
        function ToggleObject:SetDefault(value)
            Toggled = value
            UpdateToggle()
        end
        
        function ToggleObject:GetValue()
            return Toggled
        end
        
        function ToggleObject:UpdateTheme(theme)
            ToggleFrame.BackgroundColor3 = theme.Secondary
            NameLabel.TextColor3 = theme.Text
            DescLabel.TextColor3 = theme.Text
            ToggleDot.BackgroundColor3 = theme.Text
            if not Toggled then
                ToggleSwitch.BackgroundColor3 = theme.Foreground
            end
        end
        
        table.insert(elements, ToggleObject)
        return ToggleObject
    end

    -- Função Notify
    function Window:Notify(Info)
        local Info = Info or {}
        
        local NotifyFrame = Instance.new("Frame")
        NotifyFrame.Name = "NotifyFrame"
        NotifyFrame.Size = UDim2.new(0, 300, 0, 80)
        NotifyFrame.AnchorPoint = Vector2.new(0.5, 0)
        NotifyFrame.Position = UDim2.new(0.5, 0, 0, -100)
        NotifyFrame.BackgroundColor3 = currentTheme.Foreground
        NotifyFrame.BorderSizePixel = 0
        NotifyFrame.Parent = ScreenGui

        local NotifyCorner = Instance.new("UICorner")
        NotifyCorner.CornerRadius = UDim.new(0, 8)
        NotifyCorner.Parent = NotifyFrame

        local NotifyTitle = Instance.new("TextLabel")
        NotifyTitle.Name = "NotifyTitle"
        NotifyTitle.Size = UDim2.new(1, -20, 0, 25)
        NotifyTitle.Position = UDim2.new(0, 10, 0, 10)
        NotifyTitle.BackgroundTransparency = 1
        NotifyTitle.Text = Info.Title or "Notification"
        NotifyTitle.TextColor3 = currentTheme.Text
        NotifyTitle.TextSize = 16
        NotifyTitle.Font = Enum.Font.GothamBold
        NotifyTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifyTitle.Parent = NotifyFrame

        local NotifyDesc = Instance.new("TextLabel")
        NotifyDesc.Name = "NotifyDesc"
        NotifyDesc.Size = UDim2.new(1, -20, 0, 35)
        NotifyDesc.Position = UDim2.new(0, 10, 0, 35)
        NotifyDesc.BackgroundTransparency = 1
        NotifyDesc.Text = Info.Desc or "This is a notification"
        NotifyDesc.TextColor3 = currentTheme.Text
        NotifyDesc.TextSize = 12
        NotifyDesc.Font = Enum.Font.Gotham
        NotifyDesc.TextWrapped = true
        NotifyDesc.TextXAlignment = Enum.TextXAlignment.Left
        NotifyDesc.Parent = NotifyFrame

        -- Animação de entrada
        TweenService:Create(NotifyFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, 0, 0, 20)}):Play()

        -- Remover após delay
        local duration = Info.Time or 3
        wait(duration)

        -- Animação de saída
        TweenService:Create(NotifyFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, 0, 0, -100)}):Play()
        wait(0.3)
        NotifyFrame:Destroy()
    end

    return Window
end

return Lib
