local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local Image = require(Components.Display.Image)

local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local Theme = Util.Theme
local Statify = Util.Statify
local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Checkbox = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Checked: CanBeState<boolean>?,
	Disabled: CanBeState<boolean>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Checked",
	"Disabled",
	Children,
}

return function(props: Checkbox)
	local disabled = props.Disabled
	local checked = Statify(props.Checked)

	local Checkbox = New("TextButton")({

		Name = "Checkbox",

		AutomaticSize = Enum.AutomaticSize.XY,

		BackgroundTransparency = 1,

		Active = Computed(function()
			return unwrap(disabled) ~= true
		end),

		[Children] = {

			New("Frame")({

				Size = UDim2.new(0, -24, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,

				BackgroundTransparency = 1,

				[Children] = {

					New("UIListLayout")({
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 4),
					}),

					New("UIPadding")({
						PaddingTop = UDim.new(0, 0),
						PaddingBottom = UDim.new(0, 0),
						PaddingRight = UDim.new(0, 24),
						PaddingLeft = UDim.new(0, 0),
					}),

					props[Children],
				},
			}),

			Image({

				Position = UDim2.fromScale(1, 0.5),
				Size = UDim2.fromOffset(16, 16),
				AnchorPoint = Vector2.new(1, 0.5),

				Image = Computed(function()
					local imageToGet = "rbxasset://textures/DeveloperFramework/checkbox_%s%s_%s.png"
					local checked = unwrap(checked)
					local disabled = unwrap(disabled)
					local currentTheme = unwrap(Theme())

					local result = string.format(
						imageToGet,
						if checked ~= false
								and checked ~= true
								and disabled == false
							then "indeterminate"
							elseif checked == true then "checked"
							else "unchecked",
						if disabled then "_disabled" else "",
						currentTheme.Name:lower()
					)

					return result
				end),
			}),
		},

		[OnEvent("Activated")] = function()
			checked:set(not unwrap(checked))
		end,
	})

	return Fusion.Hydrate(Checkbox)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end