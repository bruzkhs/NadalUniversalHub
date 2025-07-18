--// NadalUniversalHub - v2.0
-- Autor: Nadal
-- Funcionalidades: Aimbot, ESP, Tracer, FOV fixo, Team Check, Hitbox toggle

-- substitua isso por sua biblioteca de interface depois:
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({ Name = "NadalUniversalHub", LoadingTitle = "Carregando...", ConfigurationSaving = { Enabled = false } })

local Config = {
    Aimbot = false,
    ESP = false,
    Tracer = false,
    TeamCheck = false,
    Hitbox = false,
}

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Radius = 100
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = true

local function DrawFOV()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = center
    local text = Drawing.new("Text")
    text.Text = "N"
    text.Position = center - Vector2.new(4, 8)
    text.Color = Color3.new(1, 1, 1)
    text.Size = 18
    text.Center = true
    text.Outline = true
    task.delay(0.05, function() text:Remove() end)
end

-- Aimbot
local function getClosestPlayer()
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            if Config.TeamCheck and plr.Team == LocalPlayer.Team then continue end
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < shortest and mag <= FOVCircle.Radius then
                    closest = plr
                    shortest = mag
                end
            end
        end
    end
    return closest
end

-- ESP
local ESPItems = {}

local function createESP(plr)
    local box = Drawing.new("Square")
    box.Color = Color3.new(1, 0, 0)
    box.Thickness = 1
    box.Transparency = 1
    box.Filled = false

    local line = Drawing.new("Line")
    line.Color = Color3.new(1,1,1)
    line.Thickness = 1
    line.Transparency = 1

    ESPItems[plr] = {Box = box, Tracer = line}
end

local function removeESP(plr)
    if ESPItems[plr] then
        ESPItems[plr].Box:Remove()
        ESPItems[plr].Tracer:Remove()
        ESPItems[plr] = nil
    end
end

RunService.RenderStepped:Connect(function()
    DrawFOV()

    if Config.Aimbot then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end

    for plr, esp in pairs(ESPItems) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local pos, visible = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if visible then
                local size = 1000 / pos.Z
                esp.Box.Position = Vector2.new(pos.X - size/2, pos.Y - size)
                esp.Box.Size = Vector2.new(size, size * 2)
                esp.Box.Visible = Config.ESP

                esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                esp.Tracer.Visible = Config.ESP and Config.Tracer
            else
                esp.Box.Visible = false
                esp.Tracer.Visible = false
            end
        end
    end
end)

-- Hitbox
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

-- Adiciona UI
Window:CreateTab("Funções"):CreateSection("Ativadores")
Window:CreateToggle({Name = "Aimbot", CurrentValue = false, Callback = function(v) Config.Aimbot = v end})
Window:CreateToggle({Name = "ESP", CurrentValue = false, Callback = function(v)
    Config.ESP = v
    for _, plr in ipairs(Players:GetPlayers()) do
        if v then createESP(plr) else removeESP(plr) end
    end
end})
Window:CreateToggle({Name = "Tracers", CurrentValue = false, Callback = function(v) Config.Tracer = v end})
Window:CreateToggle({Name = "Team Check", CurrentValue = false, Callback = function(v) Config.TeamCheck = v end})
Window:CreateToggle({Name = "Hitbox", CurrentValue = false, Callback = function(v) Config.Hitbox = v end})

-- Auto ESP para jogadores existentes
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then createESP(plr) end
end
Players.PlayerAdded:Connect(function(plr) if Config.ESP then createESP(plr) end end)
Players.PlayerRemoving:Connect(removeESP)
