--[[
	Text displays the given Text.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local New = Fusion.New
local Spring = Fusion.Spring

local Theme = Util.Theme
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Text = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<UDim2>?,

	Text: CanBeState<string>,
	TextColor: CanBeState<Enum.StudioStyleGuideColor>?,
	TextModifier: CanBeState<Enum.StudioStyleGuideModifier>?,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Text",
	"TextColor",
	"TextModifier",
}

local function Text(props: Text)
	local TextColor3 = Spring(Theme(props.TextColor or Enum.StudioStyleGuideColor.MainText, props.TextModifier), 40, 1)

	local Text = New("TextLabel")({

		Name = "Text",

		AutomaticSize = Enum.AutomaticSize.XY,

		BackgroundTransparency = 1,

		Text = props.Text,
		TextColor3 = TextColor3,
		TextSize = 18,
		FontFace = Font.fromEnum(Enum.Font.SourceSans),
	})

	return Fusion.Hydrate(Text)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Text
