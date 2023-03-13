local Packages = script.Parent.Parent.Parent
local GameComponents = script.Parent.Parent
local Components = GameComponents.Components

local Fusion = require(Packages.Fusion)

local Tooltip = require(Components.Interactable.Tooltip)
local Button = require(Components.Interactable.Button)

local New = Fusion.New
local Children = Fusion.Children

return function(target)
	local background = Button({
		Parent = target,

		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),

		Text = "Hello World!",
		
		[Children] = Tooltip({
			[Children] = New("Frame")({
				Size = UDim2.fromOffset(50, 50),
			})
		})
	})

	return function()
		background:Destroy()
	end
end
