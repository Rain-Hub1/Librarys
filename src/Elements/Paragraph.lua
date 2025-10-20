--!strict
local Paragraph = {}

function Paragraph:Create(Container, Info, theme)
    local Name = Info.Name or "Paragraph"
    local Desc = Info.Desc or ""
    
    local ParagraphFrame = Instance.new("Frame")
    ParagraphFrame.Name = "ParagraphFrame"
    ParagraphFrame.Size = UDim2.new(1, 0, 0, 0)
    ParagraphFrame.BackgroundColor3 = theme.Foreground
    ParagraphFrame.BackgroundTransparency = 0
    ParagraphFrame.Parent = Container
    
    local ParagraphCorner = Instance.new("UICorner")
    ParagraphCorner.CornerRadius = UDim.new(0, 6)
    ParagraphCorner.Parent = ParagraphFrame
    
    local ParagraphStroke = Instance.new("UIStroke")
    ParagraphStroke.Color = Color3.fromRGB(60, 60, 70)
    ParagraphStroke.Thickness = 1
    ParagraphStroke.Parent = ParagraphFrame
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.Size = UDim2.new(1, -16, 0, 16)
    NameLabel.Position = UDim2.new(0, 8, 0, 6)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = string.upper(Name)
    NameLabel.TextColor3 = theme.Text
    NameLabel.TextSize = 12
    NameLabel.Font = Enum.Font.GothamSemibold
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = ParagraphFrame
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Name = "DescLabel"
    DescLabel.Size = UDim2.new(1, -16, 0, 0)
    DescLabel.Position = UDim2.new(0, 8, 0, 24)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = Desc
    DescLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    DescLabel.TextSize = 10
    NameLabel.Font = Enum.Font.Gotham
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextYAlignment = Enum.TextYAlignment.Top
    DescLabel.TextWrapped = true
    DescLabel.AutomaticSize = Enum.AutomaticSize.Y
    DescLabel.Parent = ParagraphFrame
    
    -- Ajustar altura
    task.defer(function()
        local descHeight = Desc == "" and 0 or (DescLabel.TextBounds.Y + 8)
        ParagraphFrame.Size = UDim2.new(1, 0, 0, 24 + descHeight)
    end)
    
    local ParagraphAPI = {}
    
    function ParagraphAPI:SetName(NewName)
        NameLabel.Text = string.upper(NewName or Name)
    end
    
    function ParagraphAPI:SetDesc(NewDesc)
        DescLabel.Text = NewDesc or Desc
        task.defer(function()
            local descHeight = NewDesc == "" and 0 or (DescLabel.TextBounds.Y + 8)
            ParagraphFrame.Size = UDim2.new(1, 0, 0, 24 + descHeight)
        end)
    end
    
    function ParagraphAPI:Destroy()
        ParagraphFrame:Destroy()
    end
    
    return ParagraphAPI
end

return Paragraph
