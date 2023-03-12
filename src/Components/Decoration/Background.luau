--[[
	Background creates a empty themed frame that covers the entire frame.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
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
export type Background = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	BackgroundColor: CanBeState<Enum.StudioStyleGuideColor>?,
	BackgroundModifier: CanBeState<Enum.StudioStyleGuideModifier>?,

	Padding: CanBeState<number>?,
	ListPadding: CanBeState<UDim>?,

	HorizontalAlignment: CanBeState<Enum.HorizontalAlignment>?,
	VerticalAlignment: CanBeState<Enum.VerticalAlignment>?,
	SortDirection: CanBeState<Enum.SortDirection>?,
	FillDirection: CanBeState<Enum.FillDirection>?,

	NoList: CanBeState<boolean>?,
	NoPadding: CanBeState<boolean>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"BackgroundColor",
	"BackgroundModifier",
	"Padding",
	"ListPadding",
	"HorizontalAlignment",
	"VerticalAlignment",
	"SortDirection",
	"FillDirection",
	"NoList",
	"NoPadding",
}

local function Background(props: Background)
	local padding = props.Padding or 8
	local listPadding = props.ListPadding or 6

	local BackgroundColor = props.BackgroundColor or Enum.StudioStyleGuideColor.MainBackground
	local BackgroundModifier = props.BackgroundModifier

	local BackgroundColor3 = Spring(Theme(BackgroundColor, BackgroundModifier), 40, 1)

	local Background = New("Frame")({

		Name = "Background",

		Size = UDim2.fromScale(1, 1),

		BackgroundColor3 = BackgroundColor3,

		[Children] = {

			Computed(function()
				if unwrap(props.NoPadding) then
					return
				end

				return Padding({
					Padding = padding,
				})
			end, Fusion.cleanup),

			Computed(function()
				if unwrap(props.NoList) then
					return nil
				else
					return New("UIListLayout")({
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = Computed(function()
							return UDim.new(0, unwrap(listPadding))
						end),

						SortDirection = props.SortDirection,
						HorizontalAlignment = props.HorizontalAlignment,
						VerticalAlignment = props.VerticalAlignment,
						FillDirection = props.FillDirection,
					})
				end
			end, Fusion.cleanup),
		},
	})

	return Fusion.Hydrate(Background)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Background
