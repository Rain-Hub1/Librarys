--!strict
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Lib = {}

-- Carregar módulos
local baseUrl = "https://raw.githubusercontent.com/Rain-Hub1/Librarys/refs/heads/main/"

-- Função para carregar módulos
local function loadModule(modulePath)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(baseUrl .. modulePath))()
    end)
    
    if success then
        return result
    else
        warn("Failed to load module: " .. modulePath)
        return {}
    end
end

-- Carregar componentes
Lib.Themes = loadModule("src/Themes.lua")
Lib.KeySystem = loadModule("src/KeySystem.lua")
Lib.Components = {
    Window = loadModule("src/Components/Window.lua"),
    TitleBar = loadModule("src/Components/TitleBar.lua"),
    Notify = loadModule("src/Components/Notify.lua")
}

-- Carregar elementos
Lib.Elements = {
    Paragraph = loadModule("src/Elements/Paragraph.lua"),
    Button = loadModule("src/Elements/Button.lua"),
    Toggle = loadModule("src/Elements/Toggle.lua"),
    Dropdown = loadModule("src/Elements/Dropdown.lua")
}

-- Função principal da biblioteca
function Lib:Window(Info)
    return Lib.Components.Window:Create(Info, Lib)
end

return Lib
