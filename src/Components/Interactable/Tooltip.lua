local Packages = script.Parent.Parent.Parent.Parent
local GameComponents = script.Parent.Parent.Parent
local Components = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local Padding = require(Components.Decoration.Padding)
local Shadow = require(Components.Decoration.Shadow)
local Teleporter = require(Components.Utility.Teleporter)
local ViewportWrapper = require(Components.Utility.ViewportWrapper)

local New = Fusion.New
local Out = Fusion.Out
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Tooltip = {
	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	Children,
}

return function(props: Tooltip)
	local visible = Value(false)
	local currentMousePosition = Value(Vector2.zero)
	local absolutePosition = Value(Vector2.zero)

	local Tooltip = Teleporter({
		[Children] = New("Frame")({
			Name = "Input",

			Size = UDim2.fromScale(1, 1),

			BackgroundTransparency = 1,

			[OnEvent("MouseMoved")] = function(x, y)
				visible:set(true)
				currentMousePosition:set(Vector2.new(x, y))
			end,
			[OnEvent("MouseLeave")] = function()
				visible:set(false)
			end,

			[Out("AbsolutePosition")] = absolutePosition,

			[Children] = ViewportWrapper({
				Visible = visible,
				Position = Computed(function()
					local mousePosition = unwrap(currentMousePosition) - (unwrap(absolutePosition) or Vector2.zero)
					return UDim2.fromOffset(mousePosition.X + 12, mousePosition.Y + 8)
				end),

				[Children] = New("Frame")({
					Name = "ToolTip",

					AutomaticSize = Enum.AutomaticSize.XY,

					BackgroundTransparency = 1,

					[Children] = props[Children],
				}),
			}),
		}),
	})
	return Fusion.Hydrate(Tooltip)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end
