local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "EmWareHubGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main frame with rounded corners
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 350)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

-- Top bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 15)
topBarCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "EmWare Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Minimize button
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 40, 1, 0)
minimize.Position = UDim2.new(1, -40, 0, 0)
minimize.BackgroundColor3 = Color3.fromRGB(10, 100, 230)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 28
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BorderSizePixel = 0
minimize.Parent = topBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimize

-- Container for buttons
local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, -40)
container.Position = UDim2.new(0, 0, 0, 40)
container.BackgroundTransparency = 1
container.Parent = mainFrame

-- Button creator with animation
local function createButton(name, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -40, 0, 50)
	btn.Position = UDim2.new(0, 20, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(20, 140, 255)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 20
	btn.Text = name .. ": OFF"
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = container
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = btn
	
	-- Hover animation
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(40, 180, 255)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(20, 140, 255)}):Play()
	end)
	
	return btn
end

local espBtn = createButton("ESP", 15)
local farmBtn = createButton("AutoFarm", 80)
local invisBtn = createButton("Invis", 145)
local killAllBtn = createButton("KillAll", 210)

-- States
local espEnabled = false
local farming = false
local invisEnabled = false
local killAllEnabled = false
local adornments = {}

-- ESP Functions

local function isMurderer(plr)
	return plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife"))
end

local function isSheriff(plr)
	return plr.Backpack:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Revolver") or
		(plr.Character and (plr.Character:FindFirstChild("Gun") or plr.Character:FindFirstChild("Revolver")))
end

local function updateESP()
	-- Clear old adornments
	for _, adorn in pairs(adornments) do
		if adorn and adorn.Parent then
			adorn:Destroy()
		end
	end
	table.clear(adornments)

	if espEnabled then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = plr.Character.HumanoidRootPart

				-- Box adornment
				local box = Instance.new("BoxHandleAdornment")
				box.Adornee = hrp
				box.AlwaysOnTop = true
				box.ZIndex = 5
				box.Size = Vector3.new(4, 6, 2)
				box.Transparency = 0.25

				if isMurderer(plr) then
					box.Color3 = Color3.fromRGB(255, 0, 0)
				elseif isSheriff(plr) then
					box.Color3 = Color3.fromRGB(0, 170, 255)
				else
					box.Color3 = Color3.fromRGB(0, 255, 0)
				end

				box.Parent = hrp

				-- Name tag
				local nameTag = Instance.new("BillboardGui")
				nameTag.Adornee = hrp
				nameTag.AlwaysOnTop = true
				nameTag.Size = UDim2.new(0, 110, 0, 30)
				nameTag.StudsOffset = Vector3.new(0, 3.3, 0)
				nameTag.Name = "NameTag"

				local nameLabel = Instance.new("TextLabel")
				nameLabel.BackgroundTransparency = 1
				nameLabel.Size = UDim2.new(1, 0, 1, 0)
				nameLabel.Text = plr.Name
				nameLabel.TextColor3 = Color3.new(1, 1, 1)
				nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
				nameLabel.TextStrokeTransparency = 0
				nameLabel.Font = Enum.Font.GothamBold
				nameLabel.TextSize = 15
				nameLabel.Parent = nameTag

				nameTag.Parent = hrp

				-- Store for cleanup
				adornments[plr.Name .. "_box"] = box
				adornments[plr.Name .. "_name"] = nameTag
			end
		end
	end
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(1)
		if espEnabled then updateESP() end
	end)
end)

RunService.Stepped:Connect(function()
	if espEnabled then updateESP() end
end)

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	local text = espEnabled and "ON" or "OFF"
	espBtn.Text = "ESP: " .. text
	TweenService:Create(espBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(20, 140, 255)}):Play()
	updateESP()
end)

-- Invisibility toggle
local function setInvisibility(state)
	local char = player.Character
	if not char then return end

	for _, part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.Transparency = state and 1 or 0
			part.CanCollide = not state
		elseif part:IsA("Decal") then
			part.Transparency = state and 1 or 0
		elseif part:IsA("Accessory") then
			local handle = part:FindFirstChild("Handle")
			if handle and handle:IsA("BasePart") then
				handle.Transparency = state and 1 or 0
				handle.CanCollide = not state
			end
		end
	end
end

invisBtn.MouseButton1Click:Connect(function()
	invisEnabled = not invisEnabled
	local text = invisEnabled and "ON" or "OFF"
	invisBtn.Text = "Invis: " .. text
	TweenService:Create(invisBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = invisEnabled and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(20, 140, 255)}):Play()
	setInvisibility(invisEnabled)
end)

-- AutoFarm toggle
farmBtn.MouseButton1Click:Connect(function()
	farming = not farming
	local text = farming and "ON" or "OFF"
	farmBtn.Text = "AutoFarm: " .. text
	TweenService:Create(farmBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = farming and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(20, 140, 255)}):Play()
end)

-- AutoFarm loop
task.spawn(function()
	while true do
		if farming then
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")

			if hrp and hum and hum.Health > 0 and not hrp.Anchored then
				local coinParts = {}

				for _, obj in pairs(workspace:GetDescendants()) do
					if obj:IsA("Part") and obj.Name:lower():find("coin") then
						table.insert(coinParts, obj)
					end
				end

				if #coinParts > 0 then
					local randomCoin = coinParts[math.random(1, #coinParts)]
					local targetPos = randomCoin.Position + Vector3.new(0, 3, 0)
					local distance = (hrp.Position - targetPos).Magnitude
					local duration = math.clamp(distance / 30, 0.5, 1.5)

					local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						CFrame = CFrame.new(targetPos)
					})

					tween:Play()
					tween.Completed:Wait()
				end
			end
		end
		task.wait(1 + math.random() * 0.5)
	end
end)

-- KillAll toggle
killAllBtn.MouseButton1Click:Connect(function()
	killAllEnabled = not killAllEnabled
	local text = killAllEnabled and "ON" or "OFF"
	killAllBtn.Text = "KillAll: " .. text
	TweenService:Create(killAllBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = killAllEnabled and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(20, 140, 255)}):Play()
end)

-- KillAll loop
task.spawn(function()
	while true do
		if killAllEnabled then
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")

			if hum and hum.Health > 0 and hrp then
				local knife = player.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")

				if knife then
					if char:FindFirstChildOfClass("Tool") ~= knife then
						hum:EquipTool(knife)
						task.wait(0.5)
					end

					for _, target in pairs(Players:GetPlayers()) do
						if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChildOfClass("Humanoid") and target.Character.Humanoid.Health > 0 then
							hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
							knife:Activate()
							task.wait(0.6)
						end
					end
				end
			end
		end
		task.wait(1.5)
	end
end)

-- Minimize logic
local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	container.Visible = not minimized
	mainFrame.Size = minimized and UDim2.new(0, 320, 0, 40) or UDim2.new(0, 320, 0, 350)
	minimize.Text = minimized and "+" or "-"
end)
