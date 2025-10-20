--!strict
local Toggle = {}

function Toggle:Create(Container, Info, theme)
    local Name = Info.Name or "Toggle"
    local Desc = Info.Desc or ""
    local Color = Info.Color or theme.Success
    local Default = Info.Default or false
    local Callback = Info.Callback or function() end
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 0)
    ToggleFrame.BackgroundColor3 = theme.Foreground
    ToggleFrame.BackgroundTransparency = 0
    ToggleFrame.Parent = Container
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
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
    NameLabel.Parent = ToggleFrame
    
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
    DescLabel.Parent = ToggleFrame
    
    local ToggleBackground = Instance.new("Frame")
    ToggleBackground.Name = "ToggleBackground"
    ToggleBackground.Size = UDim2.new(0, 45, 0, 20)
    ToggleBackground.Position = UDim2.new(1, -55, 0, 15)
    ToggleBackground.BackgroundColor3 = Default and Color or theme.Foreground
    ToggleBackground.Parent = ToggleFrame
    
    local ToggleBackgroundCorner = Instance.new("UICorner")
    ToggleBackgroundCorner.CornerRadius = UDim.new(1, 0)
    ToggleBackgroundCorner.Parent = ToggleBackground
    
    local ToggleDot = Instance.new("Frame")
    ToggleDot.Name = "ToggleDot"
    ToggleDot.Size = UDim2.new(0, 16, 0, 16)
    ToggleDot.Position = UDim2.new(0, Default and 25 or 2, 0.5, -8)
    ToggleDot.BackgroundColor3 = theme.Text
    ToggleDot.Parent = ToggleBackground
    
    local ToggleDotCorner = Instance.new("UICorner")
    ToggleDotCorner.CornerRadius = UDim.new(1, 0)
    ToggleDotCorner.Parent = ToggleDot
    
    -- Ajustar altura
    task.defer(function()
        local descHeight = Desc == "" and 0 or (DescLabel.TextBounds.Y + 5)
        ToggleFrame.Size = UDim2.new(1, 0, 0, 45 + descHeight)
    end)
    
    local isToggled = Default
    
    local function updateToggle()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        local backgroundTween = game:GetService("TweenService"):Create(ToggleBackground, tweenInfo, {
            BackgroundColor3 = isToggled and Color or theme.Foreground
        })
        
        local dotTween = game:GetService("TweenService"):Create(ToggleDot, tweenInfo, {
            Position = UDim2.new(0, isToggled and 25 or 2, 0.5, -8)
        })
        
        backgroundTween:Play()
        dotTween:Play()
        
        Callback(isToggled)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
    end)
    
    local ToggleAPI = {}
    
    function ToggleAPI:SetName(NewName)
        NameLabel.Text = NewName or Name
    end
    
    function ToggleAPI:SetDesc(NewDesc)
        DescLabel.Text = NewDesc or Desc
        task.defer(function()
            local descHeight = NewDesc == "" and 0 or (DescLabel.TextBounds.Y + 5)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 45 + descHeight)
        end)
    end
    
    function ToggleAPI:SetColor(NewColor)
        Color = NewColor or Color
        updateToggle()
    end
    
    function ToggleAPI:SetDefault(NewDefault)
        isToggled = NewDefault or Default
        updateToggle()
    end
    
    function ToggleAPI:SetCallback(NewCallback)
        if type(NewCallback) == "function" then
            Callback = NewCallback
        elseif type(NewCallback) == "table" and NewCallback.Callback then
            Callback = NewCallback.Callback
        end
    end
    
    function ToggleAPI:GetValue()
        return isToggled
    end
    
    function ToggleAPI:SetValue(Value)
        isToggled = Value
        updateToggle()
    end
    
    function ToggleAPI:Destroy()
        ToggleFrame:Destroy()
    end
    
    return ToggleAPI
end

return Toggle
