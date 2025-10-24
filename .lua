local Lib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Utilidades
local function ColorHex(hex)
	local hex = hex:gsub("#", "")
	return Color3.fromRGB(
		tonumber("0x" .. hex:sub(1, 2)),
		tonumber("0x" .. hex:sub(3, 4)),
		tonumber("0x" .. hex:sub(5, 6))
	)
end

local function Tween(obj, props, duration, style, direction)
	local tweenInfo = TweenInfo.new(
		duration or 0.3,
		style or Enum.EasingStyle.Quad,
		direction or Enum.EasingDirection.Out
	)
	local tween = TweenService:Create(obj, tweenInfo, props)
	tween:Play()
	return tween
end

local function MakeDraggable(frame, dragArea)
	local dragging = false
	local dragInput, mousePos, framePos
	
	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = frame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	dragArea.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			Tween(frame, {
				Position = UDim2.new(
					framePos.X.Scale,
					framePos.X.Offset + delta.X,
					framePos.Y.Scale,
					framePos.Y.Offset + delta.Y
				)
			}, 0.1)
		end
	end)
end

local function CreateGlow(parent, color, size, intensity)
	local glow = Instance.new("ImageLabel")
	glow.Name = "Glow"
	glow.BackgroundTransparency = 1
	glow.Image = "rbxassetid://5028857084"
	glow.ImageColor3 = color
	glow.ImageTransparency = 1 - (intensity or 0.3)
	glow.Size = UDim2.new(1, size or 40, 1, size or 40)
	glow.Position = UDim2.new(0.5, 0, 0.5, 0)
	glow.AnchorPoint = Vector2.new(0.5, 0.5)
	glow.ZIndex = 0
	glow.Parent = parent
	return glow
end

local function CreateStroke(parent, color, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Color3.fromRGB(255, 255, 255)
	stroke.Thickness = thickness or 1
	stroke.Transparency = transparency or 0.8
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

local function CreateGradient(parent, colors, rotation)
	local gradient = Instance.new("UIGradient")
	gradient.Color = colors or ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(147, 51, 234)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(59, 130, 246))
	}
	gradient.Rotation = rotation or 45
	gradient.Parent = parent
	return gradient
end

-- Notification System
function Lib:Notify(notifInfo)
	local notifInfo = notifInfo or {}
	
	local NotifContainer = Instance.new("Frame")
	NotifContainer.Name = "Notification"
	NotifContainer.Size = UDim2.new(0, 0, 0, 0)
	NotifContainer.Position = UDim2.new(1, -20, 1, -20)
	NotifContainer.AnchorPoint = Vector2.new(1, 1)
	NotifContainer.BackgroundColor3 = ColorHex("#1A1A28")
	NotifContainer.BorderSizePixel = 0
	NotifContainer.Parent = CoreGui:FindFirstChild("BangUI") or CoreGui
	
	local NotifCorner = Instance.new("UICorner")
	NotifCorner.CornerRadius = UDim.new(0, 8)
	NotifCorner.Parent = NotifContainer
	
	CreateStroke(NotifContainer, ColorHex("#7C3AED"), 1.5, 0.5)
	CreateGlow(NotifContainer, ColorHex("#7C3AED"), 30, 0.3)
	
	local NotifIcon = Instance.new("TextLabel")
	NotifIcon.Size = UDim2.new(0, 40, 0, 40)
	NotifIcon.Position = UDim2.new(0, 10, 0, 10)
	NotifIcon.BackgroundTransparency = 1
	NotifIcon.Text = notifInfo.Icon or "📢"
	NotifIcon.TextSize = 24
	NotifIcon.Parent = NotifContainer
	
	local NotifTitle = Instance.new("TextLabel")
	NotifTitle.Size = UDim2.new(1, -65, 0, 20)
	NotifTitle.Position = UDim2.new(0, 55, 0, 12)
	NotifTitle.BackgroundTransparency = 1
	NotifTitle.Text = notifInfo.Title or "Notification"
	NotifTitle.TextColor3 = ColorHex("#FFFFFF")
	NotifTitle.TextSize = 14
	NotifTitle.Font = Enum.Font.GothamBold
	NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
	NotifTitle.Parent = NotifContainer
	
	local NotifDesc = Instance.new("TextLabel")
	NotifDesc.Size = UDim2.new(1, -65, 0, 18)
	NotifDesc.Position = UDim2.new(0, 55, 0, 32)
	NotifDesc.BackgroundTransparency = 1
	NotifDesc.Text = notifInfo.Description or "This is a notification"
	NotifDesc.TextColor3 = ColorHex("#A0A0A0")
	NotifDesc.TextSize = 11
	NotifDesc.Font = Enum.Font.Gotham
	NotifDesc.TextXAlignment = Enum.TextXAlignment.Left
	NotifDesc.TextWrapped = true
	NotifDesc.Parent = NotifContainer
	
	local ProgressBar = Instance.new("Frame")
	ProgressBar.Size = UDim2.new(1, 0, 0, 3)
	ProgressBar.Position = UDim2.new(0, 0, 1, -3)
	ProgressBar.BackgroundColor3 = ColorHex("#7C3AED")
	ProgressBar.BorderSizePixel = 0
	ProgressBar.Parent = NotifContainer
	
	CreateGradient(ProgressBar, ColorSequence.new{
		ColorSequenceKeypoint.new(0, ColorHex("#A855F7")),
		ColorSequenceKeypoint.new(1, ColorHex("#6366F1"))
	}, 90)
	
	Tween(NotifContainer, {
		Size = UDim2.new(0, 320, 0, 60)
	}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	
	local duration = notifInfo.Duration or 5
	Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)
	
	task.wait(duration)
	
	Tween(NotifContainer, {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(1, 0, 1, -20)
	}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	
	task.wait(0.3)
	NotifContainer:Destroy()
end

-- FPS Counter
function Lib:CreateFPSCounter(window)
	local FPSFrame = Instance.new("Frame")
	FPSFrame.Name = "FPSCounter"
	FPSFrame.Size = UDim2.new(0, 80, 0, 30)
	FPSFrame.Position = UDim2.new(1, -90, 0, 10)
	FPSFrame.BackgroundColor3 = ColorHex("#1A1A28")
	FPSFrame.BorderSizePixel = 0
	FPSFrame.ZIndex = 10
	FPSFrame.Parent = window
	
	local FPSCorner = Instance.new("UICorner")
	FPSCorner.CornerRadius = UDim.new(0, 6)
	FPSCorner.Parent = FPSFrame
	
	CreateStroke(FPSFrame, ColorHex("#7C3AED"), 1, 0.5)
	
	local FPSLabel = Instance.new("TextLabel")
	FPSLabel.Size = UDim2.new(1, 0, 1, 0)
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.Text = "60 FPS"
	FPSLabel.TextColor3 = ColorHex("#10B981")
	FPSLabel.TextSize = 12
	FPSLabel.Font = Enum.Font.GothamBold
	FPSLabel.Parent = FPSFrame
	
	local lastTime = tick()
	local frameCount = 0
	
	RunService.Heartbeat:Connect(function()
		frameCount = frameCount + 1
		local currentTime = tick()
		
		if currentTime - lastTime >= 1 then
			local fps = frameCount
			FPSLabel.Text = fps .. " FPS"
			
			if fps >= 55 then
				FPSLabel.TextColor3 = ColorHex("#10B981")
			elseif fps >= 30 then
				FPSLabel.TextColor3 = ColorHex("#F59E0B")
			else
				FPSLabel.TextColor3 = ColorHex("#EF4444")
			end
			
			frameCount = 0
			lastTime = currentTime
		end
	end)
end

-- Watermark
function Lib:CreateWatermark(text)
	local Watermark = Instance.new("ScreenGui")
	Watermark.Name = "Watermark"
	Watermark.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Watermark.ResetOnSpawn = false
	Watermark.Parent = CoreGui
	
	local WatermarkFrame = Instance.new("Frame")
	WatermarkFrame.Size = UDim2.new(0, 200, 0, 25)
	WatermarkFrame.Position = UDim2.new(0, 10, 0, 10)
	WatermarkFrame.BackgroundColor3 = ColorHex("#1A1A28")
	WatermarkFrame.BorderSizePixel = 0
	WatermarkFrame.BackgroundTransparency = 0.2
	WatermarkFrame.Parent = Watermark
	
	local WaterCorner = Instance.new("UICorner")
	WaterCorner.CornerRadius = UDim.new(0, 6)
	WaterCorner.Parent = WatermarkFrame
	
	CreateStroke(WatermarkFrame, ColorHex("#7C3AED"), 1, 0.5)
	
	local WaterLabel = Instance.new("TextLabel")
	WaterLabel.Size = UDim2.new(1, -10, 1, 0)
	WaterLabel.Position = UDim2.new(0, 5, 0, 0)
	WaterLabel.BackgroundTransparency = 1
	WaterLabel.Text = text or "Bang UI | " .. LocalPlayer.Name
	WaterLabel.TextColor3 = ColorHex("#FFFFFF")
	WaterLabel.TextSize = 11
	WaterLabel.Font = Enum.Font.GothamBold
	WaterLabel.TextXAlignment = Enum.TextXAlignment.Left
	WaterLabel.Parent = WatermarkFrame
	
	CreateGradient(WaterLabel, ColorSequence.new{
		ColorSequenceKeypoint.new(0, ColorHex("#FFFFFF")),
		ColorSequenceKeypoint.new(1, ColorHex("#A855F7"))
	}, 0)
	
	spawn(function()
		while WatermarkFrame.Parent do
			local time = os.date("%H:%M:%S")
			WaterLabel.Text = (text or "Bang UI") .. " | " .. time
			task.wait(1)
		end
	end)
end

-- Loading Screen
function Lib:CreateLoader(duration)
	local LoaderGui = Instance.new("ScreenGui")
	LoaderGui.Name = "Loader"
	LoaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	LoaderGui.Parent = CoreGui
	
	local LoaderBg = Instance.new("Frame")
	LoaderBg.Size = UDim2.new(1, 0, 1, 0)
	LoaderBg.BackgroundColor3 = ColorHex("#0F0F1A")
	LoaderBg.BorderSizePixel = 0
	LoaderBg.Parent = LoaderGui
	
	local LoaderFrame = Instance.new("Frame")
	LoaderFrame.Size = UDim2.new(0, 300, 0, 150)
	LoaderFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
	LoaderFrame.BackgroundColor3 = ColorHex("#181825")
	LoaderFrame.BorderSizePixel = 0
	LoaderFrame.Parent = LoaderBg
	
	local LoaderCorner = Instance.new("UICorner")
	LoaderCorner.CornerRadius = UDim.new(0, 12)
	LoaderCorner.Parent = LoaderFrame
	
	CreateStroke(LoaderFrame, ColorHex("#7C3AED"), 2, 0.5)
	CreateGlow(LoaderFrame, ColorHex("#7C3AED"), 50, 0.3)
	
	local LoaderTitle = Instance.new("TextLabel")
	LoaderTitle.Size = UDim2.new(1, 0, 0, 40)
	LoaderTitle.Position = UDim2.new(0, 0, 0, 20)
	LoaderTitle.BackgroundTransparency = 1
	LoaderTitle.Text = "BANG UI"
	LoaderTitle.TextColor3 = ColorHex("#FFFFFF")
	LoaderTitle.TextSize = 24
	LoaderTitle.Font = Enum.Font.GothamBold
	LoaderTitle.Parent = LoaderFrame
	
	CreateGradient(LoaderTitle, ColorSequence.new{
		ColorSequenceKeypoint.new(0, ColorHex("#FFFFFF")),
		ColorSequenceKeypoint.new(1, ColorHex("#A855F7"))
	}, 0)
	
	local LoaderStatus = Instance.new("TextLabel")
	LoaderStatus.Size = UDim2.new(1, 0, 0, 20)
	LoaderStatus.Position = UDim2.new(0, 0, 0, 65)
	LoaderStatus.BackgroundTransparency = 1
	LoaderStatus.Text = "Loading..."
	LoaderStatus.TextColor3 = ColorHex("#A0A0A0")
	LoaderStatus.TextSize = 12
	LoaderStatus.Font = Enum.Font.Gotham
	LoaderStatus.Parent = LoaderFrame
	
	local ProgressBarBg = Instance.new("Frame")
	ProgressBarBg.Size = UDim2.new(0, 260, 0, 6)
	ProgressBarBg.Position = UDim2.new(0.5, -130, 0, 100)
	ProgressBarBg.BackgroundColor3 = ColorHex("#2A2A3C")
	ProgressBarBg.BorderSizePixel = 0
	ProgressBarBg.Parent = LoaderFrame
	
	local ProgressCorner = Instance.new("UICorner")
	ProgressCorner.CornerRadius = UDim.new(1, 0)
	ProgressCorner.Parent = ProgressBarBg
	
	local ProgressBar = Instance.new("Frame")
	ProgressBar.Size = UDim2.new(0, 0, 1, 0)
	ProgressBar.BackgroundColor3 = ColorHex("#7C3AED")
	ProgressBar.BorderSizePixel = 0
	ProgressBar.Parent = ProgressBarBg
	
	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1, 0)
	BarCorner.Parent = ProgressBar
	
	CreateGradient(ProgressBar, ColorSequence.new{
		ColorSequenceKeypoint.new(0, ColorHex("#A855F7")),
		ColorSequenceKeypoint.new(1, ColorHex("#6366F1"))
	}, 90)
	
	local LoaderSpinner = Instance.new("ImageLabel")
	LoaderSpinner.Size = UDim2.new(0, 30, 0, 30)
	LoaderSpinner.Position = UDim2.new(0.5, -15, 0, 115)
	LoaderSpinner.BackgroundTransparency = 1
	LoaderSpinner.Image = "rbxassetid://4965945816"
	LoaderSpinner.ImageColor3 = ColorHex("#7C3AED")
	LoaderSpinner.Parent = LoaderFrame
	
	spawn(function()
		while LoaderSpinner.Parent do
			Tween(LoaderSpinner, {Rotation = 360}, 2, Enum.EasingStyle.Linear)
			task.wait(2)
			LoaderSpinner.Rotation = 0
		end
	end)
	
	local stages = {
		"Initializing...",
		"Loading components...",
		"Setting up interface...",
		"Finalizing..."
	}
	
	local stageDuration = duration / #stages
	
	for i, stage in ipairs(stages) do
		LoaderStatus.Text = stage
		Tween(ProgressBar, {
			Size = UDim2.new(i / #stages, 0, 1, 0)
		}, stageDuration, Enum.EasingStyle.Quad)
		task.wait(stageDuration)
	end
	
	LoaderStatus.Text = "Complete!"
	task.wait(0.5)
	
	Tween(LoaderBg, {BackgroundTransparency = 1}, 0.5)
	Tween(LoaderFrame, {BackgroundTransparency = 1}, 0.5)
	Tween(LoaderTitle, {TextTransparency = 1}, 0.5)
	Tween(LoaderStatus, {TextTransparency = 1}, 0.5)
	Tween(ProgressBarBg, {BackgroundTransparency = 1}, 0.5)
	Tween(ProgressBar, {BackgroundTransparency = 1}, 0.5)
	Tween(LoaderSpinner, {ImageTransparency = 1}, 0.5)
	
	task.wait(0.5)
	LoaderGui:Destroy()
end

-- Theme System
Lib.Themes = {
	Dark = {
		Background = ColorHex("#0F0F1A"),
		Secondary = ColorHex("#181825"),
		Accent = ColorHex("#7C3AED"),
		Text = ColorHex("#FFFFFF"),
		SubText = ColorHex("#A0A0A0")
	},
	Blue = {
		Background = ColorHex("#0A0E1A"),
		Secondary = ColorHex("#131A2E"),
		Accent = ColorHex("#3B82F6"),
		Text = ColorHex("#FFFFFF"),
		SubText = ColorHex("#94A3B8")
	},
	Green = {
		Background = ColorHex("#0A1A0F"),
		Secondary = ColorHex("#132E1A"),
		Accent = ColorHex("#10B981"),
		Text = ColorHex("#FFFFFF"),
		SubText = ColorHex("#86EFAC")
	},
	Red = {
		Background = ColorHex("#1A0A0F"),
		Secondary = ColorHex("#2E131A"),
		Accent = ColorHex("#EF4444"),
		Text = ColorHex("#FFFFFF"),
		SubText = ColorHex("#FCA5A5")
	},
	Purple = {
		Background = ColorHex("#130A1A"),
		Secondary = ColorHex("#1E132E"),
		Accent = ColorHex("#A855F7"),
		Text = ColorHex("#FFFFFF"),
		SubText = ColorHex("#D8B4FE")
	},
	Cyber = {
		Background = ColorHex("#000000"),
		Secondary = ColorHex("#0A0A0A"),
		Accent = ColorHex("#00FF88"),
		Text = ColorHex("#00FF88"),
		SubText = ColorHex("#00AA66")
	}
}

function Lib:SetTheme(themeName, window)
	local theme = Lib.Themes[themeName]
	if not theme then return end
	
	if window then
		Tween(window, {BackgroundColor3 = theme.Background}, 0.5)
	end
	
	Lib:Notify({
		Title = "Theme Changed",
		Description = "Theme set to " .. themeName,
		Icon = "🎨",
		Duration = 2
	})
end

function Lib:Window(Info)
	local Info = Info or {}
	local WindowLib = {}
	
	if CoreGui:FindFirstChild("BangUI") then
		CoreGui.BangUI:Destroy()
	end
	
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "BangUI"
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = CoreGui
	
	local Window = Instance.new("Frame")
	Window.Name = "MainWindow"
	Window.Size = UDim2.new(0, 580, 0, 420)
	Window.Position = UDim2.new(0.5, -290, 0.5, -210)
	Window.BackgroundColor3 = Info.BackgroundColor or ColorHex("#0F0F1A")
	Window.BorderSizePixel = 0
	Window.ClipsDescendants = true
	Window.Parent = ScreenGui
	
	local WindowCorner = Instance.new("UICorner")
	WindowCorner.CornerRadius = UDim.new(0, 12)
	WindowCorner.Parent = Window
	
	CreateStroke(Window, ColorHex("#7C3AED"), 1.5, 0.7)
	CreateGlow(Window, ColorHex("#7C3AED"), 60, 0.15)
	
	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "Shadow"
	Shadow.BackgroundTransparency = 1
	Shadow.Image = "rbxassetid://5554236805"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ImageTransparency = 0.7
	Shadow.Size = UDim2.new(1, 30, 1, 30)
	Shadow.Position = UDim2.new(0, -15, 0, -15)
	Shadow.ZIndex = -1
	Shadow.Parent = Window
	
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Size = UDim2.new(1, 0, 0, 50)
	TitleBar.BackgroundColor3 = ColorHex("#181825")
	TitleBar.BorderSizePixel = 0
	TitleBar.Parent = Window
	
	local TitleBarCorner = Instance.new("UICorner")
	TitleBarCorner.CornerRadius = UDim.new(0, 12)
	TitleBarCorner.Parent = TitleBar
	
	local TitleBarBottom = Instance.new("Frame")
	TitleBarBottom.Size = UDim2.new(1, 0, 0, 12)
	TitleBarBottom.Position = UDim2.new(0, 0, 1, -12)
	TitleBarBottom.BackgroundColor3 = ColorHex("#181825")
	TitleBarBottom.BorderSizePixel = 0
	TitleBarBottom.Parent = TitleBar
	
	CreateGradient(TitleBar, ColorSequence.new{
		ColorSequenceKeypoint.new(0, ColorHex("#1E1E2E")),
		ColorSequenceKeypoint.new(1, ColorHex("#181825"))
	}, 90)
	
	local TitleIcon = Instance.new("Frame")
	TitleIcon.Name = "Icon"
	TitleIcon.Size = UDim2.new(0, 32, 0, 32)
	TitleIcon.Position = UDim2.new(0, 12, 0.5, -16)
	TitleIcon.BackgroundColor3 = ColorHex("#7C3AED")
	TitleIcon.BorderSizePixel = 0
	TitleIcon.Parent = TitleBar
	
	local IconCorner = Instance.new("UICorner")
	IconCorner.CornerRadius = UDim.new(0, 8)
	IconCorner.Parent = TitleIcon
	
	CreateGradient(TitleIcon, ColorSequence.new{
		ColorSequenceKeypoint.new(0, ColorHex("#A855F7")),
		ColorSequenceKeypoint.new(1, ColorHex("#6366F1"))
	}, 135)
	
	local IconGlow = CreateGlow(TitleIcon, ColorHex("#A855F7"), 20, 0.4)
	
	spawn(function()
		while TitleIcon.Parent do
			Tween(IconGlow, {ImageTransparency = 0.2}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1.5)
			Tween(IconGlow, {ImageTransparency = 0.6}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1.5)
		end
	end)
	
	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(0, 200, 1, 0)
	Title.Position = UDim2.new(0, 52, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = Info.Title or "Bang UI"
	Title.TextColor3 = ColorHex("#E0E0E0")
	Title.TextSize = 18
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TitleBar
	
	CreateGradient(Title, ColorSequence.new{
		ColorSequenceKeypoint.new(0, ColorHex("#FFFFFF")),
		ColorSequenceKeypoint.new(1, ColorHex("#A855F7"))
	}, 0)
	
	local Subtitle = Instance.new("TextLabel")
	Subtitle.Name = "Subtitle"
	Subtitle.Size = UDim2.new(0, 200, 0, 15)
	Subtitle.Position = UDim2.new(0, 52, 0, 28)
	Subtitle.BackgroundTransparency = 1
	Subtitle.Text = Info.Subtitle or "v1.0.0"
	Subtitle.TextColor3 = ColorHex("#808080")
	Subtitle.TextSize = 12
	Subtitle.Font = Enum.Font.Gotham
	Subtitle.TextXAlignment = Enum.TextXAlignment.Left
	Subtitle.Parent = TitleBar
	
	local ControlsContainer = Instance.new("Frame")
	ControlsContainer.Name = "Controls"
	ControlsContainer.Size = UDim2.new(0, 100, 0, 30)
	ControlsContainer.Position = UDim2.new(1, -112, 0.5, -15)
	ControlsContainer.BackgroundTransparency = 1
	ControlsContainer.Parent = TitleBar
	
	local ControlsLayout = Instance.new("UIListLayout")
	ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
	ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	ControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	ControlsLayout.Padding = UDim.new(0, 8)
	ControlsLayout.Parent = ControlsContainer
	
	local MinimizeBtn = Instance.new("TextButton")
	MinimizeBtn.Name = "Minimize"
	MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
	MinimizeBtn.BackgroundColor3 = ColorHex("#2A2A3C")
	MinimizeBtn.Text = "−"
	MinimizeBtn.TextColor3 = ColorHex("#A0A0A0")
	MinimizeBtn.TextSize = 20
	MinimizeBtn.Font = Enum.Font.GothamBold
	MinimizeBtn.BorderSizePixel = 0
	MinimizeBtn.Parent = ControlsContainer
	
	local MinimizeCorner = Instance.new("UICorner")
	MinimizeCorner.CornerRadius = UDim.new(0, 6)
	MinimizeCorner.Parent = MinimizeBtn
	
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Name = "Close"
	CloseBtn.Size = UDim2.new(0, 30, 0, 30)
	CloseBtn.BackgroundColor3 = ColorHex("#2A2A3C")
	CloseBtn.Text = "×"
	CloseBtn.TextColor3 = ColorHex("#EF4444")
	CloseBtn.TextSize = 24
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.BorderSizePixel = 0
	CloseBtn.Parent = ControlsContainer
	
	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, 6)
	CloseCorner.Parent = CloseBtn
	
	local function SetupButtonHover(button, hoverColor, clickColor)
		local originalColor = button.BackgroundColor3
		
		button.MouseEnter:Connect(function()
			Tween(button, {BackgroundColor3 = hoverColor}, 0.2)
		end)
		
		button.MouseLeave:Connect(function()
			Tween(button, {BackgroundColor3 = originalColor}, 0.2)
		end)
		
		button.MouseButton1Down:Connect(function()
			Tween(button, {BackgroundColor3 = clickColor}, 0.1)
		end)
		
		button.MouseButton1Up:Connect(function()
			Tween(button, {BackgroundColor3 = hoverColor}, 0.1)
		end)
	end
	
	SetupButtonHover(MinimizeBtn, ColorHex("#3A3A4C"), ColorHex("#4A4A5C"))
	SetupButtonHover(CloseBtn, ColorHex("#3A2A2C"), ColorHex("#4A3A3C"))
	
	local StatusIndicator = Instance.new("Frame")
	StatusIndicator.Name = "Status"
	StatusIndicator.Size = UDim2.new(0, 8, 0, 8)
	StatusIndicator.Position = UDim2.new(1, -20, 0.5, -4)
	StatusIndicator.BackgroundColor3 = ColorHex("#10B981")
	StatusIndicator.BorderSizePixel = 0
	StatusIndicator.Parent = TitleBar
	
	local StatusCorner = Instance.new("UICorner")
	StatusCorner.CornerRadius = UDim.new(1, 0)
	StatusCorner.Parent = StatusIndicator
	
	local StatusGlow = CreateGlow(StatusIndicator, ColorHex("#10B981"), 15, 0.5)
	
	spawn(function()
		while StatusIndicator.Parent do
			Tween(StatusIndicator, {BackgroundTransparency = 0.3}, 1, Enum.EasingStyle.Sine)
			Tween(StatusGlow, {ImageTransparency = 0.3}, 1, Enum.EasingStyle.Sine)
			task.wait(1)
			Tween(StatusIndicator, {BackgroundTransparency = 0}, 1, Enum.EasingStyle.Sine)
			Tween(StatusGlow, {ImageTransparency = 0.5}, 1, Enum.EasingStyle.Sine)
			task.wait(1)
		end
	end)
	
	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "Content"
	ContentArea.Size = UDim2.new(1, -20, 1, -70)
	ContentArea.Position = UDim2.new(0, 10, 0, 60)
	ContentArea.BackgroundTransparency = 1
	ContentArea.Parent = Window
	
	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Size = UDim2.new(0, 140, 1, 0)
	Sidebar.BackgroundColor3 = ColorHex("#181825")
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = ContentArea
	
	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, 8)
	SidebarCorner.Parent = Sidebar
	
	CreateStroke(Sidebar, ColorHex("#2A2A3C"), 1, 0.5)
	
	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Name = "TabContainer"
	TabContainer.Size = UDim2.new(1, -10, 1, -10)
	TabContainer.Position = UDim2.new(0, 5, 0, 5)
	TabContainer.BackgroundTransparency = 1
	TabContainer.BorderSizePixel = 0
	TabContainer.ScrollBarThickness = 4
	TabContainer.ScrollBarImageColor3 = ColorHex("#7C3AED")
	TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabContainer.Parent = Sidebar
	
	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Padding = UDim.new(0, 6)
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Parent = TabContainer
	
	TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
	end)
	
	local PageContainer = Instance.new("Frame")
	PageContainer.Name = "Pages"
	PageContainer.Size = UDim2.new(1, -150, 1, 0)
	PageContainer.Position = UDim2.new(0, 150, 0, 0)
	PageContainer.BackgroundColor3 = ColorHex("#1A1A28")
	PageContainer.BorderSizePixel = 0
	PageContainer.Parent = ContentArea
	
	local PageCorner = Instance.new("UICorner")
	PageCorner.CornerRadius = UDim.new(0, 8)
	PageCorner.Parent = PageContainer
	
	CreateStroke(PageContainer, ColorHex("#2A2A3C"), 1, 0.5)
	
	MakeDraggable(Window, TitleBar)
	
	CloseBtn.MouseButton1Click:Connect(function()
		Tween(Window, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		task.wait(0.3)
		ScreenGui:Destroy()
	end)
	
	local minimized = false
	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			Tween(Window, {Size = UDim2.new(0, 580, 0, 50)}, 0.3)
			MinimizeBtn.Text = "□"
		else
			Tween(Window, {Size = UDim2.new(0, 580, 0, 420)}, 0.3)
			MinimizeBtn.Text = "−"
		end
	end)
	
	Window.Size = UDim2.new(0, 0, 0, 0)
	Window.BackgroundTransparency = 1
	
	Tween(Window, {
		Size = UDim2.new(0, 580, 0, 420),
		BackgroundTransparency = 0
	}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	
	WindowLib.CurrentTab = nil
	WindowLib.Tabs = {}
	WindowLib.Window = Window
	
	function WindowLib:CreateTab(tabInfo)
		local tabInfo = tabInfo or {}
		local TabLib = {}
		
		local TabButton = Instance.new("TextButton")
		TabButton.Name = tabInfo.Name or "Tab"
		TabButton.Size = UDim2.new(1, 0, 0, 36)
		TabButton.BackgroundColor3 = ColorHex("#2A2A3C")
		TabButton.BackgroundTransparency = 0.5
		TabButton.BorderSizePixel = 0
		TabButton.Text = ""
		TabButton.Parent = TabContainer
		
		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 6)
		TabCorner.Parent = TabButton
		
		local TabIcon = Instance.new("TextLabel")
		TabIcon.Size = UDim2.new(0, 30, 0, 30)
		TabIcon.Position = UDim2.new(0, 5, 0.5, -15)
		TabIcon.BackgroundTransparency = 1
		TabIcon.Text = tabInfo.Icon or "📋"
		TabIcon.TextSize = 18
		TabIcon.Parent = TabButton
		
		local TabLabel = Instance.new("TextLabel")
		TabLabel.Size = UDim2.new(1, -40, 1, 0)
		TabLabel.Position = UDim2.new(0, 40, 0, 0)
		TabLabel.BackgroundTransparency = 1
		TabLabel.Text = tabInfo.Name or "Tab"
		TabLabel.TextColor3 = ColorHex("#A0A0A0")
		TabLabel.TextSize = 13
		TabLabel.Font = Enum.Font.GothamMedium
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabLabel.Parent = TabButton
		
		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = tabInfo.Name or "Page"
		TabPage.Size = UDim2.new(1, -20, 1, -20)
		TabPage.Position = UDim2.new(0, 10, 0, 10)
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.ScrollBarThickness = 4
		TabPage.ScrollBarImageColor3 = ColorHex("#7C3AED")
		TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabPage.Visible = false
		TabPage.Parent = PageContainer
		
		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Padding = UDim.new(0, 10)
		PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		PageLayout.Parent = TabPage
		
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
		end)
		
		TabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(WindowLib.Tabs) do
				tab.Button.BackgroundTransparency = 0.5
				tab.Label.TextColor3 = ColorHex("#A0A0A0")
				tab.Page.Visible = false
			end
			
			TabButton.BackgroundTransparency = 0
			TabLabel.TextColor3 = ColorHex("#FFFFFF")
			TabPage.Visible = true
			WindowLib.CurrentTab = TabLib
			
			Tween(TabButton, {BackgroundColor3 = ColorHex("#7C3AED")}, 0.2)
		end)
		
		TabLib.Button = TabButton
		TabLib.Label = TabLabel
		TabLib.Page = TabPage
		
		table.insert(WindowLib.Tabs, TabLib)
		
		if #WindowLib.Tabs == 1 then
			TabButton.BackgroundTransparency = 0
			TabButton.BackgroundColor3 = ColorHex("#7C3AED")
			TabLabel.TextColor3 = ColorHex("#FFFFFF")
			TabPage.Visible = true
			WindowLib.CurrentTab = TabLib
		end
		
		function TabLib:CreateButton(btnInfo)
			local btnInfo = btnInfo or {}
			
			local ButtonFrame = Instance.new("Frame")
			ButtonFrame.Name = "Button"
			ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
			ButtonFrame.BackgroundColor3 = ColorHex("#212130")
			ButtonFrame.BorderSizePixel = 0
			ButtonFrame.Parent = TabPage
			
			local BtnCorner = Instance.new("UICorner")
			BtnCorner.CornerRadius = UDim.new(0, 6)
			BtnCorner.Parent = ButtonFrame
			
			CreateStroke(ButtonFrame, ColorHex("#2A2A3C"), 1, 0.6)
			
			local Button = Instance.new("TextButton")
			Button.Size = UDim2.new(1, -10, 1, -10)
			Button.Position = UDim2.new(0, 5, 0, 5)
			Button.BackgroundTransparency = 1
			Button.Text = btnInfo.Name or "Button"
			Button.TextColor3 = ColorHex("#E0E0E0")
			Button.TextSize = 14
			Button.Font = Enum.Font.GothamMedium
			Button.Parent = ButtonFrame
			
			Button.MouseEnter:Connect(function()
				Tween(ButtonFrame, {BackgroundColor3 = ColorHex("#2A2A40")}, 0.2)
			end)
			
			Button.MouseLeave:Connect(function()
				Tween(ButtonFrame, {BackgroundColor3 = ColorHex("#212130")}, 0.2)
			end)
			
			Button.MouseButton1Click:Connect(function()
				Tween(ButtonFrame, {BackgroundColor3 = ColorHex("#7C3AED")}, 0.1)
				task.wait(0.1)
				Tween(ButtonFrame, {BackgroundColor3 = ColorHex("#2A2A40")}, 0.1)
				
				if btnInfo.Callback then
					btnInfo.Callback()
				end
			end)
		end
		
		function TabLib:CreateToggle(toggleInfo)
			local toggleInfo = toggleInfo or {}
			local toggled = toggleInfo.Default or false
			
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = "Toggle"
			ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
			ToggleFrame.BackgroundColor3 = ColorHex("#212130")
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Parent = TabPage
			
			local TglCorner = Instance.new("UICorner")
			TglCorner.CornerRadius = UDim.new(0, 6)
			TglCorner.Parent = ToggleFrame
			
			CreateStroke(ToggleFrame, ColorHex("#2A2A3C"), 1, 0.6)
			
			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -60, 1, 0)
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = toggleInfo.Name or "Toggle"
			Label.TextColor3 = ColorHex("#E0E0E0")
			Label.TextSize = 14
			Label.Font = Enum.Font.GothamMedium
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = ToggleFrame
			
			local ToggleButton = Instance.new("TextButton")
			ToggleButton.Size = UDim2.new(0, 40, 0, 20)
			ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
			ToggleButton.BackgroundColor3 = ColorHex("#2A2A3C")
			ToggleButton.BorderSizePixel = 0
			ToggleButton.Text = ""
			ToggleButton.Parent = ToggleFrame
			
			local TglBtnCorner = Instance.new("UICorner")
			TglBtnCorner.CornerRadius = UDim.new(1, 0)
			TglBtnCorner.Parent = ToggleButton
			
			local ToggleCircle = Instance.new("Frame")
			ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
			ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
			ToggleCircle.BackgroundColor3 = ColorHex("#606070")
			ToggleCircle.BorderSizePixel = 0
			ToggleCircle.Parent = ToggleButton
			
			local CircleCorner = Instance.new("UICorner")
			CircleCorner.CornerRadius = UDim.new(1, 0)
			CircleCorner.Parent = ToggleCircle
			
			local function SetToggle(state)
				toggled = state
				if toggled then
					Tween(ToggleButton, {BackgroundColor3 = ColorHex("#7C3AED")}, 0.2)
					Tween(ToggleCircle, {
						Position = UDim2.new(1, -18, 0.5, -8),
						BackgroundColor3 = ColorHex("#FFFFFF")
					}, 0.2)
				else
					Tween(ToggleButton, {BackgroundColor3 = ColorHex("#2A2A3C")}, 0.2)
					Tween(ToggleCircle, {
						Position = UDim2.new(0, 2, 0.5, -8),
						BackgroundColor3 = ColorHex("#606070")
					}, 0.2)
				end
				
				if toggleInfo.Callback then
					toggleInfo.Callback(toggled)
				end
			end
			
			ToggleButton.MouseButton1Click:Connect(function()
				SetToggle(not toggled)
			end)
			
			SetToggle(toggled)
		end
		
		function TabLib:CreateSlider(sliderInfo)
			local sliderInfo = sliderInfo or {}
			local min = sliderInfo.Min or 0
			local max = sliderInfo.Max or 100
			local default = sliderInfo.Default or min
			local currentValue = default
			
			local SliderFrame = Instance.new("Frame")
			SliderFrame.Name = "Slider"
			SliderFrame.Size = UDim2.new(1, 0, 0, 60)
			SliderFrame.BackgroundColor3 = ColorHex("#212130")
			SliderFrame.BorderSizePixel = 0
			SliderFrame.Parent = TabPage
			
			local SldrCorner = Instance.new("UICorner")
			SldrCorner.CornerRadius = UDim.new(0, 6)
			SldrCorner.Parent = SliderFrame
			
			CreateStroke(SliderFrame, ColorHex("#2A2A3C"), 1, 0.6)
			
			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -20, 0, 20)
			Label.Position = UDim2.new(0, 10, 0, 8)
			Label.BackgroundTransparency = 1
			Label.Text = sliderInfo.Name or "Slider"
			Label.TextColor3 = ColorHex("#E0E0E0")
			Label.TextSize = 14
			Label.Font = Enum.Font.GothamMedium
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = SliderFrame
			
			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Size = UDim2.new(0, 60, 0, 20)
			ValueLabel.Position = UDim2.new(1, -70, 0, 8)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Text = tostring(currentValue)
			ValueLabel.TextColor3 = ColorHex("#7C3AED")
			ValueLabel.TextSize = 14
			ValueLabel.Font = Enum.Font.GothamBold
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderFrame
			
			local SliderBar = Instance.new("Frame")
			SliderBar.Size = UDim2.new(1, -20, 0, 6)
			SliderBar.Position = UDim2.new(0, 10, 0, 38)
			SliderBar.BackgroundColor3 = ColorHex("#2A2A3C")
			SliderBar.BorderSizePixel = 0
			SliderBar.Parent = SliderFrame
			
			local BarCorner = Instance.new("UICorner")
			BarCorner.CornerRadius = UDim.new(1, 0)
			BarCorner.Parent = SliderBar
			
			local SliderFill = Instance.new("Frame")
			SliderFill.Size = UDim2.new(0, 0, 1, 0)
			SliderFill.BackgroundColor3 = ColorHex("#7C3AED")
			SliderFill.BorderSizePixel = 0
			SliderFill.Parent = SliderBar
			
			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = SliderFill
			
			CreateGradient(SliderFill, ColorSequence.new{
				ColorSequenceKeypoint.new(0, ColorHex("#A855F7")),
				ColorSequenceKeypoint.new(1, ColorHex("#6366F1"))
			}, 90)
			
			local SliderButton = Instance.new("TextButton")
			SliderButton.Size = UDim2.new(0, 16, 0, 16)
			SliderButton.Position = UDim2.new(0, 0, 0.5, -8)
			SliderButton.BackgroundColor3 = ColorHex("#FFFFFF")
			SliderButton.BorderSizePixel = 0
			SliderButton.Text = ""
			SliderButton.ZIndex = 2
			SliderButton.Parent = SliderBar
			
			local BtnCorner = Instance.new("UICorner")
			BtnCorner.CornerRadius = UDim.new(1, 0)
			BtnCorner.Parent = SliderButton
			
			CreateStroke(SliderButton, ColorHex("#7C3AED"), 2, 0.5)
			
			local dragging = false
			
			local function UpdateSlider(input)
				local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
				currentValue = math.floor(min + (max - min) * pos)
				
				ValueLabel.Text = tostring(currentValue)
				Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
				Tween(SliderButton, {Position = UDim2.new(pos, -8, 0.5, -8)}, 0.1)
				
				if sliderInfo.Callback then
					sliderInfo.Callback(currentValue)
				end
			end
			
			SliderButton.MouseButton1Down:Connect(function()
				dragging = true
				Tween(SliderButton, {Size = UDim2.new(0, 20, 0, 20)}, 0.2)
			end)
			
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
					Tween(SliderButton, {Size = UDim2.new(0, 16, 0, 16)}, 0.2)
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					UpdateSlider(input)
				end
			end)
			
			SliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					UpdateSlider(input)
				end
			end)
			
			local initialPos = (default - min) / (max - min)
			SliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
			SliderButton.Position = UDim2.new(initialPos, -8, 0.5, -8)
		end
		
		function TabLib:CreateDropdown(dropdownInfo)
			local dropdownInfo = dropdownInfo or {}
			local options = dropdownInfo.Options or {}
			local selected = dropdownInfo.Default or options[1] or "None"
			local expanded = false
			
			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Name = "Dropdown"
			DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
			DropdownFrame.BackgroundColor3 = ColorHex("#212130")
			DropdownFrame.BorderSizePixel = 0
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.Parent = TabPage
			
			local DdCorner = Instance.new("UICorner")
			DdCorner.CornerRadius = UDim.new(0, 6)
			DdCorner.Parent = DropdownFrame
			
			CreateStroke(DropdownFrame, ColorHex("#2A2A3C"), 1, 0.6)
			
			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(1, -80, 0, 40)
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = dropdownInfo.Name or "Dropdown"
			Label.TextColor3 = ColorHex("#E0E0E0")
			Label.TextSize = 14
			Label.Font = Enum.Font.GothamMedium
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.Parent = DropdownFrame
			
			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Size = UDim2.new(0, 120, 0, 28)
			DropdownButton.Position = UDim2.new(1, -130, 0, 6)
			DropdownButton.BackgroundColor3 = ColorHex("#2A2A3C")
			DropdownButton.BorderSizePixel = 0
			DropdownButton.Text = ""
			DropdownButton.Parent = DropdownFrame
			
			local DdBtnCorner = Instance.new("UICorner")
			DdBtnCorner.CornerRadius = UDim.new(0, 6)
			DdBtnCorner.Parent = DropdownButton
			
			local SelectedLabel = Instance.new("TextLabel")
			SelectedLabel.Size = UDim2.new(1, -30, 1, 0)
			SelectedLabel.Position = UDim2.new(0, 8, 0, 0)
			SelectedLabel.BackgroundTransparency = 1
			SelectedLabel.Text = selected
			SelectedLabel.TextColor3 = ColorHex("#FFFFFF")
			SelectedLabel.TextSize = 12
			SelectedLabel.Font = Enum.Font.Gotham
			SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
			SelectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
			SelectedLabel.Parent = DropdownButton
			
			local Arrow = Instance.new("TextLabel")
			Arrow.Size = UDim2.new(0, 20, 1, 0)
			Arrow.Position = UDim2.new(1, -24, 0, 0)
			Arrow.BackgroundTransparency = 1
			Arrow.Text = "▼"
			Arrow.TextColor3 = ColorHex("#A0A0A0")
			Arrow.TextSize = 10
			Arrow.Font = Enum.Font.Gotham
			Arrow.Parent = DropdownButton
			
			local OptionsContainer = Instance.new("Frame")
			OptionsContainer.Size = UDim2.new(0, 120, 0, 0)
			OptionsContainer.Position = UDim2.new(1, -130, 0, 40)
			OptionsContainer.BackgroundColor3 = ColorHex("#1A1A28")
			OptionsContainer.BorderSizePixel = 0
			OptionsContainer.ClipsDescendants = true
			OptionsContainer.Parent = DropdownFrame
			
			local OptsCorner = Instance.new("UICorner")
			OptsCorner.CornerRadius = UDim.new(0, 6)
			OptsCorner.Parent = OptionsContainer
			
			CreateStroke(OptionsContainer, ColorHex("#7C3AED"), 1.5, 0.7)
			
			local OptionsList = Instance.new("UIListLayout")
			OptionsList.Padding = UDim.new(0, 2)
			OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
			OptionsList.Parent = OptionsContainer
			
			for _, option in ipairs(options) do
				local OptionButton = Instance.new("TextButton")
				OptionButton.Size = UDim2.new(1, 0, 0, 28)
				OptionButton.BackgroundColor3 = ColorHex("#212130")
				OptionButton.BackgroundTransparency = 0.5
				OptionButton.BorderSizePixel = 0
				OptionButton.Text = option
				OptionButton.TextColor3 = ColorHex("#C0C0C0")
				OptionButton.TextSize = 12
				OptionButton.Font = Enum.Font.Gotham
				OptionButton.Parent = OptionsContainer
				
				OptionButton.MouseEnter:Connect(function()
					Tween(OptionButton, {BackgroundTransparency = 0, BackgroundColor3 = ColorHex("#7C3AED")}, 0.2)
				end)
				
				OptionButton.MouseLeave:Connect(function()
					Tween(OptionButton, {BackgroundTransparency = 0.5, BackgroundColor3 = ColorHex("#212130")}, 0.2)
				end)
				
				OptionButton.MouseButton1Click:Connect(function()
					selected = option
					SelectedLabel.Text = selected
					expanded = false
					
					Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
					Tween(OptionsContainer, {Size = UDim2.new(0, 120, 0, 0)}, 0.3)
					Tween(Arrow, {Rotation = 0}, 0.3)
					
					if dropdownInfo.Callback then
						dropdownInfo.Callback(selected)
					end
				end)
			end
