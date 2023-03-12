--[[
	Shadows are used to give the user a sense of depth in a place where there
	otherwise wouldn't be any, like user interface. This is useful to display
	layered user interface, like tooltips which has to display over other UI
	while still standing out and not blending completely into the plugin's actual
	UI.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local Image = require(Components.Display.Image)
local Padding = require(Components.Decoration.Padding)

local Children = Fusion.Children

local Theme = Util.Theme
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Shadow = {
	Position: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Transparency: CanBeState<number>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"Transparency",
}

local function Shadow(props: Shadow)
	local Transparency = props.Transparency

	local Shadow = Image({

		Name = "Shadow",

		Size = UDim2.new(),
		AutomaticSize = Enum.AutomaticSize.XY,

		Image = "rbxasset://textures/StudioSharedUI/dropShadow.png",
		ImageColor3 = Theme(Enum.StudioStyleGuideColor.Midlight),
		ImageTransparency = Transparency,

		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 8, 8),
		SliceScale = 0.5,

		[Children] = Padding({
			Padding = 3,
		}),
	})

	return Fusion.Hydrate(Shadow)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Shadow
