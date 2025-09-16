--[[

    lover.lua
    Type: Bedwars
    by @stav

    ⚠️ :: NOT COMPLETE YET -> EXPECT BUGS

]]

local cloneref = cloneref or function(obj)
    return obj
end

local Library = loadstring(readfile('lover.lua/interface/interface.lua'))()

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

-- Services :)
local playersService = cloneref(game:GetService('Players'))
local starterGui = cloneref(game:GetService('StarterGui'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))

local main = Library.new()

local tabs = {
    Combat = main.create_tab('Combat'),
    Blatant = main.create_tab('Blatant'),
    Render = main.create_tab('Render'),
    Settings = main.create_tab('Settings')
}

run(function()
    local NetManaged = replicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged
    local BlockEngine = replicatedStorage.rbxts_include.node_modules["@easy-games"]["block-engine"].node_modules["@rbxts"].net.out._NetManaged

    local Remotes = {
        SwordHit = NetManaged.SwordHit,
        PickupItemDrop = NetManaged.PickupItemDrop,
        SetInvItem = NetManaged.SetInvItem,
        ProjectileFire = NetManaged.ProjectileFire,
        ChestGetItem = NetManaged["Inventory/ChestGetItem"],
        SetObservedChest = NetManaged["Inventory/SetObservedChest"],
        PlaceBlock = BlockEngine.PlaceBlock,
        DamageBlock = BlockEngine.DamageBlock,
    }
end)