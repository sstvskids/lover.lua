--[[

    lover.lua
    Type: Bedwars
    by @stav

    ⚠️ :: NOT COMPLETE YET -> EXPECT BUGS

]]

local interface = loadstring(readfile('lover.lua/interface/interface.lua'))()

local run = function(func)
    local suc, res = pcall(func)
    
	if suc then return res else
		interface:create_notification({
			name = 'error: lover.lua',
			info = 'Requested remote or function failed to load',
			lifetime = 6
		})
	end
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

local itemMeta = loadstring(downloadFile('lover.lua/libraries/meta.lua'))()

-- Services :)
local playersService = cloneref(game:GetService('Players'))
local starterGui = cloneref(game:GetService('StarterGui'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local lplr = playersService.LocalPlayer

local window = interface:window({
	name = 'lover',
	suffix = '.lua',
	gameInfo = 'Milenium for Roblox Bedwars'
})

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

    return workspace:FindFirstChild(lplr.Name).InventoryFolder.Value:FindFirstChild(bestItem)
end

local remotes
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

local self_section, enemies = window:tab({
	name = 'Combat',
	tabs = {'Self', 'Enemies'}
})

run(function()
	local VeloConn
	local FPS
    
    local column = self_section:column({})
    local knockback = column:section({
		name = 'Knockback',
		default = true
	})

	knockback:toggle({
		name = 'Velocity',
		info = 'Prevents knockback',

		seperator = true,
		callback = function(callback)
            if callback then
                local lastHP = lplr.Character.Humanoid.Health
                VeloConn = runService.RenderStepped:Connect(function()
                    if isAlive(lplr) then
                        if lplr.Character.Humanoid.Health < lastHP then
                            lplr.Character.PrimaryPart.Velocity = Vector3.zero
                        end
                        lastHP = lplr.Character.Humanoid.Health
                    end
                end)
            else
				if VeloConn then
					VeloConn:Disconnect()
				end
			end
        end
	})

	local column2 = self_section:column({})
	
	local tool = column2:section({
		name = 'Tool',
		default = true
	})

	tool:toggle({
		name = 'AutoTool',
		info = 'Automatically switches your tool',

		seperator = true,
		callback = function(callback)
            AutoTool = callback
        end
	})

	local column3 = self_section:column({})

	local fps = column3:section({
		name = 'FPS',
		default = true
	})

	fps:toggle({
		name = 'FPS',
		seperator = true,
		callback = function(callback)
			setfpscap(callback and FPS or 60)
        end
	})
	fps:slider({
		name = 'FPS',
		min = 60,
		max = 999,
		interval = 1,
		callback = function(int)
			FPS = int
		end
	})
end)

run(function()
	local AuraConn
	local Range
	local Face
    
    local column = enemies:column({})
    local section = column:section({
		name = 'Aura',
		default = true
	})

	section:toggle({
		name = 'Aura',
		info = 'Attacks players around you',

		seperator = true,
		callback = function(callback)
            if callback then
                AuraConn = runService.PreSimulation:Connect(function()
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
                if AuraConn then
                    AuraConn:Disconnect()
                end
            end
        end
	})
	section:slider({
		name = 'Range',
		min = 0,
		max = 18,
		interval = 1,
		callback = function(int)
			Range = int
		end
	})
	section:toggle({
		name = 'Face',
		seperator = true,
		callback = function(callback)
			Face = callback
		end
	})
end)

--[[

	Movement

]]

local Main = window:tab({
	name = 'Movement',
	tabs = {'Main'}
})

run(function()
	local SpeedConn
	local Value

	local column = Main:column({})
    local Speed = column:section({
		name = 'Speed',
		default = true
	})

	Speed:toggle({
		name = 'Speed',
		info = 'Increases your speed',

		seperator = true,
		callback = function(callback)
            if callback then
				SpeedConn = runService.PreSimulation:Connect(function()
                    if isAlive(lplr) then
                        lplr.Character.Humanoid.WalkSpeed = Value
                    end
                end)
			else
				if SpeedCon then
					SpeedCon:Disconnect()
				end
				lplr.Character.Humanoid.WalkSpeed = 16
			end
		end
	})
	Speed:slider({
		name = 'Speed',
		min = 0,
		max = 23,
		interval = 1,
		callback = function(int)
			Value = int
		end
	})

	local FlyVal = 0
	local Flight, FlightUp, FlightDown
	local column2 = Main:column({})
	local Fly = column2:section({
		name = 'Fly',
		default = true
	})

	local toggle = Fly:toggle({
		name = 'Flight',
		info = 'Makes you fly around in the air',

		seperator = true,
		callback = function(callback)
            if callback then
				FlyVal = 0
                FlightUp = inputService.InputBegan:Connect(function(input)
					if not inputService:GetFocusedTextBox() then
						if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
							FlyVal = 44
						elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
							FlyVal = -44
						end
					end
				end)
				FlightDown = inputService.InputEnded:Connect(function(input)
					if not inputService:GetFocusedTextBox() then
						if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
							FlyVal = 0
						elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
							FlyVal = 0
						end
					end
				end)

                Flight = runService.RenderStepped:Connect(function()
                    if isAlive(lplr) then
                        lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X, FlyVal, lplr.Character.PrimaryPart.Velocity.Z)
                    end
                end)
			else
                if Flight then
                    Flight:Disconnect()
                end

                if FlightUp then
                    FlightUp:Disconnect()
                end

                if FlightDown then
                    FlightDown:Disconnect()
                end
			end
		end
	})

	local sub_section = toggle:settings({})
	sub_section:keybind({
		name = 'Keybind',
		callback = function()
			toggle.enabled = not toggle.enabled 
            toggle.set(toggle.enabled)
		end
	})
end)

--[[

    Render

]]

local self_section2, enemies2 = window:tab({
	name = 'Render',
	tabs = {'Self', 'Enemies'}
})

run(function()
	local FOVConn
	local fov, oldfov = 60, 60
	local column = self_section2:column({})
    local FOV = column:section({
		name = 'FOV',
		default = true
	})

	FOV:toggle({
		name = 'FOV',
		seperator = true,
		callback = function(callback)
			if callback then
				oldfov = workspace.CurrentCamera.FieldOfView
                workspace.CurrentCamera.FieldOfView = fov

				FOVConn = runService.RenderStepped:Connect(function()
					workspace.CurrentCamera.FieldOfView = fov
				end)
			else
				if FOVConn then
					FOVConn:Disconnect()
				end
				workspace.CurrentCamera.FieldOfView = oldfov
			end
        end
	})
	FOV:slider({
		name = 'FOV',
		min = 60,
		max = 120,
		interval = 1,
		callback = function(int)
			fov = int
		end
	})
end)

interface:create_notification({
	name = 'lover.lua',
	info = 'thanks pook :)',
	lifetime = 6
})

interface:init_config(window)