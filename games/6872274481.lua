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
local collectionService = cloneref(game:GetService('CollectionService'))
local lplr = playersService.LocalPlayer

local objs = {
	chests = {},
	beds = {}
}

task.delay(2, function()
	for _, v in workspace:GetChildren() do
		if v.Name == 'chest' then table.insert(objs.chests, v) end
		if v.Name == 'bed' then table.insert(objs.beds, v) end
	end
end)

local function isAlive(v)
    repeat task.wait() until workspace:FindFirstChild(v.Name)

    if workspace[v.Name]:FindFirstChild('Humanoid') then
        return true
    end

    return false
end

repeat task.wait() until isAlive(lplr)

local window = interface:window({
	name = 'lover',
	suffix = '.lua',
	gameInfo = 'Milenium for Roblox Bedwars'
})

local function getNearestEntity(entitytype: string, range: number): any?
	if not isAlive(lplr) then return nil end

	if entitytype == 'Players' then
		for i,v in playersService:GetPlayers() do
			if v == lplr or v.Team == lplr.Team or not isAlive(v) then continue end

			if v.Character and v.Character.PrimaryPart then
				if (lplr.Character.PrimaryPart.Position - v.Character.PrimaryPart.Position).Magnitude <= range then
					return v
				end
			end
		end

		for i,v in collectionService:GetTagged('entity') do
			if v:HasTag('inventory-entity') and not v:HasTag('Monster') then
				continue
			elseif v:HasTag('Drone') then
				if v.PrimaryPart then
					local realplr = playersService:GetPlayerByUserId(v:GetAttribute('PlayerUserId'))
					if realplr.Team == lplr.Team then continue end

					if (lplr.Character.PrimaryPart.Position - v.PrimaryPart.Position).Magnitude <= range then
						return v
					end
				end
			end

			if v.PrimaryPart then
				if (lplr.Character.PrimaryPart.Position - v.PrimaryPart.Position).Magnitude <= range then
					return v
				end
			end
		end
	elseif entitytype == 'Chests' then
		for i,v in objs.chests do
			if (lplr.Character.PrimaryPart.Position - v.Position).Magnitude <= range then
				return v
			end
		end
	end

	return nil
end

local function hasItem(item: string)
	return workspace[lplr.Name].InventoryFolder.Value:FindFirstChild(item) and true or false
end

local function getItem(item: string)
    local suc, res = pcall(function()
        return workspace[lplr.Name].InventoryFolder.Value:FindFirstChild(item)
    end)

    if suc then return res end
    return 'string'
end

local function getBestSword()
    local bestItem, bestItemStrength = nil, 0

    for i,v in ipairs(itemMeta) do
		local item = tostring(v[1])
        if hasItem(item) and v[2] > bestItemStrength then
            bestItem, bestItemStrength = v[1], v[2]
        end
    end

    return getItem(bestItem)
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
		GroundHit = NetManaged.GroundHit,
        PlaceBlock = BlockEngine.PlaceBlock,
        DamageBlock = BlockEngine.DamageBlock
    }
end)

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
		name = 'Combat',
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

	knockback:toggle({
		name = 'FPS',
		info = 'Unlocks your FPS cap',

		seperator = true,
		callback = function(callback)
			setfpscap(callback and FPS or 60)
        end
	})
	knockback:slider({
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

	local function roundPos(pos)
		return math.round(math.abs(pos))
	end

	section:toggle({
		name = 'Aura',
		info = 'Attacks players around you',

		seperator = true,
		callback = function(callback)
            if callback then
                AuraConn = runService.PreSimulation:Connect(function()
					task.spawn(function()
						if isAlive(lplr) then
							local entity = getNearestEntity('Players', Range)

							if entity then
								local bestTool = getBestSword()

								if hasItem(bestTool.Name) and isAlive(entity) then
									local targetPos, inst, selfpos
									if entity:IsA('Player') then
										targetPos = entity.Character.PrimaryPart.Position
										selfpos = (lplr.Character.PrimaryPart.Position + entity.Character.Humanoid.MoveDirection)
										inst = entity.Character
									else
										targetPos = entity.PrimaryPart.Position
										selfpos = (lplr.Character.PrimaryPart.Position + entity.Humanoid.MoveDirection)
										inst = entity
									end

									local pos = Vector3.new(roundPos(selfpos.X), roundPos(selfpos.Y), roundPos(selfpos.Z))

									if Face then
										lplr.Character.PrimaryPart.CFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(targetPos.X, lplr.Character.HumanoidRootPart.Position.Y + 0.001, targetPos.Z))
									end

									task.spawn(function()
										remotes.SwordHit:FireServer({
											chargedAttack = {chargeRatio = 0},
											entityInstance = inst,
											weapon = bestTool,
											validate = {
												raycast = {
													cameraPosition = {value = pos}
												},
												targetPosition = {value = targetPos},
												selfPosition = {value = pos}
											}
										})
									end)
								end
							end
						end
					end)
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
	local Method

	local column = Main:column({})
    local Speed = column:section({
		name = 'Speed',
		default = true
	})

	--[[local function getSpeed()
		return lplr:GetAttribute('SpeedBoost') and 17 or 0
	end]]

	Speed:toggle({
		name = 'Speed',
		info = 'Increases your speed',

		seperator = true,
		callback = function(callback)
            if callback then
				SpeedConn = runService.PreSimulation:Connect(function(delta)
                    if isAlive(lplr) then
						if Method == 'WalkSpeed' then
                       		lplr.Character.Humanoid.WalkSpeed = Value
						elseif Method == 'CFrame' then
							local speed = (Value - lplr.Character.Humanoid.WalkSpeed)

							lplr.Character.PrimaryPart.CFrame += (lplr.Character.Humanoid.MoveDirection * speed * delta)
						end
                    end
                end)
			else
				if SpeedConn then
					SpeedConn:Disconnect()
				end
				lplr.Character.Humanoid.WalkSpeed = 16
			end
		end
	})
	Speed:dropdown({
		name = 'Method',
		items = {'CFrame', 'WalkSpeed'},
		default = 'CFrame',
		seperator = true,

		callback = function(val)
			Method = val
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
    local VerticalSpeed
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
							FlyVal = VerticalSpeed
						elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
							FlyVal = -VerticalSpeed
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
				task.spawn(function()
					if Flight then
						Flight:Disconnect()
					end

					if FlightUp then
						FlightUp:Disconnect()
					end

					if FlightDown then
						FlightDown:Disconnect()
					end
				end)
			end
		end
	})
    Fly:slider({
		name = 'Vertical Speed',
		min = 0,
		max = 150,
		interval = 1,
		callback = function(int)
			VerticalSpeed = int
		end
	})

	local sub_section = toggle:settings({})
	sub_section:keybind({
		name = 'Keybind',
		callback = function(bool)
			toggle.enabled = bool
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
		info = 'Changes your field of view',

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

--[[

	Utility

]]

local self_section3 = window:tab({
	name = 'Utility',
	tabs = {'Self'}
})

run(function()
	local StealerConn
	local Range
	local stealtick = tick()

	local column = self_section3:column({})
    local Player = column:section({
		name = 'Player',
		default = true
	})

	Player:toggle({
		name = 'Stealer',
		info = 'Automatically steals from chests',

		seperator = true,
		callback = function(callback)
			if callback then
				StealerConn = runService.RenderStepped:Connect(function()
					if stealtick < tick() then
						stealtick = tick() + 0.1

						local chests = getNearestEntity('Chests', Range)

						if chests and chests.ChestFolderValue.Value then
							remotes.SetObservedChest:FireServer(chests.ChestFolderValue.Value)

							for _, item in next, chests.ChestFolderValue.Value:GetChildren() do
								if item:IsA('Accessory') then
									task.spawn(function()
										remotes.ChestGetItem:InvokeServer(chests.ChestFolderValue.Value, item)
									end)
								end
							end

							remotes.SetObservedChest:FireServer(nil)
						end
					end
				end)
			else
				if StealerConn then
					StealerConn:Disconnect()
				end
			end
		end
	})
	Player:slider({
		name = 'Range',
		min = 0,
		max = 25,
		interval = 1,
		callback = function(int)
			Range = int
		end
	})

    local NoFallConn
    local Method
	Player:toggle({
		name = 'NoFall',
		info = 'Prevents you from taking fall damage',

		seperator = true,
		callback = function(callback)
			if callback then
				NoFallConn = runService.PreSimulation:Connect(function()
                    if isAlive(lplr) then
                        if lplr.Character.Humanoid.FloorMaterial == Enum.Material.Air and lplr.Character.PrimaryPart.AssemblyLinearVelocity.Y < -75 then
                            if Method == 'State' then
                                lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                            elseif Method == 'Remote' then
                                remotes.GroundHit:FireServer(nil, Vector3.new(0, lplr.Character.PrimaryPart.AssemblyLinearVelocity.Y, 0), workspace:GetServerTimeNow())
                            end
                        end
                    end

					task.wait()
                end)
			else
                if NoFallConn then
                    NoFallConn:Disconnect()
                end
            end
		end
	})
    Player:dropdown({
		name = 'Method',
		items = {'Remote', 'State'},
		default = 'Remote',
		seperator = true,

		callback = function(val)
			Method = val
		end
	})
end)

interface:create_notification({
	name = 'lover.lua',
	info = 'Legend man :)',
	lifetime = 3
})

interface:init_config(window)