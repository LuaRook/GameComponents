local GameComponents = script.Parent.Parent
local Packages = GameComponents.Parent
local Components = GameComponents.Components

local Fusion = require(Packages.Fusion)

local Shadow = require(Components.Decoration.Shadow)
local Button = require(Components.Interactable.Button)

local Children = Fusion.Children

return function(target)
	local background = Shadow({

		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),

		Parent = target,

		[Children] = Button({

			Text = "Hello World!",
		}),
	})

	return function()
		background:Destroy()
	end
end
