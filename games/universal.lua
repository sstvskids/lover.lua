--[[

    lover.lua
    Type: Universal
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

--[[

    Combat

]]

run(function()
    print('combat | not done yet twin')
end)

--[[

    Movement

]]

run(function()
    local Value
    tabs.Movement.create_title({
        name = 'Speed',
        section = 'left'
    })

    tabs.Movement.create_toggle({
        name = 'Speed',
        flag = 'speed',

        section = 'left',
        enabled = false,

        callback = function(callback)
            if callback then
                interface.connections.Speed = runService.PreSimulation:Connect(function()
                    if isAlive(lplr) then
                        lplr.Character.Humanoid.WalkSpeed = Value
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
    tabs.Movement.create_slider({
        name = 'Speed',
        flag = 'speedslider',

        section = 'left',

        value = 16,
        minimum_value = 16,
        maximum_value = 23,

        callback = function(val)
            Value = val
        end
    })
end)

--[[

    Settings

]]

run(function()
    tabs.Settings.create_title({
        name = 'FOV',
        section = 'left'
    })

    local fov = 60
    local oldfov
    tabs.Settings.create_toggle({
        name = 'FOVChanger',
        flag = 'fov',

        section = 'left',
        enabled = false,

        callback = function(callback)
            if callback then
                oldfov = workspace.CurrentCamera.FieldOfView
                workspace.CurrentCamera.FieldOfView = fov
				interface.connections.FOV = runService.PreSimulation:Connect(function()
					workspace.CurrentCamera.FieldOfView = fov
                end)
            else
                if interface.connections.FOV then
                    interface.connections.FOV:Disconnect()
                end
                workspace.CurrentCamera.FieldOfView = oldfov
            end
        end
    })
    tabs.Settings.create_slider({
        name = 'FOV',
        flag = 'fovslider',

        section = 'left',

        value = 60,
        minimum_value = 30,
        maximum_value = 120,

        callback = function(val)
            fov = val
        end
    })
end)

run(function()
    tabs.Settings.create_title({
        name = 'FPS',
        section = 'right'
    })

    local fps = 60
    local fpscall
    tabs.Settings.create_toggle({
        name = 'FPS',
        flag = 'nofpslimit',

        section = 'right',
        enabled = false,

        callback = function(callback)
            fpscall = callback
            if callback then
                setfpscap(fps)
            else
                setfpscap(60)
            end
        end
    })
    tabs.Settings.create_slider({
        name = 'FPS',
        flag = 'fpsslider',

        section = 'right',

        value = 999,
        minimum_value = 60,
        maximum_value = 999,

        callback = function(value)
            fps = value
            if fpscall then
                setfpscap(value)
            end
        end
    })
end)

run(function()
    tabs.Settings.create_title({
        name = 'Uninject',
        section = 'left'
    })

    tabs.Settings.create_toggle({
        name = 'Uninject',
        flag = 'uninject',

        section = 'left',
        enabled = false,

        callback = function(callback)
            if callback then
                interface.Flags['uninject'] = false
				interface.save_flags()
                task.wait(0.5)
                interface:uninject()
            end
        end
    })
end)