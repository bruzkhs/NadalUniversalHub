--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

--// Estado do script
local state = {
    Aimbot = false,
    TeamCheck = true,
    ESP = true,
    Tracer = true,
    Box = true,
    Hitbox = false,
    FOV = 120,
    RGB = true,
    Magnitude = 1000,
}

--// Interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NadalUniversalHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Nadal Universal Hub"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

local BtnMinimize = Instance.new("TextButton", MainFrame)
BtnMinimize.Size = UDim2.new(0, 30, 0, 30)
BtnMinimize.Position = UDim2.new(1, -65, 0, 0)
BtnMinimize.Text = "-"
BtnMinimize.BackgroundColor3 = Color3.fromRGB(220, 220, 220)

local BtnClose = Instance.new("TextButton", MainFrame)
BtnClose.Size = UDim2.new(0, 30, 0, 30)
BtnClose.Position = UDim2.new(1, -30, 0, 0)
BtnClose.Text = "X"
BtnClose.BackgroundColor3 = Color3.fromRGB(255, 100, 100)

-- Ícone minimizado com "N", fundo branco, borda azul, redondo e movível
local MinimizedIcon = Instance.new("TextButton", ScreenGui)
MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
MinimizedIcon.Position = UDim2.new(0.05, 0, 0.7, 0)
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- fundo branco
MinimizedIcon.BorderColor3 = Color3.fromRGB(0, 170, 255) -- borda azul
MinimizedIcon.BorderSizePixel = 4
MinimizedIcon.Text = "N"
MinimizedIcon.TextColor3 = Color3.fromRGB(255, 255, 255) -- texto branco
MinimizedIcon.TextScaled = true
MinimizedIcon.AutoButtonColor = false
MinimizedIcon.Visible = false
MinimizedIcon.Active = true
MinimizedIcon.Draggable = true
MinimizedIcon.ClipsDescendants = true
MinimizedIcon.AnchorPoint = Vector2.new(0, 0)
MinimizedIcon.BackgroundTransparency = 0
MinimizedIcon.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
MinimizedIcon.TextStrokeTransparency = 0.7
MinimizedIcon.TextWrapped = true
MinimizedIcon.ZIndex = 10
MinimizedIcon.Name = "MinimizedIcon"
MinimizedIcon.RoundedCorner = Instance.new("UICorner", MinimizedIcon)
MinimizedIcon.RoundedCorner.CornerRadius = UDim.new(1, 0)

-- Função auxiliar para criar toggles
local function createToggle(parent, text, position, default)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = position
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0.3, 0, 1, 0)
    button.Position = UDim2.new(0.7, 0, 0, 0)
    button.Text = default and "ON" or "OFF"
    button.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(170, 170, 170)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.AutoButtonColor = false

    return frame, button
end

-- Função auxiliar para criar sliders
local function createSlider(parent, text, position, min, max, default)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = position
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Text = text .. ": " .. tostring(default)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame", frame)
    sliderBg.Size = UDim2.new(1, 0, 0, 15)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sliderBg.BorderSizePixel = 0
    sliderBg.ClipsDescendants = true

    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.BorderSizePixel = 0

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
            label.Text = text .. ": " .. tostring(value)
            if text == "FOV" then
                state.FOV = value
            elseif text == "Magnitude" then
                state.Magnitude = value
            end
        end
    end)

    return frame
end

-- Criando toggles e sliders
local toggles = {}
local yPos = 40

local function addToggle(name, default)
    local frame, btn = createToggle(MainFrame, name, UDim2.new(0, 10, 0, yPos), default)
    toggles[name] = btn
    yPos = yPos + 35
    btn.MouseButton1Click:Connect(function()
        state[name] = not state[name]
        btn.Text = state[name] and "ON" or "OFF"
        btn.BackgroundColor3 = state[name] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(170, 170, 170)
    end)
end

addToggle("Aimbot", state.Aimbot)
addToggle("TeamCheck", state.TeamCheck)
addToggle("ESP", state.ESP)
addToggle("Tracer", state.Tracer)
addToggle("Box", state.Box)
addToggle("Hitbox", state.Hitbox)
addToggle("RGB", state.RGB)

local sliderFOV = createSlider(MainFrame, "FOV", UDim2.new(0, 10, 0, yPos), 50, 300, state.FOV)
yPos = yPos + 45
local sliderMag = createSlider(MainFrame, "Magnitude", UDim2.new(0, 10, 0, yPos), 100, 2000, state.Magnitude)
yPos = yPos + 45

-- Botões minimizar e fechar
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

-- Círculo FOV
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Filled = false

RunService.RenderStepped:Connect(function()
    fovCircle.Radius = state.FOV
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if state.RGB then
        fovCircle.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    else
        fovCircle.Color = Color3.fromRGB(255, 255, 255)
    end
    fovCircle.Visible = state.Aimbot
end)

-- Encontrar jogador mais próximo dentro do FOV
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if state.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if distance < state.FOV and distance < shortestDistance and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

-- Aimbot
RunService.RenderStepped:Connect(function()
    if state.Aimbot then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position + Vector3.new(0, 1.5, 0))
        end
    end
end)

-- ESP
local espObjects = {}
local originalSizes = {}

local function createESP(player)
    if espObjects[player] then
        return espObjects[player]
    end

    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Color = Color3.new(1, 1, 1)

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = Color3.new(1, 1, 1)

    local name = Drawing.new("Text")
    name.Center = true
    name.Outline = true
    name.Color = Color3.new(1, 1, 1)
    name.Size = 14

    local health = Drawing.new("Text")
    health.Center = true
    health.Outline = true
    health.Color = Color3.new(0, 1, 0)
    health.Size = 14

    local magnitudeText = Drawing.new("Text")
    magnitudeText.Center = true
    magnitudeText.Outline = true
    magnitudeText.Color = Color3.new(1, 1, 1)
    magnitudeText.Size = 14

    espObjects[player] = {
        Box = box,
        Tracer = tracer,
        Name = name,
        Health = health,
        Magnitude = magnitudeText
    }

    return espObjects[player]
end

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local esp = createESP(player)
            local hrp = player.Character.HumanoidRootPart
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude

            if onScreen and state.ESP and (not state.TeamCheck or player.Team ~= LocalPlayer.Team) and dist <= state.Magnitude then
                local col = state.RGB and Color3.fromHSV(tick() / 5 % 1, 1, 1) or Color3.new(1, 1, 1)

                esp.Box.Visible = state.Box
                esp.Box.Color = col
                esp.Box.Size = Vector2.new(40, 80)
                esp.Box.Position = Vector2.new(pos.X - 20, pos.Y - 40)

                esp.Tracer.Visible = state.Tracer
                esp.Tracer.Color = col
                esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                esp.Tracer.To = Vector2.new(pos.X, pos.Y)

                esp.Name.Visible = true
                esp.Name.Text = player.Name
                esp.Name.Color = Color3.new(1, 1, 1)
                esp.Name.Position = Vector2.new(pos.X, pos.Y - 50)

                esp.Health.Visible = true
                esp.Health.Text = "HP: " .. math.floor(hum.Health)
                esp.Health.Color = Color3.new(0, 1, 0)
                esp.Health.Position = Vector2.new(pos.X, pos.Y + 50)

                esp.Magnitude.Visible = true
                esp.Magnitude.Text = math.floor(dist) .. " studs"
                esp.Magnitude.Color = Color3.new(1, 1, 1)
                esp.Magnitude.Position = Vector2.new(pos.X, pos.Y + 65)
            else
                esp.Box.Visible = false
                esp.Tracer.Visible = false
                esp.Name.Visible = false
                esp.Health.Visible = false
                esp.Magnitude.Visible = false
            end

            if state.Hitbox then
                if not originalSizes[player] then
                    originalSizes[player] = hrp.Size
                end
                hrp.Size = Vector3.new(10, 10, 10)
                hrp.Transparency = 0.6
                hrp.Material = Enum.Material.Neon
                hrp.BrickColor = BrickColor.new("Really red")
                hrp.CanCollide = false
            else
                if originalSizes[player] then
                    hrp.Size = originalSizes[player]
                    hrp.Transparency = 1
                    hrp.Material = Enum.Material.Plastic
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        for _, v in pairs(espObjects[player]) do
            v:Remove()
        end
        espObjects[player] = nil
    end
    originalSizes[player] = nil
end)
