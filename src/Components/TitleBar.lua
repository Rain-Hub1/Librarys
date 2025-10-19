--!strict
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local TitleBar = {}

function TitleBar:Create(Parent, Info)
	local Title = Info.Title or "UI Library"
	local theme = Info.Theme
	
	local Header = Instance.new("Frame")
	Header.Name = "Header"
	Header.Size = UDim2.new(1, 0, 0, 45)
	Header.Position = UDim2.new(0, 0, 0, 0)
	Header.BackgroundColor3 = theme.Foreground
	Header.BackgroundTransparency = 1
	Header.Parent = Parent
	
	local HeaderCorner = Instance.new("UICorner")
	HeaderCorner.CornerRadius = UDim.new(0, 12)
	HeaderCorner.Parent = Header
	
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "TitleLabel"
	TitleLabel.Size = UDim2.new(1, -40, 1, 0)
	TitleLabel.Position = UDim2.new(0, 15, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = Title
	TitleLabel.TextColor3 = theme.Text
	TitleLabel.TextSize = 18
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = Header
	
	local CloseButton = Instance.new("TextButton")
	CloseButton.Name = "CloseButton"
	CloseButton.Size = UDim2.new(0, 30, 0, 30)
	CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
	CloseButton.BackgroundColor3 = theme.Error
	CloseButton.BackgroundTransparency = 1
	CloseButton.Text = "×"
	CloseButton.TextColor3 = theme.Text
	CloseButton.TextSize = 20
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Parent = Header
	
	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(1, 0)
	CloseCorner.Parent = CloseButton
	
	-- Efeitos de hover para o botão fechar
	CloseButton.MouseEnter:Connect(function()
		local tween = TweenService:Create(CloseButton, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.2
		})
		tween:Play()
	end)
	
	CloseButton.MouseLeave:Connect(function()
		local tween = TweenService:Create(CloseButton, TweenInfo.new(0.2), {
			BackgroundTransparency = 1
		})
		tween:Play()
	end)
	
	return {
		Frame = Header,
		TitleLabel = TitleLabel,
		CloseButton = CloseButton
	}
end

function TitleBar:MakeDraggable(guiObject, Header)
	local isDragging = false
	local dragStart: Vector2
	local dragOffset: Vector2
	
	local function startDrag(input)
		isDragging = true
		dragStart = input.Position
		dragOffset = dragStart - guiObject.AbsolutePosition
		
		local tween = TweenService:Create(Header.Frame, TweenInfo.new(0.1), {
			BackgroundTransparency = 0.8
		})
		tween:Play()
	end
	
	local function endDrag(input)
		isDragging = false
		
		local tween = TweenService:Create(Header.Frame, TweenInfo.new(0.1), {
			BackgroundTransparency = 1
		})
		tween:Play()
	end
	
	-- Para PC (Mouse)
	guiObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			startDrag(input)
		end
	end)

	-- Para Mobile (Touch)
	guiObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			startDrag(input)
		end
	end)

	-- Movimento para ambos
	UserInputService.InputChanged:Connect(function(input)
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

	-- Fim do arrasto para ambos
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			endDrag(input)
		end
	end)
end

return TitleBar
