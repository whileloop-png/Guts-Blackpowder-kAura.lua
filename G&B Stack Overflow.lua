--//MAX RANGE IS 25 IMO (anything over will either be buggy or fire before the server can confirm a hit)
local range = 25
local killAuraEnabled = false
local espEnabled = false
local zombies = game:GetService("Workspace"):WaitForChild("Zombies")
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local gibRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Gib")
local sabreRemote

local sabreInBackpack = player.Backpack:FindFirstChild("Sabre")
local sabreInCharacter = character:FindFirstChild("Sabre")
if sabreInBackpack then
    sabreRemote = sabreInBackpack:WaitForChild("RemoteEvent")
elseif sabreInCharacter then
    sabreRemote = sabreInCharacter:WaitForChild("RemoteEvent")
else
    warn("No Sabre found!")
end

local function isInRange(zombie)
    local zombieRoot = zombie:FindFirstChild("HumanoidRootPart")
    return zombieRoot and (zombieRoot.Position - root.Position).Magnitude <= range
end

local function getSortedZombies()
    local zombieList = {}
    for _, zombie in ipairs(zombies:GetChildren()) do
        if zombie:IsA("Model") and zombie:FindFirstChild("HumanoidRootPart") then
            table.insert(zombieList, zombie)
        end
    end
    table.sort(zombieList, function(a, b)
        return (a.HumanoidRootPart.Position - root.Position).Magnitude <
               (b.HumanoidRootPart.Position - root.Position).Magnitude
    end)
    return zombieList
end

local function attackZombies()
    if killAuraEnabled then
        for _, zombie in ipairs(getSortedZombies()) do
            if isInRange(zombie) then
                local zombieHead = zombie:FindFirstChild("Head")
                if zombieHead then
                    local hitPos = zombieHead.Position
                    local attackDir = (hitPos - root.Position).Unit
                    sabreRemote:FireServer("Swing", "Over")
                    gibRemote:FireServer(zombie, "Head", hitPos, attackDir)
                    sabreRemote:FireServer("HitZombie", zombie, hitPos, false)
                end
            end
        end
    end
end

local function addZombieChams(zombie)
    local coreGui = game:GetService("CoreGui")
    local folderName = "foldchms_" .. tostring(zombie:GetDebugId())

    for _, existing in pairs(coreGui:GetChildren()) do
        if existing.Name == folderName then
            existing:Destroy()
        end
    end

    local chamsFolder = Instance.new("Folder")
    chamsFolder.Name = folderName
    chamsFolder.Parent = coreGui

    local bodyParts = {"Torso", "Head", "HumanoidRootPart", "Left Leg", "Right Leg", "Left Arm", "Right Arm"}
    for _, partName in ipairs(bodyParts) do
        local part = zombie:FindFirstChild(partName)
        if part then
            local adornment = Instance.new("BoxHandleAdornment")
            adornment.Name = "adorn_" .. part.Name
            adornment.Parent = chamsFolder
            adornment.Adornee = part
            adornment.AlwaysOnTop = true
            adornment.ZIndex = 10
            adornment.Size = part.Size
            adornment.Transparency = 0.7
            adornment.Color3 = Color3.new(0, 0, 0)
        end
    end

    zombie.AncestryChanged:Connect(function()
        if not zombie:IsDescendantOf(game) then
            chamsFolder:Destroy()
        end
    end)
end

local function updateESP()
    for _, zombie in ipairs(zombies:GetChildren()) do
        if zombie:IsA("Model") and not game:GetService("CoreGui"):FindFirstChild(zombie.Name .. "_CHMS") then
            addZombieChams(zombie)
        end
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "598124HTG0GJSDG092QJNVSA09KD1890214"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "85901YHJ"
mainFrame.Parent = screenGui
mainFrame.Position = UDim2.new(0.554938257, 0, 0.390486717, 0)
mainFrame.Size = UDim2.new(0, 337, 0, 404)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BackgroundColor3 = Color3.new(0.188235, 0.188235, 0.188235)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.Parent = mainFrame

local headerFrame = Instance.new("Frame")
headerFrame.Name = "overhead"
headerFrame.Parent = mainFrame
headerFrame.Size = UDim2.new(0, 337, 0, 68)
headerFrame.Active = true
headerFrame.BackgroundColor3 = Color3.new(0.32549, 0.32549, 0.32549)
headerFrame.BackgroundTransparency = 0.55
headerFrame.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner")
headerCorner.Parent = headerFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "stackof"
titleLabel.Parent = mainFrame
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
killAuraButton.Parent = mainFrame
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

local keyBindButton = Instance.new("TextButton")
keyBindButton.Name = "setkeybindbtn"
keyBindButton.Parent = killAuraButton
keyBindButton.Position = UDim2.new(-0.245, 0, 0.16, 0)
keyBindButton.Size = UDim2.new(0, 33, 0, 33)
keyBindButton.BackgroundColor3 = Color3.new(146, 146, 146)
keyBindButton.BackgroundTransparency = 0.3
keyBindButton.Text = "bind"
keyBindButton.TextColor3 = Color3.new(0, 0, 0)
keyBindButton.TextScaled = true
keyBindButton.Font = Enum.Font.SourceSansBold

local keyBindButtonCorner = Instance.new("UICorner")
keyBindButtonCorner.Parent = keyBindButton

local espButton = Instance.new("TextButton")
espButton.Name = "espbtn"
espButton.Parent = mainFrame
espButton.Position = UDim2.new(0.201780409, 0, 0.400000000, 0)
espButton.Size = UDim2.new(0, 200, 0, 50)
espButton.BackgroundColor3 = Color3.new(0.678431, 0.678431, 0.678431)
espButton.BackgroundTransparency = 0.76
espButton.Text = "Zombie Chams"
espButton.TextColor3 = Color3.new(0, 0, 0)
espButton.TextScaled = true
