--!strict
local Window = {}

function Window:Create(Info, Lib)
    local Info = Info or {}
    local Title = Info.Title or "UI Library"
    local OpenButton = Info.OpenButton
    local ThemeName = Info.Theme or "Darker"
    local Size = Info.Size or {470, 340}
    local Key = Info.Key
    local KeyS = Info.KeyS
    local Parent = Info.Parent or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    local theme = Lib.Themes:GetTheme(ThemeName)
    local isOpen = false
    
    -- Validar tamanho
    local windowWidth, windowHeight
    if type(Size) == "table" then
        windowWidth = Size[1] or 470
        windowHeight = Size[2] or 340
    else
        windowWidth = 470
        windowHeight = 340
    end

    -- Criar ScreenGui principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LibWindow"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Parent

    -- Botão toggle se OpenButton for true
    local ToggleButton
    if OpenButton == true then
        ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Size = UDim2.new(0, 100, 0, 30)
        ToggleButton.Position = UDim2.new(0, 20, 0, 20)
        ToggleButton.BackgroundColor3 = theme.Accent
        ToggleButton.Text = "OPEN UI"
        ToggleButton.TextColor3 = theme.Text
        ToggleButton.TextSize = 12
        ToggleButton.Font = Enum.Font.GothamSemibold
        ToggleButton.Parent = ScreenGui
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 6)
        ToggleCorner.Parent = ToggleButton
    end

    -- Frame principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = theme.Background
    MainFrame.BackgroundTransparency = 1
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    -- Efeitos visuais
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = theme.Accent
    UIStroke.Thickness = 2
    UIStroke.Transparency = 1
    UIStroke.Parent = MainFrame

    -- Header (TitleBar reduzida)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 35) -- Header menor
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundColor3 = theme.Foreground
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -40, 1, 0)
    TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = string.upper(Title)
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -30, 0.5, -12.5)
    CloseButton.BackgroundColor3 = theme.Error
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "×"
    CloseButton.TextColor3 = theme.Text
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Header

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseButton

    -- Container de abas
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -20, 0, 35)
    TabContainer.Position = UDim2.new(0, 10, 0, 40)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabLayout.Parent = TabContainer

    -- Sistema de abas
    local tabs = {}
    local currentTab = nil
    local tabContents = {}

    -- Função para mudar de aba
    local function switchTab(tabName)
        -- Esconder todos os conteúdos
        for name, content in pairs(tabContents) do
            content.Visible = false
        end
        
        -- Desselecionar todas as abas
        for _, tab in ipairs(tabs) do
            tab:SetSelected(false)
        end
        
        -- Mostrar conteúdo da aba selecionada e selecionar a aba
        if tabContents[tabName] then
            tabContents[tabName].Visible = true
            currentTab = tabName
        end
    end

    -- Container de conteúdo principal (para quando não há abas)
    local MainContent = Instance.new("ScrollingFrame")
    MainContent.Name = "MainContent"
    MainContent.Size = UDim2.new(1, -20, 1, -80)
    MainContent.Position = UDim2.new(0, 10, 0, 80)
    MainContent.BackgroundTransparency = 1
    MainContent.BorderSizePixel = 0
    MainContent.ScrollBarThickness = 4
    MainContent.ScrollBarImageColor3 = theme.Accent
    MainContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    MainContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    MainContent.Parent = MainFrame

    local MainContentLayout = Instance.new("UIListLayout")
    MainContentLayout.Padding = UDim.new(0, 8)
    MainContentLayout.Parent = MainContent

    -- Sistema de arrastar
    local isDragging = false
    local dragStart, dragOffset

    local function makeDraggable(guiObject)
        guiObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                dragStart = input.Position
                dragOffset = dragStart - guiObject.AbsolutePosition
                
                local tween = game:GetService("TweenService"):Create(Header, TweenInfo.new(0.1), {
                    BackgroundTransparency = 0.8
                })
                tween:Play()
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local newPos = input.Position - dragOffset
                local screenSize = guiObject.Parent.AbsoluteSize
                local guiSize = guiObject.AbsoluteSize
                
                newPos = Vector2.new(
                    math.clamp(newPos.X, 0, screenSize.X - guiSize.X),
                    math.clamp(newPos.Y, 0, screenSize.Y - guiSize.Y)
                )
                
                guiObject.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
            end
        end)

        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
                
                local tween = game:GetService("TweenService"):Create(Header, TweenInfo.new(0.1), {
                    BackgroundTransparency = 1
                })
                tween:Play()
            end
        end)
    end

    makeDraggable(MainFrame)

    -- Funções de animação
    local function openWindow()
        if isOpen then return end
        isOpen = true
        MainFrame.Visible = true
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        local tween = game:GetService("TweenService"):Create(MainFrame, tweenInfo, {
            BackgroundTransparency = 0
        })
        
        local strokeTween = game:GetService("TweenService"):Create(UIStroke, tweenInfo, {
            Transparency = 0
        })
        
        tween:Play()
        strokeTween:Play()
        
        if ToggleButton then
            ToggleButton.Text = "CLOSE UI"
        end
    end

    local function closeWindow()
        if not isOpen then return end
        isOpen = false
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        local tween = game:GetService("TweenService"):Create(MainFrame, tweenInfo, {
            BackgroundTransparency = 1
        })
        
        local strokeTween = game:GetService("TweenService"):Create(UIStroke, tweenInfo, {
            Transparency = 1
        })
        
        tween:Play()
        strokeTween:Play()
        
        tween.Completed:Connect(function()
            if not isOpen then
                MainFrame.Visible = false
            end
        end)
        
        if ToggleButton then
            ToggleButton.Text = "OPEN UI"
        end
    end

    -- Controle por botão
    if ToggleButton then
        ToggleButton.MouseButton1Click:Connect(function()
            if isOpen then
                closeWindow()
            else
                openWindow()
            end
        end)
    end

    -- Evento do botão fechar
    CloseButton.MouseButton1Click:Connect(closeWindow)

    -- Efeitos de hover
    CloseButton.MouseEnter:Connect(function()
        local tween = game:GetService("TweenService"):Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2
        })
        tween:Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        local tween = game:GetService("TweenService"):Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        })
        tween:Play()
    end)

    -- API da janela
    local WindowAPI = {}

    -- Função para criar abas
    function WindowAPI:Tab(Info)
        local Name = Info.Name or "Tab"
        local Icon = Info.Icon
        local Locked = Info.Locked or false
        
        -- Criar container de conteúdo para a aba
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = "TabContent_" .. Name
        TabContent.Size = UDim2.new(1, -20, 1, -80)
        TabContent.Position = UDim2.new(0, 10, 0, 80)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Visible = false
        TabContent.Parent = MainFrame

        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Padding = UDim.new(0, 8)
        TabContentLayout.Parent = TabContent
        
        tabContents[Name] = TabContent
        
        -- Criar o botão da aba
        local tab = Lib.Elements.Tab:Create(TabContainer, {
            Name = Name,
            Icon = Icon,
            Locked = Locked
        }, theme, function()
            if not Locked then
                switchTab(Name)
                tab:SetSelected(true)
            end
        end)
        
        table.insert(tabs, tab)
        
        -- Se for a primeira aba, ativar automaticamente
        if #tabs == 1 and not Locked then
            switchTab(Name)
            tab:SetSelected(true)
        end
        
        -- API da aba
        local TabAPI = {}
        
        function TabAPI:Paragraph(Info)
            return Lib.Elements.Paragraph:Create(TabContent, Info, theme)
        end
        
        function TabAPI:Button(Info)
            return Lib.Elements.Button:Create(TabContent, Info, theme)
        end
        
        function TabAPI:Toggle(Info)
            return Lib.Elements.Toggle:Create(TabContent, Info, theme)
        end
        
        function TabAPI:Dropdown(Info)
            return Lib.Elements.Dropdown:Create(TabContent, Info, theme)
        end
        
        function TabAPI:SetLocked(locked)
            Locked = locked
            tab:SetLocked(locked)
        end
        
        function TabAPI:SetName(newName)
            tab:SetName(newName)
        end
        
        function TabAPI:SetIcon(newIcon)
            tab:SetIcon(newIcon)
        end
        
        function TabAPI:Destroy()
            tab:Destroy()
            if tabContents[Name] then
                tabContents[Name]:Destroy()
                tabContents[Name] = nil
            end
        end
        
        return TabAPI
    end

    -- Funções para adicionar elementos ao conteúdo principal (sem abas)
    function WindowAPI:Paragraph(Info)
        return Lib.Elements.Paragraph:Create(MainContent, Info, theme)
    end

    function WindowAPI:Button(Info)
        return Lib.Elements.Button:Create(MainContent, Info, theme)
    end

    function WindowAPI:Toggle(Info)
        return Lib.Elements.Toggle:Create(MainContent, Info, theme)
    end

    function WindowAPI:Dropdown(Info)
        return Lib.Elements.Dropdown:Create(MainContent, Info, theme)
    end

    function WindowAPI:Notify(Info)
        -- Criar notificação simples
        local Title = Info.Title or "Notification"
        local Desc = Info.Desc or ""
        local Time = Info.Time or 5
        
        local NotificationFrame = Instance.new("Frame")
        NotificationFrame.Name = "Notification"
        NotificationFrame.Size = UDim2.new(0, 280, 0, 70)
        NotificationFrame.Position = UDim2.new(1, 300, 0.1, 0)
        NotificationFrame.BackgroundColor3 = theme.Foreground
        NotificationFrame.Parent = ScreenGui
        
        local NotificationCorner = Instance.new("UICorner")
        NotificationCorner.CornerRadius = UDim.new(0, 8)
        NotificationCorner.Parent = NotificationFrame
        
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = theme.Accent
        UIStroke.Thickness = 1
        UIStroke.Parent = NotificationFrame
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "TitleLabel"
        TitleLabel.Size = UDim2.new(1, -20, 0, 20)
        TitleLabel.Position = UDim2.new(0, 10, 0, 10)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = string.upper(Title)
        TitleLabel.TextColor3 = theme.Text
        TitleLabel.TextSize = 12
        TitleLabel.Font = Enum.Font.GothamSemibold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = NotificationFrame
        
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Name = "DescLabel"
        DescLabel.Size = UDim2.new(1, -20, 0, 40)
        DescLabel.Position = UDim2.new(0, 10, 0, 30)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = Desc
        DescLabel.TextColor3 = theme.Text
        DescLabel.TextSize = 10
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.TextYAlignment = Enum.TextYAlignment.Top
        DescLabel.TextWrapped = true
        DescLabel.Parent = NotificationFrame
        
        -- Animação de entrada
        local tweenIn = game:GetService("TweenService"):Create(NotificationFrame, TweenInfo.new(0.3), {
            Position = UDim2.new(1, -290, 0.1, 0)
        })
        tweenIn:Play()
        
        -- Remover após o tempo
        task.delay(Time, function()
            local tweenOut = game:GetService("TweenService"):Create(NotificationFrame, TweenInfo.new(0.3), {
                Position = UDim2.new(1, 300, 0.1, 0)
            })
            tweenOut:Play()
            
            tweenOut.Completed:Connect(function()
                NotificationFrame:Destroy()
            end)
        end)
    end

    function WindowAPI:Destroy()
        ScreenGui:Destroy()
    end

    function WindowAPI:Open()
        openWindow()
    end

    function WindowAPI:Close()
        closeWindow()
    end

    -- Abrir automaticamente se não houver toggle button
    if not OpenButton then
        openWindow()
    end

    return WindowAPI
end

return Window
