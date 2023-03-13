--[[
	Provides a basic TextInput object with no special decoration.
	
]]
local TextService = game:GetService("TextService")

local Packages = script.Parent.Parent.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Enums = require(GameComponents.Enums)
local Util = require(GameComponents.Utility)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Out = Fusion.Out
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

	FocusLost: CanBeState<(enterPressed: boolean) -> ()>?,

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
	"FocusLost",
}

return function(props: BaseTextInput)
	local fontFace = props.Font or Enum.Font.SourceSans
	local textSize = props.TextSize or 18
	local disabled = props.Disabled
	local focused = Statify(props.Focused or false)
	local text = Statify(props.Text or "")

	local textBox = Value()
	local cursorPosition = Value(0)
	local textBoxClipAbsoluteSize = Value(Vector2.zero)

	local textOffset = Computed(function()
		local textBox: TextBox = unwrap(textBox)

		if not textBox then
			return { Offset = UDim2.new(), Size = UDim2.fromScale(1, 1) }
		end

		local position = unwrap(cursorPosition) or 0
		local text = unwrap(text) or ""

		local textBehindCursor = string.sub(text, 1, position - 1)

		local font = unwrap(fontFace) or Enum.Font.SourceSans
		local textSize = unwrap(textSize) or 18
		local cursorOffset = TextService:GetTextSize(textBehindCursor, textSize, font, Vector2.zero).X
		local textWidth = TextService:GetTextSize(text, textSize, font, Vector2.zero).X

		local textBoxClipAbsoluteSize = unwrap(textBoxClipAbsoluteSize) or Vector2.zero
		local previousTextBoxOffset = textBox.Position
		local textBoxOffset = math.min(previousTextBoxOffset.X.Offset, 0)
		local textBoxWidth = textBoxClipAbsoluteSize.X
		local visibleStart = -textBoxOffset
		local visibleEnd = visibleStart + textBoxWidth

		if cursorOffset <= visibleStart then
			-- If the cursor is before the leading edge of the clip area, offset
			-- the TextBox so the cursor is at the leading edge.
			textBoxOffset = -cursorOffset
		elseif cursorOffset >= visibleEnd then
			-- If the cursor is after the trailing edge of the clip area, offset
			-- the TextBox so the cursor is at the trailing edge.
			textBoxOffset = -(cursorOffset - textBoxWidth)
		end

		local overflow = math.max(textWidth - textBoxWidth, 0)
		textBoxOffset = math.max(textBoxOffset, -overflow)
		if cursorOffset == textBoxWidth - textBoxOffset then
			textBoxOffset -= 1
		end

		return {
			Offset = UDim2.new(0, textBoxOffset, 0.5, 0),
			Size = UDim2.new(0, math.max(textWidth, textBoxWidth), 0, 0),
		}
	end)

	local BaseTextInput = New("Frame")({

		Name = "BaseTextInputClip",

		Size = UDim2.fromOffset(300, 24),

		ClipsDescendants = true,

		BackgroundTransparency = 1,

		[OnEvent("InputBegan")] = function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				unwrap(textBox):CaptureFocus()
			end
		end,

		[Out("AbsoluteSize")] = textBoxClipAbsoluteSize,
		[Children] = New("TextBox")({

			Name = "TextInputBase",

			Size = Computed(function()
				return unwrap(textOffset).Size
			end),
			Position = Computed(function()
				return unwrap(textOffset).Offset
			end),

			BackgroundTransparency = 1,

			TextEditable = Computed(function()
				return not unwrap(disabled)
			end),

			Text = text,
			PlaceholderText = props.PlaceholderText,
			TextColor3 = props.TextColor3 or Theme(Enums.GuideColor.MainText),
			PlaceholderColor3 = props.PlaceholderColor3 or Theme(Enums.GuideColor.DimmedText),
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

			[OnEvent("FocusLost")] = props.FocusLost,

			[Out("Text")] = text,
			[Out("CursorPosition")] = cursorPosition,
			[Ref] = textBox,
		}),
	})

	return Fusion.Hydrate(BaseTextInput)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end
