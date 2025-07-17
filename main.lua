-- SERVICES
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- STATE
local state = {
  Aimbot = false, TeamCheck = true,
  ESP = true, Tracer = true, Box = true,
  Hitbox = false, RGB = true,
  FOV = 120, Magnitude = 1000
}

-- UI CREATION
local sg = Instance.new("ScreenGui")
sg.Name = "NadalUniversalHub"; sg.ResetOnSpawn=false
sg.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame", sg)
main.Size=UDim2.new(0,320,0,420); main.Position=UDim2.new(0.05,0,0.2,0)
main.BackgroundColor3=Color3.new(1,1,1); main.BorderColor3=Color3.fromRGB(0,170,255)
main.BorderSizePixel=3; main.Active=true; main.Draggable=true

local title=Instance.new("TextLabel",main)
title.Size=UDim2.new(1,0,0,30); title.BackgroundTransparency=1
title.Text="Nadal Universal Hub"; title.TextColor3=Color3.fromRGB(0,170,255)
title.Font=Enum.Font.SourceSansBold; title.TextSize=20

local btn_min = Instance.new("TextButton",main)
btn_min.Size=UDim2.new(0,30,0,30); btn_min.Position=UDim2.new(1,-65,0,0)
btn_min.Text="–"; btn_min.BackgroundColor3=Color3.fromRGB(220,220,220)
local btn_close = Instance.new("TextButton",main)
btn_close.Size=UDim2.new(0,30,0,30); btn_close.Position=UDim2.new(1,-30,0,0)
btn_close.Text="X"; btn_close.BackgroundColor3=Color3.fromRGB(255,100,100)

-- MINIMIZED ICON
local icon = Instance.new("TextButton", sg)
icon.Size=UDim2.new(0,50,0,50); icon.Position=UDim2.new(0.05,0,0.7,0)
icon.BackgroundColor3=Color3.new(1,1,1); icon.BorderColor3=Color3.fromRGB(0,170,255)
icon.BorderSizePixel=4; icon.Text="N"; icon.TextColor3=Color3.new(1,1,1)
icon.TextScaled=true; icon.AutoButtonColor=false
icon.Visible=false; icon.Active=true; icon.Draggable=true
local corner=Instance.new("UICorner",icon); corner.CornerRadius=UDim.new(1,0)

-- TOGGLE + SLIDER CREATION
local function makeToggle(txt, y)
  local fr=Instance.new("Frame",main)
  fr.Size=UDim2.new(1,-20,0,30); fr.Position=UDim2.new(0,10,0,y)
  fr.BackgroundTransparency=1
  local lbl=Instance.new("TextLabel",fr)
  lbl.Text=txt; lbl.Size=UDim2.new(0.7,0,1,0)
  lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.new(0,0,0)
  lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Font=Enum.Font.SourceSans
  lbl.TextSize=18
  local btn=Instance.new("TextButton",fr)
  btn.Size=UDim2.new(0.3,0,1,0); btn.Position=UDim2.new(0.7,0,0,0)
  btn.Text=state[txt] and "ON" or "OFF"
  btn.BackgroundColor3=state[txt] and Color3.fromRGB(0,170,255) or Color3.fromRGB(170,170,170)
  btn.TextColor3=Color3.new(1,1,1); btn.Font=Enum.Font.SourceSansBold
  btn.TextSize=18; btn.AutoButtonColor=false

  btn.MouseButton1Click:Connect(function()
    state[txt]=not state[txt]
    btn.Text=state[txt] and "ON" or "OFF"
    btn.BackgroundColor3=state[txt] and Color3.fromRGB(0,170,255) or Color3.fromRGB(170,170,170)
  end)
end

local function makeSlider(txt, y, mi, ma)
  local fr=Instance.new("Frame",main)
  fr.Size=UDim2.new(1,-20,0,40); fr.Position=UDim2.new(0,10,0,y)
  fr.BackgroundTransparency=1
  local lbl=Instance.new("TextLabel",fr)
  lbl.Text=txt..": "..state[txt]; lbl.Size=UDim2.new(1,0,0,20)
  lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.new(0,0,0)
  lbl.Font=Enum.Font.SourceSans; lbl.TextSize=16; lbl.TextXAlignment=Enum.TextXAlignment.Left

  local bg=Instance.new("Frame",fr)
  bg.Size=UDim2.new(1,0,0,15); bg.Position=UDim2.new(0,0,0,25)
  bg.BackgroundColor3=Color3.fromRGB(200,200,200); bg.BorderSizePixel=0
  bg.ClipsDescendants=true

  local fill=Instance.new("Frame",bg)
  fill.Size=UDim2.new((state[txt]-mi)/(ma-mi),0,1,0)
  fill.BackgroundColor3=Color3.fromRGB(0,170,255); fill.BorderSizePixel=0

  local drag=false
  bg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end end)
  bg.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
  bg.InputChanged:Connect(function(i)
    if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
      local pos=math.clamp(i.Position.X-bg.AbsolutePosition.X,0,bg.AbsoluteSize.X)
      local val=math.floor(mi + pos/bg.AbsoluteSize.X*(ma-mi))
      state[txt]=val; lbl.Text=txt..": "..val
      fill.Size=UDim2.new((val-mi)/(ma-mi),0,1,0)
    end
  end)
end

-- Create controls
local ypos=40
for _, nm in ipairs({"Aimbot","TeamCheck","ESP","Tracer","Box","Hitbox","RGB"}) do
  makeToggle(nm,ypos); ypos+=35
end
makeSlider("FOV",ypos+5,50,300); makeSlider("Magnitude",ypos+50,100,2000)

-- BUTTONS ACTION
btn_min.MouseButton1Click:Connect(function()
  main.Visible=false
  icon.Position=main.Position
  icon.Visible=true
end)
icon.MouseButton1Click:Connect(function()
  main.Position=icon.Position
  main.Visible=true
  icon.Visible=false
end)
btn_close.MouseButton1Click:Connect(function() sg:Destroy() end)

-- FUNCTIONALITY: FOV Circle, Aimbot, ESP, Hitbox
local fovCirc=Drawing.new("Circle"); fovCirc.Thickness=2; fovCirc.Filled=false
local function getClosest()
  local best, mn = nil, math.huge
  for _,p in pairs(Players:GetPlayers()) do
    if p~=Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
      if state.TeamCheck and p.Team==Players.LocalPlayer.Team then continue end
      local pos,on = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
      if on then
        local d=(Vector2.new(pos.X,pos.Y)-Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
        if d<state.FOV and d<mn and p.Character:FindFirstChildOfClass("Humanoid").Health>0 then
          mn, best = d, p
        end
      end
    end
  end
  return best
end

RunService.RenderStepped:Connect(function()
  -- FOV circle
  fovCirc.Radius=state.FOV
  fovCirc.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
  fovCirc.Color = state.RGB and Color3.fromHSV(tick()%5/5,1,1) or Color3.new(1,1,1)
  fovCirc.Visible=state.Aimbot

  -- Aimbot
  if state.Aimbot then
    local t=getClosest()
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
      Camera.CFrame=CFrame.new(Camera.CFrame.Position,t.Character.HumanoidRootPart.Position + Vector3.new(0,1.5,0))
    end
  end

  -- ESP + Hitbox
  for _,p in pairs(Players:GetPlayers()) do
    if p~=Players.LocalPlayer and state.ESP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
      local hrp=p.Character.HumanoidRootPart
      if state.Hitbox then
        if not hrp:FindFirstChild("___orig") then
          local val=hrp.Size; hrp:SetAttribute("___orig",val)
          hrp.Size=Vector3.new(10,10,10); hrp.Transparency=0.6
          hrp.Material=Enum.Material.Neon; hrp.BrickColor=BrickColor.new("Really red")
        end
      elseif hrp:GetAttribute("___orig") then
        hrp.Size=hrp:GetAttribute("___orig"); hrp.Transparency=1
        hrp.Material=Enum.Material.Plastic
        hrp:SetAttribute("___orig",nil)
      end

      local pos=Camera:WorldToViewportPoint(hrp.Position)
      if pos.z>0 and not(state.TeamCheck and p.Team==Players.LocalPlayer.Team) then
        -- draw ESP
        local col=state.RGB and Color3.fromHSV(tick()/5%1,1,1) or Color3.new(1,1,1)
        local squ=Drawing.new("Square")
        squ.Color=col; squ.Thickness=2; squ.Filled=false
        squ.Size=Vector2.new(40,80)
        squ.Position=Vector2.new(pos.x-20,pos.y-40)
        local ln=Drawing.new("Line")
        ln.Color=col; ln.Thickness=1
        ln.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
        ln.To=Vector2.new(pos.x,pos.y)
        task.defer(function() squ:Remove(); ln:Remove() end)
      end
    end
  end
end)
