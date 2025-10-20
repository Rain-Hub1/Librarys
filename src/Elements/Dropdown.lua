--!strict
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Dropdown = {}

function Dropdown:Create(Container, Info, theme)
    local Name = Info.Name or "Dropdown"
    local Desc = Info.Desc or ""
    local Options = Info.Options or {"Option 1", "Option 2", "Option 3"}
    local Default = Info.Default or 1
    local Callback = Info.Callback or function(Value, Index) end
    
    -- Validar índice padrão
    if Default < 1 or Default > #Options then
        Default = 1
    end
    
    local selectedIndex = Default
    local selectedValue = Options[Default]
    local isOpen = false
    
    -- Frame principal do dropdown
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "DropdownFrame"
    DropdownFrame.Size = UDim2.new(1, 0, 0, 50) -- Altura fixa como nas imagens
    DropdownFrame.BackgroundColor3 = theme.Foreground
    DropdownFrame.BackgroundTransparency = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = Container
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownFrame
    
    local DropdownStroke = Instance.new("UIStroke")
    DropdownStroke.Color = Color3.fromRGB(60, 60, 70)
    DropdownStroke.Thickness = 1
    DropdownStroke.Parent = DropdownFrame
    
    -- Botão principal do dropdown
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "DropdownButton"
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.ZIndex = 2
    DropdownButton.Parent = DropdownFrame
    
    -- Container do conteúdo principal
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ZIndex = 2
    ContentFrame.Parent = DropdownFrame
    
    -- Ícone da seta
    local ArrowIcon = Instance.new("ImageLabel")
    ArrowIcon.Name = "ArrowIcon"
    ArrowIcon.Size = UDim2.new(0, 20, 0, 20)
    ArrowIcon.Position = UDim2.new(1, -30, 0.5, -10)
    ArrowIcon.BackgroundTransparency = 1
    ArrowIcon.Image = "rbxassetid://6031094678" -- Seta para baixo
    ArrowIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
    ArrowIcon.ZIndex = 2
    ArrowIcon.Parent = ContentFrame
    
    -- Label do nome (pequeno, no topo)
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.Size = UDim2.new(1, -50, 0, 16)
    NameLabel.Position = UDim2.new(0, 12, 0, 6)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = Name
    NameLabel.TextColor3 = Color3.fromRGB(180, 180, 180) -- Cinza claro como na imagem
    NameLabel.TextSize = 12
    NameLabel.Font = Enum.Font.Gotham
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.ZIndex = 2
    NameLabel.Parent = ContentFrame
    
    -- Label do valor selecionado (em destaque)
    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Name = "SelectedLabel"
    SelectedLabel.Size = UDim2.new(1, -50, 0, 20)
    SelectedLabel.Position = UDim2.new(0, 12, 0, 22)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Text = selectedValue
    SelectedLabel.TextColor3 = theme.Text -- Branco como na imagem
    SelectedLabel.TextSize = 14
    SelectedLabel.Font = Enum.Font.GothamSemibold
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    SelectedLabel.ZIndex = 2
    SelectedLabel.Parent = ContentFrame
    
    -- Descrição (se houver)
    local DescLabel
    if Desc and Desc ~= "" then
        DescLabel = Instance.new("TextLabel")
        DescLabel.Name = "DescLabel"
        DescLabel.Size = UDim2.new(1, -15, 0, 0)
        DescLabel.Position = UDim2.new(0, 0, 1, 5)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = Desc
        DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        DescLabel.TextSize = 12
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.TextYAlignment = Enum.TextYAlignment.Top
        DescLabel.TextWrapped = true
        DescLabel.AutomaticSize = Enum.AutomaticSize.Y
        DescLabel.Parent = DropdownFrame
        
        -- Ajustar altura do frame principal para incluir a descrição
        task.defer(function()
            local descHeight = DescLabel.TextBounds.Y + 10
            DropdownFrame.Size = UDim2.new(1, 0, 0, 50 + descHeight)
        end)
    end
    
    -- Frame das opções (aparece sobre outros elementos)
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Name = "OptionsFrame"
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 0, 50)
    OptionsFrame.BackgroundColor3 = theme.Foreground
    OptionsFrame.BackgroundTransparency = 0
    OptionsFrame.Visible = false
    OptionsFrame.ZIndex = 10
    OptionsFrame.Parent = DropdownFrame
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 8)
    OptionsCorner.Parent = OptionsFrame
    
    local OptionsStroke = Instance.new("UIStroke")
    OptionsStroke.Color = Color3.fromRGB(60, 60, 70)
    OptionsStroke.Thickness = 1
    OptionsStroke.Parent = OptionsFrame
    
    -- ScrollingFrame para as opções (com altura máxima)
    local OptionsScrolling = Instance.new("ScrollingFrame")
    OptionsScrolling.Name = "OptionsScrolling"
    OptionsScrolling.Size = UDim2.new(1, 0, 1, 0)
    OptionsScrolling.Position = UDim2.new(0, 0, 0, 0)
    OptionsScrolling.BackgroundTransparency = 1
    OptionsScrolling.BorderSizePixel = 0
    OptionsScrolling.ScrollBarThickness = 4
    OptionsScrolling.ScrollBarImageColor3 = theme.Accent
    OptionsScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    OptionsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    OptionsScrolling.ZIndex = 10
    OptionsScrolling.Parent = OptionsFrame
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.Padding = UDim.new(0, 1)
    OptionsLayout.Parent = OptionsScrolling
    
    -- Criar botões das opções
    local optionButtons = {}
    
    local function createOptionButtons()
        -- Limpar opções existentes
        for _, button in ipairs(optionButtons) do
            button:Destroy()
        end
        optionButtons = {}
        
        -- Criar novas opções
        for i, option in ipairs(Options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = "OptionButton_" .. i
            OptionButton.Size = UDim2.new(1, 0, 0, 36) -- Altura fixa como na imagem
            OptionButton.BackgroundColor3 = theme.Foreground
            OptionButton.BackgroundTransparency = 0
            OptionButton.Text = ""
            OptionButton.ZIndex = 11
            OptionButton.Parent = OptionsScrolling
            
            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 0)
            OptionCorner.Parent = OptionButton
            
            -- Texto da opção
            local OptionText = Instance.new("TextLabel")
            OptionText.Name = "OptionText"
            OptionText.Size = UDim2.new(1, -20, 1, 0)
            OptionText.Position = UDim2.new(0, 12, 0, 0)
            OptionText.BackgroundTransparency = 1
            OptionText.Text = option
            OptionText.TextColor3 = i == selectedIndex and theme.Accent or theme.Text
            OptionText.TextSize = 14
            OptionText.Font = Enum.Font.Gotham
            OptionText.TextXAlignment = Enum.TextXAlignment.Left
            OptionText.ZIndex = 12
            OptionText.Parent = OptionButton
            
            -- Indicador de seleção (apenas para o item selecionado)
            if i == selectedIndex then
                local SelectedIndicator = Instance.new("Frame")
                SelectedIndicator.Name = "SelectedIndicator"
                SelectedIndicator.Size = UDim2.new(0, 3, 0, 20)
                SelectedIndicator.Position = UDim2.new(0, 5, 0.5, -10)
                SelectedIndicator.BackgroundColor3 = theme.Accent
                SelectedIndicator.ZIndex = 12
                SelectedIndicator.Parent = OptionButton
                
                local IndicatorCorner = Instance.new("UICorner")
                IndicatorCorner.CornerRadius = UDim.new(1, 0)
                IndicatorCorner.Parent = SelectedIndicator
            end
            
            -- Efeitos de hover
            OptionButton.MouseEnter:Connect(function()
                if i ~= selectedIndex then
                    local tween = TweenService:Create(OptionButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = Color3.fromRGB(
                            math.floor(theme.Foreground.R * 255 + 10),
                            math.floor(theme.Foreground.G * 255 + 10),
                            math.floor(theme.Foreground.B * 255 + 10)
                        )
                    })
                    tween:Play()
                end
            end)
            
            OptionButton.MouseLeave:Connect(function()
                if i ~= selectedIndex then
                    local tween = TweenService:Create(OptionButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = theme.Foreground
                    })
                    tween:Play()
                end
            end)
            
            -- Selecionar opção
            OptionButton.MouseButton1Click:Connect(function()
                selectedIndex = i
                selectedValue = option
                SelectedLabel.Text = option
                
                -- Atualizar cores de todas as opções
                for j, btn in ipairs(optionButtons) do
                    local optionText = btn:FindFirstChild("OptionText")
                    local selectedIndicator = btn:FindFirstChild("SelectedIndicator")
                    
                    if optionText then
                        optionText.TextColor3 = j == i and theme.Accent or theme.Text
                    end
                    
                    -- Remover indicador anterior e adicionar no novo
                    if selectedIndicator then
                        selectedIndicator:Destroy()
                    end
                    
                    if j == i then
                        local newIndicator = Instance.new("Frame")
                        newIndicator.Name = "SelectedIndicator"
                        newIndicator.Size = UDim2.new(0, 3, 0, 20)
                        newIndicator.Position = UDim2.new(0, 5, 0.5, -10)
                        newIndicator.BackgroundColor3 = theme.Accent
                        newIndicator.ZIndex = 12
                        newIndicator.Parent = btn
                        
                        local IndicatorCorner = Instance.new("UICorner")
                        IndicatorCorner.CornerRadius = UDim.new(1, 0)
                        IndicatorCorner.Parent = newIndicator
                    end
                end
                
                Callback(option, i)
                toggleDropdown()
            end)
            
            table.insert(optionButtons, OptionButton)
        end
    end
    
    createOptionButtons()
    
    -- Função para abrir/fechar dropdown
    local function toggleDropdown()
        isOpen = not isOpen
        
        if isOpen then
            OptionsFrame.Visible = true
            local optionHeight = math.min(#Options * 37, 200) -- Altura máxima de 200
            OptionsFrame.Size = UDim2.new(1, 0, 0, optionHeight)
            
            -- Animação de abertura
            local tween = TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, optionHeight)
            })
            tween:Play()
            
            local arrowTween = TweenService:Create(ArrowIcon, TweenInfo.new(0.2), {
                Rotation = 180,
                ImageColor3 = theme.Accent
            })
            arrowTween:Play()
            
            -- Ajustar a posição se necessário para caber na tela
            local absolutePosition = DropdownFrame.AbsolutePosition
            local absoluteSize = DropdownFrame.AbsoluteSize
            local screenSize = DropdownFrame.Parent.AbsoluteSize
            
            if absolutePosition.Y + absoluteSize.Y + optionHeight > screenSize.Y then
                -- Se não couber abaixo, abrir acima
                OptionsFrame.Position = UDim2.new(0, 0, 0, -optionHeight)
            else
                OptionsFrame.Position = UDim2.new(0, 0, 0, DropdownFrame.Size.Y.Offset)
            end
        else
            -- Animação de fechamento
            local tween = TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 0)
            })
            tween:Play()
            
            local arrowTween = TweenService:Create(ArrowIcon, TweenInfo.new(0.2), {
                Rotation = 0,
                ImageColor3 = Color3.fromRGB(180, 180, 180)
            })
            arrowTween:Play()
            
            tween.Completed:Connect(function()
                if not isOpen then
                    OptionsFrame.Visible = false
                end
            end)
        end
    end
    
    -- Evento do botão principal
    DropdownButton.MouseButton1Click:Connect(toggleDropdown)
    
    -- Fechar dropdown quando clicar fora
    local dropdownConnection
    local function closeDropdownOnClickOutside(input)
        if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local absolutePos = DropdownFrame.AbsolutePosition
            local absoluteSize = DropdownFrame.AbsoluteSize
            
            -- Verificar se o clique foi fora do dropdown
            if mousePos.X < absolutePos.X or mousePos.X > absolutePos.X + absoluteSize.X or
               mousePos.Y < absolutePos.Y or mousePos.Y > absolutePos.Y + absoluteSize.Y + OptionsFrame.AbsoluteSize.Y then
                toggleDropdown()
            end
        end
    end
    
    dropdownConnection = UserInputService.InputBegan:Connect(closeDropdownOnClickOutside)
    
    -- Efeito hover no botão principal
    DropdownButton.MouseEnter:Connect(function()
        local tween = TweenService:Create(DropdownFrame, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(
                math.floor(theme.Foreground.R * 255 + 5),
                math.floor(theme.Foreground.G * 255 + 5),
                math.floor(theme.Foreground.B * 255 + 5)
            )
        })
        tween:Play()
    end)
    
    DropdownButton.MouseLeave:Connect(function()
        if not isOpen then
            local tween = TweenService:Create(DropdownFrame, TweenInfo.new(0.15), {
                BackgroundColor3 = theme.Foreground
            })
            tween:Play()
        end
    end)
    
    -- API do Dropdown
    local DropdownAPI = {}
    
    function DropdownAPI:SetName(NewName)
        NameLabel.Text = NewName or Name
    end
    
    function DropdownAPI:SetDesc(NewDesc)
        if DescLabel then
            DescLabel.Text = NewDesc or Desc
            task.defer(function()
                local descHeight = DescLabel.TextBounds.Y + 10
                DropdownFrame.Size = UDim2.new(1, 0, 0, 50 + descHeight)
            end)
        end
    end
    
    function DropdownAPI:SetOptions(NewOptions)
        Options = NewOptions or Options
        
        -- Ajustar índice selecionado se necessário
        if selectedIndex > #Options then
            selectedIndex = 1
            selectedValue = Options[1] or "Select..."
            SelectedLabel.Text = selectedValue
        end
        
        createOptionButtons()
        
        if isOpen then
            toggleDropdown() -- Fechar e reabrir para atualizar
            task.wait(0.25)
            toggleDropdown()
        end
    end
    
    function DropdownAPI:SetDefault(Index)
        if Index >= 1 and Index <= #Options then
            selectedIndex = Index
            selectedValue = Options[Index]
            SelectedLabel.Text = selectedValue
            createOptionButtons()
            Callback(selectedValue, selectedIndex)
        end
    end
    
    function DropdownAPI:SetCallback(NewCallback)
        if type(NewCallback) == "function" then
            Callback = NewCallback
        elseif type(NewCallback) == "table" and NewCallback.Callback then
            Callback = NewCallback.Callback
        end
    end
    
    function DropdownAPI:GetValue()
        return selectedValue, selectedIndex
    end
    
    function DropdownAPI:SetValue(Value)
        for i, option in ipairs(Options) do
            if option == Value then
                selectedIndex = i
                selectedValue = option
                SelectedLabel.Text = option
                createOptionButtons()
                Callback(selectedValue, selectedIndex)
                return true
            end
        end
        return false
    end
    
    function DropdownAPI:AddOption(Option)
        table.insert(Options, Option)
        createOptionButtons()
        
        if isOpen then
            toggleDropdown()
            task.wait(0.25)
            toggleDropdown()
        end
    end
    
    function DropdownAPI:RemoveOption(Index)
        if Index >= 1 and Index <= #Options then
            table.remove(Options, Index)
            
            -- Ajustar índice selecionado se necessário
            if selectedIndex == Index then
                selectedIndex = math.max(1, Index - 1)
                selectedValue = Options[selectedIndex] or "Select..."
                SelectedLabel.Text = selectedValue
            elseif selectedIndex > Index then
                selectedIndex = selectedIndex - 1
            end
            
            createOptionButtons()
            
            if isOpen then
                toggleDropdown()
                task.wait(0.25)
                toggleDropdown()
            end
        end
    end
    
    function DropdownAPI:ClearOptions()
        Options = {}
        selectedIndex = 1
        selectedValue = "Select..."
        SelectedLabel.Text = selectedValue
        createOptionButtons()
        
        if isOpen then
            toggleDropdown()
        end
    end
    
    function DropdownAPI:GetOptions()
        return Options
    end
    
    function DropdownAPI:IsOpen()
        return isOpen
    end
    
    function DropdownAPI:Open()
        if not isOpen then
            toggleDropdown()
        end
    end
    
    function DropdownAPI:Close()
        if isOpen then
            toggleDropdown()
        end
    end
    
    function DropdownAPI:Destroy()
        if dropdownConnection then
            dropdownConnection:Disconnect()
        end
        DropdownFrame:Destroy()
    end
    
    return DropdownAPI
end

return Dropdown
