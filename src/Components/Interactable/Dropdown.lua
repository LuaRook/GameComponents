local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Enums = require(GameComponents.Enums)
local Util = require(GameComponents.Utility)

local Expandable = require(Components.Utility.Expandable)
local Teleporter = require(Components.Utility.Teleporter)
local Background = require(Components.Decoration.Background)
local ScrollingFrame = require(Components.Decoration.ScrollingFrame)
local Border = require(Components.Decoration.Border)
local Button = require(Components.Interactable.Button)
local Image = require(Components.Display.Image)
local Padding = require(Components.Decoration.Padding)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local ForPairs = Fusion.ForPairs

local Theme = Util.Theme
local unwrap = Util.unwrap
local Statify = Util.Statify
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Dropdown = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	DropdownItems: CanBeState<{ CanBeState<string> }>,
	Selected: CanBeState<string>?,

	MaxItems: CanBeState<number>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"DropdownItems",
	"Selected",
	"MaxItems",
}

return function(props: Dropdown)
	local expanded = Value(false)
	local dropdownItems = props.DropdownItems
	local selected = Statify(props.Selected or "")
	local maxItems = props.MaxItems or 5
	local itemSize = 24

	local Dropdown = Button({

		Size = UDim2.fromOffset(200, 32),

		BackgroundColor = Enums.GuideColor.EmulatorDropDown,

		Text = Computed(function()
			return unwrap(selected) or ""
		end),

		[OnEvent("Activated")] = function()
			expanded:set(not unwrap(expanded))
		end,

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

			Teleporter({
				[Children] = Expandable({
					Name = "DropdownMenu",

					Position = UDim2.fromOffset(0, 38),

					Expanded = expanded,

					[Children] = {

						Padding({
							Padding = 1,
							PaddingBottom = UDim.new(0, 2),
						}),

						New("UIListLayout")({}),

						Background({

							Size = Computed(function()
								local y = math.min(#unwrap(dropdownItems), unwrap(maxItems)) * (unwrap(itemSize) + 2)
								return UDim2.new(1, 0, 0, y + 8)
							end),

							NoPadding = true,
							NoList = true,

							[Children] = {

								New("UICorner")({
									CornerRadius = UDim.new(0, 3),
								}),

								Border({}),

								Padding({
									Padding = 0,
									PaddingLeft = UDim.new(0, 2),
									PaddingRight = UDim.new(0, 2),
								}),

								ScrollingFrame({

									Position = UDim2.fromOffset(0, 0),
									Size = UDim2.fromScale(1, 1),
									CanvasSize = Computed(function()
										local y = #unwrap(dropdownItems) * (unwrap(itemSize) + 2)
										return UDim2.new(0, 0, 0, y + 8)
									end),
									AutomaticCanvasSize = Enum.AutomaticSize.None,

									Padding = 4,
									ListPadding = 2,

									BackgroundTransparency = 1,

									[Children] = {

										ForPairs(dropdownItems, function(key: number, value: string)
											return key,
												Button({
													Name = key,
													LayoutOrder = key,

													Size = Computed(function()
														return UDim2.new(1, 0, 0, unwrap(itemSize))
													end),
													AutomaticSize = Enum.AutomaticSize.X,

													Text = value,
													BackgroundColor = Enums.GuideColor.EmulatorDropDown,
													BorderColor = Enums.GuideColor.EmulatorDropDown,

													[OnEvent("Activated")] = function()
														expanded:set(false)
														selected:set(value)
													end,
												})
										end, Fusion.cleanup),
									},
								}),
							},
						}),
					},
				}),
			}),
		},
	})

	return Fusion.Hydrate(Dropdown)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

