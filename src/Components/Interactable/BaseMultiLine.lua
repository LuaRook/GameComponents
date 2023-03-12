--[[
	Provides a basic TextInput object with no special decoration.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local Background = require(Components.Decoration.Background)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Out = Fusion.Out
local Cleanup = Fusion.Cleanup
local Ref = Fusion.Ref

local Theme = Util.Theme
local unwrap = Util.unwrap
local Statify = Util.Statify
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type BaseTextInput = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Text: CanBeState<string>?,
	TextColor3: CanBeState<Color3>?,
	TextSize: CanBeState<number>?,
	Font: CanBeState<Enum.Font>?,

	Disabled: CanBeState<boolean>?,
	Focused: CanBeState<boolean>?, -- READ-ONLY

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Text",
	"PlaceholderText",
	"TextColor3",
	"PlaceholderColor3",
	"TextSize",
	"Font",
	"Disabled",
	"Focused",
}

local function BaseTextInput(props: BaseTextInput)
	local fontFace = props.Font or Enum.Font.SourceSans --props.FontFace or Font.fromEnum(Enum.Font.SourceSans)
	local textSize = props.TextSize or 18
	local disabled = props.Disabled
	local focused = Statify(props.Focused or false)
	local text = Statify(props.Text or "")

	local textBox = Value()

	local BaseTextInput = Background({

		Name = "BaseTextInputClip",

		Size = UDim2.fromOffset(300, 24),
		AutomaticSize = Enum.AutomaticSize.Y,

		BackgroundTransparency = 1,

		Padding = 2,

		[OnEvent("InputBegan")] = function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				unwrap(textBox):CaptureFocus()
			end
		end,

		[Children] = New("TextBox")({

			Name = "TextInputBase",

			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,

			BackgroundTransparency = 1,

			TextEditable = Computed(function()
				return not unwrap(disabled)
			end),

			Text = text,
			MultiLine = true,
			TextWrapped = true,
			PlaceholderText = props.PlaceholderText,
			TextColor3 = props.TextColor3 or Theme(Enum.StudioStyleGuideColor.MainText),
			PlaceholderColor3 = props.PlaceholderColor3 or Theme(Enum.StudioStyleGuideColor.DimmedText),
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			Font = fontFace,

			[OnEvent("Focused")] = function()
				focused:set(true)
			end,

			[OnEvent("FocusLost")] = function()
				focused:set(false)
			end,

			[Out("Text")] = text,
			[Ref] = textBox,

			[Cleanup] = Computed(function()
				-- Hacky solution to get the cursor position to update properly
				unwrap(text)
				local textBox = unwrap(textBox, false) :: TextBox
				if textBox == nil then
					return
				end

				textBox.CursorPosition -= 1
				textBox.CursorPosition += 1
			end),
		}),
	})

	return Fusion.Hydrate(BaseTextInput)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return BaseTextInput
