local GameComponents = script.Parent.Parent
local Components = GameComponents.Components

local Button = require(Components.Interactable.Button)

return function(target)
	local background = Button({
		Parent = target,

		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),

		Text = "Hello World!",
	})

	return function()
		background:Destroy()
	end
end
