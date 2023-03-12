--[[
	This generates a Computed object which will change what GuideColor it will
	return based off the given GuideModifier. This can be used when the default
	Colors of a certain GuideColor does not satisfy the needs that are given due
	to lacking (for example) a different color for a certain guide modifier.
	
	Usage:
	```lua
	
	local guideColor = mapGuideColor(currentGuideModifier, {
		[Enum.StudioStyleGuideModifier.Default] = Enum.StudioStyleGuideColor.MainBackground
	})
	
	```
	
]]

local Packages = script.Parent.Parent.Parent
local Util = script.Parent

local Fusion = require(Packages.Fusion)

local unwrap = require(Util.unwrap)

type CanBeState<T> = Fusion.CanBeState<T>
type Computed<T> = Fusion.Computed<T>

type StudioStyleGuideColor = Enum.StudioStyleGuideColor
type StudioStyleGuideModifier = Enum.StudioStyleGuideModifier

local Computed = Fusion.Computed

local function mapGuideColor(
	current: CanBeState<StudioStyleGuideModifier>,
	overwrites: { [StudioStyleGuideModifier]: Enum.StudioStyleGuideColor }
): Computed<StudioStyleGuideColor>
	return Computed(function()
		local currentOverwrites = unwrap(overwrites)
		local currentModifier = unwrap(current)

		local result = currentOverwrites[currentModifier] or currentOverwrites[Enum.StudioStyleGuideModifier.Default]

		return result
	end, Fusion.doNothing)
end

return mapGuideColor
