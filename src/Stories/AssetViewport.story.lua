local GameComponents = script.Parent.Parent
local Components = GameComponents.Components

local AssetViewport = require(Components.Display.AssetViewport)

return function(target)
	local background = AssetViewport({
		Parent = target,

		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),

		Object = Instance.new("Part"),
		ObjectCFrame = CFrame.new(0, 3, 0),
	})

	return function()
		background:Destroy()
	end
end
