local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local PlayerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.Parent = PlayerGui

-- Background frame for corner UI
local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.new(0, 120, 0, 70)
bgFrame.Position = UDim2.new(1, -130, 0, 20) -- Top right corner with padding
bgFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
bgFrame.BackgroundTransparency = 0.1
bgFrame.BorderSizePixel = 0
bgFrame.Parent = screenGui
bgFrame.Active = true
bgFrame.Draggable = false
bgFrame.AnchorPoint = Vector2.new(0, 0)

-- Label above the button
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -10, 0, 20)
label.Position = UDim2.new(0, 5, 0, 5)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(0, 200, 255)
label.Font = Enum.Font.GothamBold
label.TextSize = 18
label.Text = "Emware Hub"
label.TextStrokeTransparency = 0.6
label.Parent = bgFrame

-- Button inside the frame below label
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 0, 40)
button.Position = UDim2.new(0, 5, 0, 25)
button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
button.BorderSizePixel = 0
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.Text = "Fly: OFF"
button.AutoButtonColor = true
button.Parent = bgFrame

-- Hover effect with size tween
local hoverTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local normalSize = button.Size
local hoverSize = UDim2.new(normalSize.X.Scale, normalSize.X.Offset + 10, normalSize.Y.Scale, normalSize.Y.Offset + 5)

button.MouseEnter:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    TweenService:Create(button, hoverTweenInfo, {Size = hoverSize}):Play()
end)

button.MouseLeave:Connect(function()
    button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    TweenService:Create(button, hoverTweenInfo, {Size = normalSize}):Play()
end)

-- Flying variables
local flying = false
local speed = 70
local flyDirection = Vector3.new(0,0,0)

-- Update flying direction relative to camera
local function updateFlyDirection()
    local camCFrame = workspace.CurrentCamera.CFrame
    local direction = Vector3.new()

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction = direction + camCFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction = direction - camCFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction = direction - camCFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction = direction + camCFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        direction = direction - Vector3.new(0, 1, 0)
    end

    if direction.Magnitude > 0 then
        flyDirection = direction.Unit
    else
        flyDirection = Vector3.new(0,0,0)
    end
end

-- Connect input events
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        updateFlyDirection()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed then
        updateFlyDirection()
    end
end)

-- Flying loop
local connection
local function startFlying()
    humanoid.PlatformStand = true
    connection = RunService.Heartbeat:Connect(function()
        updateFlyDirection()
        hrp.Velocity = flyDirection * speed
    end)
end

local function stopFlying()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    humanoid.PlatformStand = false
    hrp.Velocity = Vector3.new(0,0,0)
end

-- Button toggle
button.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        button.Text = "Fly: ON"
        startFlying()
    else
        button.Text = "Fly: OFF"
        stopFlying()
    end
end)
