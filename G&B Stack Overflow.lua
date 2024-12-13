--//MAX RANGE IS 25 IMO (anything over will either be buggy or fire before the server can confirm a hit)
local range = 25
local auraActive = false
local guiHidden = false

local plr = game:GetService("Players").LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local zombies = game:GetService("Workspace"):WaitForChild("Zombies")
local gibRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Gib")
local backupsab = plr.Backpack:WaitForChild("Sabre", 5)
local charsab = char:FindFirstChild("Sabre")
local sabreRemote

if backupsab then
    sabreRemote = backupsab:WaitForChild("RemoteEvent")
else
    if charsab then
        sabreRemote = charsab:WaitForChild("RemoteEvent")
    else
        warn("No Sabre found in backpack or character!")
    end
end

local function inRange(zombie)
    local zRoot = zombie:FindFirstChild("HumanoidRootPart")
    return zRoot and (zRoot.Position - root.Position).Magnitude <= range
end

local function sortedZombies()
    local list = {}
    for _, z in ipairs(zombies:GetChildren()) do
        if z:IsA("Model") and z:FindFirstChild("HumanoidRootPart") then
            table.insert(list, z)
        end
    end
    table.sort(list, function(a, b)
        return (a.HumanoidRootPart.Position - root.Position).Magnitude < 
               (b.HumanoidRootPart.Position - root.Position).Magnitude
    end)
    return list
end

local function attack()
    if auraActive then
        for _, z in ipairs(sortedZombies()) do
            if inRange(z) then
                local zHead = z:FindFirstChild("Head")
                if zHead then
                    local hitPos = zHead.Position
                    local atkDir = (hitPos - root.Position).Unit
                    sabreRemote:FireServer("Swing", "Over")
                    gibRemote:FireServer(z, "Head", hitPos, atkDir)
                    sabreRemote:FireServer("HitZombie", z, hitPos, false)
                end
            end
        end
    end
end

local scrgui = Instance.new("ScreenGui")
scrgui.Name = "598124HTG0GJSDG092QJNVSA09KD1890214"
scrgui.Parent = game:GetService("CoreGui")
scrgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame")
frame.Name = "85901YHJ"
frame.Parent = scrgui
frame.Position = UDim2.new(0.554938257, 0, 0.390486717, 0)
frame.Size = UDim2.new(0, 337, 0, 404)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.new(0.188235, 0.188235, 0.188235)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0

local frameCorner = Instance.new("UICorner")
frameCorner.Parent = frame

local frameHeader = Instance.new("Frame")
frameHeader.Name = "overhead"
frameHeader.Parent = frame
frameHeader.Size = UDim2.new(0, 337, 0, 68)
frameHeader.Active = true
frameHeader.BackgroundColor3 = Color3.new(0.32549, 0.32549, 0.32549)
frameHeader.BackgroundTransparency = 0.55
frameHeader.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.Parent = frameHeader

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "stackof"
titleLabel.Parent = frameHeader
titleLabel.Position = UDim2.new(0, 0, -0.088, 0)
titleLabel.Size = UDim2.new(0, 336, 0, 79)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Stack Overflow"
titleLabel.TextColor3 = Color3.new(0.854902, 0.854902, 0.854902)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold


local titleLabelCorner = Instance.new("UICorner")
titleLabelCorner.Parent = titleLabel

local killAuraButton = Instance.new("TextButton")
killAuraButton.Name = "aurabtn"
killAuraButton.Parent = frame
killAuraButton.Position = UDim2.new(0.201780409, 0, 0.235148519, 0)
killAuraButton.Size = UDim2.new(0, 200, 0, 50)
killAuraButton.BackgroundColor3 = Color3.new(0.678431, 0.678431, 0.678431)
killAuraButton.BackgroundTransparency = 0.76
killAuraButton.Text = "Kill Aura"
killAuraButton.TextColor3 = Color3.new(0, 0, 0)
killAuraButton.TextScaled = true
killAuraButton.Font = Enum.Font.SourceSansBold

local killAuraButtonCorner = Instance.new("UICorner")
killAuraButtonCorner.Parent = killAuraButton

local statusFrame = Instance.new("Frame")
statusFrame.Name = "status"
statusFrame.Parent = killAuraButton
statusFrame.Position = UDim2.new(-0.245, 0, 0.16, 0)
statusFrame.Size = UDim2.new(0, 33, 0, 33)
statusFrame.BackgroundColor3 = Color3.new(0.898039, 0.898039, 0.898039)
statusFrame.BackgroundTransparency = 0.4
statusFrame.BorderSizePixel = 0

local statusFrameCorner = Instance.new("UICorner")
statusFrameCorner.Parent = statusFrame

local btnClose = Instance.new("TextButton")
btnClose.Name = "destroy"
btnClose.Parent = frame
btnClose.Position = UDim2.new(0.569732964, 0, 0.866336644, 0)
btnClose.Size = UDim2.new(0, 128, 0, 43)
btnClose.BackgroundColor3 = Color3.new(0.494118, 0.494118, 0.494118)
btnClose.Text = "Scrap UI"
btnClose.TextColor3 = Color3.new(0.901961, 0.901961, 0.901961)
btnClose.TextScaled = true
btnClose.Font = Enum.Font.SourceSansBold

local btnCloseCorner = Instance.new("UICorner")
btnCloseCorner.Parent = btnClose

killAuraButton.MouseButton1Click:Connect(function()
    auraActive = not auraActive
    statusFrame.BackgroundColor3 = auraActive and Color3.new(0, 1, 0) or Color3.new(0.898039, 0.898039, 0.898039)
end)

btnClose.MouseButton1Click:Connect(function()
    scrgui:Destroy()
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if auraActive then
        attack()
    end
end)
