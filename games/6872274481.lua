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

local function downloadFile(file)
    url = file:gsub('lover.lua/', '')
    if not isfile(file) then
        writefile(file, game:HttpGet('https://raw.githubusercontent.com/sstvskids/lover.lua/'..readfile('lover.lua/commit.txt')..'/'..url))
    end

    repeat task.wait() until isfile(file)
    return readfile(file)
end

local interface = loadstring(readfile('lover.lua/interface/interface.lua'))()
local itemMeta = loadstring(downloadFile('lover.lua/libraries/meta.lua'))()

-- Services :)
local playersService = cloneref(game:GetService('Players'))
local starterGui = cloneref(game:GetService('StarterGui'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local lplr = playersService.LocalPlayer

local notif = function(title, txt, dur)
    local packet = {
        Title = title,
        Text = txt,
        Duration = dur
    }

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
    if workspace:FindFirstChild(v.Name) then
        return true
    end

    return false
end

local function getNearestEntity(range: number): number
	for i,v in playersService:GetPlayers() do
		if v == lplr or v.Team == lplr.Team or not isAlive(v) then continue end

		if v.Character and v.Character.PrimaryPart then
			if (lplr.Character.PrimaryPart.Position - v.Character.PrimaryPart.Position).Magnitude <= range then
				return v
			end
		end
	end
end

local function hasItem(item: string)
    if isAlive(lplr) and workspace[lplr.Name]:FindFirstChild(item) then
        return true
    end

    return false
end

local function getBestSword()
    local bestItem, bestItemStrength = nil, 0

    for i,v in ipairs(itemMeta) do
		local item = tostring(v[1])
        if hasItem(item) and v[2] > bestItemStrength then
            bestItem, bestItemStrength = v[1], v[2]
        end
    end

    return workspace[lplr.Name].InventoryFolder.Value:FindFirstChild(bestItem)
end

run(function()
    local NetManaged = replicatedStorage.rbxts_include.node_modules['@rbxts'].net.out._NetManaged
    local BlockEngine = replicatedStorage.rbxts_include.node_modules['@easy-games']['block-engine'].node_modules['@rbxts'].net.out._NetManaged

    remotes = {
        SwordHit = NetManaged.SwordHit,
        PickupItemDrop = NetManaged.PickupItemDrop,
        SetInvItem = NetManaged.SetInvItem,
        ProjectileFire = NetManaged.ProjectileFire,
        ChestGetItem = NetManaged['Inventory/ChestGetItem'],
        SetObservedChest = NetManaged['Inventory/SetObservedChest'],
        PlaceBlock = BlockEngine.PlaceBlock,
        DamageBlock = BlockEngine.DamageBlock
    }
end)

local AutoTool = false
local function spoofTool(item: string): string
    if AutoTool == true and isAlive(lplr) and not hasItem(item) then
        remotes.SetInvItem:InvokeServer({
			['hand'] = workspace[lplr.Name].InventoryFolder.Value:FindFirstChild(item)
		})
    end
end

--[[

    Combat

]]

run(function()
    tabs.Combat.create_title({
        name = 'Knockback',
        section = 'left'
    })

    tabs.Combat.create_toggle({
        name = 'Velocity',
        flag = 'velocity',

        section = 'left',
        enabled = false,

        callback = function(callback)
            if callback then
                local lastHP = lplr.Character.Humanoid.Health
                interface.connections.Velocity = runService.RenderStepped:Connect(function()
                    if isAlive(lplr) then
                        if lplr.Character.Humanoid.Health < lastHP then
                            lplr.Character.PrimaryPart.Velocity = Vector3.zero
                        end
                        lastHP = lplr.Character.Humanoid.Health
                    end
                end)
            else
                if interface.connections.Velocity then
                    interface.connections.Velocity:Disconnect()
                end
            end
        end,
    })
end)

run(function()
    local Aura
    local Range = 18
    local Face = false
    tabs.Combat.create_title({
        name = 'Aura',
        section = 'right'
    })

    tabs.Combat.create_toggle({
        name = 'Aura',
        flag = 'aura',

        section = 'right',
        enabled = false,

        callback = function(callback)
            if callback then
                interface.connections.Aura = runService.PreSimulation:Connect(function()
					if isAlive(lplr) then
						local entity = getNearestEntity(Range)

						if entity then
							local bestTool = getBestSword()
							spoofTool(bestTool.Name)

							if hasItem(bestTool.Name) then
								local targetPos = entity.Character.PrimaryPart.Position
								local selfpos = lplr.Character.PrimaryPart.Position

								local delta = (targetPos - selfpos)
								local dir = CFrame.lookAt(selfpos, targetPos).LookVector
								local pos = selfpos + dir * math.max(delta.Magnitude - 14.399, 0)

                                if Face then
						            local vec = entity.Character.PrimaryPart.Position * Vector3.new(1, 0, 1)
						            lplr.Character.PrimaryPart.CFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(vec.X, lplr.Character.HumanoidRootPart.Position.Y + 0.001, vec.Z))
                                end

								remotes.SwordHit:FireServer({
									chargedAttack = {chargeRatio = 0},
									entityInstance = entity.Character,
									weapon = bestTool,
									validate = {
										raycast = {
											cameraPosition = {value = pos},
											cursorDirection = {value = dir}
										},
										targetPosition = {value = targetPos},
										selfPosition = {value = pos}
									}
								})
							end
						end
					end
                end)
            else
                if interface.connections.Aura then
                    interface.connections.Aura:Disconnect()
                end
            end
        end
    })
    tabs.Combat.create_slider({
        name = 'Range',
        flag = 'rangeslider',

        section = 'right',

        value = 18,
        minimum_value = 1,
        maximum_value = 18,

        callback = function(val)
            Range = val
        end
    })
    tabs.Combat.create_toggle({
        name = 'Face',
        flag = 'auraface',

        section = 'right',
        enabled = false,

        callback = function(callback)
            Face = callback
        end
    })
end)

run(function()
    tabs.Combat.create_title({
        name = 'AutoTool',
        section = 'left'
    })

    tabs.Combat.create_toggle({
        name = 'AutoTool',
        flag = 'autotool',

        section = 'left',
        enabled = false,

        callback = function(callback)
            AutoTool = callback
        end
    })
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

run(function()
    local FlyVal = 0
    tabs.Movement.create_title({
        name = 'Flight',
        section = 'right'
    })

    tabs.Movement.create_toggle({
        name = 'Flight',
        flag = 'flight',

        section = 'right',
        enabled = false,

        callback = function(callback)
            if callback then
                interface.connections.FlightUp = inputService.InputBegan:Connect(function(input)
					if not inputService:GetFocusedTextBox() then
						if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
							FlyVal = 44
						elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
							FlyVal = -44
						end
					end
				end)
				interface.connections.FlightDown = inputService.InputEnded:Connect(function(input)
					if not inputService:GetFocusedTextBox() then
						if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
							FlyVal = 0
						elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
							FlyVal = 0
						end
					end
				end)

                interface.connections.Flight = runService.RenderStepped:Connect(function()
                    if isAlive(lplr) then
                        lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X, FlyVal, lplr.Character.PrimaryPart.Velocity.Z)
                    end
                end)
            else
                if interface.connections.Flight then
                    interface.connections.Flight:Disconnect()
                end

                if interface.connections.FlightUp then
                    interface.connections.FlightUp:Disconnect()
                end

                if interface.connections.FlightDown then
                    interface.connections.FlightDown:Disconnect()
                end
            end
        end
    })
    tabs.Movement.create_keybind({
        name = 'Flight',
        flag = 'flightkeybind',

        section = 'right',
        keycode = Enum.KeyCode.R,

        callback = function()
            interface.Flags['flight'] = interface.Flags['flight']
			interface.save_flags()

			tabs.Movement.update_toggle({
				state = interface.Flags['flight'],
				toggle = interface.Toggles['flight']
			})

			interface.Toggles['flight'].callback(interface.Flags['flight'])
        end
    })
end)

--[[

    Render

]]

print('real render')

--[[

    Settings

]]

run(function()
    tabs.Settings.create_title({
        name = 'FOV',
        section = 'left'
    })

    local fov = 60
    local oldfov = 60
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
                interface:uninject()
            end
        end
    })
end)

notif('💖 lover.lua', 'Script loaded', math.random(6, 7))