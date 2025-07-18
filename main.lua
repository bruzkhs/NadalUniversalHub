-- Script NadalUniversalHub com ícone minimizado "N"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Aimbot = false,
    ESP = false,
    Tracer = false,
    TeamCheck = false,
    Hitbox = false,
    FOVRadius = 100,
    RGBEnabled = false,
}

-- Cria ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NadalUniversalHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Fundo branco
MainFrame.BorderColor3 = Color3.fromRGB(0, 162, 255) -- Borda azul escaldante
MainFrame.BorderSizePixel = 3
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NadalUniversalHub"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.fromRGB(0, 162, 255)
Title.TextSize = 24
Title.Parent = MainFrame

-- Botão minimizar (ícone redondo com letra N)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -45, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Text = "N"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 24
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = MainFrame
MinimizeButton.AutoButtonColor = true
MinimizeButton.ClipsDescendants = true
MinimizeButton.AnchorPoint = Vector2.new(1, 0)

-- Frame minimizado (círculo com N)
local MiniFrame = Instance.new("Frame")
MiniFrame.Name = "MiniFrame"
MiniFrame.Size = UDim2.new(0, 50, 0, 50)
MiniFrame.Position = UDim2.new(0, 20, 0.5, -25)
MiniFrame.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
MiniFrame.Visible = false
MiniFrame.Parent = ScreenGui
MiniFrame.Active = true
MiniFrame.Draggable = true

local MiniText = Instance.new("TextLabel")
MiniText.Name = "MiniText"
MiniText.Size = UDim2.new(1, 0, 1, 0)
MiniText.BackgroundTransparency = 1
MiniText.Text = "N"
MiniText.Font = Enum.Font.SourceSansBold
MiniText.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniText.TextSize = 28
MiniText.Parent = MiniFrame

-- Função para alternar visibilidade
local function toggleUI()
    MainFrame.Visible = not MainFrame.Visible
    MiniFrame.Visible = not MiniFrame.Visible
end

MinimizeButton.MouseButton1Click:Connect(toggleUI)
MiniFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleUI()
    end
end)

-- (Aqui entram as suas outras funções e toggles do script, para não ficar gigante vou colocar o básico para exemplo)

-- Exemplo básico de toggle Aimbot para ilustrar
local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Size = UDim2.new(0, 100, 0, 30)
AimbotToggle.Position = UDim2.new(0, 20, 0, 50)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
AimbotToggle.TextColor3 = Color3.new(1,1,1)
AimbotToggle.Text = "Aimbot: OFF"
AimbotToggle.Parent = MainFrame

AimbotToggle.MouseButton1Click:Connect(function()
    Config.Aimbot = not Config.Aimbot
    AimbotToggle.Text = Config.Aimbot and "Aimbot: ON" or "Aimbot: OFF"
end)

-- Continue com suas funções de ESP, FOV, etc, integrando com Config e interface.

print("Script NadalUniversalHub com ícone N pronto para uso!")
