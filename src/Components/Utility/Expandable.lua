--[[
	Expandables are used to create UI which can expand and retract. This is
	useful for stuff like dropdowns and expandable panes, which will use a
	animation to show that they are expanding so the user can see the full
	contents.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local Out = Fusion.Out
local Spring = Fusion.Spring

local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Expandable = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Expanded: CanBeState<boolean>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Expanded",
	Children,
}

return function(props: Expandable)
	local expanded = props.Expanded

	local contentSize = Value(Vector2.zero)
	local snappedSize = Computed(function()
		if unwrap(expanded) then
			local contentSize = unwrap(contentSize) or Vector2.zero

			return UDim2.new(1, 0, 0, contentSize.Y)
		else
			return UDim2.new(1, 0, 0, 0)
		end
	end)
	local currentSize = Spring(snappedSize, 40, 1)

	local Expandable = New("Frame")({
		Name = "ExpandableContainer",

		Size = currentSize,

		BackgroundTransparency = 1,

		ClipsDescendants = true,

		[Children] = New("Frame")({
			Name = "Container",

			Size = UDim2.new(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,

			BackgroundTransparency = 1,

			[Out("AbsoluteSize")] = contentSize,
			[Children] = props[Children],
		}),
	})

	return Fusion.Hydrate(Expandable)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end
