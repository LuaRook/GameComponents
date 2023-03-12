local GameComponents = script.Parent.Parent
local Components = GameComponents.Components

local Text = require(Components.Display.Text)

return function(target)
	local text = Text({
		Parent = target,

		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),

		Text = "Hello World!",
	})

	return function()
		text:Destroy()
	end
end
