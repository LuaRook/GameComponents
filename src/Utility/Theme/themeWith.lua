--[[
	This function should be used for returning the provided theme color associated
	with the given GuideColor and GuideModifier, this makes it incredibly easy for
	developers to retrieve a Theme that automatically updates according to theme
	changes.
	
]]

local Packages = script.Parent.Parent.Parent
local Util = script.Parent

local Fusion = require(Packages.Fusion)
local unwrap = require(Util.unwrap)
local Enums = require(script.Parent.Enums)

local Value = Fusion.Value
local Computed = Fusion.Computed

local CurrentTheme = Value("Dark")

type CanBeState<T> = Fusion.CanBeState<T>?
type Computed<T> = Fusion.Computed<T>

local function themeWith(GuideColor: CanBeState<any>, GuideModifier: CanBeState<any>): Computed<Color3>
	if GuideColor == nil then
		return CurrentTheme
	end

	return Computed(function()
		local guideColor = unwrap(GuideColor) or Enums.GuideColor.MainBackground
		local guideModifier = unwrap(GuideModifier) or Enums.GuideModifier.Default

		local currentTheme = unwrap(CurrentTheme)
		local themeData = unwrap(currentTheme)

		if not themeData[currentTheme][guideModifier] then
			return themeData[currentTheme][Enums.GuideModifier.Default]
		end

		return themeData[unwrap(CurrentTheme)][guideColor][guideModifier]
	end, Fusion.doNothing)
end

return themeWith
