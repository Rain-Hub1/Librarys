--!strict
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Lib = {}

-- URL base do GitHub
local baseUrl = "https://raw.githubusercontent.com/Rain-Hub1/Librarys/refs/heads/main/"

-- Função para carregar módulos
local function loadModule(modulePath)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(baseUrl .. modulePath))()
    end)
    
    if success then
        return result
    else
        warn("Falha ao carregar módulo: " .. modulePath .. " - " .. tostring(result))
        return nil
    end
end

-- Carregar módulos principais
local Themes = loadModule("src/Themes.lua")
local KeySystem = loadModule("src/KeySystem.lua")

-- Inicializar componentes
Lib.Themes = Themes
Lib.KeySystem = KeySystem

-- Função principal da biblioteca
function Lib:Window(Info)
    local Info = Info or {}
    
    -- Carregar componentes necessários
    local WindowComponent = loadModule("src/Components/Window.lua")
    local TitleBar = loadModule("src/Components/TitleBar.lua")
    local Notify = loadModule("src/Components/Notify.lua")
    
    -- Carregar elementos
    local Paragraph = loadModule("src/Elements/Paragraph.lua")
    local Button = loadModule("src/Elements/Button.lua")
    local Toggle = loadModule("src/Elements/Toggle.lua")
    local Dropdown = loadModule("src/Elements/Dropdown.lua")
    
    -- Verificar se todos os módulos foram carregados
    if not WindowComponent or not TitleBar or not Notify or not Paragraph or not Button or not Toggle then
        warn("Alguns módulos não puderam ser carregados")
        return {}
    end
    
    -- Criar objeto com módulos carregados
    local Modules = {
        Themes = Themes,
        KeySystem = KeySystem,
        Components = {
            Window = WindowComponent,
            TitleBar = TitleBar,
            Notify = Notify
        },
        Elements = {
            Paragraph = Paragraph,
            Button = Button,
            Toggle = Toggle,
            Dropdown = Dropdown
        }
    }
    
    -- Criar a janela
    return WindowComponent:Create(Info, Modules)
end

return Lib
