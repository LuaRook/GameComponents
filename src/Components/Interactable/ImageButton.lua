--[[
	Image;
	
]]

local Packages = script.Parent.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)

local New = Fusion.New

type CanBeState<T> = Fusion.CanBeState<T>
export type Image = {
	Image: CanBeState<string>,

	[any]: any,
}

return function(props: Image)
	local Image = New("ImageButton")({

		Name = "ImageButton",

		Size = UDim2.fromOffset(32, 32),

		BackgroundTransparency = 1,
	})

	return Fusion.Hydrate(Image)(props)
end
