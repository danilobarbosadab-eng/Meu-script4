--==================================================
-- HUB ESP VIP - PRIVADO (KEY + HUB ARRASTÁVEL)
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==============================
-- KEY VIP
--==============================
local KEY_CORRETA = "VIP-9X7A-QP2M-48ZK-FF2026"

--==============================
-- FUNÇÃO QUE INICIA O HUB (SÓ APÓS KEY)
--==============================
local function iniciarHub()

	-- CONTROLE
	local HUB_ON = false
	local CFG = { Line=false, Box=false, Vida=false, Skeleton=false }
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
		for i=1,5 do
			local l = Drawing.new("Line")
			l.Thickness = 2
			l.Color = Color3.fromRGB(255,255,255)
			table.insert(bones,l)
		end

		ESPs[plr] = {Box=box, Line=line, Vida=vida, VidaBg=vidaBg, Bones=bones}
	end

	local function esconder(d)
		for _,v in pairs(d) do
			if typeof(v)=="table" then
				for _,l in pairs(v) do l.Visible=false end
			else
				v.Visible=false
			end
		end
	end

	for _,p in pairs(Players:GetPlayers()) do criarESP(p) end
	Players.PlayerAdded:Connect(criarESP)
	Players.PlayerRemoving:Connect(function(p)
		if ESPs[p] then esconder(ESPs[p]); ESPs[p]=nil end
	end)

	--==============================
	-- UPDATE ESP
	--==============================
	RunService.RenderStepped:Connect(function()
		if not HUB_ON then
			for _,d in pairs(ESPs) do esconder(d) end
			return
		end

		for plr,d in pairs(ESPs) do
			local c = plr.Character
			local h = c and c:FindFirstChildOfClass("Humanoid")
			local r = c and c:FindFirstChild("HumanoidRootPart")
			local head = c and c:FindFirstChild("Head")
			if not (c and h and r and head) then esconder(d) continue end

			local hp, vis = Camera:WorldToViewportPoint(head.Position)
			if not vis then esconder(d) continue end

			local fp = Camera:WorldToViewportPoint(r.Position - Vector3.new(0, h.HipHeight+2, 0))
			local H = math.abs(fp.Y - hp.Y)
			local W = H/2

			-- BOX
			d.Box.Visible = CFG.Box
			d.Box.Size = Vector2.new(W,H)
			d.Box.Position = Vector2.new(hp.X-W/2, hp.Y)

			-- LINE
			d.Line.Visible = CFG.Line
			d.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
			d.Line.To = Vector2.new(hp.X, hp.Y)

			-- VIDA
			local life = math.clamp(h.Health/h.MaxHealth,0,1)
			d.VidaBg.Visible = CFG.Vida
			d.Vida.Visible = CFG.Vida
			d.VidaBg.Size = Vector2.new(4,H)
			d.VidaBg.Position = Vector2.new(hp.X-W/2-6, hp.Y)
			d.Vida.Size = Vector2.new(4,H*life)
			d.Vida.Position = Vector2.new(hp.X-W/2-6, hp.Y+(H-H*life))
			d.Vida.Color = Color3.fromRGB(255*(1-life),255*life,0)

			-- ESQUELETO
			for _,b in pairs(d.Bones) do b.Visible = CFG.Skeleton end
			if CFG.Skeleton then
				local torso = Camera:WorldToViewportPoint(r.Position)
				local lArm = Camera:WorldToViewportPoint(r.Position + Vector3.new(-1,1,0))
				local rArm = Camera:WorldToViewportPoint(r.Position + Vector3.new(1,1,0))
				local lLeg = Camera:WorldToViewportPoint(r.Position + Vector3.new(-0.6,-2,0))
				local rLeg = Camera:WorldToViewportPoint(r.Position + Vector3.new(0.6,-2,0))

				local B = d.Bones
				B[1].From = Vector2.new(hp.X,hp.Y);       B[1].To = Vector2.new(torso.X,torso.Y)
				B[2].From = Vector2.new(torso.X,torso.Y); B[2].To = Vector2.new(lArm.X,lArm.Y)
				B[3].From = Vector2.new(torso.X,torso.Y); B[3].To = Vector2.new(rArm.X,rArm.Y)
				B[4].From = Vector2.new(torso.X,torso.Y); B[4].To = Vector2.new(lLeg.X,lLeg.Y)
				B[5].From = Vector2.new(torso.X,torso.Y); B[5].To = Vector2.new(rLeg.X,rLeg.Y)
			end
		end
	end)

	--==============================
	-- GUI HUB (CENTRO + ARRASTÁVEL)
	--==============================
	local gui = Instance.new("ScreenGui", LP.PlayerGui)
	gui.ResetOnSpawn = false

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0,240,0,310)
	frame.Position = UDim2.new(0.5,-120,0.5,-155) -- meio da tela
	frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
	frame.BorderSizePixel = 0
	frame.Active = true
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

	-- DRAG (MOBILE + PC)
	local dragging=false
	local dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1
		or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true
			dragStart=input.Position
			startPos=frame.Position
		end
	end)
	frame.InputEnded:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1
		or input.UserInputType==Enum.UserInputType.Touch then
			dragging=false
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement
		or input.UserInputType==Enum.UserInputType.Touch) then
			local delta=input.Position-dragStart
			frame.Position=UDim2.new(
				startPos.X.Scale, startPos.X.Offset+delta.X,
				startPos.Y.Scale, startPos.Y.Offset+delta.Y
			)
		end
	end)

	local function botao(txt,y,cb)
		local b=Instance.new("TextButton",frame)
		b.Size=UDim2.new(1,-20,0,40)
		b.Position=UDim2.new(0,10,0,y)
		b.Text=txt.." ❌"
		b.TextScaled=true
		b.Font=Enum.Font.GothamBold
		b.BackgroundColor3=Color3.fromRGB(35,35,35)
		b.TextColor3=Color3.new(1,1,1)
		Instance.new("UICorner",b).CornerRadius=UDim.new(0,12)

		local on=false
		b.MouseButton1Click:Connect(function()
			on=not on
			b.Text=txt..(on and " ✅" or " ❌")
			b.BackgroundColor3=on and Color3.fromRGB(0,170,0) or Color3.fromRGB(35,35,35)
			cb(on)
		end)
	end

	botao("ATIVAR FUNÇÕES",10,function(v) HUB_ON=v end)
	botao("ESP LINHA",60,function(v) CFG.Line=v end)
	botao("ESP BOX",110,function(v) CFG.Box=v end)
	botao("ESP VIDA",160,function(v) CFG.Vida=v end)
	botao("ESP ESQUELETO",210,function(v) CFG.Skeleton=v end)

	print("🔥 HUB ESP VIP ATIVO 🔥")
end

--==============================
-- TELA DE KEY (ÚNICA COISA NO INÍCIO)
--==============================
local guiKey = Instance.new("ScreenGui", LP.PlayerGui)
guiKey.ResetOnSpawn = false

local f = Instance.new("Frame", guiKey)
f.Size = UDim2.new(0,320,0,200)
f.Position = UDim2.new(0.5,-160,0.5,-100)
f.BackgroundColor3 = Color3.fromRGB(15,15,15)
f.BorderSizePixel = 0
Instance.new("UICorner",f).CornerRadius=UDim.new(0,18)

local t = Instance.new("TextLabel", f)
t.Size=UDim2.new(1,0,0,40)
t.Text="🔒 VIP ACCESS"
t.TextScaled=true
t.Font=Enum.Font.GothamBold
t.TextColor3=Color3.new(1,1,1)
t.BackgroundTransparency=1

local box = Instance.new("TextBox", f)
box.Size=UDim2.new(1,-40,0,45)
box.Position=UDim2.new(0,20,0,60)
box.PlaceholderText="Digite a KEY..."
box.Text=""
box.TextScaled=true
box.Font=Enum.Font.Gotham
box.BackgroundColor3=Color3.fromRGB(30,30,30)
box.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",box).CornerRadius=UDim.new(0,12)

local btn = Instance.new("TextButton", f)
btn.Size=UDim2.new(1,-40,0,45)
btn.Position=UDim2.new(0,20,0,120)
btn.Text="CONFIRMAR"
btn.TextScaled=true
btn.Font=Enum.Font.GothamBold
btn.BackgroundColor3=Color3.fromRGB(0,170,0)
btn.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",btn).CornerRadius=UDim.new(0,12)

btn.MouseButton1Click:Connect(function()
	if box.Text == KEY_CORRETA then
		guiKey:Destroy()
		iniciarHub()
	else
		btn.Text="KEY INVÁLIDA ❌"
		task.wait(1)
		btn.Text="CONFIRMAR"
	end
end)
