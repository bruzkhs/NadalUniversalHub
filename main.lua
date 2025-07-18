-- Script NadalUniversalHub base (funcional, sem ícone minimizar)

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

-- Criando ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NadalUniversalHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderColor3 = Color3.fromRGB(0, 162, 255)
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

-- Função para criar botões toggle
local function createToggle(name, initialValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = MainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(0.75, 0, 0.15, 0)
    toggle.BackgroundColor3 = initialValue and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(200, 200, 200)
    toggle.Text = initialValue and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 18
    toggle.Parent = frame

    toggle.MouseButton1Click:Connect(function()
        local newVal = not (toggle.Text == "ON")
        toggle.Text = newVal and "ON" or "OFF"
        toggle.BackgroundColor3 = newVal and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(200, 200, 200)
        callback(newVal)
    end)
end

-- Criando toggles para cada função
local toggles = {
    {Name = "Aimbot", Key = "Aimbot"},
    {Name = "ESP", Key = "ESP"},
    {Name = "Tracer", Key = "Tracer"},
    {Name = "Team Check", Key = "TeamCheck"},
    {Name = "Hitbox", Key = "Hitbox"},
    {Name = "RGB", Key = "RGBEnabled"},
}

for _, toggleInfo in ipairs(toggles) do
    createToggle(toggleInfo.Name, Config[toggleInfo.Key], function(val)
        Config[toggleInfo.Key] = val
    end)
end

-- Slider FOV
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, -20, 0, 50)
SliderFrame.Position = UDim2.new(0, 10, 0, 240)
SliderFrame.BackgroundTransparency = 1
SliderFrame.Parent = MainFrame

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(0.7, 0, 1, 0)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "FOV Radius: "..Config.FOVRadius
SliderLabel.Font = Enum.Font.SourceSans
SliderLabel.TextSize = 18
SliderLabel.TextColor3 = Color3.fromRGB(0,0,0)
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = SliderFrame

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(0.7, 0, 0.3, 0)
SliderBar.Position = UDim2.new(0.25, 0, 0.5, -10)
SliderBar.BackgroundColor3 = Color3.fromRGB(200,200,200)
SliderBar.Parent = SliderFrame

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 20, 1, 0)
SliderButton.Position = UDim2.new(0, (Config.FOVRadius/300)*SliderBar.AbsoluteSize.X, 0, 0)
SliderButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
SliderButton.Text = ""
SliderButton.Parent = SliderBar

local dragging = false
local UserInputService = game:GetService("UserInputService")

SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local pos = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
        SliderButton.Position = UDim2.new(0, pos, 0, 0)
        Config.FOVRadius = math.floor((pos / SliderBar.AbsoluteSize.X) * 300)
        SliderLabel.Text = "FOV Radius: "..Config.FOVRadius
    end
end)

-- FOV circle com Drawing
local Drawing = Drawing
local Camera = workspace.CurrentCamera

local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = Config.FOVRadius
FOVCircle.Color = Color3.fromRGB(0, 162, 255)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 1

local FOVText = Drawing.new("Text")
FOVText.Text = "N"
FOVText.Size = 22
FOVText.Color = Color3.fromRGB(0, 162, 255)
FOVText.Center = true
FOVText.Outline = true

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = center
    FOVCircle.Radius = Config.FOVRadius
    FOVText.Position = center
end)

-- Função para achar alvo para aimbot
local function getClosestPlayer()
    local closest, shortestDist = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") then
            if plr.Character.Humanoid.Health > 0 then
                if Config.TeamCheck and plr.Team == LocalPlayer.Team then
                    -- ignorar time
                else
                    local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if dist < Config.FOVRadius and dist < shortestDist then
                            closest = plr
                            shortestDist = dist
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Config.Aimbot then
        local target = getClosestPlayer()
        if target and target.Character then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- ESP e Tracer (simplificado)
local ESPItems = {}

local function createESP(plr)
    local box = Drawing.new("Square")
    box.Color = Config.RGBEnabled and Color3.fromHSV(tick()%5/5, 1, 1) or Color3.new(1, 0, 0)
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1

    local tracer = Drawing.new("Line")
    tracer.Color = Config.RGBEnabled and Color3.fromHSV(tick()%5/5, 1, 1) or Color3.new(1, 1, 1)
    tracer.Thickness = 1
    tracer.Transparency = 1

    local name = Drawing.new("Text")
    name.Text = plr.Name
    name.Color = Config.RGBEnabled and Color3.fromHSV(tick()%5/5, 1, 1) or Color3.new(1, 1, 1)
    name.Size = 16
    name.Center = true
    name.Outline = true

    local healthBar = Drawing.new("Square")
    healthBar.Color = Color3.new(0, 1, 0)
    healthBar.Thickness = 2
    healthBar.Filled = true
    healthBar.Transparency = 1

    ESPItems[plr] = {
        Box = box,
        Tracer = tracer,
        Name = name,
        HealthBar = healthBar,
    }
end

local function removeESP(plr)
    if ESPItems[plr] then
        for _, item in pairs(ESPItems[plr]) do
            item:Remove()
        end
        ESPItems[plr] = nil
    end
end

RunService.RenderStepped:Connect(function()
    for plr, esp in pairs(ESPItems) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen and Config.ESP then
                local size = 1000 / pos.Z
                esp.Box.Position = Vector2.new(pos.X - size/2, pos.Y - size)
                esp.Box.Size = Vector2.new(size, size * 2)
                esp.Box.Visible = true

                esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                esp.Tracer.Visible = Config.Tracer

                esp.Name.Text = plr.Name
                esp.Name.Position = Vector2.new(pos.X, pos.Y - size - 20)
                esp.Name.Visible = true

                local healthPercent = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth
                esp.HealthBar.Position = Vector2.new(pos.X - size/2 - 10, pos.Y - size)
                esp.HealthBar.Size = Vector2.new(5, size * 2 * healthPercent)
                esp.HealthBar.Visible = true
            else
                esp.Box.Visible = false
                esp.Tracer.Visible = false
                esp.Name.Visible = false
                esp.HealthBar.Visible = false
            end
        else
            removeESP(plr)
        end
    end
end)

-- Hitbox toggle
RunService.Heartbeat:Connect(function()
    if Config.Hitbox then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local part = plr.Character.HumanoidRootPart
                part.Size = Vector3.new(10, 10, 10)
                part.Transparency = 0.5
                part.CanCollide = false
            end
        end
    end
end)

-- Inicializa ESP para jogadores atuais
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then createESP(plr) end
end

Players.PlayerAdded:Connect(function(plr)
    if Config.ESP then createESP(plr) end
end)

Players.PlayerRemoving:Connect(removeESP)
