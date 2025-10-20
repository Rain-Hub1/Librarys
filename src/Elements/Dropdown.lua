--!strict
local TweenService = game:GetService("TweenService")

local Dropdown = {}

function Dropdown:Create(Container, Info, theme)
    local Name = Info.Name or "Dropdown"
    local Desc = Info.Desc or ""
    local Options = Info.Options or {"Opção 1", "Opção 2", "Opção 3"}
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
    DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    DropdownFrame.BackgroundColor3 = theme.Foreground
    DropdownFrame.BackgroundTransparency = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = Container
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownFrame
    
    -- Botão principal do dropdown
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "DropdownButton"
    DropdownButton.Size = UDim2.new(1, 0, 0, 45)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.Parent = DropdownFrame
    
    -- Label do nome
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.Size = UDim2.new(1, -70, 0, 20)
    NameLabel.Position = UDim2.new(0, 10, 0, 10)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = Name
    NameLabel.TextColor3 = theme.Text
    NameLabel.TextSize = 15
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = DropdownFrame
    
    -- Label da descrição
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Name = "DescLabel"
    DescLabel.Size = UDim2.new(1, -70, 0, 0)
    DescLabel.Position = UDim2.new(0, 10, 0, 35)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = Desc
    DescLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    DescLabel.TextSize = 13
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.TextWrapped = true
    DescLabel.AutomaticSize = Enum.AutomaticSize.Y
    DescLabel.Parent = DropdownFrame
    
    -- Seta do dropdown
    local Arrow = Instance.new("TextLabel")
    Arrow.Name = "Arrow"
    Arrow.Size = UDim2.new(0, 20, 0, 20)
    Arrow.Position = UDim2.new(1, -35, 0, 12)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = theme.Text
    Arrow.TextSize = 14
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = DropdownFrame
    
    -- Label do valor selecionado
    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Name = "SelectedLabel"
    SelectedLabel.Size = UDim2.new(0, 100, 0, 20)
    SelectedLabel.Position = UDim2.new(1, -60, 0, 12)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Text = selectedValue
    SelectedLabel.TextColor3 = theme.Text
    SelectedLabel.TextSize = 13
    SelectedLabel.Font = Enum.Font.Gotham
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    SelectedLabel.Parent = DropdownFrame
    
    -- Frame das opções
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Name = "OptionsFrame"
    OptionsFrame.Size = UDim2.new(1, -10, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 5, 0, 45)
    OptionsFrame.BackgroundColor3 = theme.Background
    OptionsFrame.BackgroundTransparency = 0
    OptionsFrame.Visible = false
    OptionsFrame.Parent = DropdownFrame
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 6)
    OptionsCorner.Parent = OptionsFrame
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.Padding = UDim.new(0, 2)
    OptionsLayout.Parent = OptionsFrame
    
    -- Ajustar altura inicial
    local function updateHeight()
        local descHeight = Desc == "" and 0 or (DescLabel.TextBounds.Y + 5)
        local baseHeight = 45 + descHeight
        
        if isOpen then
            local optionHeight = #Options * 32
            DropdownFrame.Size = UDim2.new(1, 0, 0, baseHeight + optionHeight + 5)
        else
            DropdownFrame.Size = UDim2.new(1, 0, 0, baseHeight)
        end
    end
    
    task.defer(updateHeight)
    
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
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.BackgroundColor3 = theme.Foreground
            OptionButton.Text = option
            OptionButton.TextColor3 = theme.Text
            OptionButton.TextSize = 12
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Parent = OptionsFrame
            
            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 4)
            OptionCorner.Parent = OptionButton
            
            -- Efeitos de hover
            OptionButton.MouseEnter:Connect(function()
                if i ~= selectedIndex then
                    local tween = TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = theme.Accent
                    })
                    tween:Play()
                end
            end)
            
            OptionButton.MouseLeave:Connect(function()
                if i ~= selectedIndex then
                    local tween = TweenService:Create(OptionButton, TweenInfo.new(0.2), {
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
                
                -- Atualizar cores das opções
                for j, btn in ipairs(optionButtons) do
                    if j == i then
                        btn.BackgroundColor3 = theme.Success
                    else
                        btn.BackgroundColor3 = theme.Foreground
                    end
                end
                
                Callback(option, i)
                toggleDropdown()
            end)
            
            table.insert(optionButtons, OptionButton)
        end
        
        -- Marcar opção selecionada
        if selectedIndex >= 1 and selectedIndex <= #optionButtons then
            optionButtons[selectedIndex].BackgroundColor3 = theme.Success
        end
    end
    
    createOptionButtons()
    
    -- Função para abrir/fechar dropdown
    local function toggleDropdown()
        isOpen = not isOpen
        
        if isOpen then
            OptionsFrame.Visible = true
            local optionHeight = #Options * 32
            OptionsFrame.Size = UDim2.new(1, -10, 0, optionHeight)
            
            -- Animação de abertura
            local tween = TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(1, 0, 0, 45 + (Desc == "" and 0 or (DescLabel.TextBounds.Y + 5)) + optionHeight + 5)
            })
            tween:Play()
            
            local arrowTween = TweenService:Create(Arrow, TweenInfo.new(0.3), {
                Rotation = 180
            })
            arrowTween:Play()
        else
            -- Animação de fechamento
            local baseHeight = 45 + (Desc == "" and 0 or (DescLabel.TextBounds.Y + 5))
            local tween = TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(1, 0, 0, baseHeight)
            })
            tween:Play()
            
            local arrowTween = TweenService:Create(Arrow, TweenInfo.new(0.3), {
                Rotation = 0
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
    local function closeDropdownOnClickOutside(input)
        if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local absolutePos = DropdownFrame.AbsolutePosition
            local absoluteSize = DropdownFrame.AbsoluteSize
            
            if mousePos.X < absolutePos.X or mousePos.X > absolutePos.X + absoluteSize.X or
               mousePos.Y < absolutePos.Y or mousePos.Y > absolutePos.Y + absoluteSize.Y then
                toggleDropdown()
            end
        end
    end
    
    game:GetService("UserInputService").InputBegan:Connect(closeDropdownOnClickOutside)
    
    -- API do Dropdown
    local DropdownAPI = {}
    
    function DropdownAPI:SetName(NewName)
        NameLabel.Text = NewName or Name
        updateHeight()
    end
    
    function DropdownAPI:SetDesc(NewDesc)
        DescLabel.Text = NewDesc or Desc
        updateHeight()
    end
    
    function DropdownAPI:SetOptions(NewOptions)
        Options = NewOptions or Options
        
        -- Ajustar índice selecionado se necessário
        if selectedIndex > #Options then
            selectedIndex = 1
            selectedValue = Options[1] or "Selecionar"
            SelectedLabel.Text = selectedValue
        end
        
        createOptionButtons()
        updateHeight()
        
        if isOpen then
            toggleDropdown() -- Fechar e reabrir para atualizar altura
            task.wait(0.35)
            toggleDropdown()
        end
    end
    
    function DropdownAPI:SetDefault(Index)
        if Index >= 1 and Index <= #Options then
            selectedIndex = Index
            selectedValue = Options[Index]
            SelectedLabel.Text = selectedValue
            createOptionButtons() -- Recriar para atualizar cores
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
                createOptionButtons() -- Recriar para atualizar cores
                Callback(selectedValue, selectedIndex)
                return true
            end
        end
        return false
    end
    
    function DropdownAPI:AddOption(Option)
        table.insert(Options, Option)
        createOptionButtons()
        updateHeight()
        
        if isOpen then
            toggleDropdown()
            task.wait(0.35)
            toggleDropdown()
        end
    end
    
    function DropdownAPI:RemoveOption(Index)
        if Index >= 1 and Index <= #Options then
            table.remove(Options, Index)
            
            -- Ajustar índice selecionado se necessário
            if selectedIndex == Index then
                selectedIndex = math.max(1, Index - 1)
                selectedValue = Options[selectedIndex] or "Selecionar"
                SelectedLabel.Text = selectedValue
            elseif selectedIndex > Index then
                selectedIndex = selectedIndex - 1
            end
            
            createOptionButtons()
            updateHeight()
            
            if isOpen then
                toggleDropdown()
                task.wait(0.35)
                toggleDropdown()
            end
        end
    end
    
    function DropdownAPI:ClearOptions()
        Options = {}
        selectedIndex = 1
        selectedValue = "Selecionar"
        SelectedLabel.Text = selectedValue
        createOptionButtons()
        updateHeight()
        
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
        DropdownFrame:Destroy()
    end
    
    return DropdownAPI
end

return Dropdown
