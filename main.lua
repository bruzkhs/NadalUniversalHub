local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TesteInterface"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 300)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.Active = true
MainFrame.Draggable = true

local toggleNames = {"Aimbot", "ESP", "Hitbox"}
local toggles = {}

for i, name in ipairs(toggleNames) do
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 10 + (i-1)*40)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(function()
        if btn.Text:find("OFF") then
            btn.Text = name .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        else
            btn.Text = name .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
        end
    end)
    toggles[name] = btn
end
