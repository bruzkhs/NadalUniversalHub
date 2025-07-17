local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NadalUniversalHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.BorderSizePixel = 3
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "Nadal Universal Hub"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Botões minimizar e fechar
local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Size = UDim2.new(0, 30, 0, 30)
BtnMinimize.Position = UDim2.new(1, -65, 0, 0)
BtnMinimize.Text = "-"
BtnMinimize.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
BtnMinimize.Parent = MainFrame

local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 30, 0, 30)
BtnClose.Position = UDim2.new(1, -30, 0, 0)
BtnClose.Text = "X"
BtnClose.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
BtnClose.Parent = MainFrame

-- Ícone minimizado com "N", fundo branco, borda azul, redondo e movível
local MinimizedIcon = Instance.new("TextButton")
MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
MinimizedIcon.Position = UDim2.new(0.1, 0, 0.7, 0)
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MinimizedIcon.BorderColor3 = Color3.fromRGB(0, 170, 255)
MinimizedIcon.BorderSizePixel = 4
MinimizedIcon.Text = "N"
MinimizedIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedIcon.TextScaled = true
MinimizedIcon.AutoButtonColor = false
MinimizedIcon.Visible = false
MinimizedIcon.Active = true
MinimizedIcon.Draggable = true
MinimizedIcon.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MinimizedIcon

-- Função para criar toggles
local function createToggle(name, position)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = MainFrame

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.3, 0, 1, 0)
    button.Position = UDim2.new(0.7, 0, 0, 0)
    button.Text = "OFF"
    button.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.AutoButtonColor = false
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        if button.Text == "OFF" then
            button.Text = "ON"
            button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        else
            button.Text = "OFF"
            button.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
        end
    end)

    return button
end

-- Função para criar sliders
local function createSlider(name, position, min, max, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = MainFrame

    local label = Instance.new("TextLabel")
    label.Text = name .. ": " .. default
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 15)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sliderBg.BorderSizePixel = 0
    sliderBg.ClipsDescendants = true
    sliderBg.Parent = frame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg

    local dragging = false

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderBg.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local value = min + (relativeX / sliderBg.AbsoluteSize.X) * (max - min)
            value = math.floor(value)
            sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            label.Text = name .. ": " .. tostring(value)
        end
    end)

    return frame
end

-- Criar toggles
local toggleNames = {"Aimbot", "TeamCheck", "ESP", "Tracer", "Box", "Hitbox", "RGB"}
local buttons = {}
local currentY = 40

for _, name in ipairs(toggleNames) do
    buttons[name] = createToggle(name, UDim2.new(0, 10, 0, currentY))
    currentY = currentY + 35
end

-- Criar sliders
local sliderFOV = createSlider("FOV", UDim2.new(0, 10, 0, currentY), 50, 300, 120)
currentY = currentY + 45
local sliderMagnitude = createSlider("Magnitude", UDim2.new(0, 10, 0, currentY), 100, 2000, 1000)

-- Funções dos botões minimizar e fechar
BtnMinimize.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedIcon.Position = MainFrame.Position
    MinimizedIcon.Visible = true
end)

MinimizedIcon.MouseButton1Click:Connect(function()
    MainFrame.Position = MinimizedIcon.Position
    MainFrame.Visible = true
    MinimizedIcon.Visible = false
end)

BtnClose.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
