--[[
	Given a Instance, determines the ideal cframe a camera needs to be at in
	order to be able to put the entire instance in frame.
	
]]

local function getIdealCameraCFrame(part: BasePart | Model, fov: number?)
	if part == nil or part:IsA("BasePart") == false and part:IsA("Model") == false then
		return CFrame.new()
	end

	local cframe, size

	if part:IsA("BasePart") then
		cframe, size = part.CFrame, part.Size
	elseif part:IsA("Model") then
		cframe, size = part:GetBoundingBox()
	end

	local target = CFrame.new(0, 0, math.max(size.X, size.Y, size.Z) / math.tan(math.rad(fov or 70) / 2))
		+ cframe.Position

	return target
end

return getIdealCameraCFrame
