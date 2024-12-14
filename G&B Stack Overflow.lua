local range = 25
local killAuraEnabled = false
local espEnabled = false
local zombies = game:GetService("Workspace"):WaitForChild("Zombies")
local player = game:GetService("Players").LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local gibRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Gib")
local sabreRemote

local sabreInBackpack = player.Backpack:FindFirstChild("Sabre")
local sabreInChar = char:FindFirstChild("Sabre")
if sabreInBackpack then
    sabreRemote = sabreInBackpack:WaitForChild("RemoteEvent")
elseif sabreInChar then
    sabreRemote = sabreInChar:WaitForChild("RemoteEvent")
else
    warn("No Sabre found!")
end

local function inRange(z)
    local zRoot = z:FindFirstChild("HumanoidRootPart")
    return zRoot and (zRoot.Position - root.Position).Magnitude <= range
end

local function sortedZ()
    local zList = {}
    for _, z in ipairs(zombies:GetChildren()) do
        if z:IsA("Model") and z:FindFirstChild("HumanoidRootPart") then
            table.insert(zList, z)
        end
    end
    table.sort(zList, function(a, b)
        return (a.HumanoidRootPart.Position - root.Position).Magnitude <
               (b.HumanoidRootPart.Position - root.Position).Magnitude
    end)
    return zList
end

local function attackZ()
    if killAuraEnabled then
        for _, z in ipairs(sortedZ()) do
            if inRange(z) then
                local zHead = z:FindFirstChild("Head")
                if zHead then
                    local hitPos = zHead.Position
                    local dir = (hitPos - root.Position).Unit
                    sabreRemote:FireServer("Swing", "Over")
                    gibRemote:FireServer(z, "Head", hitPos, dir)
                    sabreRemote:FireServer("HitZombie", z, hitPos, false)
                end
            end
        end
    end
end

local function zombichams(z)
    local cg = game:GetService("CoreGui")
    local fn = "foldchms_" .. tostring(z:GetDebugId())

    for _, v in pairs(cg:GetChildren()) do
        if v.Name == fn then
            v:Destroy()
        end
    end

    local chams = Instance.new("Folder")
    chams.Name = fn
    chams.Parent = cg

    local parts = {"Torso", "Head", "HumanoidRootPart", "Left Leg", "Right Leg", "Left Arm", "Right Arm"}
    for _, pName in ipairs(parts) do
        local part = z:FindFirstChild(pName)
        if part then
            local adorn = Instance.new("BoxHandleAdornment")
            adorn.Name = "adorn_" .. part.Name
            adorn.Parent = chams
            adorn.Adornee = part
            adorn.AlwaysOnTop = true
            adorn.ZIndex = 10
            adorn.Size = part.Size
            adorn.Transparency = 0.7
            adorn.Color3 = Color3.new(0, 0, 0)
        end
    end

    z.AncestryChanged:Connect(function()
        if not z:IsDescendantOf(game) then
            chams:Destroy()
        end
    end)
end

local function freshReload()
    for _, z in ipairs(zombies:GetChildren()) do
        if z:IsA("Model") and not game:GetService("CoreGui"):FindFirstChild(z.Name .. "_CHMS") then
            zombichams(z)
        end
    end
end

local scrgui = Instance.new("ScreenGui")
scrgui.Name = "598124HTG0GJSDG092QJNVSA09KD1890214"
scrgui.Parent = game:GetService("CoreGui")
scrgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frm = Instance.new("Frame")
frm.Name = "85901YHJ"
frm.Parent = scrgui
frm.Position = UDim2.new(0.554938257, 0, 0.390486717, 0)
frm.Size = UDim2.new(0, 337, 0, 404)
frm.Active = true
frm.Draggable = true
frm.BackgroundColor3 = Color3.new(0.188235, 0.188235, 0.188235)
frm.BackgroundTransparency = 0.15
frm.BorderSizePixel = 0

local frmCorner = Instance.new("UICorner")
frmCorner.Parent = frm

local frmHead = Instance.new("Frame")
frmHead.Name = "overhead"
frmHead.Parent = frm
frmHead.Size = UDim2.new(0, 337, 0, 68)
frmHead.Active = true
frmHead.BackgroundColor3 = Color3.new(0.32549, 0.32549, 0.32549)
frmHead.BackgroundTransparency = 0.55
frmHead.BorderSizePixel = 0

local frmHeadCorner = Instance.new("UICorner")
frmHeadCorner.Parent = frmHead

local txtLabel = Instance.new("TextLabel")
txtLabel.Name = "stackof"
txtLabel.Parent = frm
txtLabel.Size = UDim2.new(0, 336, 0, 79)
txtLabel.BackgroundTransparency = 1
txtLabel.Text = "Stack Overflow"
txtLabel.TextColor3 = Color3.new(0.854902, 0.854902, 0.854902)
txtLabel.TextScaled = true
txtLabel.Font = Enum.Font.SourceSansBold

local txtLabelCorner = Instance.new("UICorner")
txtLabelCorner.Parent = txtLabel

local killBtn = Instance.new("TextButton")
killBtn.Name = "aurabtn"
killBtn.Parent = frm
killBtn.Position = UDim2.new(0.201780409, 0, 0.235148519, 0)
killBtn.Size = UDim2.new(0, 200, 0, 50)
killBtn.BackgroundColor3 = Color3.new(0.678431, 0.678431, 0.678431)
killBtn.BackgroundTransparency = 0.76
killBtn.Text = "Kill Aura"
killBtn.TextColor3 = Color3.new(0, 0, 0)
killBtn.TextScaled = true
killBtn.Font = Enum.Font.SourceSansBold

local killBtnCorner = Instance.new("UICorner")
killBtnCorner.Parent = killBtn

local killKeyBtn = Instance.new("TextButton")
killKeyBtn.Name = "setkeybindbtn"
killKeyBtn.Parent = killBtn
killKeyBtn.Position = UDim2.new(-0.245, 0, 0.16, 0)
killKeyBtn.Size = UDim2.new(0, 33, 0, 33)
killKeyBtn.BackgroundColor3 = Color3.new(146, 146, 146)
killKeyBtn.BackgroundTransparency = 0.3
killKeyBtn.Text = "bind"
killKeyBtn.TextColor3 = Color3.new(0, 0, 0)
killKeyBtn.TextScaled = true
killKeyBtn.Font = Enum.Font.SourceSansBold

local killKeyBtnCorner = Instance.new("UICorner")
killKeyBtnCorner.Parent = killKeyBtn

local espBtn = Instance.new("TextButton")
espBtn.Name = "espbtn"
espBtn.Parent = frm
espBtn.Position = UDim2.new(0.201780409, 0, 0.400000000, 0)
espBtn.Size = UDim2.new(0, 200, 0, 50)
espBtn.BackgroundColor3 = Color3.new(0.678431, 0.678431, 0.678431)
espBtn.BackgroundTransparency = 0.76
espBtn.Text = "Zombie Chams"
espBtn.TextColor3 = Color3.new(0, 0, 0)
espBtn.TextScaled = true
espBtn.Font = Enum.Font.SourceSansBold

local espBtnCorner = Instance.new("UICorner")
espBtnCorner.Parent = espBtn

local destroyBtn = Instance.new("TextButton")
destroyBtn.Name = "destroy"
destroyBtn.Parent = frm
destroyBtn.Position = UDim2.new(0.569732964, 0, 0.866336644, 0)
destroyBtn.Size = UDim2.new(0, 128, 0, 43)
destroyBtn.BackgroundColor3 = Color3.new(0.494118, 0.494118, 0.494118)
destroyBtn.Text = "SCRAP UI"
destroyBtn.TextColor3 = Color3.new(0.901961, 0.901961, 0.901961)
destroyBtn.TextScaled = true
destroyBtn.Font = Enum.Font.SourceSansBold

local destroyBtnCorner = Instance.new("UICorner")
destroyBtnCorner.Parent = destroyBtn

local keybind = nil
local settingKey = false

destroyBtn.MouseButton1Click:Connect(function()
    keybind = nil
    settingKey = false
    killAuraEnabled = false
    espEnabled = false
    killBtn.BackgroundColor3 = Color3.new(0.678431, 0.678431, 0.678431)
    espBtn.BackgroundColor3 = Color3.new(0.678431, 0.678431, 0.678431)

    local cg = game:GetService("CoreGui")
    for _, v in pairs(cg:GetChildren()) do
        if string.match(v.Name, "foldchms_") then
            v:Destroy()
        end
    end

    scrgui:Destroy()
end)

killBtn.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    killBtn.BackgroundColor3 = killAuraEnabled and Color3.new(0, 1, 0) or Color3.new(0.678431, 0.678431, 0.678431)
end)

killKeyBtn.MouseButton1Click:Connect(function()
    settingKey = true
    killKeyBtn.Text = "..."
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if settingKey and not processed then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            keybind = input.KeyCode
            killKeyBtn.Text = input.KeyCode.Name
            settingKey = false
        end
    end

    if input.KeyCode == keybind then
        killAuraEnabled = not killAuraEnabled
        killBtn.BackgroundColor3 = killAuraEnabled and Color3.new(0, 1, 0) or Color3.new(0.678431, 0.678431, 0.678431)
    end
end)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.BackgroundColor3 = espEnabled and Color3.new(0, 1, 0) or Color3.new(0.678431, 0.678431, 0.678431)

    if espEnabled then
        freshReload()
    else
        local cg = game:GetService("CoreGui")
        for _, v in pairs(cg:GetChildren()) do
            if string.match(v.Name, "foldchms_") then
                v:Destroy()
            end
        end
    end
end)
