local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONTROLE
local HUB_ON = false
local HUB_ABERTO = true

local CFG = {
Line = false,
Box = false,
Vida = false,
Skeleton = false
}

local ESPs = {}

--==============================
-- CRIAR ESP
--==============================
local function criarESP(plr)
if plr == LP or ESPs[plr] then return end

local box = Drawing.new("Square")
box.Thickness = 2
box.Filled = false
box.Color = Color3.fromRGB(0,255,0)

local line = Drawing.new("Line")
line.Thickness = 2
line.Color = Color3.fromRGB(0,255,0)

local vidaBg = Drawing.new("Square")
vidaBg.Filled = true
vidaBg.Color = Color3.fromRGB(40,40,40)

local vida = Drawing.new("Square")
vida.Filled = true

local bones = {}
for i = 1,8 do
local l = Drawing.new("Line")
l.Thickness = 2
l.Color = Color3.fromRGB(255,255,255)
table.insert(bones,l)
end

ESPs[plr] = {
Box = box,
Line = line,
Vida = vida,
VidaBg = vidaBg,
Bones = bones
}

end

local function esconder(data)
for _,v in pairs(data) do
if typeof(v) == "table" then
for _,l in pairs(v) do l.Visible = false end
else
v.Visible = false
end
end
end

-- PLAYERS
for _,p in pairs(Players:GetPlayers()) do criarESP(p) end
Players.PlayerAdded:Connect(criarESP)
Players.PlayerRemoving:Connect(function(p)
if ESPs[p] then
esconder(ESPs[p])
ESPs[p] = nil
end
end)

--==============================
-- UPDATE ESP
--==============================
RunService.RenderStepped:Connect(function()
if not HUB_ON then
for _,d in pairs(ESPs) do esconder(d) end
return
end

for plr,data in pairs(ESPs) do
local char = plr.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local head = char and char:FindFirstChild("Head")

if not (char and hum and hrp and head) then    
    esconder(data)    
    continue    
end    

local headPos, vis = Camera:WorldToViewportPoint(head.Position)    
if not vis then esconder(data) continue end    

local footPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, hum.HipHeight+2, 0))    
local h = math.abs(footPos.Y - headPos.Y)    
local w = h/2    

-- BOX    
data.Box.Visible = CFG.Box    
data.Box.Size = Vector2.new(w,h)    
data.Box.Position = Vector2.new(headPos.X-w/2, headPos.Y)    

-- LINE    
data.Line.Visible = CFG.Line    
data.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)    
data.Line.To = Vector2.new(headPos.X, headPos.Y)    

-- VIDA    
local hp = math.clamp(hum.Health/hum.MaxHealth,0,1)    
data.VidaBg.Visible = CFG.Vida    
data.Vida.Visible = CFG.Vida    

data.VidaBg.Size = Vector2.new(4,h)    
data.VidaBg.Position = Vector2.new(headPos.X-w/2-6, headPos.Y)    

data.Vida.Size = Vector2.new(4,h*hp)    
data.Vida.Position = Vector2.new(headPos.X-w/2-6, headPos.Y+(h-h*hp))    
data.Vida.Color = Color3.fromRGB(255*(1-hp),255*hp,0)    

-- SKELETON    
for _,b in pairs(data.Bones) do b.Visible = CFG.Skeleton end    
if CFG.Skeleton then    
    local torso = Camera:WorldToViewportPoint(hrp.Position)    
    local lArm = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(-1,1,0))    
    local rArm = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(1,1,0))    
    local lLeg = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(-0.6,-2,0))    
    local rLeg = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0.6,-2,0))    

    local B = data.Bones    
    B[1].From = Vector2.new(headPos.X,headPos.Y); B[1].To = Vector2.new(torso.X,torso.Y)    
    B[2].From = Vector2.new(torso.X,torso.Y); B[2].To = Vector2.new(lArm.X,lArm.Y)    
    B[3].From = Vector2.new(torso.X,torso.Y); B[3].To = Vector2.new(rArm.X,rArm.Y)    
    B[4].From = Vector2.new(torso.X,torso.Y); B[4].To = Vector2.new(lLeg.X,lLeg.Y)    
    B[5].From = Vector2.new(torso.X,torso.Y); B[5].To = Vector2.new(rLeg.X,rLeg.Y)    
end

end

end)

--==============================
-- GUI HUB
--==============================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false

-- HUB FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,240,0,310)
frame.Position = UDim2.new(0,20,0,200)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- DRAG MOBILE
local drag, start, pos
frame.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.Touch then
drag = true; start = i.Position; pos = frame.Position
end
end)
frame.InputEnded:Connect(function(i)
if i.UserInputType == Enum.UserInputType.Touch then drag = false end
end)
UIS.InputChanged:Connect(function(i)
if drag and i.UserInputType == Enum.UserInputType.Touch then
local d = i.Position-start
frame.Position = UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
end
end)

-- BOTÃO HUB BOLA 👁️
local eye = Instance.new("TextButton", gui)
eye.Size = UDim2.new(0,55,0,55)
eye.Position = UDim2.new(0,20,0,130)
eye.Text = "👁️"
eye.TextScaled = true
eye.BackgroundColor3 = Color3.fromRGB(0,170,0)
eye.TextColor3 = Color3.new(1,1,1)
eye.BorderSizePixel = 0
eye.Active = true
Instance.new("UICorner", eye).CornerRadius = UDim.new(1,0)

eye.MouseButton1Click:Connect(function()
HUB_ABERTO = not HUB_ABERTO
frame.Visible = HUB_ABERTO
end)

-- BOTÕES HUB
local function botao(txt,y,cb)
local b = Instance.new("TextButton", frame)
b.Size = UDim2.new(1,-20,0,40)
b.Position = UDim2.new(0,10,0,y)
b.Text = txt.." ❌"
b.TextScaled = true
b.Font = Enum.Font.GothamBold
b.BackgroundColor3 = Color3.fromRGB(35,35,35)
b.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)

local on = false
b.MouseButton1Click:Connect(function()
on = not on
b.Text = txt .. (on and " ✅" or " ❌")
b.BackgroundColor3 = on and Color3.fromRGB(0,170,0) or Color3.fromRGB(35,35,35)
cb(on)
end)

end

botao("ATIVAR FUNÇÕES",10,function(v) HUB_ON = v end)
botao("ESP LINHA",60,function(v) CFG.Line = v end)
botao("ESP BOX",110,function(v) CFG.Box = v end)
botao("ESP VIDA",160,function(v) CFG.Vida = v end)
botao("ESP ESQUELETO",210,function(v) CFG.Skeleton = v end)

print("🔥 HUB FF + 👁️ + ESQUELETO CARREGADO 🔥")
