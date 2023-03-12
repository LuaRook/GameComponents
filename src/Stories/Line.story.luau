local GameComponents = script.Parent.Parent
local Components = GameComponents.Components

local Line = require(Components.Decoration.Line)

return function(target)
	local Line = Line({
		Parent = target,

		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
	})

	return function()
		Line:Destroy()
	end
end
