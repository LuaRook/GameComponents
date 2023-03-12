
local GameComponents = script.Parent.Parent
local Components = GameComponents.Components

local Dropdown = require(Components.Interactable.Dropdown)

return function(target)
	
	local background = Dropdown {
		Parent = target,
		
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		
		DropdownItems = {"Apple", "Pear", "Grape", "Blackberry", "Cherry", "Pineapple", "A", "B", "C"},
		Selected = ""
		
	}
	
	return function()
		
		background:Destroy()
		
	end
	
end