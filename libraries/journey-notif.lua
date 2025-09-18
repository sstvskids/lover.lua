local cloneref = cloneref or function(obj)
    return obj
end

local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local tweenService = cloneref(game:GetService('TweenService'))
local playersService = cloneref(game:GetService('Players'))
local lplr = playersService.LocalPlayer

local suc, res = pcall(require, replicatedStorage.GameModules.NotifyModule)
return suc and res or {
    NewNotification = function(plr, txt, dur, color, sound)
        local plrUI = plr.PlayerGui:WaitForChild('NotificationInterface')
        local frame = plrUI.LocalScript.listing_Frame:Clone()
        local listing = frame.listing
		local listingshadow = frame.listing_Shadow

        if type(txt) == 'table' then
			listing.Text = ''..txt[1]
			listingshadow.Text = ''..txt[2]
		else
			listing.Text = ''..txt
			listingshadow.Text = ''..txt
		end

        local constraint1 = listing.UITextSizeConstraint
		constraint1.MaxTextSize = 20
		constraint1.MinTextSize = 9
		local constraint2 = listingshadow.UITextSizeConstraint
		constraint1.MaxTextSize = 20
		constraint1.MinTextSize = 9

        listing.TextTransparency = 1
		listingshadow.TextTransparency = 1

        if color == "Rainbow" then
			task.spawn(function()
                local colors = {
					Color3.fromRGB(0, 255, 255),
					Color3.fromRGB(255, 147, 0),
					Color3.fromRGB(255, 255, 0),
					Color3.fromRGB(255, 0, 0),
					Color3.fromRGB(0, 255, 0),
					Color3.fromRGB(255, 100, 255)
				}

                for _ = 1, #colors do
					if listing then
						local txtcolor = {
							["TextColor3"] = colors[math.random(1, #colors)]
						}
						local tween = tweenService:Create(listing, TweenInfo.new(dur / #colors), txtcolor)

						tween:Play()
						tween.Completed:Wait()
					end
				end
            end)
        elseif type(color) == "table" then
            task.spawn(function()
                for _ = 1, #color do
					if listing then
						local txtcolor = {
							["TextColor3"] = color[math.random(1, #color)]
						}
						local tween = tweenService:Create(listing, TweenInfo.new(dur / #color), txtcolor)

						tween:Play()
						tween.Completed:Wait()
					end
				end
            end)
        else
            listing.TextColor3 = color
        end

        frame.Parent = plrUI.Frame

        tweenService:Create(constraint1, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
			MaxTextSize = 40,
			MinTextSize = 18
		}):Play()

		tweenService:Create(constraint2, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
			MaxTextSize = 40,
			MinTextSize = 18
		}):Play()

		tweenService:Create(listingshadow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
			TextTransparency = 0.8
		}):Play()

		local audiojank = tweenService:Create(listing, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
			TextTransparency = 0
		})

		audiojank:Play()
		audiojank.Completed:Connect(function()
			local folder = frame.SoundFolder
			if sound ~= nil and folder:FindFirstChild(''..sound) then
				folder:FindFirstChild(''..sound):Play()
			end
		end)
		audiojank.Completed:Wait()
		task.wait(dur)

        tweenService:Create(listingshadow, TweenInfo.new(0.5, Enum.EasingStyle.Circular), {
			TextTransparency = 1
		}):Play()

		local disappear = tweenService:Create(listing, TweenInfo.new(0.5, Enum.EasingStyle.Circular), {
			TextTransparency = 1
		})

        disappear:Play()
		disappear.Completed:Connect(function()
			frame:Destroy()
		end)
    end
}