--[[

    lover.lua
    Type: Bedwars
    by @stav

    ⚠️ :: NOT COMPLETE YET -> EXPECT BUGS

]]

local Library = loadstring(readfile('lover.lua/interface/interface.lua'))()
local Window = Library:Window({
    Name = 'lover'
})

local Combat, Movement, Exploit, Settings =
	Window:Tab({ Icon = "rbxassetid://130346086543864", Tabs = { 'Combat', 'Movement', 'Exploit', 'Settings' } })

for _, tab in { Combat, Movement, Exploit, Settings } do
	local Section = tab:Section({ Name = "Left Section" })
	Section:Toggle({ Name = "Hello!" })
	Section:Slider({})
	Section:Label({ Name = "This is a label!" })
	Section:Dropdown({ Options = { "Nigger1", "Nigger2", "Nigger3" }, Multi = true })
	local Section = tab:Section({ Name = "Right Section" })
end

task.wait(0.25)
Window.ToggleMenu(true)