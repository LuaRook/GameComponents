local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local Background = require(Components.Decoration.Background)
local Border = require(Components.Decoration.Border)
local Text = require(Components.Display.Text)

local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children

local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Pane = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	PaneText: CanBeState<string>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"PaneText",
	Children,
}
local CORNER_RADIUS = 3

local function Pane(props: Pane)
	local Pane = Background({

		Size = UDim2.new(1, 0, 0, 32),
		AutomaticSize = Enum.AutomaticSize.Y,

		NoList = true,

		[Children] = {

			New("UICorner")({
				CornerRadius = UDim.new(0, CORNER_RADIUS),
			}),

			Border({}),

			Background({
				Name = "Name",

				Position = UDim2.fromScale(0, 0),
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.new(),
				AutomaticSize = Enum.AutomaticSize.XY,

				Padding = 2,

				Visible = Computed(function()
					return not not props.PaneText
				end),

				[Children] = Text({
					Text = props.PaneText,
					TextColor = Enum.StudioStyleGuideColor.DimmedText,

					TextSize = 14,
				}),
			}),

			Background({
				Name = "Container",

				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,

				Padding = 2,

				[Children] = props[Children],
			}),
		},
	})

	return Fusion.Hydrate(Pane)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Pane
