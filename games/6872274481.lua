--[[

    lover.lua
    Type: Bedwars
    by @stav

    ⚠️ :: NOT COMPLETE YET -> EXPECT BUGS

]]

local run = function(func)
    local suc, res = pcall(func)
    return suc == true and res or suc == false and ((writefile and writefile('lover.lua/errorlog.txt', res)) or warn(res))
end
local cloneref = cloneref or function(obj)
    return obj
end

local interface = loadstring(readfile('lover.lua/interface/interface.lua'))()

-- Services :)
local playersService = cloneref(game:GetService('Players'))
local starterGui = cloneref(game:GetService('StarterGui'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local lplr = playersService.LocalPlayer

local notif = function(title, txt, dur, buttons)
    local packet = {
        Title = title,
        Text = txt,
        Duration = dur
    }

    for i,v in buttons do
        packet[i] = v
    end

    starterGui:SetCore('SendNotification', packet)
end

local main = interface.new()

local remotes, tabs = {}, {
    Combat = main.create_tab('Combat'),
    Movement = main.create_tab('Movement'),
    Render = main.create_tab('Render'),
    Settings = main.create_tab('Settings')
}

local function isAlive(v)
    if v.Character and v.Character:FindFirstChild('Humanoid') and v.Character:FindFirstChild('HumanoidRootPart') and v.Character.Humanoid.Health > 0 then
        return true
    end

    return false
end

local function getPart(v)
    if isAlive(v) then
        return v.Character.PrimaryPart
    end
end

run(function()
    local NetManaged = replicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged
    local BlockEngine = replicatedStorage.rbxts_include.node_modules["@easy-games"]["block-engine"].node_modules["@rbxts"].net.out._NetManaged

    remotes = setmetatable({
        SwordHit = NetManaged.SwordHit,
        PickupItemDrop = NetManaged.PickupItemDrop,
        SetInvItem = NetManaged.SetInvItem,
        ProjectileFire = NetManaged.ProjectileFire,
        ChestGetItem = NetManaged["Inventory/ChestGetItem"],
        SetObservedChest = NetManaged["Inventory/SetObservedChest"],
        PlaceBlock = BlockEngine.PlaceBlock,
        DamageBlock = BlockEngine.DamageBlock,
    }, nil)
end)

run(function()
    local Speed
    local Value
    tabs.Movement.create_title({
        name = 'Speed',
        section = 'left'
    })

    Speed = tabs.Movement.create_toggle({
        name = 'Speed',
        flag = 'speed',

        section = 'left',
        enabled = false,

        callback = function(callback)
            if callback then
                interface.connections.Speed = runService.PreSimulation:Connect(function()
                    if isAlive(lplr) then
                        lplr.Character.Humanoid.WalkSpeed = Value.value
                    end
                end)
            else
                if interface.connections.Speed then
                    interface.connections.Speed:Disconnect()
                end
                lplr.Character.Humanoid.WalkSpeed = 16
            end
        end
    })
    Value = tabs.Movement.create_slider({
        name = 'Speed',
        flag = 'speedslider',

        section = 'left',

        value = 23,
        minimum_value = 16,
        maximum_value = 23
    })
end)