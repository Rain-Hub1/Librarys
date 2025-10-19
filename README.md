## `Full Example` • AI

```lua
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Hub1/Librarys/refs/heads/main/SabLib%20AI.lua"))()

local Win = Lib:Window({
    Title = "Minha Interface",
    OpenButton = Enum.KeyCode.RightShift,
    Theme = "Darker"
})

-- Paragraph
local MyParagraph = Win:Paragraph({
    Name = "Bem-vindo",
    Desc = "Esta é uma descrição de exemplo para o parágrafo."
})

-- Button
local MyButton = Win:Button({
    Name = "Meu Botão",
    Desc = "Clique para executar uma ação",
    Color = Color3.fromRGB(255, 100, 100),
    Callback = function()
        print("Botão clicado!")
        Win:Notify({
            Title = "Sucesso!",
            Desc = "Ação executada com sucesso",
            Time = 3
        })
    end
})

-- Toggle
local MyToggle = Win:Toggle({
    Name = "Meu Toggle",
    Desc = "Ative ou desative este recurso",
    Color = Color3.fromRGB(100, 200, 100),
    Default = false,
    Callback = function(Value)
        print("Toggle:", Value)
        Win:Notify({
            Title = "Toggle Alterado",
            Desc = "Estado: " .. tostring(Value),
            Time = 2
        })
    end
})

-- Notificação direta
Win:Notify({
    Title = "Sistema Iniciado",
    Desc = "Interface carregada com sucesso!",
    Time = 5
})

-- Exemplo de atualização dinâmica
task.wait(5)
MyParagraph:SetName("Bem-vindo Atualizado")
MyParagraph:SetDesc("Descrição atualizada dinamicamente!")

MyButton:SetName("Botão Atualizado")
MyButton:SetDesc("Nova descrição do botão")
MyButton:SetColor(Color3.fromRGB(100, 150, 255))

MyToggle:SetName("Toggle Atualizado")
MyToggle:SetDefault(true)
```
