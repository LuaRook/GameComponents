--[[
	Background creates a empty themed frame that covers the entire frame.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Enums = require(GameComponents.Enums)
local Util = require(GameComponents.Utility)

local Padding = require(Components.Decoration.Padding)

local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children
local Spring = Fusion.Spring

local Theme = Util.Theme
local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type ScrollingFrame = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	BackgroundColor: CanBeState<any>?,
	BackgroundModifier: CanBeState<any>?,

	Padding: CanBeState<number>?,
	ListPadding: CanBeState<UDim>?,

	SortOrder: CanBeState<Enum.StartOrder>?,
	
	HorizontalAlignment: CanBeState<Enum.HorizontalAlignment>?,
	VerticalAlignment: CanBeState<Enum.VerticalAlignment>?,
	SortDirection: CanBeState<Enum.SortDirection>?,
	StartCorner: CanBeState<Enum.SortDirection>?,

	NoList: CanBeState<boolean>?,
	NoPadding: CanBeState<boolean>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"BackgroundColor",
	"BackgroundModifier",
	"Padding",
	"ListPadding",
	"SortOrder",
	"HorizontalAlignment",
	"VerticalAlignment",
	"SortDirection",
	"FillDirection",
	"StartCorner",
	"NoList",
	"NoPadding",
}

return function(props: ScrollingFrame)
	local padding = props.Padding or 8
	local listPadding = props.ListPadding or 6

	local BackgroundColor = props.BackgroundColor or Enums.GuideColor.MainBackground
	local BackgroundModifier = props.BackgroundModifier

	local BackgroundColor3 = Spring(Theme(BackgroundColor, BackgroundModifier), 40, 1)

	local Background = New("ScrollingFrame")({

		Name = "ScrollFrame",

		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.fromScale(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,

		BackgroundColor3 = BackgroundColor3,

		ScrollBarImageColor3 = Theme(Enums.GuideColor.ScrollBar, Enums.GuideModifier.Hover),
		ScrollBarThickness = 6,
		VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,

		[Children] = {

			Computed(function()
				if unwrap(props.NoLayout) then
					return
				end

				return Padding({
					Padding = padding,
				})
			end, Fusion.cleanup),

			Computed(function()
				if unwrap(props.NoList) then
					return nil
				end

				return New("UIListLayout")({
					SortOrder = props.SortOrder or Enum.SortOrder.LayoutOrder,
					Padding = Computed(function()
						return UDim.new(0, unwrap(listPadding))
					end),

					SortDirection = props.SortDirection,
					HorizontalAlignment = props.HorizontalAlignment,
					VerticalAlignment = props.VerticalAlignment,
				})
			end, Fusion.cleanup),
		},
	})

	return Fusion.Hydrate(Background)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end
