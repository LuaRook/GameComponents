--[[
	AssetViewports are used to display objects or assets inside UI.
	
]]

local Packages = script.Parent.Parent.Parent.Parent
local GameComponents = script.Parent.Parent.Parent
local Components = script.Parent.Parent

local Fusion = require(Packages.Fusion)
local Util = require(GameComponents.Utility)

local Background = require(Components.Decoration.Background)
local Border = require(Components.Decoration.Border)

local New = Fusion.New
local Computed = Fusion.Computed
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent
local Cleanup = Fusion.Cleanup

local Statify = Util.Statify
local getIdealCameraCFrame = Util.getIdealCameraCFrame
local unwrap = Util.unwrap
local stripProps = Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type AssetViewport = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,

	CFrame: CanBeState<CFrame>?,
	ObjectCFrame: CanBeState<CFrame>?,
	Focus: CanBeState<CFrame>?,
	Draggable: CanBeState<boolean>?,
	DoNotOverwriteCFrame: CanBeState<boolean>?,

	Object: CanBeState<Instance>?,

	[any]: any,
}

local COMPONENT_ONLY_PROPERTIES = {
	"CFrame",
	"ObjectCFrame",
	"Focus",
	"Draggable",
	"Object",
	"DoNotOverwriteCFrame",
}

local function AssetViewport(props: AssetViewport)
	local noOverwrite = props.DoNotOverwriteCFrame
	local objectCFrame = props.ObjectCFrame or CFrame.new()
	local cframe = Statify(props.CFrame)
	local object = Computed(function()
		local object: Instance = unwrap(props.Object)

		if not object then
			return
		end

		object = object:Clone()

		-- Overwrites the CFrame with a "ideal" one.
		if not unwrap(noOverwrite) then
			cframe:set(getIdealCameraCFrame(object, 30))
		end

		return object
	end, Fusion.cleanup)
	local focus = props.Focus or CFrame.new()
	local isOrbitDragging = false
	local draggable = if props.Draggable ~= nil then props.Draggable else true
	local isShiftDown = false

	local changeObjectCFrame = Computed(function()
		local object = unwrap(object)

		if object == nil then
			return
		end

		if object:IsA("Model") then
			object:PivotTo(unwrap(objectCFrame))
		elseif object:IsA("BasePart") then
			object.CFrame = unwrap(objectCFrame)
		end
	end)

	local Camera = New("Camera")({
		CFrame = cframe,
		Focus = focus,

		FieldOfView = 30,
	})

	local function zoom(zoomFactor)
		local current = unwrap(cframe)
		local focus = unwrap(focus)

		local distance = (current.Position - focus.Position).Magnitude
		distance = distance ~= distance and 0 or distance

		local moveAmount = math.max(distance * 0.1, 0.1)
		local targetCFame = current * CFrame.new(0, 0, zoomFactor * moveAmount)

		cframe:set(targetCFame)
	end

	local AssetViewport = Background({

		Size = UDim2.fromOffset(256, 256),
		BackgroundColor = Enum.StudioStyleGuideColor.ViewPortBackground,

		[Children] = {
			Border({
				BorderColor = Enum.StudioStyleGuideColor.InputFieldBorder,
			}),
			New("UICorner")({
				CornerRadius = UDim.new(0, 8),
			}),

			New("ViewportFrame")({

				Size = UDim2.fromScale(1, 1),

				BackgroundTransparency = 1,

				CurrentCamera = Camera,

				[Children] = object,

				[OnEvent("InputBegan")] = function(input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseButton2 then
						isOrbitDragging = true
					elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
						isShiftDown = true
					end
				end,

				[OnEvent("InputChanged")] = function(input: InputObject)
					if not isOrbitDragging or draggable == false then
						return
					end
					if input.UserInputType ~= Enum.UserInputType.MouseMovement then
						return
					end

					local targetFocus = unwrap(focus)
					local targetCFrame = targetFocus:ToObjectSpace(unwrap(cframe))

					targetCFrame = CFrame.fromAxisAngle(targetCFrame.RightVector, input.Delta.Y * -0.02) * targetCFrame
					targetCFrame = CFrame.fromAxisAngle(Vector3.yAxis, input.Delta.X * -0.02) * targetCFrame

					cframe:set(Camera.Focus:ToWorldSpace(targetCFrame))
				end,

				[OnEvent("InputEnded")] = function(input: InputObject)
					if input.UserInputType == Enum.UserInputType.MouseButton2 then
						isOrbitDragging = false
					elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
						isShiftDown = false
					end
				end,

				[OnEvent("MouseWheelForward")] = function()
					zoom(-3 / (isShiftDown and 5 or 1))
				end,

				[OnEvent("MouseWheelBackward")] = function()
					zoom(3 / (isShiftDown and 5 or 1))
				end,
			}),
		},

		[Cleanup] = changeObjectCFrame,
	})

	return Fusion.Hydrate(AssetViewport)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
end

return AssetViewport
