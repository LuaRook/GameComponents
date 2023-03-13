local Packages = script.Parent.Parent.Parent.Parent
local GameComponents = script.Parent.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local New = Fusion.New

local stripProps = Util.stripProps
local unwrap = Util.unwrap

type CanBeState<T> = Fusion.CanBeState<T>
export type Grid = {
	CellPadding: CanBeState<UDim2>?,
	CellSize: CanBeState<UDim2>?,

	HorizontalAlignment: CanBeState<Enum.HorizontalAlignment>?,
	VerticalAlignment: CanBeState<Enum.VerticalAlignment>?,

	FillDirection: CanBeState<Enum.FillDirection>?,
	StartCorner: CanBeState<Enum.StartCorner>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"CellPadding",
	"CellSize",
	"HorizontalAlignment",
	"VerticalAlignment",
	"FillDirection",
	"StartCorner",
}

return function(props: GridList)
	local cellPadding = unwrap(props.CellPadding) or UDim2.fromOffset(0, 0)

	local Grid = New("UIGridLayout")({
		CellPadding = cellPadding,
		CellSize = props.cellSize,

		HorizontalAlignment = props.HorizontalAlignment,
		VerticalAlignment = props.VerticalAlignment,

		FillDirection = props.FillDirection,
		StartCorner = props.StartCorner,
	})

	return Fusion.Hydrate(Grid)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end
