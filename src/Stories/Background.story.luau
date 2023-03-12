
local GameComponents = script.Parent.Parent
local Components = GameComponents.Components

local Background = require(Components.Decoration.Background)

return function(target)
	
	local background = Background {
		Parent = target,
		
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
		
	}
	
	return function()
		
		background:Destroy()
		
	end
	
end