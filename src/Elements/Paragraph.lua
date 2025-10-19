--!strict
local Paragraph = {}

function Paragraph:Create(Container, Info, theme)
	local Name = Info.Name or "Paragraph"
	local Desc = Info.Desc or ""
	
	local ParagraphFrame = Instance.new("Frame")
	ParagraphFrame.Name = "ParagraphFrame"
	ParagraphFrame.Size = UDim2.new(1, 0, 0, 0)
	ParagraphFrame.BackgroundTransparency = 1
	ParagraphFrame.Parent = Container
	
	local NameLabel = Instance.new("TextLabel")
	NameLabel.Name = "NameLabel"
	NameLabel.Size = UDim2.new(1, 0, 0, 20)
	NameLabel.Position = UDim2.new(0, 0, 0, 0)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = Name
	NameLabel.TextColor3 = theme.Text
	NameLabel.TextSize = 16
	NameLabel.Font = Enum.Font.GothamBold
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.Parent = ParagraphFrame
	
	local DescLabel = Instance.new("TextLabel")
	DescLabel.Name = "DescLabel"
	DescLabel.Size = UDim2.new(1, 0, 0, 0)
	DescLabel.Position = UDim2.new(0, 0, 0, 25)
	DescLabel.BackgroundTransparency = 1
	DescLabel.Text = Desc
	DescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	DescLabel.TextSize = 14
	DescLabel.Font = Enum.Font.Gotham
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.TextYAlignment = Enum.TextYAlignment.Top
	DescLabel.TextWrapped = true
	DescLabel.AutomaticSize = Enum.AutomaticSize.Y
	DescLabel.Parent = ParagraphFrame
	
	-- Ajustar altura do frame
	task.defer(function()
		ParagraphFrame.Size = UDim2.new(1, 0, 0, 25 + DescLabel.TextBounds.Y + 5)
	end)
	
	local ParagraphAPI = {}
	
	function ParagraphAPI:SetName(NewName)
		NameLabel.Text = NewName or Name
	end
	
	function ParagraphAPI:SetDesc(NewDesc)
		DescLabel.Text = NewDesc or Desc
		task.defer(function()
			ParagraphFrame.Size = UDim2.new(1, 0, 0, 25 + DescLabel.TextBounds.Y + 5)
		end)
	end
	
	function ParagraphAPI:Destroy()
		ParagraphFrame:Destroy()
	end
	
	return ParagraphAPI
end

return Paragraph
