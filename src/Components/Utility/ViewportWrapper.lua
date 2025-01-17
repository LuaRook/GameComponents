--[[
	ViewportWrappers are used to wrap it's given UI element inside the Viewport
	to make sure that something stays visible.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local unwrap = Util.unwrap
local stripProps = Util.stripProps

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate
local Cleanup = Fusion.Cleanup
local Out = Fusion.Out

local COMPONENT_ONLY_PROPERTIES = {
	Children,
}

export type ViewportWrapper = {

	[any]: any,
}

return function(props: ViewportWrapper)
	local parent = Value()
	local update = Value()
	local layerCollector = Computed(function()
		local currentParent: Instance = unwrap(parent)
		unwrap(update)

		if currentParent then
			local layerCollector = currentParent:FindFirstAncestorWhichIsA("LayerCollector")
			if layerCollector then
				return layerCollector
			end
		end

		return nil
	end, Fusion.doNothing)

	local absolutePosition = Value(Vector2.zero)
	local absoluteSize = Value(Vector2.zero)
	local viewportSize = Computed(function()
		local layer = unwrap(layerCollector)
		if layer then
			return layer.AbsoluteSize
		end

		return Vector2.zero
	end, Fusion.doNothing)

	local previous = UDim2.new()
	local adjustedPosition = Computed(function()
		local currentPosition = unwrap(absolutePosition)
		local currentSize = unwrap(absoluteSize)
		local currentViewportSize = unwrap(viewportSize)
		local parent = unwrap(parent)

		if not (currentPosition and currentSize and currentViewportSize and parent) then
			return previous
		end

		currentPosition = Vector2.new(
			math.clamp(currentPosition.X, 0, currentViewportSize.X),
			math.clamp(currentPosition.Y, 0, currentViewportSize.Y)
		)
		local endPosition = Vector2.new(
			math.clamp(currentPosition.X + currentSize.X, 0, currentViewportSize.X),
			math.clamp(currentPosition.Y + currentSize.Y, 0, currentViewportSize.Y)
		)

		local resultPosition = endPosition - currentSize - unwrap(absolutePosition, false)
		local result = UDim2.fromOffset(resultPosition.X, resultPosition.Y)

		previous = result
		return result
	end, Fusion.doNothing)

	local ViewportWrapper = New("Frame")({

		Name = "ViewportWrapper",

		BackgroundTransparency = 1,

		[OnEvent("AncestryChanged")] = function()
			update:set(os.clock())
		end,

		[Out("Parent")] = parent,
		[Out("AbsolutePosition")] = absolutePosition,

		[Children] = New("Frame")({

			Name = "ViewportWrapperContainer",

			Position = adjustedPosition,
			AutomaticSize = Enum.AutomaticSize.XY,

			BackgroundTransparency = 1,

			[Out("AbsoluteSize")] = absoluteSize,
			[Children] = props[Children],
		}),
	})

	return Hydrate(ViewportWrapper)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end
