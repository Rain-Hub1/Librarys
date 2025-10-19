--!strict
local TweenService = game:GetService("TweenService")

local Dropdown = {}

function Dropdown:Create(Container, Info, theme)
	local Name = Info.Name or "Dropdown"
	local Desc = Info.Desc or ""
	local Options = Info.Options or {}
	local Default = Info.Default or 1
	local Callback = Info.Callback or function() end
	
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
	
	local DropdownButton = Instance.new("TextButton")
	DropdownButton.Name = "DropdownButton"
	DropdownButton.Size = UDim2.new(1, 0, 0, 45)
	DropdownButton.BackgroundTransparency = 1
	DropdownButton.Text = ""
	DropdownButton.Parent = DropdownFrame
	
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
	
	local SelectedLabel = Instance.new("TextLabel")
	SelectedLabel.Name = "SelectedLabel"
	SelectedLabel.Size = UDim2.new(0, 100, 0, 20)
	SelectedLabel.Position = UDim2.new(1, -60, 0, 12)
	SelectedLabel.BackgroundTransparency = 1
	SelectedLabel.Text = Options[Default] or "Select..."
	SelectedLabel.TextColor3 = theme.Text
	SelectedLabel.TextSize = 13
	SelectedLabel.Font = Enum.Font.Gotham
	SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
	SelectedLabel.Parent = DropdownFrame
	
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
	
	-- Criar opções
	local optionButtons = {}
	for i, option in ipairs(Options) do
		local OptionButton = Instance.new("TextButton")
		OptionButton.Name = "OptionButton"
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
		
		OptionButton.MouseEnter:Connect(function()
			local tween = TweenService:Create(OptionButton, TweenInfo.new(0.2), {
				BackgroundColor3 = theme.Accent
			})
			tween:Play()
		end)
		
		OptionButton.MouseLeave:Connect(function()
			local tween = TweenService:Create(OptionButton, TweenInfo.new(0.2), {
				BackgroundColor3 = theme.Foreground
			})
			tween:Play()
		end)
		
		OptionButton.MouseButton1Click:Connect(function()
			SelectedLabel.Text = option
			Callback(option, i)
			toggleDropdown()
		end)
		
		table.insert(optionButtons, OptionButton)
	end
	
	-- Ajustar altura inicial
	task.defer(function()
		local descHeight = Desc == "" and 0 or (DescLabel.TextBounds.Y + 5)
		DropdownFrame.Size = UDim2.new(1, 0, 0, 45 + descHeight)
	end)
	
	local isOpen = false
	
	local function toggleDropdown()
		isOpen = not isOpen
		
		if isOpen then
			OptionsFrame.Visible = true
			local optionHeight = #Options * 32
			OptionsFrame.Size = UDim2.new(1, -10, 0, optionHeight)
			
			local totalHeight = 45 + (Desc == "" and 0 or (DescLabel.TextBounds.Y + 5)) + optionHeight + 5
			local tween = TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {
				Size = UDim2.new(1, 0, 0, totalHeight)
			})
			tween:Play()
			
			local arrowTween = TweenService:Create(Arrow, TweenInfo.new(0.3), {
				Rotation = 180
			})
			arrowTween:Play()
		else
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
	
	DropdownButton.MouseButton1Click:Connect(toggleDropdown)
	
	local DropdownAPI = {}
	
	function DropdownAPI:SetName(NewName)
		NameLabel.Text = NewName or Name
	end
	
	function DropdownAPI:SetDesc(NewDesc)
		DescLabel.Text = NewDesc or Desc
		task.defer(function()
			local descHeight = NewDesc == "" and 0 or (DescLabel.TextBounds.Y + 5)
			local baseHeight = 45 + descHeight
			if isOpen then
				local optionHeight = #Options * 32
				DropdownFrame.Size = UDim2.new(1, 0, 0, baseHeight + optionHeight + 5)
			else
				DropdownFrame.Size = UDim2.new(1, 0, 0, baseHeight)
			end
		end)
	end
	
	function DropdownAPI:SetOptions(NewOptions)
		Options = NewOptions or Options
		
		-- Limpar opções antigas
		for _, button in ipairs(optionButtons) do
			button:Destroy()
		end
		optionButtons = {}
		
		-- Criar novas opções
		for i, option in ipairs(Options) do
			local OptionButton = Instance.new("TextButton")
			OptionButton.Name = "OptionButton"
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
			
			OptionButton.MouseEnter:Connect(function()
				local tween = TweenService:Create(OptionButton, TweenInfo.new(0.2), {
					BackgroundColor3 = theme.Accent
				})
				tween:Play()
			end)
			
			OptionButton.MouseLeave:Connect(function()
				local tween = TweenService:Create(OptionButton, TweenInfo.new(0.2), {
					BackgroundColor3 = theme.Foreground
				})
				tween:Play()
			end)
			
			OptionButton.MouseButton1Click:Connect(function()
				SelectedLabel.Text = option
				Callback(option, i)
				toggleDropdown()
			end)
			
			table.insert(optionButtons, OptionButton)
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
		return SelectedLabel.Text
	end
	
	function DropdownAPI:SetValue(Value)
		if table.find(Options, Value) then
			SelectedLabel.Text = Value
			Callback(Value, table.find(Options, Value))
		end
	end
	
	function DropdownAPI:Destroy()
		DropdownFrame:Destroy()
	end
	
	return DropdownAPI
end

return Dropdown
