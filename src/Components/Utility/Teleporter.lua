--[[
	Teleporter is a special utility component that is used to bring nested components
	to the top of the UI so that it will be over all the other UI.
	This can be used for Tooltips, Dropdowns and other UI that has to overlay.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local New = Fusion.New
local Value = Fusion.Value
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Observer = Fusion.Observer
local Hydrate = Fusion.Hydrate
local Cleanup = Fusion.Cleanup
local Out = Fusion.Out

local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type Teleporter = {
	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	Children,
}

local function Teleporter(props: Teleporter)
	local refLayerCollector = props.LayerCollector or Value()

	local realSize = Value()
	local realPosition = Value()
	local realRotation = Value()

	local parent = Value()
	local update = Value(math.random())
	local highestLayerCollector = Computed(function()
		local currentParent: Instance = unwrap(parent)
		unwrap(update)

		if currentParent then
			local layerCollector = currentParent:FindFirstAncestorWhichIsA("LayerCollector")

			if layerCollector then
				refLayerCollector:set(layerCollector)
				return layerCollector
			end
		end

		refLayerCollector:set(nil)
		return nil
	end, Fusion.doNothing)

	local observer = Observer(parent):onChange(function()
		local currentParent = unwrap(parent)

		if currentParent then
			Hydrate(currentParent)({

				[Cleanup] = currentParent.Changed:Connect(function(propertyName)
					if propertyName == "AbsoluteSize" then
						realSize:set(currentParent.AbsoluteSize)
					elseif propertyName == "AbsolutePosition" then
						realPosition:set(currentParent.AbsolutePosition)
					elseif propertyName == "AbsoluteRotation" then
						realRotation:set(currentParent.AbsoluteRotation)
					end
				end),
			})
		end
	end)

	local BaseClone = New("Folder")({

		Name = "TopLayerPortal",
		Parent = highestLayerCollector,

		[Children] = New("Frame")({

			Name = "Portal:TopLayer",

			Size = Computed(function()
				local size = unwrap(realSize)
				if size == nil then
					return UDim2.new()
				end
				return UDim2.fromOffset(size.X, size.Y)
			end),
			Position = Computed(function()
				local position = unwrap(realPosition)
				if position == nil then
					return UDim2.new()
				end
				return UDim2.fromOffset(position.X, position.Y)
			end),
			Rotation = realRotation,

			BackgroundTransparency = 1,

			[Children] = props[Children],
		}),

		[Cleanup] = observer,
	})

	local TopLayer = New("Configuration")({

		Name = "Portal:TopLayer",

		[OnEvent("AncestryChanged")] = function()
			update:set(math.random())
		end,
		[Out("Parent")] = parent,

		[Cleanup] = BaseClone,
	})

	return Hydrate(TopLayer)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return Teleporter
