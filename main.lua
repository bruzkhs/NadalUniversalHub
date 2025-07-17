-- Nadal Universal Hub por Bruno
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Interface
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "NadalUniversalHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 350)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
MainFrame.BorderSizePixel = 4
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.Active = true
MainFrame.Draggable = true

local title = Instance.new("TextLabel", MainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Nadal Universal Hub"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Minimizar e Icone
local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Text = "-"
MinBtn.Position = UDim2.new(1, -60, 0, 5)
MinBtn.Size = UDim2.new(0, 25, 0, 20)
MinBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Text = "X"
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.Size = UDim2.new(0, 25, 0, 20)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)

local Icon = Instance.new("TextButton", ScreenGui)
Icon.Visible = false
Icon.Size = UDim2.new(0, 50, 0, 50)
Icon.Position = UDim2.new(0.02, 0, 0.7, 0)
Icon.Text = "N"
Icon.BackgroundColor3 = Color3.new(1, 1, 1)
Icon.TextColor3 = Color3.fromRGB(0, 170, 255)
Icon.BorderColor3 = Color3.fromRGB(0, 170, 255)
Icon.TextScaled = true
Icon.Font = Enum.Font.SourceSansBold
Icon.BorderSizePixel = 3
Icon.Draggable = true

MinBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	Icon.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

Icon.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	Icon.Visible = false
end)

-- Funções principais
local aimbotOn = false
local fovSize = 100
local espOn = false
local hitboxOn = false
local rgbFov = false
local rgbEsp = false

-- FOV círculo
local fovCircle = Drawing.new("Circle")
fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
fovCircle.Radius = fovSize
fovCircle.Thickness = 1.5
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(0,170,255)
fovCircle.Visible = true

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    fovCircle.Radius = fovSize
    if rgbFov then
        local t = tick() * 2
        fovCircle.Color = Color3.fromHSV(t % 1, 1, 1)
    end
end)

-- Botões da UI
local function createButton(name, yPos, callback)
	local btn = Instance.new("TextButton", MainFrame)
	btn.Size = UDim2.new(0, 120, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Text = name .. ": OFF"
	btn.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.MouseButton1Click:Connect(function()
		local state = btn.Text:find("OFF") and true or false
		btn.Text = name .. (state and ": ON" or ": OFF")
		btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(170,170,170)
		callback(state)
	end)
end

local function createSlider(name, yPos, min, max, onChange)
	local label = Instance.new("TextLabel", MainFrame)
	label.Size = UDim2.new(0, 140, 0, 20)
	label.Position = UDim2.new(0, 10, 0, yPos)
	label.Text = name..": "..fovSize
	label.TextScaled = true
	label.BackgroundTransparency = 1

	local slider = Instance.new("TextButton", MainFrame)
	slider.Size = UDim2.new(0, 140, 0, 20)
	slider.Position = UDim2.new(0, 10, 0, yPos+20)
	slider.Text = ""
	slider.BackgroundColor3 = Color3.fromRGB(200,200,200)

	slider.MouseButton1Down:Connect(function()
		local move
		move = RunService.RenderStepped:Connect(function()
			local mouseX = Mouse.X
			local relX = math.clamp(mouseX - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
			local percent = relX / slider.AbsoluteSize.X
			local value = math.floor(min + (max - min) * percent)
			onChange(value)
			label.Text = name..": "..value
		end)
		local up
		up = game:GetService("UserInputService").InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
				move:Disconnect()
				up:Disconnect()
			end
		end)
	end)
end

-- Aimbot
createButton("Aimbot", 50, function(state)
	aimbotOn = state
end)

-- ESP
createButton("ESP", 90, function(state)
	espOn = state
end)

-- Hitbox
createButton("Hitbox", 130, function(state)
	hitboxOn = state
end)

-- RGB FOV
createButton("FOV RGB", 170, function(state)
	rgbFov = state
end)

-- RGB ESP
createButton("ESP RGB", 210, function(state)
	rgbEsp = state
end)

-- FOV Slider
createSlider("FOV Size", 250, 50, 300, function(val)
	fovSize = val
end)

-- Aimbot (Camlock básico)
local function getClosest()
	local closest, dist = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local pos = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
			local diff = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
			if diff < fovSize and diff < dist then
				closest = player
				dist = diff
			end
		end
	end
	return closest
end

RunService.RenderStepped:Connect(function()
	if aimbotOn then
		local target = getClosest()
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.HumanoidRootPart.Position)
		end
	end
end)

-- Hitbox
RunService.RenderStepped:Connect(function()
	if hitboxOn then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.Size = Vector3.new(10,10,10)
				player.Character.HumanoidRootPart.Transparency = 0.7
			end
		end
	end
end)

-- ESP
local drawings = {}

RunService.RenderStepped:Connect(function()
	for _, d in pairs(drawings) do d.Visible = false end

	if not espOn then return end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if player.Team ~= LocalPlayer.Team then
				local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
				if onScreen then
					if not drawings[player] then
						drawings[player] = {
							box = Drawing.new("Square"),
							text = Drawing.new("Text"),
							line = Drawing.new("Line")
						}
					end
					local box = drawings[player].box
					local text = drawings[player].text
					local line = drawings[player].line

					local color = rgbEsp and Color3.fromHSV(tick() % 5 / 5, 1, 1) or Color3.fromRGB(0,170,255)

					box.Visible = true
					box.Size = Vector2.new(40, 100)
					box.Position = Vector2.new(pos.X - 20, pos.Y - 100)
					box.Color = color
					box.Thickness = 1
					box.Transparency = 1
					box.Filled = false

					text.Visible = true
					text.Text = player.Name
					text.Position = Vector2.new(pos.X - 20, pos.Y - 110)
					text.Color = color
					text.Size = 14
					text.Center = true

					line.Visible = true
					line.From = Vector2.new(pos.X, pos.Y)
					line.To = Vector2.new(pos.X, workspace.CurrentCamera.ViewportSize.Y)
					line.Color = color
					line.Thickness = 1
				end
			end
		end
	end
end)
