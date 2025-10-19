--!strict
local TweenService = game:GetService("TweenService")

local Notify = {}

function Notify:Create(Parent, Info, theme, notificationsTable)
	local Title = Info.Title or "Notification"
	local Desc = Info.Desc or ""
	local Time = Info.Time or 5
	
	local notifications = notificationsTable or {}
	
	local NotificationFrame = Instance.new("Frame")
	NotificationFrame.Name = "Notification"
	NotificationFrame.Size = UDim2.new(0, 300, 0, 80)
	NotificationFrame.Position = UDim2.new(1, 320, 0.1 + (#notifications * 0.15), 0)
	NotificationFrame.BackgroundColor3 = theme.Foreground
	NotificationFrame.Parent = Parent
	
	local NotificationCorner = Instance.new("UICorner")
	NotificationCorner.CornerRadius = UDim.new(0, 8)
	NotificationCorner.Parent = NotificationFrame
	
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = theme.Accent
	UIStroke.Thickness = 2
	UIStroke.Parent = NotificationFrame
	
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "TitleLabel"
	TitleLabel.Size = UDim2.new(1, -20, 0, 25)
	TitleLabel.Position = UDim2.new(0, 10, 0, 10)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = Title
	TitleLabel.TextColor3 = theme.Text
	TitleLabel.TextSize = 16
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = NotificationFrame
	
	local DescLabel = Instance.new("TextLabel")
	DescLabel.Name = "DescLabel"
	DescLabel.Size = UDim2.new(1, -20, 0, 35)
	DescLabel.Position = UDim2.new(0, 10, 0, 35)
	DescLabel.BackgroundTransparency = 1
	DescLabel.Text = Desc
	DescLabel.TextColor3 = theme.Text
	DescLabel.TextSize = 14
	DescLabel.Font = Enum.Font.Gotham
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.TextYAlignment = Enum.TextYAlignment.Top
	DescLabel.TextWrapped = true
	DescLabel.Parent = NotificationFrame
	
	-- Animação de entrada
	local tweenIn = TweenService:Create(NotificationFrame, TweenInfo.new(0.3), {
		Position = UDim2.new(1, -310, 0.1 + (#notifications * 0.15), 0)
	})
	tweenIn:Play()
	
	table.insert(notifications, NotificationFrame)
	
	-- Atualizar posições das notificações existentes
	for i, notif in ipairs(notifications) do
		local tween = TweenService:Create(notif, TweenInfo.new(0.3), {
			Position = UDim2.new(1, -310, 0.1 + ((i-1) * 0.15), 0)
		})
		tween:Play()
	end
	
	-- Remover após o tempo
	task.delay(Time, function()
		local tweenOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.3), {
			Position = UDim2.new(1, 320, NotificationFrame.Position.Y.Scale, 0)
		})
		tweenOut:Play()
		
		tweenOut.Completed:Connect(function()
			NotificationFrame:Destroy()
			local index = table.find(notifications, NotificationFrame)
			if index then
				table.remove(notifications, index)
			end
		end)
	end)
end

return Notify
