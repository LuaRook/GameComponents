local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Enums = require(GameComponents.Enums)
local Util = require(GameComponents.Utility)

local Text = require(Components.Display.Text)
local Border = require(Components.Decoration.Border)
local Padding = require(Components.Decoration.Padding)

local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Spring = Fusion.Spring

local Theme = Util.Theme
local Statify = Util.Statify
local unwrap = Util.unwrap
local stripProps = Util.stripProps
local guideState = Util.guideState
local mapGuideModifier = Util.mapGuideColor

type CanBeState<T> = Fusion.CanBeState<T>
export type Button = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Text: CanBeState<string>?,

	BackgroundColor: CanBeState<any>?,
	BackgroundModifier: CanBeState<any>?,
	BorderColor: CanBeState<any>?,
	BorderModifier: CanBeState<any>?,
	TextColor: CanBeState<any>?,
	TextModifier: CanBeState<any>?,

	Disabled: CanBeState<boolean>?,
	Selected: CanBeState<boolean>?,
	Pressed: CanBeState<boolean>?,
	Hovering: CanBeState<boolean>?,

	FillDirection: CanBeState<Enum.FillDirection>?,
	VerticalAlignment: CanBeState<Enum.VerticalAlignment>?,
	HorizontalAlignment: CanBeState<Enum.HorizontalAlignment>?,

	NoText: CanBeState<boolean>?,
	NoPadding: CanBeState<boolean>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Text",
	"BackgroundColor",
	"BackgroundModifier",
	"BorderColor",
	"BorderModifier",
	"TextColor",
	"TextModifier",
	"Disabled",
	"Selected",
	"Pressed",
	"Hovering",
	"FillDirection",
	"VerticalAlignment",
	"HorizontalAlignment",
	"NoText",
	"NoPadding",
	Children,
}
local CORNER_RADIUS = 3

local function Button(props: Button)
	local Disabled = props.Disabled or false
	local Selected = props.Selected or false
	local Pressed = Statify(props.Pressed or false)
	local Hovering = Statify(props.Hovering)

	local GeneralModifier = guideState(Selected, Disabled, Pressed, Hovering)

	local BackgroundModifier = props.BackgroundModifier or GeneralModifier
	local BackgroundColor = Spring(
		Theme(props.BackgroundColor or mapGuideModifier(BackgroundModifier, {
			[Enums.GuideModifier.Default] = Enums.GuideColor.Button,
			[Enums.GuideModifier.Disabled] = Enums.GuideColor.InputFieldBackground,
		}), BackgroundModifier),
		120,
		1
	)
	local BorderModifier = props.BorderModifier or GeneralModifier
	local BorderColor = Spring(
		Theme(props.BorderColor or mapGuideModifier(BorderModifier, {
			[Enums.GuideModifier.Default] = Enums.GuideColor.Border,
			[Enums.GuideModifier.Selected] = Enums.GuideColor.MainButton,
			[Enums.GuideModifier.Disabled] = Enums.GuideColor.Button,
		}), BorderModifier),
		80,
		1
	)
	local TextModifier = props.TextModifier or GeneralModifier
	local TextColor = Spring(Theme(props.TextColor or Enums.GuideColor.ButtonText, TextModifier), 100, 1)

	local Button = New("TextButton")({

		Name = "Button",

		AutomaticSize = Enum.AutomaticSize.XY,

		Active = Computed(function()
			return not unwrap(Disabled)
		end),

		BackgroundColor3 = BackgroundColor,

		TextTransparency = 1,

		[OnEvent("MouseButton1Down")] = function()
			Pressed:set(true)
		end,
		[OnEvent("MouseButton1Up")] = function()
			Pressed:set(false)
		end,
		[OnEvent("MouseLeave")] = function()
			Pressed:set(false)
			Hovering:set(false)
		end,
		[OnEvent("MouseEnter")] = function()
			Hovering:set(true)
		end,

		[Children] = {

			Computed(function()
				if unwrap(props.NoPadding) then
					return nil
				end
				return Padding({
					Padding = 8,
					PaddingTop = UDim.new(0, 4),
					PaddingBottom = UDim.new(0, 4),
				})
			end, Fusion.cleanup),

			Border({
				Color = BorderColor,
			}),

			Text({

				TextColor3 = TextColor,

				Text = props.Text,
				TextSize = props.TextSize,

				Visible = Computed(function()
					return not unwrap(props.NoText)
				end),

				LayoutOrder = 100,
			}),

			New("UIListLayout")({
				FillDirection = props.FillDirection or Enum.FillDirection.Horizontal,
				VerticalAlignment = props.VerticalAlignment or Enum.VerticalAlignment.Center,
				HorizontalAlignment = props.HorizontalAlignment,
				SortOrder = Enum.SortOrder.LayoutOrder,

				Padding = UDim.new(0, 6),
			}),

			New("UICorner")({
				CornerRadius = UDim.new(0, CORNER_RADIUS),
			}),

			props[Children],
		},
	})

	return Fusion.Hydrate(Button)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Button
