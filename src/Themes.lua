--!strict
local Themes = {}

Themes.THEMES = {
	Dark = {
		Background = Color3.fromRGB(30, 30, 40),
		Foreground = Color3.fromRGB(45, 45, 55),
		Text = Color3.fromRGB(255, 255, 255),
		Accent = Color3.fromRGB(0, 150, 255),
		Success = Color3.fromRGB(60, 180, 80),
		Error = Color3.fromRGB(220, 80, 80),
		Warning = Color3.fromRGB(255, 180, 0)
	},
	Darker = {
		Background = Color3.fromRGB(15, 15, 20),
		Foreground = Color3.fromRGB(25, 25, 35),
		Text = Color3.fromRGB(240, 240, 240),
		Accent = Color3.fromRGB(0, 130, 220),
		Success = Color3.fromRGB(50, 170, 70),
		Error = Color3.fromRGB(200, 60, 60),
		Warning = Color3.fromRGB(240, 160, 0)
	},
	Cyberpunk = {
		Background = Color3.fromRGB(10, 10, 25),
		Foreground = Color3.fromRGB(20, 20, 40),
		Text = Color3.fromRGB(255, 50, 255),
		Accent = Color3.fromRGB(0, 255, 255),
		Success = Color3.fromRGB(0, 255, 150),
		Error = Color3.fromRGB(255, 50, 100),
		Warning = Color3.fromRGB(255, 255, 0)
	}
}

function Themes:GetTheme(themeName)
	return self.THEMES[themeName] or self.THEMES.Darker
end

return Themes
