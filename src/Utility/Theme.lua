--[[
	This function should be used for returning the provided theme color associated
	with the given GuideColor and GuideModifier. This makes it incredibly easy for
	developers to retrieve a Theme that automatically updates according to theme
	changes.

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = script.Parent.Parent.Parent
local Util = script.Parent
local GameComponents = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Signal = require(Packages.Signal)

local Themes = require(ReplicatedStorage.Common.Themes)
local Enums = require(GameComponents.Enums)
local unwrap = require(Util.unwrap)

local Value = Fusion.Value
local Computed = Fusion.Computed

local CurrentTheme = Value({})
local ThemeChanged = Signal.new()

type CanBeState<T> = Fusion.CanBeState<T>?
type Computed<T> = Fusion.Computed<T>

local function Theme(GuideColor: CanBeState<any>, GuideModifier: CanBeState<any>): Computed<Color3>
	if GuideColor == nil then
		return CurrentTheme
	end

	return Computed(function()
		local guideColor = unwrap(GuideColor)
		local guideModifier = unwrap(GuideModifier)
		
		return unwrap(CurrentTheme):GetColor(
			guideColor or Enums.GuideColor.MainBackground,
			guideModifier or Enums.GuideModifier.Default
		)
	end, Fusion.doNothing)
end

ThemeChanged:Connect(function(theme)
	CurrentTheme:set(theme)
end)

for name, data in Themes do
	data.Name = name

	function data:GetColor(GuideColor: any, GuideModifier: any?)
		local color = data[GuideColor][GuideModifier]
		if not color then
			return data[GuideColor][Enums.GuideModifier.Default]
		end

		return color
	end
	function data:SetAsTheme()
		ThemeChanged:Fire(data)
	end

	if data.Default then
		data:SetAsTheme()
	end
end

return Theme
