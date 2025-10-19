--!strict
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local KeySystem = {}

-- Função para verificar keys remotas
function KeySystem:CheckRemoteKeys(url, keysToCheck)
	local success, result = pcall(function()
		return game:HttpGet(url)
	end)
	
	if success then
		local remoteKeys = {}
		for key in string.gmatch(result, '[%w%-]+') do
			table.insert(remoteKeys, key)
		end
		
		for _, inputKey in ipairs(keysToCheck) do
			for _, remoteKey in ipairs(remoteKeys) do
				if inputKey == remoteKey then
					return true
				end
			end
		end
	end
	
	return false
end

-- Criar interface de key
function KeySystem:CreateKeyInterface(KeyS, Parent, onKeyValidated)
	local keyScreenGui = Instance.new("ScreenGui")
	keyScreenGui.Name = "KeyInterface"
	keyScreenGui.ResetOnSpawn = false
	keyScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	keyScreenGui.Parent = Parent
	
	local keyTheme = KeyS.Theme and self:GetTheme(KeyS.Theme) or self:GetTheme("Darker")
	local keySize = KeyS.Size or {250, 300}
	local keyWidth, keyHeight = keySize[1], keySize[2]
	
	-- Frame principal da key
	local KeyMainFrame = Instance.new("Frame")
	KeyMainFrame.Name = "KeyMainFrame"
	KeyMainFrame.Size = UDim2.new(0, keyWidth, 0, keyHeight)
	KeyMainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	KeyMainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	KeyMainFrame.BackgroundColor3 = keyTheme.Background
	KeyMainFrame.Parent = keyScreenGui
	
	-- Efeitos visuais
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 12)
	UICorner.Parent = KeyMainFrame
	
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = keyTheme.Accent
	UIStroke.Thickness = 2
	UIStroke.Parent = KeyMainFrame
	
	local DropShadow = Instance.new("ImageLabel")
	DropShadow.Name = "DropShadow"
	DropShadow.Size = UDim2.new(1, 0, 1, 0)
	DropShadow.Position = UDim2.new(0, 0, 0, 0)
	DropShadow.BackgroundTransparency = 1
	DropShadow.Image = "rbxassetid://6010260683"
	DropShadow.ImageColor3 = Color3.new(0, 0, 0)
	DropShadow.ImageTransparency = 0.9
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow.Parent = KeyMainFrame
	
	-- Título
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "TitleLabel"
	TitleLabel.Size = UDim2.new(1, -20, 0, 40)
	TitleLabel.Position = UDim2.new(0, 10, 0, 10)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = KeyS.Title or "Enter Key"
	TitleLabel.TextColor3 = keyTheme.Text
	TitleLabel.TextSize = 18
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Parent = KeyMainFrame
	
	-- Campo de entrada
	local KeyTextBox = Instance.new("TextBox")
	KeyTextBox.Name = "KeyTextBox"
	KeyTextBox.Size = UDim2.new(1, -20, 0, 40)
	KeyTextBox.Position = UDim2.new(0, 10, 0, 60)
	KeyTextBox.BackgroundColor3 = keyTheme.Foreground
	KeyTextBox.TextColor3 = keyTheme.Text
	KeyTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	KeyTextBox.PlaceholderText = "Enter your key here..."
	KeyTextBox.Text = ""
	KeyTextBox.TextSize = 14
	KeyTextBox.Font = Enum.Font.Gotham
	KeyTextBox.Parent = KeyMainFrame
	
	local TextBoxCorner = Instance.new("UICorner")
	TextBoxCorner.CornerRadius = UDim.new(0, 8)
	TextBoxCorner.Parent = KeyTextBox
	
	-- Botão de submit
	local SubmitButton = Instance.new("TextButton")
	SubmitButton.Name = "SubmitButton"
	SubmitButton.Size = UDim2.new(1, -20, 0, 40)
	SubmitButton.Position = UDim2.new(0, 10, 0, 110)
	SubmitButton.BackgroundColor3 = keyTheme.Accent
	SubmitButton.Text = "Submit Key"
	SubmitButton.TextColor3 = keyTheme.Text
	SubmitButton.TextSize = 14
	SubmitButton.Font = Enum.Font.GothamBold
	SubmitButton.Parent = KeyMainFrame
	
	local SubmitCorner = Instance.new("UICorner")
	SubmitCorner.CornerRadius = UDim.new(0, 8)
	SubmitCorner.Parent = SubmitButton
	
	-- Botão para obter key
	if KeyS.Url then
		local GetKeyButton = Instance.new("TextButton")
		GetKeyButton.Name = "GetKeyButton"
		GetKeyButton.Size = UDim2.new(1, -20, 0, 40)
		GetKeyButton.Position = UDim2.new(0, 10, 0, 160)
		GetKeyButton.BackgroundColor3 = keyTheme.Success
		GetKeyButton.Text = "Get Key"
		GetKeyButton.TextColor3 = keyTheme.Text
		GetKeyButton.TextSize = 14
		GetKeyButton.Font = Enum.Font.GothamBold
		GetKeyButton.Parent = KeyMainFrame
		
		local GetKeyCorner = Instance.new("UICorner")
		GetKeyCorner.CornerRadius = UDim.new(0, 8)
		GetKeyCorner.Parent = GetKeyButton
		
		GetKeyButton.MouseButton1Click:Connect(function()
			StarterGui:SetCore("OpenBrowserWindow", {
				Url = KeyS.Url
			})
		end)
	end
	
	-- Mensagem de status
	local StatusLabel = Instance.new("TextLabel")
	StatusLabel.Name = "StatusLabel"
	StatusLabel.Size = UDim2.new(1, -20, 0, 30)
	StatusLabel.Position = UDim2.new(0, 10, 1, -40)
	StatusLabel.BackgroundTransparency = 1
	StatusLabel.Text = ""
	StatusLabel.TextColor3 = keyTheme.Text
	StatusLabel.TextSize = 12
	StatusLabel.Font = Enum.Font.Gotham
	StatusLabel.TextWrapped = true
	StatusLabel.Parent = KeyMainFrame
	
	-- Função de validação
	local function validateKey()
		local inputKey = KeyTextBox.Text
		
		if inputKey == "" then
			StatusLabel.Text = "Please enter a key"
			StatusLabel.TextColor3 = keyTheme.Warning
			return
		end
		
		-- Verificar keys locais
		local validKeys = KeyS.Key or {}
		local isValid = false
		
		for _, key in ipairs(validKeys) do
			if inputKey == key then
				isValid = true
				break
			end
		end
		
		-- Verificar keys remotas se houver URL
		if not isValid and KeyS.Url then
			StatusLabel.Text = "Checking remote keys..."
			StatusLabel.TextColor3 = keyTheme.Text
			
			task.spawn(function()
				local remoteValid = self:CheckRemoteKeys(KeyS.Url, {inputKey})
				
				if remoteValid then
					StatusLabel.Text = "Key validated successfully!"
					StatusLabel.TextColor3 = keyTheme.Success
					
					task.wait(1)
					keyScreenGui:Destroy()
					onKeyValidated()
				else
					StatusLabel.Text = "Invalid key! Please check and try again."
					StatusLabel.TextColor3 = keyTheme.Error
				end
			end)
		elseif isValid then
			StatusLabel.Text = "Key validated successfully!"
			StatusLabel.TextColor3 = keyTheme.Success
			
			task.wait(1)
			keyScreenGui:Destroy()
			onKeyValidated()
		else
			StatusLabel.Text = "Invalid key! Please check and try again."
			StatusLabel.TextColor3 = keyTheme.Error
		end
	end
	
	-- Conexões de eventos
	SubmitButton.MouseButton1Click:Connect(validateKey)
	
	KeyTextBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			validateKey()
		end
	end)
	
	-- Efeitos de hover
	SubmitButton.MouseEnter:Connect(function()
		local tween = TweenService:Create(SubmitButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(
				math.floor(keyTheme.Accent.R * 255 * 0.8),
				math.floor(keyTheme.Accent.G * 255 * 0.8),
				math.floor(keyTheme.Accent.B * 255 * 0.8)
			)
		})
		tween:Play()
	end)
	
	SubmitButton.MouseLeave:Connect(function()
		local tween = TweenService:Create(SubmitButton, TweenInfo.new(0.2), {
			BackgroundColor3 = keyTheme.Accent
		})
		tween:Play()
	end)
	
	return keyScreenGui
end

function KeySystem:GetTheme(themeName)
	-- Esta função será substituída quando carregada na Lib principal
	return {
		Background = Color3.fromRGB(15, 15, 20),
		Foreground = Color3.fromRGB(25, 25, 35),
		Text = Color3.fromRGB(240, 240, 240),
		Accent = Color3.fromRGB(0, 130, 220),
		Success = Color3.fromRGB(50, 170, 70),
		Error = Color3.fromRGB(200, 60, 60),
		Warning = Color3.fromRGB(240, 160, 0)
	}
end

return KeySystem
