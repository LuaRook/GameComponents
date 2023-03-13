--[[
	Creates a GuideModifier state which can be used to track if a component is
	being hovered/pressed.
	
]]

local Packages = script.Parent.Parent.Parent
local Util = script.Parent
local GameComponents = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Enums = require(GameComponents.Enums)
local unwrap = require(Util.unwrap)

type StateObject = Fusion.CanBeState<boolean>?
type Computed<T> = Fusion.Computed<T>

local Computed = Fusion.Computed

local function guideState(
	selected: StateObject,
	disabled: StateObject,
	pressed: StateObject,
	hovering: StateObject
): Computed<any>
	return Computed(function()
		local value = if unwrap(disabled)
			then Enums.GuideModifier.Disabled
			elseif unwrap(selected) then Enums.GuideModifier.Selected
			elseif unwrap(pressed) then Enums.GuideModifier.Pressed
			elseif unwrap(hovering) then Enums.GuideModifier.Hover
			else Enums.GuideModifier.Default

		return value
	end, Fusion.doNothing)
end

return guideState
