-- UNIVERSAL SCRIPT - NADALUNIVERSALHUB

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ESTADOS INICIAIS
local state = {
  Aimbot = true,
  TeamCheck = true,
  ESP = true,
  Tracer = true,
  Box = true,
  Hitbox = false,
  FOV = 150,
  RGB = true,
  Mag = 1000
}

-- INTERFACE
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "NadalUniversalHub"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 500)
mainFrame.Position = UDim2.new(0.35, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
mainFrame.BorderSizePixel = 4
mainFrame.BorderColor3 = Color3.fromRGB(0,170,255)
mainFrame.Active = true
mainFrame.Draggable = true

local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Text = "–"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(230,230,230)

local iconFrame = Instance.new("ImageButton", screenGui)
iconFrame.Name = "NadalIcon"
iconFrame.Size = UDim2.new(0, 50, 0, 50)
iconFrame.Position = mainFrame.Position
iconFrame.BackgroundTransparency = 1
iconFrame.Image = "https://i.imgur.com/D8FQ4Pw.png" -- ícone do Nadal
iconFrame.Visible = false
iconFrame.Active = true
iconFrame.Draggable = true

minimizeBtn.MouseButton1Click:Connect(function()
  mainFrame.Visible = false
  iconFrame.Position = mainFrame.Position
  iconFrame.Visible = true
end)

iconFrame.MouseButton1Click:Connect(function()
  mainFrame.Position = iconFrame.Position
  mainFrame.Visible = true
  iconFrame.Visible = false
end)

-- FUNÇÕES GET
local function getAimbotState() return state.Aimbot end
local function getESPState() return state.ESP end
local function getTeamCheckState() return state.TeamCheck end
local function getTracerState() return state.Tracer end
local function getBoxState() return state.Box end
local function getHitboxState() return state.Hitbox end
local function getFOVValue() return state.FOV end
local function getRGBState() return state.RGB end
local function getMagValue() return state.Mag end

-- Aimbot + FOV circle
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Filled = false

RunService.RenderStepped:Connect(function()
  fovCircle.Radius = getFOVValue()
  fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
  fovCircle.Color = getRGBState() and Color3.fromHSV(tick() % 5 / 5, 1, 1) or Color3.fromRGB(255,255,255)
  fovCircle.Visible = getAimbotState()
end)

local function getClosestPlayer()
  local closest, dist = nil, math.huge
  for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
      if getTeamCheckState() and p.Team == LocalPlayer.Team then continue end
      local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
      if onScreen then
        local mag = (Vector2.new(pos.X, pos.Y) - fovCircle.Position).Magnitude
        if mag < fovCircle.Radius and mag < dist and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
          dist = mag; closest = p
        end
      end
    end
  end
  return closest
end

RunService.RenderStepped:Connect(function()
  if getAimbotState() then
    local tgt = getClosestPlayer()
    if tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") then
      local aimPos = tgt.Character.HumanoidRootPart.Position + Vector3.new(0,1.5,0)
      Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
    end
  end
end)

-- ESP & Hitbox
local espObjs = {}
local originalSizes = {}

local function drawESP(player)
  if player == LocalPlayer then return end
  local char = player.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")
  local hum = char and char:FindFirstChildOfClass("Humanoid")
  if not hrp or not hum then return end

  if not espObjs[player] then
    espObjs[player] = {
      Box = Drawing.new("Square"),
      Tracer = Drawing.new("Line"),
      Name = Drawing.new("Text"),
      Health = Drawing.new("Text"),
      Mag = Drawing.new("Text")
    }
  end

  local objs = espObjs[player]
  local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
  local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude

  if onScreen and getESPState() and (not getTeamCheckState() or player.Team ~= LocalPlayer.Team) and dist <= getMagValue() then
    local col = getRGBState() and Color3.fromHSV(tick()/5%1,1,1) or Color3.fromRGB(0,255,0)

    objs.Box.Visible = getBoxState()
    objs.Box.Color = col
    objs.Box.Thickness = 1
    objs.Box.Size = Vector2.new(40,80)
    objs.Box.Position = Vector2.new(pos.X-20,pos.Y-40)

    objs.Tracer.Visible = getTracerState()
    objs.Tracer.Color = col
    objs.Tracer.Thickness = 1
    objs.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
    objs.Tracer.To = Vector2.new(pos.X,pos.Y)

    objs.Name.Visible = true
    objs.Name.Text = player.Name
    objs.Name.Color = Color3.new(1,1,1)
    objs.Name.Size = 13
    objs.Name.Position = Vector2.new(pos.X-20,pos.Y-55)
    objs.Name.Outline = true

    objs.Health.Visible = true
    objs.Health.Text = "HP:"..math.floor(hum.Health)
    objs.Health.Color = Color3.new(0,1,0)
    objs.Health.Size = 13
    objs.Health.Position = Vector2.new(pos.X-20,pos.Y+40)
    objs.Health.Outline = true

    objs.Mag.Visible = true
    objs.Mag.Text = math.floor(dist).." studs"
    objs.Mag.Color = Color3.new(1,1,1)
    objs.Mag.Size = 13
    objs.Mag.Position = Vector2.new(pos.X-20,pos.Y+55)
    objs.Mag.Outline = true
  else
    for _, o in pairs(espObjs[player]) do o.Visible = false end
  end
end

Players.PlayerRemoving:Connect(function(p)
  if espObjs[p] then
    for _, o in pairs(espObjs[p]) do o:Remove() end
    espObjs[p] = nil
  end
  originalSizes[p] = nil
end)

RunService.RenderStepped:Connect(function()
  for _, p in pairs(Players:GetPlayers()) do
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
      -- hitbox
      if getHitboxState() then
        local hrp = p.Character.HumanoidRootPart
        if not originalSizes[p] then originalSizes[p] = hrp.Size end
        hrp.Size = Vector3.new(10,10,10)
        hrp.Transparency = 0.6
        hrp.Material = Enum.Material.Neon
        hrp.BrickColor = BrickColor.new("Really red")
        hrp.CanCollide = false
      elseif originalSizes[p] then
        local hrp = p.Character.HumanoidRootPart
        hrp.Size = originalSizes[p]
        hrp.Transparency = 1
        hrp.Material = Enum.Material.Plastic
      end

      -- esp
      drawESP(p)
    end
  end
end)
