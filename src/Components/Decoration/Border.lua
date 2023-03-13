--[[
	Displays a border which is used to show a boundary between elements.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Enums = require(GameComponents.Enums)
local Util = require(GameComponents.Utility)

local New = Fusion.New
local Spring = Fusion.Spring

local Theme = Util.Theme
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Border = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Thickness: CanBeState<number>?,
	BorderColor: CanBeState<any>?,
	BorderModifier: CanBeState<any>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"BorderColor",
	"BorderModifier",
}

return function(props: Border)
	local BorderColor = props.BorderColor or Enums.GuideColor.Border
	local BorderModifier = props.BorderModifier

	local BorderColor3 = Spring(Theme(BorderColor, BorderModifier), 40, 1)

	local Border = New("UIStroke")({

		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = BorderColor3,
	})

	return Fusion.Hydrate(Border)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end
