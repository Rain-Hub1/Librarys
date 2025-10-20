--!strict
local TweenService = game:GetService("TweenService")

local Tab = {}

function Tab:Create(Container, Info, theme, onTabSelected)
    local Name = Info.Name or "Tab"
    local Icon = Info.Icon
    local Locked = Info.Locked or false
    
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "TabButton"
    TabButton.Size = UDim2.new(0, 80, 0, 30)
    TabButton.BackgroundColor3 = theme.Foreground
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = Container
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = Color3.fromRGB(60, 60, 70)
    TabStroke.Thickness = 1
    TabStroke.Parent = TabButton
    
    -- Content container
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = TabButton
    
    -- Icon (if provided)
    local IconLabel
    if Icon then
        IconLabel = Instance.new("ImageLabel")
        IconLabel.Name = "Icon"
        IconLabel.Size = UDim2.new(0, 16, 0, 16)
        IconLabel.Position = UDim2.new(0, 8, 0.5, -8)
        IconLabel.BackgroundTransparency = 1
        IconLabel.Image = Icon
        IconLabel.ImageColor3 = theme.Text
        IconLabel.Parent = ContentFrame
    end
    
    -- Text label
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "TextLabel"
    TextLabel.Size = UDim2.new(1, Icon and -24 or -16, 1, 0)
    TextLabel.Position = UDim2.new(0, Icon and 24 or 8, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = string.upper(Name)
    TextLabel.TextColor3 = theme.Text
    TextLabel.TextSize = 11 -- Fonte menor
    TextLabel.Font = Enum.Font.GothamSemibold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = ContentFrame
    
    -- Lock icon (if locked)
    local LockIcon
    if Locked then
        LockIcon = Instance.new("ImageLabel")
        LockIcon.Name = "LockIcon"
        LockIcon.Size = UDim2.new(0, 12, 0, 12)
        LockIcon.Position = UDim2.new(1, -16, 0.5, -6)
        LockIcon.BackgroundTransparency = 1
        LockIcon.Image = "rbxassetid://6031229363"
        LockIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        LockIcon.Parent = ContentFrame
    end
    
    local isSelected = false
    
    local function setSelected(selected)
        isSelected = selected
        if selected then
            TabButton.BackgroundColor3 = theme.Accent
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            if IconLabel then
                IconLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
        else
            TabButton.BackgroundColor3 = theme.Foreground
            TextLabel.TextColor3 = theme.Text
            if IconLabel then
                IconLabel.ImageColor3 = theme.Text
            end
        end
    end
    
    -- Hover effects
    TabButton.MouseEnter:Connect(function()
        if not isSelected then
            local tween = TweenService:Create(TabButton, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(
                    math.floor(theme.Foreground.R * 255 + 10),
                    math.floor(theme.Foreground.G * 255 + 10),
                    math.floor(theme.Foreground.B * 255 + 10)
                )
            })
            tween:Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if not isSelected then
            local tween = TweenService:Create(TabButton, TweenInfo.new(0.15), {
                BackgroundColor3 = theme.Foreground
            })
            tween:Play()
        end
    end)
    
    -- Click event
    if not Locked then
        TabButton.MouseButton1Click:Connect(function()
            onTabSelected()
        end)
    end
    
    local TabAPI = {}
    
    function TabAPI:SetSelected(selected)
        setSelected(selected)
    end
    
    function TabAPI:SetLocked(locked)
        Locked = locked
        if Locked and not LockIcon then
            LockIcon = Instance.new("ImageLabel")
            LockIcon.Name = "LockIcon"
            LockIcon.Size = UDim2.new(0, 12, 0, 12)
            LockIcon.Position = UDim2.new(1, -16, 0.5, -6)
            LockIcon.BackgroundTransparency = 1
            LockIcon.Image = "rbxassetid://6031229363"
            LockIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
            LockIcon.Parent = ContentFrame
        elseif not Locked and LockIcon then
            LockIcon:Destroy()
            LockIcon = nil
        end
    end
    
    function TabAPI:SetName(newName)
        TextLabel.Text = string.upper(newName or Name)
    end
    
    function TabAPI:SetIcon(newIcon)
        if newIcon and not IconLabel then
            IconLabel = Instance.new("ImageLabel")
            IconLabel.Name = "Icon"
            IconLabel.Size = UDim2.new(0, 16, 0, 16)
            IconLabel.Position = UDim2.new(0, 8, 0.5, -8)
            IconLabel.BackgroundTransparency = 1
            IconLabel.Image = newIcon
            IconLabel.ImageColor3 = isSelected and Color3.fromRGB(255, 255, 255) or theme.Text
            IconLabel.Parent = ContentFrame
            
            TextLabel.Size = UDim2.new(1, -24, 1, 0)
            TextLabel.Position = UDim2.new(0, 24, 0, 0)
        elseif not newIcon and IconLabel then
            IconLabel:Destroy()
            IconLabel = nil
            
            TextLabel.Size = UDim2.new(1, -16, 1, 0)
            TextLabel.Position = UDim2.new(0, 8, 0, 0)
        elseif newIcon and IconLabel then
            IconLabel.Image = newIcon
        end
    end
    
    function TabAPI:Destroy()
        TabButton:Destroy()
    end
    
    return TabAPI
end

return Tab
