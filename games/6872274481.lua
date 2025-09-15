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

-- Services :)
local playersService = cloneref(game:GetService('Players'))

local Window = Library:Window({
    Name = 'lover'
})

local Combat, Movement = Window:Tab(
    {
        Icon = "rbxassetid://130346086543864",
        Tabs = {
            'Combat', 'Movement'
        }
    }
)

local Player, UI = Window:Tab(
    {
        Icon = "rbxassetid://134036018950416",
        Tabs = {
            'Player', 'UI'
        }
    }
)

do
    local AuraSection = Combat:Section({Name = 'Killaura'})
end

do
    local VeloSection = Combat:Section({ Name = 'Velocity'})
end

do
    local MenuSection = UI:Section({Name = 'Interface'})

    Window.Tweening = true
	MenuSection:Label({ Name = "Menu Bind" }):Keybind({
		Name = "Menu Bind",
		Callback = function(bool)
			if Window.Tweening then
				return
			end

			Window.ToggleMenu(bool)
		end,
		Default = true
	})
end

--[[for _, tab in { Combat, Movement, Exploit, Settings } do
	local Section = tab:Section({ Name = "Left Section" })
	Section:Toggle({ Name = "Hello!" })
	Section:Slider({})
	Section:Label({ Name = "This is a label!" })
	Section:Dropdown({ Options = { "Nigger1", "Nigger2", "Nigger3" }, Multi = true })
	local Section = tab:Section({ Name = "Right Section" })
end]]

task.wait(0.25)
Window.ToggleMenu(true)