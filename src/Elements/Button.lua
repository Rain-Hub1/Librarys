--!strict
local TweenService = game:GetService("TweenService")

local Button = {}

function Button:Create(Container, Info, theme)
	local Name = Info.Name or "Button"
	local Desc = Info.Desc or ""
	local Color = Info.Color or theme.Accent
	local Callback = Info.Callback or function() end
	
	local ButtonFrame = Instance.new("Frame")
	ButtonFrame.Name = "ButtonFrame"
	ButtonFrame.Size = UDim2.new(1, 0, 0, 0)
	ButtonFrame.BackgroundColor3 = theme.Foreground
	ButtonFrame.BackgroundTransparency = 0
	ButtonFrame.Parent = Container
	
	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 8)
	ButtonCorner.Parent = ButtonFrame
	
	local Button = Instance.new("TextButton")
	Button.Name = "Button"
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.BackgroundTransparency = 1
	Button.Text = ""
	Button.Parent = ButtonFrame
	
	local NameLabel = Instance.new("TextLabel")
	NameLabel.Name = "NameLabel"
	NameLabel.Size = UDim2.new(1, -15, 0, 20)
	NameLabel.Position = UDim2.new(0, 10, 0, 10)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = Name
	NameLabel.TextColor3 = theme.Text
	NameLabel.TextSize = 15
	NameLabel.Font = Enum.Font.GothamBold
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.Parent = ButtonFrame
	
	local DescLabel = Instance.new("TextLabel")
	DescLabel.Name = "DescLabel"
	DescLabel.Size = UDim2.new(1, -15, 0, 0)
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
	DescLabel.Parent = ButtonFrame
	
	-- Ajustar altura
	task.defer(function()
		local descHeight = Desc == "" and 0 or (DescLabel.TextBounds.Y + 5)
		ButtonFrame.Size = UDim2.new(1, 0, 0, 45 + descHeight)
	end)
	
	-- Efeitos de hover
	Button.MouseEnter:Connect(function()
		local tween = TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
			BackgroundColor3 = Color
		})
		tween:Play()
	end)
	
	Button.MouseLeave:Connect(function()
		local tween = TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
			BackgroundColor3 = theme.Foreground
		})
		tween:Play()
	end)
	
	Button.MouseButton1Click:Connect(function()
		Callback()
	end)
	
	local ButtonAPI = {}
	
	function ButtonAPI:SetName(NewName)
		NameLabel.Text = NewName or Name
	end
	
	function ButtonAPI:SetDesc(NewDesc)
		DescLabel.Text = NewDesc or Desc
		task.defer(function()
			local descHeight = NewDesc == "" and 0 or (DescLabel.TextBounds.Y + 5)
			ButtonFrame.Size = UDim2.new(1, 0, 0, 45 + descHeight)
		end)
	end
	
	function ButtonAPI:SetColor(NewColor)
		Color = NewColor or Color
	end
	
	function ButtonAPI:SetCallback(NewCallback)
		if type(NewCallback) == "function" then
			Callback = NewCallback
		elseif type(NewCallback) == "table" and NewCallback.Callback then
			Callback = NewCallback.Callback
		end
	end
	
	function ButtonAPI:Destroy()
		ButtonFrame:Destroy()
	end
	
	return ButtonAPI
end

return Button
