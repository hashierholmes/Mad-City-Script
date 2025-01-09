-- Ensure game is fully loaded
repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.Character
repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- Prevent multiple executions
if _G.AutoRob then
    warn("Auto Rob already loaded.")
    return
end

_G.AutoRob = true
queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/hashierholmes/Mad-City-Script/refs/heads/main/auto2.lua'))()")

-- Debug info
for i = 1, 10 do
    print("@Made by NtOpenProcess and deni210 (on Discord)")
end

-- Function to hop to another server
local function serverHop()
    local success, result = pcall(function()
        local servers = {}
        local response = request({
            Url = "https://games.roblox.com/v1/games/91282350711571/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"
        })
        local data = game:GetService("HttpService"):JSONDecode(response.Body)

        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
        end

        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(91282350711571, servers[math.random(1, #servers)], game.Players.LocalPlayer)
        else
            if #game.Players:GetChildren() <= 1 then
                game.Players.LocalPlayer:Kick("Rejoining...")
                wait(1)
                game:GetService("TeleportService"):Teleport(91282350711571, game.Players.LocalPlayer)
            else
                game:GetService("TeleportService"):TeleportToPlaceInstance(91282350711571, game.JobId, game.Players.LocalPlayer)
            end
        end
    end)

    if not success then
        warn("Server hop failed: ", result)
        serverHop()
    end
end

-- Respawn handler
local function onDeath()
    serverHop()
end

game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(onDeath)

-- Remove teleport effect if present
local teleportEffect = game.Players.LocalPlayer.PlayerGui.MainGUI:FindFirstChild("TeleportEffect")
if teleportEffect then
    teleportEffect:Destroy()
end

-- Teleport function
local function teleportTo(x, y, z)
    local corePart = workspace.Pyramid.Tele.Core2
    corePart.CanCollide = false
    corePart.Transparency = 1
    corePart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    task.wait()
    corePart.CFrame = CFrame.new(1231.14185, 51051.2344, 318.096191)
    corePart.Transparency = 0
    corePart.CanCollide = true
    task.wait()

    for _ = 1, 45 do
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
        task.wait()
    end
end

-- Mini-robbery handling
local MiniRobberies = {"Cash", "CashRegister", "DiamondBox", "Laptop", "Phone", "Luggage", "ATM", "TV", "Safe"}

local function findRemoteEvent(object)
    for _, descendant in ipairs(object:GetDescendants()) do
        if descendant:IsA("RemoteEvent") then
            return descendant
        end
    end
    return nil
end

local function findRobbery()
    for _, obj in ipairs(workspace.ObjectSelection:GetChildren()) do
        if table.find(MiniRobberies, obj.Name) and not obj:FindFirstChild("Nope") and findRemoteEvent(obj) then
            return obj
        end
    end
    return nil
end

-- Execute robbery sequence
teleportTo(-82, 86, 807)
task.wait(0.5)

for _, box in ipairs(workspace.JewelryStore.JewelryBoxes:GetChildren()) do
    task.spawn(function()
        for _ = 1, 5 do
            workspace.JewelryStore.JewelryBoxes.JewelryManager.Event:FireServer(box)
        end
    end)
end

task.wait(2)
teleportTo(2115, 26, 420)
task.wait(1)

repeat
    local robberyTarget = findRobbery()
    if robberyTarget then
        for _ = 1, 20 do
            local pos = robberyTarget:GetPivot().Position
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos.x, pos.y + 5, pos.z)
            findRemoteEvent(robberyTarget):FireServer()
            task.wait()
        end
    end
until not findRobbery()

task.wait(1)
serverHop()
