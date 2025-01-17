--[[
	Lists are special objects used to stream a static set of objects into a
	scrollingframe to grant more ideal performance with extremely large lists.
	
	Use the StreamIn function to Stream In objects
	Use the ItemSize state to determine how big each item is.
	Use MaxItems to limit the maximum number of items
	Use MinItems to limit the minimum number of items
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local Components = script.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local ScrollingFrame = require(Components.Decoration.ScrollingFrame)

local unwrap = Util.unwrap
local stripProps = Util.stripProps

local Value = Fusion.Value
local Out = Fusion.Out
local Computed = Fusion.Computed
local Children = Fusion.Children

local COMPONENT_ONLY_PROPERTIES = {
	"ItemSize",
	"StreamIn",
	"MaxItems",
	"MinItems",
}

type CanBeState<T> = Fusion.CanBeState<T>
type Value<T> = Fusion.Value<T>
export type List = {
	ItemSize: Fusion.CanBeState<number>,

	StreamIn: (index: Value<number>) -> Instance,
	MaxItems: CanBeState<number>?,
	MinItems: CanBeState<number>?,

	[any]: any,
}

local function List(props: List)
	local itemSize = props.ItemSize
	local streamIn = props.StreamIn
	local maxItems = props.MaxItems or math.huge
	local minItems = props.MinItems or 0

	local streamed = {}
	local streamedStates = {}

	local absoluteSize = Value(Vector2.new())
	local absoluteCanvasSize = Value(Vector2.new())
	local canvasPosition = Value(Vector2.new())

	local itemsIndexes = Computed(function()
		local currentAbsoluteSize = unwrap(absoluteSize)
		local currentAbsoluteCanvasSize = unwrap(absoluteCanvasSize)
		local currentCanvasPosition = unwrap(canvasPosition)
		local currentItemSize = unwrap(itemSize)
		local minItems = unwrap(minItems)
		local maxItems = unwrap(maxItems)

		if not (currentAbsoluteSize and currentAbsoluteCanvasSize and currentCanvasPosition) then
			return { 1, 2 }
		end

		--local totalItemsToRender = math.ceil(currentAbsoluteSize.Y / currentItemSize + 2)

		-- Determines the indexes to render it for.
		local areaMin, areaMax = currentCanvasPosition, currentCanvasPosition + currentAbsoluteSize

		local minIndex = math.clamp(math.floor(areaMin.Y / currentItemSize) - 2, minItems, maxItems)
		local maxIndex = math.clamp(math.ceil(areaMax.Y / currentItemSize) + 2, minItems, maxItems)

		--print(minIndex, maxIndex)

		return { minIndex, maxIndex }
	end)
	local totalItems = Computed(function()
		local currentAbsoluteSize = unwrap(absoluteSize) or Vector2.zero
		local currentItemSize = unwrap(itemSize)

		return currentAbsoluteSize.Y / currentItemSize + 4
	end)

	local items = Computed(function()
		local itemIndexes = unwrap(itemsIndexes)
		local itemsToRender = unwrap(totalItems)
		local minIndex = itemIndexes[1] - 1

		for i = 1, math.max(#streamed, itemsToRender) do
			if not streamed[i] then
				local index = Value(minIndex + i)

				streamedStates[i] = index
				streamed[i] = streamIn(index)
			elseif streamed[i] and i > itemsToRender then
				streamedStates[i] = nil

				streamed[i]:Destroy()
				streamed[i] = nil
			else
				streamedStates[i]:set(minIndex + i)
			end
		end

		return streamed
	end, Fusion.cleanup)

	local List = ScrollingFrame({

		ListPadding = 0,

		CanvasSize = props.CanvasSize or Computed(function()
			if unwrap(maxItems) == math.huge then
				local itemIndexes = unwrap(itemsIndexes)
				local canvasSize = unwrap(absoluteCanvasSize) or Vector2.new()

				return UDim2.fromOffset(0, math.max((itemIndexes[2] + 2) * unwrap(itemSize), canvasSize.Y))
			else
				return UDim2.fromOffset(0, unwrap(maxItems) * unwrap(itemSize))
			end
		end),
		AutomaticCanvasSize = Enum.AutomaticSize.X,

		[Out("AbsoluteSize")] = absoluteSize,
		[Out("AbsoluteCanvasSize")] = absoluteCanvasSize,
		[Out("CanvasPosition")] = canvasPosition,

		[Children] = items,
	})

	return Fusion.Hydrate(List)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return List
