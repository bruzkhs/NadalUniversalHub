--// NadalUniversalHub - v2.0
-- Autor: Nadal
-- Funcionalidades: Aimbot, ESP, Tracer, FOV fixo, Team Check, Hitbox toggle

local Library = loadstring(game:HttpGet("https://pastebin.com/raw/YourUILibrary"))()
local Window = Library:CreateWindow("NadalUniversalHub")

-- Config
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
local Mouse = LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")

-- UI

-- Buttons
Window:CreateToggle("Aimbot (Camlock)", function(val) Config.Aimbot = val end)
Window:CreateToggle("ESP", function(val) Config.ESP = val end)
Window:CreateToggle("Tracers", function(val) Config.Tracer = val end)
Window:CreateToggle("Team Check", function(val) Config.TeamCheck = val end)
Window:CreateToggle("Hitbox", function(val) Config.Hitbox = val end)
-- Circle FOV with "N" inside
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = 100
FOVCircle.Color = Color3.new(1, 1, 1)
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 1
function DrawFOV()
    FOVCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
    local text = Drawing.new("Text")
    text.Text = "N"
    text.Position = FOVCircle.Position - Vector2.new(5,5)
    text.Color = Color3.new(1,1,1)
    text.Size = 18
    text.Center = true
    text.Outline = true
    task.spawn(function()
        wait(0.03)
        text:Remove()
    end)
end

-- Funções utilitárias
local function getClosestPlayer()
    local closest, dist = nil, math.huge
    local cam = workspace.CurrentCamera
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid").Health > 0 then
            if Config.TeamCheck and plr.Team == LocalPlayer.Team then continue end
            local pos, onScreen = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude
                if mag < dist and mag <= FOVCircle.Radius then
                    closest, dist = plr, mag
                end
            end
        end
    end
    return closest
end

-- Loops principais
RunService.RenderStepped:Connect(function()
    DrawFOV()
    if Config.Aimbot then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, target.Character.Head.Position)
        end
    end
end)

-- ESP & Tracers
local espItems = {}

local function createESP(plr)
    local outline = Drawing.new("Square")
    outline.Color = Color3.new(1,0,0)
    outline.Thickness = 1
    outline.Transparency = 1
    local tracer = Drawing.new("Line")
    tracer.Color = Color3.new(1,1,1)
    tracer.Thickness = 1
    tracer.Transparency = 1
    espItems[plr] = {outline = outline, tracer = tracer}
end

local function removeESP(plr)
    local items = espItems[plr]
    if items then
        items.outline:Remove()
        items.tracer:Remove()
        espItems[plr] = nil
    end
end

Players.PlayerAdded:Connect(function(plr) if Config.ESP then createESP(plr) end end)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    for plr, items in pairs(espItems) do
        if Config.ESP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local rootPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local size = 1000 / rootPos.Z
                items.outline.Position = Vector2.new(rootPos.X - size/2, rootPos.Y - size/2)
                items.outline.Size = Vector2.new(size, size)
                items.outline.Color = Color3.fromHSV((tick()%5)/5, 1, 1)
                items.outline.Visible = true

                items.tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y)
                items.tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                items.tracer.Visible = Config.Tracer
            else
                items.outline.Visible = false
                items.tracer.Visible = false
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
                plr.Character.HumanoidRootPart.Size = Vector3.new(10,10,10)
                plr.Character.HumanoidRootPart.Transparency = 0.5
            end
        end
    end
end)

-- Quando inicializa, garante esp existing
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then createESP(plr) end
end
