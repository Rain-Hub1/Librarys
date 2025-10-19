--!strict
local Window = {}

function Window:Create(Info, Lib)
	local Info = Info or {}
	local Title = Info.Title or "UI Library"
	local OpenButton = Info.OpenButton
	local ThemeName = Info.Theme or "Darker"
	local Size = Info.Size or {470, 340}
	local Key = Info.Key
	local KeyS = Info.KeyS
	local Parent = Info.Parent or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	
	local theme = Lib.Themes:GetTheme(ThemeName)
	local isOpen = false
	local elements = {}
	local notifications = {}
	
	-- Validar e extrair tamanho
	local windowWidth = tonumber(Size[1]) or 470
	local windowHeight = tonumber(Size[2]) or 340
	
	-- Sistema de Key
	local keyValidated = false
	local keyScreenGui = nil
	
	-- Função para criar a interface principal
	local function createMainInterface()
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "LibWindow"
		ScreenGui.ResetOnSpawn = false
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.Parent = Parent
		
		-- Botão de abrir/fechar (se OpenButton for true)
		local ToggleButton
		if OpenButton == true then
			ToggleButton = Instance.new("TextButton")
			ToggleButton.Name = "ToggleButton"
			ToggleButton.Size = UDim2.new(0, 120, 0, 40)
			ToggleButton.Position = UDim2.new(0, 20, 0, 20)
			ToggleButton.BackgroundColor3 = theme.Accent
			ToggleButton.Text = "Abrir UI"
			ToggleButton.TextColor3 = theme.Text
			ToggleButton.TextSize = 14
			ToggleButton.Font = Enum.Font.GothamBold
			ToggleButton.Parent = ScreenGui
			
			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 8)
			ToggleCorner.Parent = ToggleButton
			
			local ToggleStroke = Instance.new("UIStroke")
			ToggleStroke.Color = Color3.fromRGB(100, 100, 100)
			ToggleStroke.Thickness = 2
			ToggleStroke.Parent = ToggleButton
		end
		
		-- Frame principal
		local MainFrame = Instance.new("Frame")
		MainFrame.Name = "MainFrame"
		MainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
		MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		MainFrame.BackgroundColor3 = theme.Background
		MainFrame.BackgroundTransparency = 1
		MainFrame.Visible = false
		MainFrame.Parent = ScreenGui
		
		-- Efeitos visuais
		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 12)
		UICorner.Parent = MainFrame
		
		local UIStroke = Instance.new("UIStroke")
		UIStroke.Color = theme.Accent
		UIStroke.Thickness = 2
		UIStroke.Transparency = 1
		UIStroke.Parent = MainFrame
		
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
		DropShadow.Parent = MainFrame
		
		-- Header usando TitleBar component
		local Header = Lib.Components.TitleBar:Create(MainFrame, {
			Title = Title,
			Theme = theme
		})
		
		-- Container de conteúdo
		local ContentContainer = Instance.new("ScrollingFrame")
		ContentContainer.Name = "ContentContainer"
		ContentContainer.Size = UDim2.new(1, -20, 1, -65)
		ContentContainer.Position = UDim2.new(0, 10, 0, 55)
		ContentContainer.BackgroundTransparency = 1
		ContentContainer.BorderSizePixel = 0
		ContentContainer.ScrollBarThickness = 4
		ContentContainer.ScrollBarImageColor3 = theme.Accent
		ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
		ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
		ContentContainer.Parent = MainFrame
		
		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.Padding = UDim.new(0, 12)
		UIListLayout.Parent = ContentContainer
		
		-- Sistema de arrastar
		Lib.Components.TitleBar:MakeDraggable(MainFrame, Header)
		
		-- Funções de animação
		local function openWindow()
			if isOpen then return end
			isOpen = true
			MainFrame.Visible = true
			
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			
			local tween = game:GetService("TweenService"):Create(MainFrame, tweenInfo, {
				BackgroundTransparency = 0
			})
			
			local strokeTween = game:GetService("TweenService"):Create(UIStroke, tweenInfo, {
				Transparency = 0
			})
			
			tween:Play()
			strokeTween:Play()
			
			if ToggleButton then
				ToggleButton.Text = "Fechar UI"
			end
		end
		
		local function closeWindow()
			if not isOpen then return end
			isOpen = false
			
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			
			local tween = game:GetService("TweenService"):Create(MainFrame, tweenInfo, {
				BackgroundTransparency = 1
			})
			
			local strokeTween = game:GetService("TweenService"):Create(UIStroke, tweenInfo, {
				Transparency = 1
			})
			
			tween:Play()
			strokeTween:Play()
			
			tween.Completed:Connect(function()
				if not isOpen then
					MainFrame.Visible = false
				end
			end)
			
			if ToggleButton then
				ToggleButton.Text = "Abrir UI"
			end
		end
		
		-- Controle por botão (se OpenButton for true)
		if ToggleButton then
			ToggleButton.MouseButton1Click:Connect(function()
				if isOpen then
					closeWindow()
				else
					openWindow()
				end
			end)
			
			-- Efeitos de hover para o botão toggle
			ToggleButton.MouseEnter:Connect(function()
				local tween = game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.fromRGB(0, 110, 200)
				})
				tween:Play()
			end)
			
			ToggleButton.MouseLeave:Connect(function()
				local tween = game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
					BackgroundColor3 = theme.Accent
				})
				tween:Play()
			end)
		end
		
		-- Evento do botão fechar
		Header.CloseButton.MouseButton1Click:Connect(closeWindow)
		
		-- API pública da janela
		local WindowAPI = {}
		
		-- Componente Paragraph
		function WindowAPI:Paragraph(Info)
			return Lib.Elements.Paragraph:Create(ContentContainer, Info, theme)
		end
		
		-- Componente Button
		function WindowAPI:Button(Info)
			return Lib.Elements.Button:Create(ContentContainer, Info, theme)
		end
		
		-- Componente Toggle
		function WindowAPI:Toggle(Info)
			return Lib.Elements.Toggle:Create(ContentContainer, Info, theme)
		end
		
		-- Componente Dropdown
		function WindowAPI:Dropdown(Info)
			return Lib.Elements.Dropdown:Create(ContentContainer, Info, theme)
		end
		
		-- Função de notificação
		function WindowAPI:Notify(Info)
			Lib.Components.Notify:Create(ScreenGui, Info, theme, notifications)
		end
		
		-- Métodos da janela
		function WindowAPI:Destroy()
			ScreenGui:Destroy()
		end
		
		function WindowAPI:Open()
			openWindow()
		end
		
		function WindowAPI:Close()
			closeWindow()
		end
		
		return WindowAPI
	end
	
	-- Verificar se precisa de key
	if Key == false then
		-- Se Key é false, criar a interface principal diretamente
		return createMainInterface()
	elseif KeyS then
		-- Se KeyS existe, criar a interface de key
		Lib.KeySystem:CreateKeyInterface(KeyS, Parent, function()
			keyValidated = true
			createMainInterface()
		end)
		return {} -- Retornar tabela vazia temporariamente
	else
		-- Caso contrário, criar a interface principal diretamente
		return createMainInterface()
	end
end

return Window
