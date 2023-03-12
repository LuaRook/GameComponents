local Packages = script.Parent.Parent.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local New = Fusion.New

local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Image = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	Image: CanBeState<string>,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {}

local function Image(props: Image)
	local Image = New("ImageLabel")({

		Name = "Image",

		Size = UDim2.fromOffset(64, 64),

		BackgroundTransparency = 1,
	})

	return Fusion.Hydrate(Image)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Image
