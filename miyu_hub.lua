local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxcursedsocute/UI-Library/refs/heads/main/UI-Library.txt"))()

local windows = UILibrary.CreateWindow("MIYU HUB ","","590","STA")

local Home = windows:AddTab("Home","Home")

Home:AddSection('ESP GAME')

--// SERVICES
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

--// SETTINGS
local MAX_DISTANCE = 333

--// TOGGLES
local Toggles = {
    Weapon=false,Breakable=false,Item=false,Gun=false,Med=false,
    Ammo=false,Fuel=false,Food=false,Crate=false,Battery=false,
    Armor=false,Throwable=false,Backpack=false
}

--// CONFIG
local ESP_TYPES = {
    Weapon={color=Color3.fromRGB(255,50,50),list={"Bat","Knife","Crowbar","Spiked Bat","Spear","Hatchet","Katana","Fire Axe","Sledgehammer","Riot Shield","Scythe","Dark Scythe","Bloodthirster","Chainsaw"}},
    Breakable={color=Color3.fromRGB(200,200,200),list={"Barrel","Military Box","Scrap Pile","Refined Scrap Pile"}},
    Item={color=Color3.fromRGB(255,255,0),list={"Scrap","Tray","Reactor Component","Screws","Spatula","Dumbell","Refined Metal","Bucket","Watch","TV","AC"}},
    Gun={color=Color3.fromRGB(150,75,0),list={"Pistol","Minigun","Medi Gun","Revolver","Uzi","Shotgun","Rifle","Assault Rifle","Double Barrel","Ak-47","Sniper","SVD","Combat SMG","AA-12","LMG","Desert Eagle","Heavy Sniper","Ray Gun","Flamethrower","Grenade Launcher"}},
    Med={color=Color3.fromRGB(0,255,100),list={"Bandage","Medkit","Compound R","Compound I","Compound S"}},
    Ammo={color=Color3.fromRGB(180,180,180),list={"Long Ammo","Medium Ammo","Shells","Pistol Ammo","Ammo Box"}},
    Fuel={color=Color3.fromRGB(0,200,255),list={"Fuel","Refined Fuel","Nuclear Fuel"}},
    Food={color=Color3.fromRGB(255,140,0),list={"Carrot","Bloxy Cola","Bloxiade","Beans","Chips","MRE"}},
    Crate={color=Color3.fromRGB(255,165,0),list={"Crate","Better Crate","Emerald Chest","Reactor Crate","Mystery Box"}},
    Battery={color=Color3.fromRGB(170,0,255),list={"Battery","Battery Pack"}},
    Armor={color=Color3.fromRGB(255,105,180),list={"Light Armor","Medium Armor","Heavy Armor","Power Armor","Gas Mask"}},
    Throwable={color=Color3.fromRGB(210,180,140),list={"Grenade","Molotov","Flashbang","Tear Gas"}},
    Backpack={color=Color3.fromRGB(0,255,200),list={"Basic Backpack","Good Backpack","Great Backpack"}}
}

--// STORAGE
local espList = {}
local typeCache = {}

--// FAST TYPE
local function getType(name)
    if typeCache[name] then return unpack(typeCache[name]) end
    for t,data in pairs(ESP_TYPES) do
        for _,n in ipairs(data.list) do
            if n==name then
                typeCache[name]={t,data.color}
                return t,data.color
            end
        end
    end
end

--// ROOT FIX MODEL
local function getRoot(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    end
end

--// CREATE ESP
local function createESP(obj)
    if espList[obj] then return end

    local t,color = getType(obj.Name)
    if not t then return end

    local root = getRoot(obj)
    if not root then return end

    local gui = Instance.new("BillboardGui")
    gui.Size = UDim2.new(0,110,0,30)
    gui.AlwaysOnTop = true
    gui.StudsOffset = Vector3.new(0,1.5,0)
    gui.MaxDistance = MAX_DISTANCE
    gui.Parent = root

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = color
    text.TextStrokeTransparency = 0.3
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.Parent = gui

    espList[obj] = {gui=gui,text=text,type=t,root=root}
end

--// UPDATE
local last = 0
runService.Heartbeat:Connect(function()
    if tick()-last < 0.1 then return end
    last = tick()

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for obj,data in pairs(espList) do
        if not obj or not obj.Parent or not data.root then
            if data.gui then data.gui:Destroy() end
            espList[obj]=nil
        else
            if not Toggles[data.type] then
                data.gui.Enabled=false
            else
                local dist = (hrp.Position - data.root.Position).Magnitude
                if dist > MAX_DISTANCE then
                    data.gui.Enabled=false
                else
                    data.gui.Enabled=true
                    data.text.Text = obj.Name.." ["..math.floor(dist).."m]"
                end
            end
        end
    end
end)

--// FILTER SCAN (GIẢM LAG)
local function valid(name)
    return typeCache[name] or getType(name)
end

task.spawn(function()
    for _,v in ipairs(workspace:GetDescendants()) do
        if valid(v.Name) then
            createESP(v)
        end
    end
end)

workspace.DescendantAdded:Connect(function(v)
    task.delay(0.3,function()
        if valid(v.Name) then
            createESP(v)
        end
    end)
end)

--// UI TOGGLES
Home:AddToggle({Name="Weapon ESP", Callback=function(v) Toggles.Weapon=v end})
Home:AddToggle({Name="Breakable ESP", Callback=function(v) Toggles.Breakable=v end})
Home:AddToggle({Name="Item ESP", Callback=function(v) Toggles.Item=v end})
Home:AddToggle({Name="Gun ESP", Callback=function(v) Toggles.Gun=v end})
Home:AddToggle({Name="Med ESP", Callback=function(v) Toggles.Med=v end})
Home:AddToggle({Name="Ammo ESP", Callback=function(v) Toggles.Ammo=v end})
Home:AddToggle({Name="Fuel ESP", Callback=function(v) Toggles.Fuel=v end})
Home:AddToggle({Name="Food ESP", Callback=function(v) Toggles.Food=v end})
Home:AddToggle({Name="Crate ESP", Callback=function(v) Toggles.Crate=v end})
Home:AddToggle({Name="Battery ESP", Callback=function(v) Toggles.Battery=v end})
Home:AddToggle({Name="Armor ESP", Callback=function(v) Toggles.Armor=v end})
Home:AddToggle({Name="Throwable ESP", Callback=function(v) Toggles.Throwable=v end})
Home:AddToggle({Name="Backpack ESP", Callback=function(v) Toggles.Backpack=v end})

-----------------------------------------------------------------------------------------------------------//

local Player = windows:AddTab("Player","Player")

Player:AddSection('Main')

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// TOGGLES
local noclip = false
local speed = false
local killaura = false
local infjump = false

--// Noclip
RunService.Stepped:Connect(function()
    if noclip then
        local char = player.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

--// Speed
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if speed then
        if hum.WalkSpeed ~= 30 then
            hum.WalkSpeed = 30
        end
    else
        if hum.WalkSpeed ~= 16 then
            hum.WalkSpeed = 16
        end
    end
end)

--// Kill Aura -- giữ nguyên 0.1
local RANGE = 76
local DELAY = 0.1

local function getWeapon(char)
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local swing = tool:FindFirstChild("Swing")
            local hit = tool:FindFirstChild("HitTargets")

            if swing and hit then
                return tool, swing, hit
            end
        end
    end
end

task.spawn(function()
    while task.wait(DELAY) do
        if not killaura then continue end

        local char = player.Character
        if not char then continue end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local tool, swing, hit = getWeapon(char)
        if not tool then continue end

        local targets = {}

        local charactersFolder = workspace:FindFirstChild("Characters")
        if charactersFolder then
            for _, v in pairs(charactersFolder:GetChildren()) do
                if v ~= char then
                    local enemyHRP = v:FindFirstChild("HumanoidRootPart")
                    local humanoid = v:FindFirstChild("Humanoid")

                    if enemyHRP and humanoid and humanoid.Health > 0 then
                        if (enemyHRP.Position - hrp.Position).Magnitude <= RANGE then
                            table.insert(targets, v)
                        end
                    end
                end
            end
        end

        local structures = workspace:FindFirstChild("Structures")
        if structures then
            for _, obj in pairs(structures:GetChildren()) do
                if obj:IsA("Model") then
                    local part = obj:FindFirstChild("HumanoidRootPart")
                                or obj:FindFirstChildWhichIsA("BasePart")

                    if part then
                        local dist = (part.Position - hrp.Position).Magnitude
                        if dist <= RANGE then
                            if obj.Name == "Barrel"
                            or obj.Name == "Military Box"
                            or obj.Name == "Scrap Pile"
                            or obj.Name == "Refined Scrap Pile" then
                                table.insert(targets, obj)
                            end
                        end
                    end
                end
            end
        end

        if #targets > 0 then
            swing:FireServer()
            hit:FireServer(targets)
        end
    end
end)

--// Infinite Jump
UIS.JumpRequest:Connect(function()
    if infjump then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--// UI TOGGLES

Player:AddButton({
    Name = "Tele Base",
    Description = "Dịch chuyển về lại base",
    Callback = function()
        local char = player.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        hrp.CFrame = hrp.CFrame * CFrame.new(0, -200, 0)
    end,
})

Player:AddToggle({
    Name = "Noclip",
    Description = "Đi xuyên tường",
    Callback = function(v)
        noclip = v
    end,
})

Player:AddToggle({
    Name = "Speed X2",
    Description = 'Tăng tốc độ',
    Callback = function(v)
        speed = v
    end,
})

Player:AddToggle({
    Name = "Kill Aura",
    Description = 'Đánh Lan',
    Callback = function(v)
        killaura = v
    end,
})

Player:AddToggle({
    Name = "Infinite Jump",
    Description = 'Nhảy liên tục',
    Callback = function(v)
        infjump = v
    end,
})

-------------------------------------------------------------------------------------------------------------//

local Misc = windows:AddTab("Misc","Misc")
Misc:AddSection('Support')

--// SERVICES
local Lighting     = game:GetService("Lighting")
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local VirtualUser  = game:GetService("VirtualUser")

local player = Players.LocalPlayer

--// STATES
local FullBright   = false
local FPSBoost     = false
local FPSBoostV2   = false
local AntiAFK      = false

--// CONNECTIONS
local fullBrightConn
local fpsConn
local fpsV2Conn
local antiAFKConn

local tickCount = 0

--// FULL BRIGHT
Misc:AddToggle({
    Name = 'Full Bright',
    Description = 'Luôn sáng map',
    Callback = function(state)
        FullBright = state

        if state then
            fullBrightConn = RunService.RenderStepped:Connect(function()
                Lighting.Brightness = 5
                Lighting.ClockTime = 14
                Lighting.FogEnd = 1000000
                Lighting.GlobalShadows = false
                Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
            end)
        else
            if fullBrightConn then fullBrightConn:Disconnect() end
        end
    end
})

--// FPS BOOST (LITE)
local function optimizeLightingLite()
    Lighting.FogStart = 0
    Lighting.FogEnd   = 1000000

    local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmo then atmo:Destroy() end

    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BloomEffect")
        or v:IsA("BlurEffect")
        or v:IsA("SunRaysEffect")
        or v:IsA("ColorCorrectionEffect")
        or v:IsA("DepthOfFieldEffect") then
            v:Destroy()
        end
    end
end

local function optimizeMapLite()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
            v.CastShadow = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end
end

Misc:AddToggle({
    Name = 'Remove Fog',
    Description = 'Giảm lag nhẹ',
    Callback = function(state)
        FPSBoost = state

        if state then
            FPSBoostV2 = false
            if fpsV2Conn then fpsV2Conn:Disconnect() end

            optimizeLightingLite()
            optimizeMapLite()

            fpsConn = RunService.RenderStepped:Connect(function()
                Lighting.FogEnd = 1000000
            end)
        else
            if fpsConn then fpsConn:Disconnect() end
        end
    end
})

--// FPS BOOST V2
local function optimizeTerrain()
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        Terrain.WaterWaveSize     = 0
        Terrain.WaterWaveSpeed    = 0
        Terrain.WaterReflectance  = 0
        Terrain.WaterTransparency = 1
    end
end

local function optimizeLighting()
    Lighting.FogStart             = 0
    Lighting.FogEnd               = 1e10
    Lighting.GlobalShadows        = false
end

local function nuke(root)
    for _, v in pairs(root:GetDescendants()) do
        if v:IsA("PointLight")
        or v:IsA("SpotLight")
        or v:IsA("SurfaceLight") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Beam")
        or v:IsA("Smoke")
        or v:IsA("Fire")
        or v:IsA("Sparkles") then
            v:Destroy()
        elseif v:IsA("Highlight")
        or v:IsA("SelectionBox")
        or v:IsA("SelectionSphere") then
            v:Destroy()
        elseif v:IsA("Decal")
        or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("SurfaceAppearance") then
            v:Destroy()
        elseif v:IsA("MeshPart") then
            v.TextureID = ""
            v.Material  = Enum.Material.SmoothPlastic
        elseif v:IsA("BasePart") then
            v.Material    = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow  = false
        elseif v:IsA("Explosion") then
            v.BlastPressure = 0
            v.BlastRadius   = 0
        elseif v:IsA("BillboardGui") then
            v.Enabled = false
        end
    end
end

Misc:AddToggle({
    Name = 'FPS Boost',
    Description = 'Giảm lag cực mạnh<máy yếu khuyên dùng>',
    Callback = function(state)
        FPSBoostV2 = state

        if state then
            FPSBoost = false
            if fpsConn then fpsConn:Disconnect() end

            optimizeLighting()
            optimizeTerrain()
            nuke(workspace)

            fpsV2Conn = RunService.RenderStepped:Connect(function()
                if not FPSBoostV2 then return end

                Lighting.FogEnd        = 1e10
                Lighting.GlobalShadows = false

                -- FIX: 300 → 600
                tickCount += 1
                if tickCount >= 600 then
                    tickCount = 0

                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("ParticleEmitter")
                        or v:IsA("Trail")
                        or v:IsA("Beam")
                        or v:IsA("Smoke")
                        or v:IsA("Fire")
                        or v:IsA("Sparkles")
                        or v:IsA("PointLight")
                        or v:IsA("SpotLight")
                        or v:IsA("SurfaceLight") then
                            v:Destroy()
                        end
                    end
                end
            end)

        else
            if fpsV2Conn then fpsV2Conn:Disconnect() end
        end
    end
})

--// ANTI AFK
Misc:AddToggle({
    Name = 'Anti AFK',
    Description = 'Không bị kick',
    Callback = function(state)
        AntiAFK = state

        if state then
            antiAFKConn = player.Idled:Connect(function()
                if not AntiAFK then return end
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        else
            if antiAFKConn then antiAFKConn:Disconnect() end
        end
    end
})

repeat task.wait() until windows and windows.UI

--// BUTTON TOGGLE
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui")

local button = Instance.new("ImageButton", gui)
button.Size = UDim2.new(0,60,0,60)
button.Position = UDim2.new(0.1,0,0.5,0)
button.Image = "rbxassetid://102778899304981"
button.BackgroundColor3 = Color3.fromRGB(30,30,30)

Instance.new("UICorner", button).CornerRadius = UDim.new(1,0)

--// VIỀN ĐỔI MÀU -- FIX: 0.03 → 0.05
local stroke = Instance.new("UIStroke", button)
stroke.Thickness = 3

task.spawn(function()
    local t = 0
    while true do
        t += 0.05

        local alpha = (math.sin(t) + 1) / 2
        local r = 255 * (1 - alpha)
        local g = 170 * alpha
        local b = 255 * alpha

        stroke.Color = Color3.fromRGB(r,g,b)

        task.wait(0.05) -- FIX: 0.03 → 0.05
    end
end)

--// TOGGLE UI
local UIEnabled = true

button.MouseButton1Click:Connect(function()
    UIEnabled = not UIEnabled

    if windows and windows.UI then
        windows.UI.Enabled = UIEnabled
    end
end)

--// DRAG MOBILE
local dragging = false
local dragInput, dragStart, startPos

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
