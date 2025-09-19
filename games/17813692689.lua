--[[

    lover.lua
    Type: Journey with Jesus
    by @stav

]]

local run = function(func)
    local suc, res = pcall(func)
    return suc == true and res or suc == false and ((writefile and writefile('lover.lua/errorlog.txt', res)) or warn(res))
end
local cloneref = cloneref or function(obj)
    return obj
end

local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))
local runService = cloneref(game:GetService('RunService'))
local lplr = playersService.LocalPlayer

local function downloadFile(file)
    url = file:gsub('lover.lua/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/sstvskids/lover.lua/'..readfile('lover.lua/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

local interface = loadstring(readfile('lover.lua/interface/interface.lua'))()
local Notifications = loadstring(downloadFile('lover.lua/libraries/journey-notif.lua'))()

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

local main = interface.new()
local tabs = {
    Combat = main.create_tab('Combat'),
    Movement = main.create_tab('Movement'),
    Render = main.create_tab('Render'),
    Settings = main.create_tab('Settings')
}

run(function()
    tabs.Combat.create_title({
        name = 'Aura',
        section = 'left'
    })

    local TPAura
    local Range
    tabs.Combat.create_toggle({
        name = 'Aura',
        flag = 'aura',

        section = 'left',
        enabled = false,

        callback = function(callback)
            if callback then
                interface.connections.Aura = runService.PreSimulation:Connect(function()
                    task.spawn(function()
                        for _, v in playersService:GetPlayers() do
                            if v ~= lplr and isAlive(v) and (getPart(lplr).Position - getPart(v).Position).Magnitude <= Range then
                                if TPAura then
                                    getPart(lplr).CFrame = getPart(v).CFrame + Vector3.new(0, 1, 0)
                                end

                                workspace.CombatSystemFolder.PannelFolder.Remotes.PunchRemote:FireServer('LeftPunch', {}, 0)
                                workspace.CombatSystemFolder.PannelFolder.Remotes.PunchRemote:FireServer('RightPunch', {}, 0)
                            end
                        end
                    end)
                end)
            else
                if interface.connections.Aura then
                    interface.connections.Aura:Disconnect()
                end
            end
        end
    })
    tabs.Combat.create_toggle({
        name = 'TPAura',
        flag = 'tpaura',

        section = 'left',
        enabled = false,
        callback = function(callback)
            TPAura = callback
        end
    })
    tabs.Combat.create_slider({
        name = 'Range',
        flag = 'aurarange',

        section = 'left',

        value = 15,
        minimum_value = 1,
        maximum_value = 20,

        callback = function(value)
            Range = value
        end
    })
end)

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
        maximum_value = 100,

        callback = function(val)
            Value = val
        end
    })
end)

run(function()
    tabs.Movement.create_title({
        name = 'Grace',
        section = 'right'
    })

    tabs.Movement.create_toggle({
        name = 'DoubleGrace',
        flag = 'grace',

        section = 'right',
        enabled = false,

        callback = function(callback)
            if callback then
                interface.connections.Grace = runService.PreSimulation:Connect(function()
                    if isAlive(lplr) then
                        getPart(lplr).CFrame = workspace.JacobLadder.PhysicalSetup.Stand.CFrame + Vector3.new(0, 3.25, 0)
                    end
                end)
            else
                if interface.connections.Grace then
                    interface.connections.Grace:Disconnect()
                end
            end
        end
    })
end)

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
                task.spawn(function()
                    interface.Flags['uninject'] = false
    				interface.save_flags()
    			end)
                task.wait(0.5)
                Notifications.NewNotification(lplr, 'uninjected', 2, Color3.fromRGB(255,255,255), 'Yay!')
                interface:uninject()
            end
        end
    })
end)

return Notifications.NewNotification(lplr, 'Script fully loaded :)', 4, Color3.fromRGB(255,255,255), 'Yay!')