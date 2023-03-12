local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)
local Background = require(Components.Decoration.Background)
local Button = require(Components.Interactable.Button)
local Expandable = require(Components.Utility.Expandable)
local Text = require(Components.Display.Text)
local Image = require(Components.Display.Image)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Out = Fusion.Out
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children

local Theme = Util.Theme
local Statify = Util.Statify
local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type ExpandablePane = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	PaneText: CanBeState<string>?,
	TitleDecoration: (CanBeState<{ CanBeState<Instance> }> | CanBeState<Instance>)?,

	Expanded: CanBeState<boolean>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"PaneText",
	"TitleDecoration",
	"Expanded",
	Children,
}

local function ExpandablePane(props: ExpandablePane)
	local expanded = Statify(props.Expanded or false)
	local hovering = Value(false)
	local contentSize = Value(Vector2.zero)

	local ExpandablePane = Button({

		Name = "ExpandablePane",

		Size = Computed(function()
			local size = unwrap(contentSize) or Vector2.zero
			return UDim2.new(1, 0, 0, math.max(32, size.Y + 28))
		end),
		AutomaticSize = Enum.AutomaticSize.X,

		BackgroundColor = Enum.StudioStyleGuideColor.EmulatorDropDown,
		Text = "",
		FillDirection = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Top,

		Hovering = hovering,

		[Children] = {

			Background({
				Name = "Title",

				Position = UDim2.fromScale(0, 0),
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(1, 0, 0, 24),
				AutomaticSize = Enum.AutomaticSize.XY,

				BackgroundTransparency = 1,

				Padding = 2,

				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,

				[Children] = {

					Image({
						Name = "Arrow",

						Size = UDim2.fromOffset(12, 12),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),

						Image = "rbxasset://textures/StudioSharedUI/arrowSpritesheet.png",
						ImageRectSize = Vector2.new(12, 12),
						ImageRectOffset = Computed(function()
							return if unwrap(expanded) then Vector2.new(24, 0) else Vector2.new(12, 0)
						end),
						ImageColor3 = Computed(function()
							return if unwrap(Theme()).Name == "Dark"
								then Color3.fromRGB(225, 225, 225)
								else Color3.fromRGB(29, 29, 29)
						end),
					}),

					Text({
						Text = props.PaneText,
						FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
					}),

					props.TitleDecoration,
				},
			}),

			Expandable({
				Name = "Container",

				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 1, 0),

				Expanded = expanded,

				[Out("AbsoluteSize")] = contentSize,

				[Children] = {
					New("UIPadding")({
						PaddingBottom = UDim.new(0, 12),
					}),

					Background({

						[Children] = {
							New("UICorner")({
								CornerRadius = UDim.new(0, 3),
							}),

							props[Children],
						},

						[OnEvent("MouseMoved")] = function()
							if unwrap(expanded) then
								hovering:set(false)
							end
						end,

						[OnEvent("MouseLeave")] = function()
							if unwrap(expanded) then
								hovering:set(true)
							end
						end,
					}),
				},
			}),
		},

		[OnEvent("Activated")] = function()
			if unwrap(hovering) == false then
				return
			end
			expanded:set(not unwrap(expanded))
		end,
	})

	return Fusion.Hydrate(ExpandablePane)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return ExpandablePane
