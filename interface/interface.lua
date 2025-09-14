--[[

    Boost UI
    -> Made by @finobe 
    -> Kind of got bored idk what to do with life
]]

if getgenv().Loaded then
	getgenv().Library:Unload()
end

getgenv().Loaded = true

-- Variables
-- Services
local cloneref = cloneref or function(obj)
	return obj
end

local InputService, HttpService, GuiService, RunService, Stats, CoreGui, TweenService, SoundService, Workspace, Players =
	cloneref(game:GetService("UserInputService")),
	cloneref(game:GetService("HttpService")),
	cloneref(game:GetService("GuiService")),
	cloneref(game:GetService("RunService")),
	cloneref(game:GetService("Stats")),
	cloneref(game:GetService("CoreGui")),
	cloneref(game:GetService("TweenService")),
	cloneref(game:GetService("SoundService")),
	cloneref(game:GetService("Workspace")),
	cloneref(game:GetService("Players"))


local Camera, lp, gui_offset = Workspace.CurrentCamera, Players.LocalPlayer, GuiService:GetGuiInset().Y
local mouse = cloneref(lp:GetMouse())
local vec2, vec3, dim2, dim, rect, dim_offset =
	Vector2.new, Vector3.new, UDim2.new, UDim.new, Rect.new, UDim2.fromOffset
local color, rgb, hex, hsv, rgbseq, rgbkey, numseq, numkey =
	Color3.new,
	Color3.fromRGB,
	Color3.fromHex,
	Color3.fromHSV,
	ColorSequence.new,
	ColorSequenceKeypoint.new,
	NumberSequence.new,
	NumberSequenceKeypoint.new
--

-- Library init
getgenv().Library = {
	Directory = "lover.lua",
	Folders = {
		"/fonts",
		"/configs",
	},
	Flags = {},
	ConfigFlags = {},
	Connections = {},
	Notifications = { Notifs = {} },
	OpenElement = {}, -- type: table or userdata
	EasingStyle = Enum.EasingStyle.Quint,
	TweeningSpeed = 0.25,
}

local themes = {
	preset = {
		accent = rgb(183, 250, 142),
	},
	utility = {},
	gradients = {
		Selected = {},
		Deselected = {},
	},
}

for theme, color in themes.preset do
	themes.utility[theme] = {
		BackgroundColor3 = {},
		TextColor3 = {},
		ImageColor3 = {},
		ScrollBarImageColor3 = {},
		Color = {},
	}
end

local Keys = {
	[Enum.KeyCode.LeftShift] = "LS",
	[Enum.KeyCode.RightShift] = "RS",
	[Enum.KeyCode.LeftControl] = "LC",
	[Enum.KeyCode.RightControl] = "RC",
	[Enum.KeyCode.Insert] = "INS",
	[Enum.KeyCode.Backspace] = "BS",
	[Enum.KeyCode.Return] = "Ent",
	[Enum.KeyCode.LeftAlt] = "LA",
	[Enum.KeyCode.RightAlt] = "RA",
	[Enum.KeyCode.CapsLock] = "CAPS",
	[Enum.KeyCode.One] = "1",
	[Enum.KeyCode.Two] = "2",
	[Enum.KeyCode.Three] = "3",
	[Enum.KeyCode.Four] = "4",
	[Enum.KeyCode.Five] = "5",
	[Enum.KeyCode.Six] = "6",
	[Enum.KeyCode.Seven] = "7",
	[Enum.KeyCode.Eight] = "8",
	[Enum.KeyCode.Nine] = "9",
	[Enum.KeyCode.Zero] = "0",
	[Enum.KeyCode.KeypadOne] = "Num1",
	[Enum.KeyCode.KeypadTwo] = "Num2",
	[Enum.KeyCode.KeypadThree] = "Num3",
	[Enum.KeyCode.KeypadFour] = "Num4",
	[Enum.KeyCode.KeypadFive] = "Num5",
	[Enum.KeyCode.KeypadSix] = "Num6",
	[Enum.KeyCode.KeypadSeven] = "Num7",
	[Enum.KeyCode.KeypadEight] = "Num8",
	[Enum.KeyCode.KeypadNine] = "Num9",
	[Enum.KeyCode.KeypadZero] = "Num0",
	[Enum.KeyCode.Minus] = "-",
	[Enum.KeyCode.Equals] = "=",
	[Enum.KeyCode.Tilde] = "~",
	[Enum.KeyCode.LeftBracket] = "[",
	[Enum.KeyCode.RightBracket] = "]",
	[Enum.KeyCode.RightParenthesis] = ")",
	[Enum.KeyCode.LeftParenthesis] = "(",
	[Enum.KeyCode.Semicolon] = ",",
	[Enum.KeyCode.Quote] = "'",
	[Enum.KeyCode.BackSlash] = "\\",
	[Enum.KeyCode.Comma] = ",",
	[Enum.KeyCode.Period] = ".",
	[Enum.KeyCode.Slash] = "/",
	[Enum.KeyCode.Asterisk] = "*",
	[Enum.KeyCode.Plus] = "+",
	[Enum.KeyCode.Period] = ".",
	[Enum.KeyCode.Backquote] = "`",
	[Enum.UserInputType.MouseButton1] = "MB1",
	[Enum.UserInputType.MouseButton2] = "MB2",
	[Enum.UserInputType.MouseButton3] = "MB3",
	[Enum.KeyCode.Escape] = "ESC",
	[Enum.KeyCode.Space] = "SPC",
}

Library.__index = Library

for _, path in Library.Folders do
	makefolder(Library.Directory .. path)
end

local Flags = Library.Flags
local ConfigFlags = Library.ConfigFlags
local Notifications = Library.Notifications

local Fonts = {}
do
    function downloadFile(file, read)
        url = file:gsub('lover.lua/', '')
        if not isfile(file) then
            writefile(file, game:HttpGet('https://raw.githubusercontent.com/sstvskids/lover.lua/'..readfile('lover.lua/commit.txt')..'/'..url))
        end

        if read ~= nil and read == false then
            return
        end

        repeat task.wait() until isfile(file)
        return readfile(file)
    end

	function RegisterFont(Name, Weight, Style, Asset)
		if not isfile(Asset.Id) then
			writefile(Asset.Id, Asset.Font)
		end

		if isfile(Name .. ".font") then
			delfile(Name .. ".font")
		end

		local Data = {
			name = Name,
			faces = {
				{
					name = "Normal",
					weight = Weight,
					style = Style,
					assetId = getcustomasset(Asset.Id),
				},
			},
		}

		writefile(Name .. ".font", HttpService:JSONEncode(Data))

		return getcustomasset(Name .. ".font")
	end

	local Verdana = RegisterFont("Verawdawdawdwaddana", 400, "Normal", {
		Id = "Verdanawdawdwada.ttf",
		Font = downloadFile('lover.lua/interface/fs-tahoma-8px.ttf'),
	})

	Library.Font = Font.new(Verdana, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end
--

-- Library functions
-- Misc functions
function Library:GetTransparency(obj)
	if obj:IsA("Frame") then
		return { "BackgroundTransparency" }
	elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
		return { "TextTransparency", "BackgroundTransparency" }
	elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
		return { "BackgroundTransparency", "ImageTransparency" }
	elseif obj:IsA("ScrollingFrame") then
		return { "BackgroundTransparency", "ScrollBarImageTransparency" }
	elseif obj:IsA("TextBox") then
		return { "TextTransparency", "BackgroundTransparency" }
	elseif obj:IsA("UIStroke") then
		return { "Transparency" }
	end

	return nil
end

function Library:Tween(Object, Properties, Info)
	local tween = TweenService:Create(
		Object,
		Info or TweenInfo.new(Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.InOut, 0, false, 0),
		Properties
	)
	tween:Play()

	return tween
end

function Library:Fade(obj, prop, vis, speed)
	if not (obj and prop) then
		return
	end

	local OldTransparency = obj[prop]
	obj[prop] = vis and 1 or OldTransparency

	local Tween = Library:Tween(
		obj,
		{ [prop] = vis and OldTransparency or 1 },
		TweenInfo.new(speed or Library.TweeningSpeed, Library.EasingStyle, Enum.EasingDirection.InOut, 0, false, 0)
	)

	Library:Connection(Tween.Completed, function()
		if not vis then
			task.wait()
			obj[prop] = OldTransparency
		end
	end)

	return Tween
end

function Library:Resizify(Parent)
	local Resizing = Library:Create("TextButton", {
		Position = dim2(1, -10, 1, -10),
		BorderColor3 = rgb(0, 0, 0),
		Size = dim2(0, 10, 0, 10),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(255, 255, 255),
		Parent = Parent,
		BackgroundTransparency = 1,
		Text = "",
	})

	local IsResizing = false
	local Size
	local InputLost
	local ParentSize = Parent.Size

	Resizing.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			IsResizing = true
			InputLost = input.Position
			Size = Parent.Size
		end
	end)

	Resizing.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			IsResizing = false
		end
	end)

	Library:Connection(InputService.InputChanged, function(input, game_event)
		if IsResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local NewSize = dim2(
				Size.X.Scale,
				math.clamp(Size.X.Offset + (input.Position.X - InputLost.X), ParentSize.X.Offset, Camera.ViewportSize.X),
				Size.Y.Scale,
				math.clamp(Size.Y.Offset + (input.Position.Y - InputLost.Y), ParentSize.Y.Offset, Camera.ViewportSize.Y)
			)

			Library:Tween(
				Parent,
				{ Size = NewSize },
				TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
			)
		end
	end)
end

function Library:Hovering(Object)
	if type(Object) == "table" then
		local Pass = false

		for _, obj in Object do
			if Library:Hovering(obj) then
				Pass = true
				return Pass
			end
		end
	else
		local y_cond = Object.AbsolutePosition.Y <= mouse.Y
			and mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
		local x_cond = Object.AbsolutePosition.X <= mouse.X
			and mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X

		return (y_cond and x_cond)
	end
end

function Library:Draggify(Parent)
	local Dragging = false
	local IntialSize = Parent.Position
	local InitialPosition

	Parent.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			InitialPosition = Input.Position
			InitialSize = Parent.Position
		end
	end)

	Parent.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = false
		end
	end)

	Library:Connection(InputService.InputChanged, function(Input, game_event)
		if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
			local Horizontal = Camera.ViewportSize.X
			local Vertical = Camera.ViewportSize.Y

			local NewPosition = dim2(
				0,
				math.clamp(
					InitialSize.X.Offset + (Input.Position.X - InitialPosition.X),
					0,
					Horizontal - Parent.Size.X.Offset
				),
				0,
				math.clamp(
					InitialSize.Y.Offset + (Input.Position.Y - InitialPosition.Y),
					0,
					Vertical - Parent.Size.Y.Offset
				)
			)

			Library:Tween(
				Parent,
				{ Position = NewPosition },
				TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
			)
		end
	end)
end

function Library:Convert(str)
	local Values = {}

	for Value in string.gmatch(str, "[^,]+") do
		table.insert(Values, tonumber(Value))
	end

	if #Values == 4 then
		return unpack(Values)
	else
		return
	end
end

function Library:Lerp(start, finish, t)
	t = t or 1 / 8

	return start * (1 - t) + finish * t
end

function Library:ConvertEnum(enum)
	local EnumParts = {}

	for part in string.gmatch(enum, "[%w_]+") do
		insert(EnumParts, part)
	end

	local EnumTable = Enum

	for i = 2, #EnumParts do
		local EnumItem = EnumTable[EnumParts[i]]

		EnumTable = EnumItem
	end

	return EnumTable
end

function Library:ConvertHex(color, alpha)
	local r = math.floor(color.R * 255)
	local g = math.floor(color.G * 255)
	local b = math.floor(color.B * 255)
	local a = alpha and math.floor(alpha * 255) or 255
	return string.format("#%02X%02X%02X%02X", r, g, b, a)
end

function Library:ConvertFromHex(color)
	color = color:gsub("#", "")
	local r = tonumber(color:sub(1, 2), 16) / 255
	local g = tonumber(color:sub(3, 4), 16) / 255
	local b = tonumber(color:sub(5, 6), 16) / 255
	local a = tonumber(color:sub(7, 8), 16) and tonumber(color:sub(7, 8), 16) / 255 or 1
	return Color3.new(r, g, b), a
end

local ConfigHolder
function Library:UpdateConfigList()
	if not ConfigHolder then
		print("no exist :(")
		return
	end

	local List = {}

	for _, file in listfiles(Library.Directory .. "/configs") do
		local Name = file:gsub(Library.Directory .. "/configs\\", "")
			:gsub(".cfg", "")
			:gsub(Library.Directory .. "\\configs\\", "")
		List[#List + 1] = Name
	end

	for _, v in List do
		print(_, v)
	end

	ConfigHolder.RefreshOptions(List)
end

function Library:Keypicker(properties)
	local Cfg = {
		Name = properties.Name or "Color",
		Flag = properties.Flag or properties.Name or "Colorpicker",
		Callback = properties.Callback or function() end,

		Color = properties.Color or color(1, 1, 1), -- Default to white color if not provided
		Alpha = properties.Alpha or properties.Transparency or 0,

		Mode = properties.Mode or "Keypicker", -- Animation

		-- Other
		Open = false,
		Items = {},
	}

	local DraggingSat = false
	local DraggingHue = false
	local DraggingAlpha = false

	local h, s, v = Cfg.Color:ToHSV()
	local a = Cfg.Alpha

	Flags[Cfg.Flag] = { Color = Cfg.Color, Transparency = Cfg.Alpha }

	local Items = Cfg.Items
	do
		-- Component

		--

		-- Colorpicker

		--
	end

	function Cfg.SetVisible(bool)
		Items.Fade.BackgroundTransparency = 0
		Library:Tween(Items.Fade, { BackgroundTransparency = 1 })

		Items.Colorpicker.Visible = bool
		Items.Colorpicker.Parent = bool and Library.Items or Library.Other
		Items.Colorpicker.Position =
			dim2(0, Items.ColorpickerObject.AbsolutePosition.X + 2, 0, Items.ColorpickerObject.AbsolutePosition.Y + 74)
	end

	function Cfg.Set(color, alpha)
		if type(color) == "boolean" then
			return
		end

		if color then
			h, s, v = color:ToHSV()
		end

		if alpha then
			a = alpha
		end

		local Color = hsv(h, s, v)

		Items.SatValPicker.Position = dim2(s, 0, 1 - v, 0)
		Items.AlphaPicker.Position = dim2(0, -1, a, -1)
		Items.HuePicker.Position = dim2(0, -1, h, -1)

		Items.Inner.BackgroundColor3 = hsv(h, s, v)
		Items.InlineColorPicker.BackgroundColor3 = hsv(h, s, v)
		Items.Color.BackgroundColor3 = hsv(h, 1, 1)

		Flags[Cfg.Flag] = {
			Color = Color,
			Transparency = a,
		}

		local Color = Items.InlineColorPicker.BackgroundColor3 -- Overwriting to format<<
		Items.RGBInput.Text = string.format(
			"%s, %s, %s, ",
			Library:Round(Color.R * 255),
			Library:Round(Color.G * 255),
			Library:Round(Color.B * 255)
		)
		Items.RGBInput.Text ..= Library:Round(1 - a, 0.01)

		Items.InputAlpha.Text = Library:ConvertHex(Color, 1 - a)

		Cfg.Callback(Color, a)
	end

	function Cfg.UpdateColor()
		local Mouse = InputService:GetMouseLocation()
		local offset = vec2(Mouse.X, Mouse.Y - gui_offset)

		if DraggingSat then
			s = math.clamp((offset - Items.Sat.AbsolutePosition).X / Items.Sat.AbsoluteSize.X, 0, 1)
			v = 1 - math.clamp((offset - Items.Sat.AbsolutePosition).Y / Items.Sat.AbsoluteSize.Y, 0, 1)
		elseif DraggingHue then
			h = math.clamp((offset - Items.HueSlider.AbsolutePosition).Y / Items.HueSlider.AbsoluteSize.Y, 0, 1)
		elseif DraggingAlpha then
			a = math.clamp((offset - Items.AlphaSlider.AbsolutePosition).Y / Items.AlphaSlider.AbsoluteSize.Y, 0, 1)
		end

		Cfg.Set()
	end

	Items.ColorpickerObject.MouseButton1Click:Connect(function()
		Cfg.Open = not Cfg.Open
		Cfg.SetVisible(Cfg.Open)
	end)

	InputService.InputChanged:Connect(function(input)
		if
			(DraggingSat or DraggingHue or DraggingAlpha)
			and input.UserInputType == Enum.UserInputType.MouseMovement
		then
			Cfg.UpdateColor()
		end
	end)

	Library:Connection(InputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			DraggingSat = false
			DraggingHue = false
			DraggingAlpha = false
		end
	end)

	Items.AlphaSlider.MouseButton1Down:Connect(function()
		DraggingAlpha = true
	end)

	Items.HueSlider.MouseButton1Down:Connect(function()
		DraggingHue = true
	end)

	Items.Sat.MouseButton1Down:Connect(function()
		DraggingSat = true
	end)

	Items.RGBInput.FocusLost:Connect(function()
		local text = Items.RGBInput.Text
		local r, g, b, a = Library:Convert(text)

		if r and g and b and a then
			Cfg.Set(rgb(r, g, b), 1 - a)
		end
	end)

	Items.InputAlpha.FocusLost:Connect(function()
		local Color, Alpha = Library:ConvertFromHex(Items.InputAlpha.Text)
		Cfg.Set(Color, 1 - Alpha)
	end)

	Cfg.Set(Cfg.Color, Cfg.Alpha)
	ConfigFlags[Cfg.Flag] = Cfg.Set

	return setmetatable(Cfg, Library)
end

function Library:GetConfig()
	local Config = {}

	for Idx, Value in Flags do
		if type(Value) == "table" and Value.key then
			Config[Idx] = { active = Value.Active, mode = Value.Mode, key = tostring(Value.Key) }
		elseif type(Value) == "table" and Value["Transparency"] and Value["Color"] then
			Config[Idx] = { Transparency = Value["Transparency"], Color = Value["Color"]:ToHex() }
		else
			Config[Idx] = Value
		end
	end

	return HttpService:JSONEncode(Config)
end

function Library:LoadConfig(JSON)
	local Config = HttpService:JSONDecode(JSON)

	for Idx, Value in Config do
		if Idx == "config_name_list" then
			continue
		end

		local Function = ConfigFlags[Idx]

		if Function then
			if type(Value) == "table" and Value["Transparency"] and Value["Color"] then
				Function(hex(Value["Color"]), Value["Transparency"])
			elseif type(Value) == "table" and Value["Active"] then
				Function(Value)
			else
				Function(Value)
			end
		end
	end
end

function Library:Round(num, float)
	local Multiplier = 1 / (float or 1)
	return math.floor(num * Multiplier + 0.5) / Multiplier
end

function Library:Themify(instance, theme, property)
	table.insert(themes.utility[theme][property], instance)
end

function Library:SaveGradient(instance, theme) -- instance, tabfill or background, color
	table.insert(themes.gradients[theme], instance)
end

function Library:RefreshTheme(theme, color)
	for property, instances in themes.utility[theme] do
		for _, object in instances do
			if object[property] == themes.preset[theme] then
				object[property] = color
			end
		end
	end

	themes.preset[theme] = color
end

function Library:Connection(signal, callback)
	local connection = signal:Connect(callback)

	table.insert(Library.Connections, connection)

	return connection
end

function Library:CloseElement()
	local IsMulti = typeof(Library.OpenElement)

	if not Library.OpenElement then
		return
	end

	for i = 1, #Library.OpenElement do
		local Data = Library.OpenElement[i]

		if Data.Ignore then
			continue
		end

		Data.SetVisible(false)
		Data.Open = false
	end

	Library.OpenElement = {}
end

function Library:Create(instance, options)
	local ins = Instance.new(instance)

	for prop, value in options do
		ins[prop] = value
	end

	if ins == "TextButton" then
		ins["AutoButtonColor"] = false
		ins["Text"] = ""
	end

	return ins
end

function Library:Unload()
	if Library.Items then
		Library.Items:Destroy()
	end

	if Library.Other then
		Library.Other:Destroy()
	end

	for _, connection in Library.Connections do
		connection:Disconnect()
		connection = nil
	end

	getgenv().Library = nil
end
--

-- Library element functions
function Library:Window(properties)
	local Cfg = {
		Name = properties.Name or "Nebula",
		Domain = properties.Domain or "Lua",
		Size = properties.Size or dim2(0, 730, 0, 485),
		TabInfo,
		Items = {},
	}

	Library.Items = Library:Create("ScreenGui", {
		Parent = CoreGui,
		Name = "\0",
		Enabled = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
	})

	Library.Other = Library:Create("ScreenGui", {
		Parent = CoreGui,
		Name = "\0",
		Enabled = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
	})

	local Items = Cfg.Items
	do
		-- Window
		Items.Window = Library:Create("Frame", {
			Parent = Library.Items,
			Name = "\0",
			Visible = false,
			Position = dim2(0.5, -Cfg.Size.X.Offset / 2, 0.5, -Cfg.Size.Y.Offset / 2),
			BorderColor3 = rgb(0, 0, 0),
			Size = Cfg.Size,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(15, 15, 15),
		})
		Items.Window.Position = dim2(0, Items.Window.AbsolutePosition.X, 0, Items.Window.AbsolutePosition.Y)
		Library:Draggify(Items.Window)
		Library:Resizify(Items.Window)

		Items.Fade = Library:Create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.Window,
			Name = "\0",
			Visible = true,
			Interactable = true,
			BackgroundTransparency = 1,
			Position = dim2(0, 100, 0, 50),
			Size = dim2(1, -100, 1, -50),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(15, 15, 15),
		})

		Library:Create("UICorner", {
			Parent = Items.Window,
			CornerRadius = dim(0, 4),
		})

		Library:Create("UIStroke", {
			Color = rgb(38, 38, 38),
			Parent = Items.Window,
		})

		Items.Sidebar = Library:Create("Frame", {
			ClipsDescendants = true,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.Window,
			BackgroundTransparency = 1,
			Name = "\0",
			Size = dim2(0, 100, 1, 0),
			ZIndex = 0,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UICorner", {
			Parent = Items.Sidebar,
			CornerRadius = dim(0, 4),
		})

		Items.Separator = Library:Create("Frame", {
			AnchorPoint = vec2(1, 0),
			Parent = Items.Sidebar,
			Name = "\0",
			Position = dim2(1, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 1, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(38, 38, 38),
		})

		Items.TabButtonHolder = Library:Create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			AnchorPoint = vec2(0.5, 0.5),
			Parent = Items.Sidebar,
			BackgroundTransparency = 1,
			Position = dim2(0, 0, 0, 0),
			Position = dim2(0.5, 0, 0.5, 0),
			Name = "\0",
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Parent = Items.TabButtonHolder,
			Padding = dim(0, 25),
		})

		Library:Create("UIPadding", {
			Parent = Items.TabButtonHolder,
			PaddingTop = dim(0, 16),
		})

		Items.Inline = Library:Create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.Sidebar,
			AnchorPoint = vec2(0.5, 0.5),
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0.5, 0, 0.5, 0),
			Size = dim2(1, -2, 1, -2),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UIStroke", {
			Color = rgb(24, 24, 24),
			Parent = Items.Inline,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		Library:Create("UICorner", {
			Parent = Items.Inline,
			CornerRadius = dim(0, 4),
		})

		Items.Navigation = Library:Create("Frame", {
			LayoutOrder = 6,
			BorderColor3 = rgb(0, 0, 0),
			AnchorPoint = vec2(0.5, 1),
			Name = "\0",
			Position = dim2(0.5, 0, 1, -12),
			Parent = Items.Sidebar,
			Size = dim2(0, 38, 0, 100),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(20, 20, 20),
		})

		Library:Create("UICorner", {
			Parent = Items.Navigation,
			CornerRadius = dim(0, 64),
		})

		Library:Create("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = 0.6499999761581421,
			Color = rgb(38, 38, 38),
			Parent = Items.Navigation,
			Thickness = 2,
		})

		Library:Create("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Parent = Items.Navigation,
			Padding = dim(0, 12),
			ItemLineAlignment = Enum.ItemLineAlignment.Center,
		})

		Library:Create("UIPadding", {
			PaddingBottom = dim(0, 14),
			PaddingTop = dim(0, 14),
			Parent = Items.Navigation,
		})

		Items.IconHolder = Library:Create("ImageButton", {
			ImageColor3 = rgb(183, 250, 142),
			ScaleType = Enum.ScaleType.Fit,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.Navigation,
			Name = "\0",
			Size = dim2(0, 18, 0, 18),
			Image = "rbxassetid://123012485780468",
			BackgroundTransparency = 1,
			Position = dim2(0.31578946113586426, 0, -0.0555555559694767, 0),
			LayoutOrder = 3,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UICorner", {
			Parent = Items.IconHolder,
			CornerRadius = dim(0, 64),
		})

		Items.IconHolder = Library:Create("ImageButton", {
			ImageColor3 = rgb(183, 250, 142),
			ImageTransparency = 1,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.Navigation,
			Name = "\0",
			Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
			BackgroundTransparency = 1,
			Size = dim2(0, 16, 0, 16),
			LayoutOrder = 2,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UICorner", {
			Parent = Items.IconHolder,
			CornerRadius = dim(0, 64),
		})

		Library:Create("UIStroke", {
			Thickness = 2,
			Parent = Items.IconHolder,
			Color = rgb(183, 250, 142),
		})

		Items.IconHolder = Library:Create("ImageButton", {
			ImageColor3 = rgb(183, 250, 142),
			ScaleType = Enum.ScaleType.Fit,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.Navigation,
			Image = "rbxassetid://134036018950416",
			BackgroundTransparency = 1,
			Name = "\0",
			Size = dim2(0, 18, 0, 18),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UICorner", {
			Parent = Items.IconHolder,
			CornerRadius = dim(0, 64),
		})

		Items.TabHolder = Library:Create("Frame", {
			Parent = Items.Window,
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 100, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -100, 0, 50),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Separator = Library:Create("Frame", {
			AnchorPoint = vec2(1, 1),
			Parent = Items.TabHolder,
			Name = "\0",
			Position = dim2(1, 0, 1, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, 0, 0, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(38, 38, 38),
		})

		Items.ActualContainer = Library:Create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			AnchorPoint = vec2(0.5, 0.5),
			Parent = Items.TabHolder,
			BackgroundTransparency = 1,
			Position = dim2(0.5, 0, 0.5, 0),
			Name = "\0",
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UIListLayout", {
			Parent = Items.ActualContainer,
			Wraps = true,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Library:Create("UIPadding", {
			PaddingRight = dim(0, -100),
			Parent = Items.ActualContainer,
		})

		Items.MultiHolder = Library:Create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.ActualContainer,
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 144, 0, 0),
			Size = dim2(0, 0, 0, 50),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Container = Library:Create("Frame", {
			Parent = Items.MultiHolder,
			BackgroundTransparency = 1,
			Name = "\0",
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Parent = Items.Container,
			Padding = dim(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Library:Create("UIPadding", {
			Parent = Items.Container,
			PaddingRight = dim(0, 11),
			PaddingLeft = dim(0, 11),
		})

		Items.TitleContainer = Library:Create("Frame", {
			LayoutOrder = -1,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.ActualContainer,
			AnchorPoint = vec2(0, 0.5),
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(-0.025902913883328438, 16, 0.5, 0),
			Size = dim2(0.040473274886608124, 120, 1, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Text = Library:Create("TextLabel", {
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			Parent = Items.TitleContainer,
			TextColor3 = rgb(183, 250, 142),
			BorderColor3 = rgb(0, 0, 0),
			Text = Cfg.Name,
			Name = "\0",
			Size = dim2(0, 0, 1, 0),
			AnchorPoint = vec2(0, 0.5),
			Position = dim2(0, 0, 0.5, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 18,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		Library:Themify(Items.Text, "accent", "BackgroundColor3")

		Items.SubText = Library:Create("TextLabel", {
			LayoutOrder = 2,
			FontFace = Font.new(
				"rbxasset://fonts/families/SourceSansPro.json",
				Enum.FontWeight.Regular,
				Enum.FontStyle.Normal
			),
			Parent = Items.TitleContainer,
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = Cfg.Domain,
			Name = "\0",
			Size = dim2(0, 0, 1, 0),
			AnchorPoint = vec2(1, 0),
			Position = dim2(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 18,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Seperator = Library:Create("Frame", {
			LayoutOrder = 1,
			Parent = Items.TitleContainer,
			BackgroundTransparency = 1,
			Name = "\0",
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 1, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Separator = Library:Create("Frame", {
			AnchorPoint = vec2(0, 0.5),
			Parent = Items.Seperator,
			Name = "\0",
			Position = dim2(0, 0, 0.5, 1),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 1, 1, -35),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(38, 38, 38),
		})

		Library:Create("UIListLayout", {
			Parent = Items.TitleContainer,
			Padding = dim(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Wraps = true,
		})

		Library:Create("UIPadding", {
			PaddingLeft = dim(0, 18),
			Parent = Items.TitleContainer,
		})

		Items.Separator = Library:Create("Frame", {
			LayoutOrder = 55,
			Parent = Items.TitleContainer,
			Name = "\0",
			Position = dim2(0, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 1, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(38, 38, 38),
		})

		Items.PlayerInfo = Library:Create("Frame", {
			Parent = Items.TabHolder,
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(1, 0, 0, 0),
			AnchorPoint = vec2(1, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 82, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.SearchHolder = Library:Create("Frame", {
			Name = "\0",
			Parent = Items.PlayerInfo,
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 28, 0, 28),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(20, 20, 20),
		})

		Items.Search = Library:Create("ImageButton", {
			ImageColor3 = rgb(38, 38, 38),
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.SearchHolder,
			Name = "\0",
			AutoButtonColor = false,
			AnchorPoint = vec2(0.5, 0.5),
			Image = "rbxassetid://97248513837768",
			BackgroundTransparency = 1,
			Position = dim2(0.5, 0, 0.5, 0),
			Size = dim2(1, -6, 1, -6),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UICorner", {
			Parent = Items.SearchHolder,
		})

		Library:Create("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = 0.6499999761581421,
			Color = rgb(38, 38, 38),
			Parent = Items.SearchHolder,
			Thickness = 2,
		})

		Library:Create("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Parent = Items.PlayerInfo,
			Padding = dim(0, 18),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Items.PlayerInfoHolder = Library:Create("Frame", {
			Parent = Items.PlayerInfo,
			BackgroundTransparency = 1,
			Name = "\0",
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 26, 0, 26),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(20, 20, 20),
		})

		Items.Player = Library:Create("ImageButton", {
			ImageColor3 = rgb(38, 38, 38),
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.PlayerInfoHolder,
			Name = "\0",
			AutoButtonColor = false,
			AnchorPoint = vec2(0.5, 0.5),
			Image = "-",
			BackgroundTransparency = 1,
			Position = dim2(0.5, 0, 0.5, 0),
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UICorner", {
			Parent = Items.Player,
			CornerRadius = dim(0, 64),
		})

		Library:Create("UIStroke", {
			Thickness = 2,
			Parent = Items.Player,
			Color = rgb(183, 250, 142),
		})
		Library:Themify(Items.UIStroke, "accent", "BackgroundColor3")

		Library:Create("UIPadding", {
			PaddingRight = dim(0, 12),
			Parent = Items.PlayerInfo,
		})

		Items.PageHolder = Library:Create("Frame", {
			Interactable = false,
			Parent = Items.Window,
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 100, 0, 50),
			Size = dim2(1, -100, 1, -50),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Gradient_Holder = Library:Create("Frame", {
			Active = true,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.Window,
			AnchorPoint = vec2(0.5, 0.5),
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0.5, 0, 0.5, 0),
			Size = dim2(1, 0, 1, 0),
			ZIndex = 0,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Gradient_1 = Library:Create("ImageLabel", {
			ImageTransparency = 0.30000001192092896,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.Gradient_Holder,
			Name = "\0",
			Size = dim2(0, 150, 0, 150),
			Rotation = 180,
			Image = "rbxassetid://72749412994515",
			BackgroundTransparency = 1,
			Position = dim2(0, -1, 0, -1),
			ZIndex = -1,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UICorner", {
			Parent = Items.Gradient_1,
			CornerRadius = dim(0, 4),
		})

		Items.Gradient_2 = Library:Create("ImageLabel", {
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.Gradient_Holder,
			Name = "\0",
			Size = dim2(0, 150, 0, 150),
			AnchorPoint = vec2(1, 1),
			Image = "rbxassetid://72749412994515",
			BackgroundTransparency = 1,
			Position = dim2(1, 0, 1, 0),
			ZIndex = -1,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UICorner", {
			Parent = Items.Gradient_2,
			CornerRadius = dim(0, 4),
		})

		Library:Create("ImageLabel", {
			Visible = false,
			Image = "rbxassetid://73228291871702",
			Parent = Items.Window,
			Size = dim2(1, 0, 1, 0),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		--
	end

	function Cfg.ToggleMenu(bool)
		if Cfg.Tweening then
			return
		end

		Cfg.Tweening = true

		if bool then
			Items.Window.Visible = true
		end

		local Children = Items.Window:GetDescendants()
		table.insert(Children, Items.Window)

		local Tween
		for _, obj in Children do
			local Index = Library:GetTransparency(obj)

			if not Index then
				continue
			end

			if type(Index) == "table" then
				for _, prop in Index do
					Tween = Library:Fade(obj, prop, bool)
				end
			else
				Tween = Library:Fade(obj, Index, bool)
			end
		end

		Library:Connection(Tween.Completed, function()
			Cfg.Tweening = false
			Items.Window.Visible = bool
		end)
	end

	return setmetatable(Cfg, Library)
end

function Library:Tab(properties)
	local Cfg = {
		Icon = properties.icon or properties.Icon or "rbxassetid://130346086543864",
		Tabs = properties.tabs or properties.Tabs or { "Tab1", "Tab2", "Tab3" },
		MultiTabs = {},
		Items = {},
		CurrentMulti,
	}

	local Items = Cfg.Items
	do
		-- Tab button
		Items.IconHolder = Library:Create("TextButton", {
			Active = false,
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			AutoButtonColor = false,
			Name = "\0",
			Parent = self.Items.TabButtonHolder,
			Size = dim2(0, 45, 0, 45),
			Selectable = false,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(20, 20, 20),
		})

		Library:Create("UICorner", {
			Parent = Items.IconHolder,
			CornerRadius = dim(0, 4),
		})

		Items.Icon = Library:Create("ImageLabel", {
			ImageColor3 = themes.preset.accent,
			ScaleType = Enum.ScaleType.Fit,
			ImageTransparency = 0.5299999713897705,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.IconHolder,
			Name = "\0",
			AnchorPoint = vec2(0.5, 0.5),
			Image = Cfg.Icon,
			BackgroundTransparency = 1,
			Position = dim2(0.5, 0, 0.5, 0),
			Size = dim2(1, -22, 1, -22),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		Library:Themify(Items.Icon, "accent", "ImageColor3")

		Items.ButtonGlow = Library:Create("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = 0.6499999761581421,
			Color = rgb(38, 38, 38),
			Parent = Items.IconHolder,
			Thickness = 2,
		})
		--

		-- Page Directory
		Items.Page = Library:Create("Frame", {
			Parent = Library.Other, -- self.Items.Window
			Name = "\0",
			Visible = false,
			BackgroundTransparency = 1,
			Position = dim2(0, 100, 0, 50),
			Size = dim2(1, -100, 1, -50),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})
		--

		-- Multi Directory
		Items.Container = Library:Create("Frame", {
			Parent = Library.Other, -- self.Items.MultiHolder
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Parent = Items.Container,
			Padding = dim(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Library:Create("UIPadding", {
			Parent = Items.Container,
			PaddingRight = dim(0, 11),
			PaddingLeft = dim(0, 11),
		})
		--
	end

	-- multi logic
	for _, multi in Cfg.Tabs do
		local Info = { Items = {} }

		local MultiItems = Info.Items
		do
			-- Button
			MultiItems.Tab = Library:Create("TextButton", {
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
				TextColor3 = rgb(64, 64, 66),
				BorderColor3 = rgb(0, 0, 0),
				Text = multi,
				AutoButtonColor = false,
				Parent = Items.Container,
				Size = dim2(0, 55, 0, 35),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 14,
				BackgroundColor3 = rgb(25, 25, 25),
			})

			Library:Create("UICorner", {
				Parent = MultiItems.Tab,
			})

			Library:Create("UIPadding", {
				Parent = MultiItems.Tab,
				PaddingTop = dim(0, 2),
				PaddingRight = dim(0, 5),
				PaddingLeft = dim(0, 5),
			})

			MultiItems.Accent = Library:Create("Frame", {
				Parent = MultiItems.Tab,
				Name = "\0",
				BackgroundTransparency = 1,
				Position = dim2(0, 8, 1, -2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -16, 0, 10),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
			})
			Library:Themify(MultiItems.Accent, "accent", "BackgroundColor3")

			Library:Create("UICorner", {
				Parent = MultiItems.Accent,
				CornerRadius = dim(0, 10),
			})
			--

			-- Page
			MultiItems.Page = Library:Create("Frame", {
				Parent = Library.Other, -- Items.Page
				Name = "\0",
				Visible = false,
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 1, 0),
				BorderColor3 = rgb(0, 0, 0),
				Interactable = true,
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
			})

			Library:Create("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Parent = MultiItems.Page,
				Padding = dim(0, 20),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalFlex = Enum.UIFlexAlignment.Fill,
			})

			Library:Create("UIPadding", {
				PaddingTop = dim(0, 20),
				PaddingBottom = dim(0, 20),
				Parent = MultiItems.Page,
				PaddingRight = dim(0, 20),
				PaddingLeft = dim(0, 20),
			})
			--
		end

		function Info.Open()
			local Current = Cfg.CurrentMulti

			if Current then
				Current.Page.Visible = false
				Current.Page.Parent = Library.Other

				Library:Tween(Current.Accent, { BackgroundTransparency = 1 })
				Library:Tween(Current.Tab, { BackgroundTransparency = 1, TextColor3 = rgb(64, 64, 66) })
			end

			MultiItems.Page.Parent = Items.Page
			MultiItems.Page.Visible = true

			Library:Tween(MultiItems.Accent, { BackgroundTransparency = 0 })
			Library:Tween(MultiItems.Tab, { BackgroundTransparency = 0, TextColor3 = rgb(255, 255, 255) })

			if Current ~= MultiItems then
				self.Items.Fade.BackgroundTransparency = 0
				Library:Tween(
					self.Items.Fade,
					{ BackgroundTransparency = 1 },
					TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)
				)

				Items.Page.Size = dim2(1, -120, 1, -90)
				Library:Tween(
					Items.Page,
					{ Size = dim2(1, -100, 1, -50) },
					TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)
				)
			end

			Cfg.CurrentMulti = MultiItems
		end

		MultiItems.Tab.MouseButton1Click:Connect(function()
			Info.Open()
		end)

		Cfg.MultiTabs[#Cfg.MultiTabs + 1] = setmetatable(Info, Library)
	end
	--

	function Cfg.OpenTab()
		local Tab = self.TabInfo

		if Tab then
			Tab.Page.Visible = false
			Tab.Page.Parent = Library.Other

			Tab.Container.Visible = false
			Tab.Container.Parent = Library.Other

			Library:Tween(
				Tab.ButtonGlow,
				{ Color = themes.preset.accent, Transparency = 1 },
				TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)
			)
		end

		Items.Page.Parent = self.Items.Window
		Items.Page.Visible = true

		Items.Container.Parent = self.Items.MultiHolder
		Items.Container.Visible = true

		Library:Tween(
			Items.ButtonGlow,
			{ Color = themes.preset.accent, Transparency = 0 },
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)
		)

		if Tab ~= Items then
			self.Items.Fade.BackgroundTransparency = 0
			Library:Tween(
				self.Items.Fade,
				{ BackgroundTransparency = 1 },
				TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)
			)

			Items.Page.Size = dim2(1, -120, 1, -90)
			Library:Tween(
				Items.Page,
				{ Size = dim2(1, -100, 1, -50) },
				TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0)
			)
		end

		self.TabInfo = Cfg.Items
	end

	Items.IconHolder.MouseButton1Down:Connect(function()
		Cfg.OpenTab()
	end)

	Cfg.MultiTabs[1].Open()

	if not self.TabInfo then
		Cfg.OpenTab()
	end

	return unpack(Cfg.MultiTabs)
end

function Library:Section(properties)
	local Cfg = {
		Name = properties.name or properties.Name or "Section",
		Side = properties.side or properties.Side or "Left",

		-- Other
		Items = {},
	}

	local Items = Cfg.Items
	do
		Items.Section = Library:Create("Frame", {
			Name = "\0",
			ZIndex = 5,
			Parent = self.Items.Page,
			BorderColor3 = rgb(38, 38, 38),
			Size = dim2(0, 100, 0, 100),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(20, 20, 20),
		})

		Library:Create("UICorner", {
			Parent = Items.Section,
			CornerRadius = dim(0, 6),
		})

		Library:Create("UIStroke", {
			Color = rgb(38, 38, 38),
			Parent = Items.Section,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		Library:Create("TextLabel", {
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = Cfg.Name,
			Parent = Items.Section,
			Size = dim2(0, 50, 0, 20),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Position = dim2(0.03999999910593033, 0, -0.029999999329447746, 0),
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 14,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Scrolling = Library:Create("ScrollingFrame", {
			Active = true,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ZIndex = 4,
			BorderSizePixel = 0,
			CanvasSize = dim2(0, 0, 0, 0),
			ScrollBarImageColor3 = rgb(183, 250, 142),
			MidImage = "rbxassetid://73504581233551",
			BorderColor3 = rgb(0, 0, 0),
			ScrollBarThickness = 5,
			Parent = Items.Section,
			Name = "\0",
			ScrollingEnabled = true,
			BackgroundTransparency = 1,
			Position = dim2(0, -1, 0, 0),
			Size = dim2(1, 0, 1, -2),
			BottomImage = "rbxassetid://84857766715955",
			TopImage = "rbxassetid://81416694737432",
			BackgroundColor3 = rgb(255, 255, 255),
		})
		Library:Themify(Items.Scrolling, "accent", "BackgroundColor3")

		Items.Elements = Library:Create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.Scrolling,
			AnchorPoint = vec2(0.5, 0),
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(0.5, 1, 0, 5),
			Size = dim2(1, 0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UICorner", {
			Parent = Items.Elements,
			CornerRadius = dim(0, 6),
		})

		Library:Create("UIListLayout", {
			Parent = Items.Elements,
			Padding = dim(0, 8),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Library:Create("UIPadding", {
			PaddingTop = dim(0, 20),
			PaddingBottom = dim(0, 20),
			Parent = Items.Elements,
			PaddingRight = dim(0, 20),
			PaddingLeft = dim(0, 20),
		})

		Items.Scrollbarfill = Library:Create("Frame", {
			Visible = true,
			BackgroundTransparency = 1,
			BorderColor3 = rgb(0, 0, 0),
			AnchorPoint = vec2(1, 0),
			Name = "\0",
			Position = dim2(1, 0, 0, 0),
			Parent = Items.Section,
			Size = dim2(0, 7, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(38, 38, 38),
		})

		Library:Create("UICorner", {
			Parent = Items.Scrollbarfill,
			CornerRadius = dim(0, 6),
		})

		Items.Fill = Library:Create("Frame", {
			Name = "\0",
			BackgroundTransparency = 1,
			Parent = Items.Scrollbarfill,
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 4, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(38, 38, 38),
		})
	end

	Items.Scrolling:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
		local Scroll = Items.Scrolling.AbsoluteCanvasSize.Y > Items.Scrolling.AbsoluteSize.Y
		Library:Tween(Items.Fill, { BackgroundTransparency = Scroll and 0 or 1 })
		Library:Tween(Items.Scrollbarfill, { BackgroundTransparency = Scroll and 0 or 1 })
	end)

	return setmetatable(Cfg, Library)
end

function Library:Toggle(properties)
	local Cfg = {
		Name = properties.Name or "Toggle",
		Flag = properties.Flag or properties.Name or "Toggle",
		Enabled = properties.Default or false,
		Callback = properties.Callback or function() end,

		Items = {},
	}

	local Items = Cfg.Items
	do
		Items.Object = Library:Create("TextButton", {
			Active = false,
			TextTransparency = 1,
			Text = "",
			Parent = self.Items.Elements,
			Name = "\0",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 0, 20),
			Selectable = false,
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Title = Library:Create("TextLabel", {
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = Cfg.Name,
			Parent = Items.Object,
			Name = "\0",
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			TextSize = 16,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.ComponentHolder = Library:Create("Frame", {
			Parent = Items.Object,
			Name = "\0",
			Position = dim2(1, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Parent = Items.ComponentHolder,
			Padding = dim(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Items.Elements = Library:Create("Frame", {
			LayoutOrder = -1,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.ComponentHolder,
			AnchorPoint = vec2(1, 0),
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(1, -50, 0, 0),
			Size = dim2(0, 32, 0, 18),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Parent = Items.Elements,
			Padding = dim(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Items.ToggleContainer = Library:Create("Frame", {
			Parent = Items.ComponentHolder,
			Name = "\0",
			Position = dim2(1, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 36, 0, 18),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(24, 24, 24),
		})

		Library:Create("UICorner", {
			Parent = Items.ToggleContainer,
			CornerRadius = dim(0, 64),
		})

		Library:Create("UIStroke", {
			Color = rgb(38, 38, 38),
			Transparency = 0.6499999761581421,
			Parent = Items.ToggleContainer,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		})

		Items.Circle = Library:Create("Frame", {
			Parent = Items.ToggleContainer,
			Name = "\0",
			Position = dim2(0, 0, 0, 2),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 14, 0, 14),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(56, 56, 56),
		})

		Library:Create("UICorner", {
			Parent = Items.Circle,
			CornerRadius = dim(0, 64),
		})

		Library:Create("UIPadding", {
			Parent = Items.ToggleContainer,
			PaddingRight = dim(0, 2),
			PaddingLeft = dim(0, 2),
		})

		Items.Glow = Library:Create("ImageLabel", {
			ImageColor3 = rgb(183, 250, 142),
			ScaleType = Enum.ScaleType.Slice,
			ImageTransparency = 1,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.ToggleContainer,
			Name = "\0",
			BackgroundColor3 = rgb(255, 255, 255),
			Size = dim2(1, 20, 1, 20),
			Image = "rbxassetid://18245826428",
			BackgroundTransparency = 1,
			Position = dim2(0, -10, 0, -10),
			ZIndex = 0,
			BorderSizePixel = 0,
			SliceCenter = rect(vec2(20, 20), vec2(80, 80)),
		})
		Library:Themify(Items.Glow, "accent", "BackgroundColor3")
	end

	function Cfg.Set(bool)
		Library:Tween(Items.ToggleContainer, { BackgroundColor3 = bool and themes.preset.accent or rgb(24, 24, 24) })
		Library:Tween(Items.Circle, {
			Position = bool and dim2(1, 0, 0, 2) or dim2(0, 0, 0, 2),
			AnchorPoint = bool and vec2(1, 0) or vec2(0, 0),
		})
		Library:Tween(Items.Glow, { ImageTransparency = bool and 0.69 or 1 })

		Flags[Cfg.Flag] = bool
		Cfg.Callback(bool)
	end

	Items.Object.MouseButton1Click:Connect(function()
		Cfg.Enabled = not Cfg.Enabled
		Cfg.Set(Cfg.Enabled)
	end)

	Cfg.Set(Cfg.Default)

	ConfigFlags[Cfg.Flag] = Cfg.Set

	return setmetatable(Cfg, Library)
end

function Library:Slider(properties)
	local Cfg = {
		Name = properties.Name or "Set me a name zaddy",
		Suffix = properties.Suffix or "",
		Flag = properties.Flag or properties.Name or "Slider",
		Callback = properties.Callback or function() end,

		-- Value Settings
		Min = properties.Min or 0,
		Max = properties.Max or 100,
		Intervals = properties.Decimal or 1,
		Value = properties.Default or 10,

		-- Other
		Dragging = false,
		Items = {},
	}

	local Items = Cfg.Items
	do
		Items.Object = Library:Create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			Rotation = 180,
			BackgroundTransparency = 1,
			Parent = self.Items.Elements,
			Name = "\0",
			Size = dim2(1, 0, 0, 30),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Title = Library:Create("TextLabel", {
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = Cfg.Name,
			Parent = Items.Object,
			Name = "\0",
			Size = dim2(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 16,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Outline = Library:Create("TextButton", {
			Parent = Items.Object,
			AutoButtonColor = false,
			Text = "",
			Name = "\0",
			Position = dim2(0, 1, 0, 23),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -1, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(25, 25, 25),
		})

		Library:Create("UICorner", {
			Parent = Items.Outline,
			CornerRadius = dim(0, 4),
		})

		Library:Create("UIStroke", {
			Color = rgb(34, 34, 34),
			Parent = Items.Outline,
		})

		Items.Accent = Library:Create("Frame", {
			Parent = Items.Outline,
			Name = "\0",
			Position = dim2(0, -1, 0, -1),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0.5, 1, 1, 2),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(183, 250, 142),
		})
		Library:Themify(Items.Accent, "accent", "BackgroundColor3")

		Library:Create("UICorner", {
			Parent = Items.Accent,
			CornerRadius = dim(0, 4),
		})

		Items.Circle = Library:Create("Frame", {
			AnchorPoint = vec2(1, 0.5),
			Parent = Items.Accent,
			Name = "\0",
			Position = dim2(1, -2, 0.5, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 6, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(20, 20, 20),
		})

		Library:Create("UICorner", {
			Parent = Items.Circle,
			CornerRadius = dim(0, 999),
		})

		Items.Glow = Library:Create("ImageLabel", {
			ImageColor3 = rgb(183, 250, 142),
			ScaleType = Enum.ScaleType.Slice,
			ImageTransparency = 0.6899999976158142,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.Accent,
			Name = "\0",
			BackgroundColor3 = rgb(255, 255, 255),
			Size = dim2(1, 20, 1, 20),
			Image = "rbxassetid://18245826428",
			BackgroundTransparency = 1,
			Position = dim2(0, -10, 0, -10),
			ZIndex = 0,
			BorderSizePixel = 0,
			SliceCenter = rect(vec2(20, 20), vec2(80, 80)),
		})
		Library:Themify(Items.Glow, "accent", "BackgroundColor3")

		Items.Value = Library:Create("TextBox", {
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			TextColor3 = rgb(55, 55, 57),
			BorderColor3 = rgb(0, 0, 0),
			Text = "50%",
			Parent = Items.Object,
			Name = "\0",
			Size = dim2(1, 0, 0, 0),
			BackgroundTransparency = 1,
			ClearTextOnFocus = true,
			TextXAlignment = Enum.TextXAlignment.Right,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 16,
			BackgroundColor3 = rgb(255, 255, 255),
		})
	end

	function Cfg.Set(value)
		Cfg.Value = math.clamp(Library:Round(value, Cfg.Intervals), Cfg.Min, Cfg.Max)

		Library:Tween(
			Items.Accent,
			{ Size = dim2((Cfg.Value - Cfg.Min) / (Cfg.Max - Cfg.Min), 1, 1, 2) },
			TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
		)
		Items.Value.Text = tostring(Cfg.Value) .. Cfg.Suffix
		Library:Tween(
			Items.Value,
			{ TextColor3 = rgb(255, 255, 255) },
			TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
		)

		Flags[Cfg.Flag] = Cfg.Value
		Cfg.Callback(Flags[Cfg.Flag])
	end

	Items.Outline.MouseButton1Down:Connect(function()
		Cfg.Dragging = true
	end)

	Library:Connection(InputService.InputChanged, function(input)
		if Cfg.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local Size = (input.Position.X - Items.Outline.AbsolutePosition.X) / Items.Outline.AbsoluteSize.X
			local Value = ((Cfg.Max - Cfg.Min) * Size) + Cfg.Min
			Cfg.Set(Value)
		end
	end)

	Library:Connection(InputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Cfg.Dragging = false
			Library:Tween(Items.Value, { TextColor3 = rgb(55, 55, 57) })
		end
	end)

	Items.Value.FocusLost:Connect(function()
		Cfg.Set(Items.Value.Text)
		Library:Tween(Items.Value, { TextColor3 = rgb(55, 55, 57) })
	end)

	Library:Tween(Items.Value, { TextColor3 = rgb(55, 55, 57) })

	Cfg.Set(Cfg.Value)
	ConfigFlags[Cfg.Flag] = Cfg.Set

	return setmetatable(Cfg, Library)
end

function Library:Dropdown(properties)
	local Cfg = {
		Name = properties.Name or "Dropdown",
		Flag = properties.Flag or properties.Name or "Dropdown",
		Options = properties.Options or { "" },
		Callback = properties.Callback or function() end,
		Multi = properties.Multi or false,
		Scrolling = properties.Scrolling or false,

		-- Ignore these
		Open = false,
		OptionInstances = {},
		MultiItems = {},
		Items = {},
		Tweening = false,
		Ignore = properties.Ignore or false,
	}

	Cfg.Default = properties.Default or (Cfg.Multi and { Cfg.Items[1] }) or Cfg.Items[1] or "None"
	Flags[Cfg.Flag] = Cfg.Default

	local Items = Cfg.Items
	do
		-- Element
		Items.Dropdown = Library:Create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			Parent = self.Items.Elements,
			BackgroundTransparency = 1,
			Name = "\0",
			Size = dim2(1, 0, 0, 20),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Text = Library:Create("TextLabel", {
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = Cfg.Name,
			Parent = Items.Dropdown,
			Name = "\0",
			Size = dim2(1, 0, 0, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 16,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Outline = Library:Create("TextButton", {
			Active = false,
			AutoButtonColor = false,
			BorderColor3 = rgb(0, 0, 0),
			Text = "",
			Parent = Items.Dropdown,
			Name = "\0",
			Position = dim2(0, 0, 0, 23),
			Size = dim2(1, 0, 0, 25),
			Selectable = false,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(25, 25, 25),
		})

		Library:Create("UICorner", {
			Parent = Items.Outline,
			CornerRadius = dim(0, 4),
		})

		Items.Inline = Library:Create("Frame", {
			Parent = Items.Outline,
			Name = "\0",
			Position = dim2(0, 0, 0, 1),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(1, -2, 1, -2),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(33, 33, 33),
		})

		Library:Create("UICorner", {
			Parent = Items.Inline,
			CornerRadius = dim(0, 4),
		})

		Items.Inner = Library:Create("TextLabel", {
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = "Option1, Option2, Option3, Option4, Option5",
			Parent = Items.Inline,
			Name = "\0",
			Size = dim2(1, 0, 1, 0),
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			ClipsDescendants = true,
			BorderSizePixel = 0,
			TextSize = 16,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UIPadding", {
			PaddingLeft = dim(0, 5),
			Parent = Items.Inner,
		})

		Items.Gradient = Library:Create("Frame", {
			AnchorPoint = vec2(1, 0),
			Parent = Items.Inline,
			Name = "\0",
			Position = dim2(1, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 100, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(33, 33, 33),
		})

		Library:Create("UIGradient", {
			Parent = Items.Gradient,
			Transparency = numseq({ numkey(0, 1), numkey(0.727, 0), numkey(1, 0) }),
		})

		Items.ImageHolder = Library:Create("Frame", {
			BorderColor3 = rgb(0, 0, 0),
			AnchorPoint = vec2(1, 0.5),
			Parent = Items.Gradient,
			BackgroundTransparency = 1,
			Position = dim2(1, -4, 0.5, 0),
			Name = "\0",
			Size = dim2(0, 16, 0, 16),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Glow = Library:Create("ImageLabel", {
			ImageColor3 = rgb(183, 250, 142),
			ScaleType = Enum.ScaleType.Slice,
			ImageTransparency = 1,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.ImageHolder,
			Name = "\0",
			Size = dim2(1, 20, 1, 20),
			Image = "rbxassetid://18245826428",
			BackgroundTransparency = 1,
			Position = dim2(0, -10, 0, -10),
			BackgroundColor3 = rgb(255, 255, 255),
			BorderSizePixel = 0,
			SliceCenter = rect(vec2(20, 20), vec2(80, 80)),
		})
		Library:Themify(Items.Glow, "accent", "BackgroundColor3")

		Items.Items = Library:Create("ImageLabel", {
			ImageColor3 = rgb(53, 53, 53),
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.ImageHolder,
			Name = "\0",
			Image = "rbxassetid://79197303583784",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 1, 0),
			ZIndex = 2,
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UIGradient", {
			Color = rgbseq({ rgbkey(0, rgb(198, 198, 198)), rgbkey(1, rgb(198, 198, 198)) }),
			Parent = Items.Items,
		})
		--

		-- Element Holder
		Items.DropdownHolder = Library:Create("Frame", {
			Parent = Library.Items,
			Visible = false,
			Size = dim2(0, 245, 0, 32),
			Name = "\0",
			Position = dim2(0, 1008, 0, 620),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = rgb(25, 25, 25),
		})

		Library:Create("UICorner", {
			Parent = Items.DropdownHolder,
			CornerRadius = dim(0, 4),
		})

		Items.DropdownItems = Library:Create("Frame", {
			Parent = Items.DropdownHolder,
			Size = dim2(1, -2, 1, -2),
			Name = "\0",
			Position = dim2(0, 0, 0, 1),
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = rgb(33, 33, 33),
		})

		Library:Create("UICorner", {
			Parent = Items.DropdownItems,
			CornerRadius = dim(0, 4),
		})

		Library:Create("UIListLayout", {
			Parent = Items.DropdownItems,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = dim(0, 1),
		})

		Library:Create("UIPadding", {
			PaddingBottom = dim(0, 1),
			Parent = Items.DropdownItems,
			PaddingLeft = dim(0, 1),
			PaddingRight = dim(0, -1),
		})
		--
	end

	function Cfg.RenderOption(text)
		local Options = { Items = {} }

		local OptionItems = Options.Items
		do
			OptionItems.Option = Library:Create("TextButton", {
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				Parent = Items.DropdownItems,
				AutoButtonColor = false,
				TextColor3 = rgb(63, 63, 65),
				BorderColor3 = rgb(0, 0, 0),
				Text = text,
				Name = "\0",
				Size = dim2(1, 0, 0, 0),
				Position = dim2(0.403292179107666, 0, 1.4716981649398804, 0),
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextSize = 16,
				BackgroundColor3 = rgb(182, 249, 141),
			})

			OptionItems.Padding = Library:Create("UIPadding", {
				PaddingTop = dim(0, 5),
				PaddingBottom = dim(0, 5),
				Parent = OptionItems.Option,
				PaddingRight = dim(0, 5),
				PaddingLeft = dim(0, 5),
			})

			OptionItems.Stroke = Library:Create("UIStroke", {
				Color = rgb(183, 250, 142),
				Transparency = 1,
				Parent = OptionItems.Option,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			})
			Library:Themify(Items.UIStroke, "accent", "BackgroundColor3")

			OptionItems.Circle = Library:Create("Frame", {
				BorderColor3 = rgb(0, 0, 0),
				AnchorPoint = vec2(1, 0.5),
				Parent = OptionItems.Option,
				BackgroundTransparency = 1,
				Position = dim2(1, 10, 0.5, 0), -- x offset : -2
				Name = "\0",
				Size = dim2(0, 6, 0, 6),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(182, 250, 141),
			})

			Library:Create("UICorner", {
				Parent = OptionItems.Circle,
				CornerRadius = dim(0, 999),
			})

			OptionItems.Glow = Library:Create("ImageLabel", {
				ImageColor3 = rgb(183, 250, 142),
				ScaleType = Enum.ScaleType.Slice,
				ImageTransparency = 1,
				BorderColor3 = rgb(0, 0, 0),
				Parent = OptionItems.Circle,
				BackgroundColor3 = rgb(255, 255, 255),
				Size = dim2(1, 20, 1, 20),
				Image = "rbxassetid://18245826428",
				BackgroundTransparency = 1,
				Position = dim2(0, -10, 0, -10),
				ZIndex = 0,
				BorderSizePixel = 0,
				SliceCenter = rect(vec2(20, 20), vec2(80, 80)),
			})
			Library:Themify(Items.ImageLabel, "accent", "BackgroundColor3")
		end

		table.insert(Cfg.OptionInstances, OptionItems)

		return OptionItems
	end

	function Cfg.SetVisible(bool)
		if Library.OpenElement ~= Cfg then
			Library:CloseElement(Cfg)
		end

		Library:Tween(Items.Items, { ImageColor3 = bool and themes.preset.accent or rgb(53, 53, 53) })
		Library:Tween(Items.Glow, { ImageTransparency = bool and 0.69 or 1 })

		Items.DropdownHolder.Position =
			dim2(0, Items.Outline.AbsolutePosition.X, 0, Items.Outline.AbsolutePosition.Y + 85)
		Items.DropdownHolder.Size = dim_offset(Items.Outline.AbsoluteSize.X, 0)
		Items.DropdownHolder.Visible = bool

		Library.OpenElement = Cfg
	end

	function Cfg.Set(value)
		local Selected = {}
		local IsTable = type(value) == "table"

		for _, option in Cfg.OptionInstances do
			if option.Option.Text == value or (IsTable and table.find(value, option.Option.Text)) then
				table.insert(Selected, option.Option.Text)
				Cfg.MultiItems = Selected
				Library:Tween(option.Option, { BackgroundTransparency = 0.8, TextColor3 = themes.preset.accent })
				Library:Tween(option.Stroke, { Transparency = 0 })
				Library:Tween(option.Circle, { BackgroundTransparency = 0, Position = dim2(1, -2, 0.5, 0) })
				Library:Tween(option.Glow, { ImageTransparency = 0.69 })
			else
				Library:Tween(option.Option, { BackgroundTransparency = 1, TextColor3 = rgb(63, 63, 65) })
				Library:Tween(option.Circle, { BackgroundTransparency = 1, Position = dim2(1, -10, 0.5, 0) })
				Library:Tween(option.Glow, { ImageTransparency = 1 })
				Library:Tween(option.Stroke, { Transparency = 1 })
			end
		end

		Items.Inner.Text = if IsTable then table.concat(Selected, ", ") else Selected[1] or ""
		Flags[Cfg.Flag] = if IsTable then Selected else Selected[1]

		Cfg.Callback(Flags[Cfg.Flag])
	end

	function Cfg.RefreshOptions(options)
		for _, option in Cfg.OptionInstances do
			option.Option:Destroy()
		end

		Cfg.OptionInstances = {}

		for _, option in options do
			local Button = Cfg.RenderOption(option)

			Button.Option.MouseButton1Down:Connect(function()
				if Cfg.Multi then
					local Selected = table.find(Cfg.MultiItems, Button.Option.Text)

					if Selected then
						table.remove(Cfg.MultiItems, Selected)
					else
						table.insert(Cfg.MultiItems, Button.Option.Text)
					end

					Cfg.Set(Cfg.MultiItems)
				else
					Cfg.SetVisible(false)
					Cfg.Open = false

					Cfg.Set(Button.Option.Text)
				end
			end)
		end
	end

	function Cfg.Tween(bool)
		if Cfg.Tweening == true then
			return
		end

		Cfg.Tweening = true

		if bool then
			Items.DropdownElements.Visible = true
			Items.DropdownElements.Parent = Library.Items
		end

		local Children = Items.DropdownElements:GetDescendants()
		table.insert(Children, Items.DropdownElements)

		local Tween
		for _, obj in Children do
			local Index = Library:GetTransparency(obj)

			if not Index then
				continue
			end

			if type(Index) == "table" then
				for _, prop in Index do
					Tween = Library:Fade(obj, prop, bool, 0.1)
				end
			else
				Tween = Library:Fade(obj, Index, bool, 0.1)
			end
		end

		task.delay(0.09, function()
			Cfg.Tweening = false
			Items.DropdownElements.Visible = bool
			Items.DropdownElements.Parent = bool and Library.Items or Library.Other
		end)
	end

	Items.Outline.MouseButton1Click:Connect(function()
		Cfg.Open = not Cfg.Open

		Cfg.SetVisible(Cfg.Open)
	end)

	Library:Connection(InputService.InputBegan, function(input, game_event)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not Library:Hovering({ Items.Dropdown, Items.DropdownHolder }) then
				Cfg.SetVisible(false)
				Cfg.Open = false
			end
		end
	end)

	Flags[Cfg.Flag] = {}
	ConfigFlags[Cfg.Flag] = Cfg.Set

	Cfg.RefreshOptions(Cfg.Options)
	Cfg.Set(Cfg.Default)

	return setmetatable(Cfg, Library)
end

function Library:Label(properties)
	local Cfg = {
		Name = properties.Name or "Label",

		-- Other
		Items = {},
	}

	local Items = Cfg.Items
	do
		Items.Object = Library:Create("TextButton", {
			Active = false,
			TextTransparency = 1,
			Text = "",
			Parent = self.Items.Elements,
			Name = "\0",
			BackgroundTransparency = 1,
			Size = dim2(1, 0, 0, 20),
			Selectable = false,
			BorderColor3 = rgb(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.Title = Library:Create("TextLabel", {
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			TextColor3 = rgb(255, 255, 255),
			BorderColor3 = rgb(0, 0, 0),
			Text = Cfg.Name,
			Parent = Items.Object,
			Name = "\0",
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = dim2(1, 0, 1, 0),
			BorderSizePixel = 0,
			TextSize = 16,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Items.ComponentHolder = Library:Create("Frame", {
			Parent = Items.Object,
			Name = "\0",
			Position = dim2(1, 0, 0, 0),
			BorderColor3 = rgb(0, 0, 0),
			Size = dim2(0, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Parent = Items.ComponentHolder,
			Padding = dim(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Items.Elements = Library:Create("Frame", {
			LayoutOrder = -1,
			BorderColor3 = rgb(0, 0, 0),
			Parent = Items.ComponentHolder,
			AnchorPoint = vec2(1, 0),
			Name = "\0",
			BackgroundTransparency = 1,
			Position = dim2(1, -50, 0, 0),
			Size = dim2(0, 32, 0, 18),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = rgb(255, 255, 255),
		})

		Library:Create("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Parent = Items.Elements,
			Padding = dim(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	end

	function Cfg.Set(Text)
		Items.Title.Text = Text
	end

	return setmetatable(Cfg, Library)
end

function Library:Colorpicker(properties)
	local Cfg = {
		Name = properties.Name or "Color",
		Flag = properties.Flag or properties.Name or "Colorpicker",
		Callback = properties.Callback or function() end,

		Color = properties.Color or color(1, 1, 1), -- Default to white color if not provided
		Alpha = properties.Alpha or properties.Transparency or 0,

		-- Other
		Open = false,
		Mode = properties.Mode or "Animation",
		Items = {},
	}

	local Picker = self:Keypicker(Cfg)

	local Items = Picker.Items
	do
		Cfg.Items = Items
		Cfg.Set = Picker.Set
	end

	Cfg.Set(Cfg.Color, Cfg.Alpha)
	ConfigFlags[Cfg.Flag] = Cfg.Set

	return setmetatable(Cfg, Library)
end

function Library:Textbox(properties)
	local Cfg = {
		Name = properties.Name or "TextBox",
		PlaceHolder = properties.PlaceHolder
			or properties.PlaceHolderText
			or properties.Holder
			or properties.HolderText
			or "Type here...",
		Default = properties.Default or "",
		Flag = properties.Flag or properties.Name or "TextBox",
		Callback = properties.Callback or function() end,

		Items = {},
	}

	Flags[Cfg.Flag] = Cfg.default

	local Items = Cfg.Items
	do
	end

	function Cfg.Set(text)
		Flags[Cfg.Flag] = text

		Items.Input.Text = text

		Cfg.Callback(text)
	end

	Items.Input:GetPropertyChangedSignal("Text"):Connect(function()
		Cfg.Set(Items.Input.Text)
	end)

	if Cfg.Default then
		Cfg.Set(Cfg.Default)
	end

	ConfigFlags[Cfg.Flag] = Cfg.Set

	return setmetatable(Cfg, Library)
end

function Library:Keybind(properties)
	local Cfg = {
		Flag = properties.Flag or properties.Name,
		Callback = properties.Callback or function() end,
		Name = properties.Name or nil,

		Key = properties.Key or nil,
		Mode = properties.Mode or "Toggle",
		Active = properties.Default or false,

		Show = properties.ShowInList or true,

		Open = false,
		Binding,
		Ignore = false,

		Items = {},
	}

	-- change object and text

	Flags[Cfg.Flag] = {
		Mode = Cfg.Mode,
		Key = Cfg.Key,
		Active = Cfg.Active,
	}

	local Items = Cfg.Items
	do
		-- Component

		--

		-- Mode holder

		--
	end

	function Cfg.SetMode(mode)
		Cfg.Mode = mode

		if mode == "Always" then
			Cfg.Set(true)
		elseif mode == "Hold" then
			Cfg.Set(false)
		end

		Flags[Cfg.Flag].Mode = mode
	end

	function Cfg.Set(input)
		if type(input) == "boolean" then
			Cfg.Active = input

			if Cfg.Mode == "Always" then
				Cfg.Active = true
			end
		elseif tostring(input):find("Enum") then
			input = input.Name == "Escape" and "NONE" or input

			Cfg.Key = input or "NONE"
		elseif table.find({ "Toggle", "Hold", "Always" }, input) then
			if input == "Always" then
				Cfg.Active = true
			end

			Cfg.Mode = input
			Cfg.SetMode(Cfg.Mode)
		elseif type(input) == "table" then
			input.Key = type(input.Key) == "string" and input.Key ~= "NONE" and Library:ConvertEnum(input.key)
				or input.Key
			input.Key = input.Key == Enum.KeyCode.Escape and "NONE" or input.Key

			Cfg.Key = input.Key or "NONE"
			Cfg.Mode = input.Mode or "Toggle"

			if input.Active then
				Cfg.Active = input.Active
			end

			Cfg.SetMode(Cfg.Mode)
		end

		Cfg.Callback(Cfg.Active)

		local text = (tostring(Cfg.Key) ~= "Enums" and (Keys[Cfg.Key] or tostring(Cfg.Key):gsub("Enum.", "")) or nil)
		local __text = text and tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", "")

		Items.Key.Text = __text

		if Items.Keybinds then
			Items.Keybinds.TextTransparency = 1
			Library:Tween(Items.Keybinds, { TextTransparency = 0 })

			Items.KeybindsStroke.Transparency = 1
			Library:Tween(Items.KeybindsStroke, { Transparency = 0 })

			Items.Keybinds.Visible = Cfg.Active
			Items.Keybinds.Text = string.format("[%s]: %s", __text, Cfg.Name or Cfg.Flag or "Key")
		end

		Flags[Cfg.Flag] = {
			mode = Cfg.Mode,
			key = Cfg.Key,
			active = Cfg.Active,
		}
	end

	function Cfg.SetVisible(bool)
		Items.Fade.BackgroundTransparency = 0
		Library:Tween(Items.Fade, { BackgroundTransparency = 1 })

		Items.ModeHolder.Visible = bool
		Items.ModeHolder.Position =
			dim2(0, Items.KeybindOutline.AbsolutePosition.X + 2, 0, Items.KeybindOutline.AbsolutePosition.Y + 74)
	end

	Items.KeybindOutline.MouseButton1Down:Connect(function()
		task.wait()
		Items.Key.Text = "..."

		Cfg.Binding = Library:Connection(InputService.InputBegan, function(keycode, game_event)
			Cfg.Set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)

			Cfg.Binding:Disconnect()
			Cfg.Binding = nil
		end)
	end)

	Items.KeybindOutline.MouseButton2Down:Connect(function()
		Cfg.Open = not Cfg.Open

		Cfg.SetVisible(Cfg.Open)
	end)

	Library:Connection(InputService.InputBegan, function(input, game_event)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not (Library:Hovering(Items.Dropdown.Items.DropdownElements) or Library:Hovering(Items.ModeHolder)) then
				Items.Dropdown.SetVisible(false)
				Items.Dropdown.Visible = false

				Cfg.SetVisible(false)
				Cfg.Open = false
			end
		end

		if not game_event then
			local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
				or input.UserInputType

			if selected_key == Cfg.Key then
				if Cfg.Mode == "Toggle" then
					Cfg.Active = not Cfg.Active
					Cfg.Set(Cfg.Active)
				elseif Cfg.Mode == "Hold" then
					Cfg.Set(true)
				end
			end
		end
	end)

	Library:Connection(InputService.InputEnded, function(input, game_event)
		if game_event then
			return
		end

		local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

		if selected_key == Cfg.Key then
			if Cfg.Mode == "Hold" then
				Cfg.Set(false)
			end
		end
	end)

	Cfg.Set({ Mode = Cfg.Mode, Active = Cfg.Active, Key = Cfg.Key })
	ConfigFlags[Cfg.Flag] = Cfg.Set
	Items.Dropdown.Set(Cfg.Mode)

	return setmetatable(Cfg, Library)
end

function Library:Button(properties)
	local Cfg = {
		Name = properties.Name or "TextBox",
		Callback = properties.Callback or function() end,

		-- Other
		Items = {},
	}

	local Items = Cfg.Items
	do
	end

	Items.Button.MouseButton1Click:Connect(function()
		Cfg.Callback()
	end)

	return setmetatable(Cfg, Library)
end

function Library:Configs(window)
	local Text
	local ConfigText

	local Tab = window:Tab({ Name = "Settings" })

	local Section = Tab:Section({ Name = "Main", Side = "Left" })
	ConfigHolder = Section:Dropdown({
		Name = "Configs",
		Options = { "Report", "This", "Error", "To", "Finobe" },
		Callback = function(option)
			if Text then
				Text.Set(option)
			end
		end,
		Flag = "config_Name_list",
	})
	Library:UpdateConfigList()
	window.Tweening = true
	Text = Section:Textbox({
		Name = "Config Name:",
		Flag = "config_Name_text",
		Callback = function(text)
			ConfigText = text
		end,
	})
	window.Tweening = false
	Section:Button({
		Name = "Save",
		Callback = function()
			writefile(Library.Directory .. "/configs/" .. ConfigText .. ".cfg", Library:GetConfig())
			Library:UpdateConfigList()
			Notifications:Create({
				Name = "Saved Config (" .. Library.Directory .. "/configs/" .. ConfigText .. ".cfg" .. ")",
			})
		end,
	})

	Section:Button({
		Name = "Load",
		Callback = function()
			Library:LoadConfig(readfile(Library.Directory .. "/configs/" .. ConfigText .. ".cfg"))
			Library:UpdateConfigList()
			Notifications:Create({
				Name = "Loaded Config (" .. Library.Directory .. "/configs/" .. ConfigText .. ".cfg" .. ")",
			})
		end,
	})

	Section:Button({
		Name = "Delete",
		Callback = function()
			delfile(Library.Directory .. "/configs/" .. ConfigText .. ".cfg")
			Library:UpdateConfigList()
			Notifications:Create({
				Name = "Deleted Config (" .. Library.Directory .. "/configs/" .. ConfigText .. ".cfg" .. ")",
			})
		end,
	})

	window.Tweening = true
	Section:Label({ Name = "Menu Bind" }):Keybind({
		Name = "Menu Bind",
		ShowInList = false,
		Callback = function(bool)
			if window.Tweening then
				return
			end

			window.ToggleMenu(bool)
		end,
		Default = true,
	})
end

return Library