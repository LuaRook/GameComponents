local RunService = game:GetService("RunService")

local Packages = script.Parent.Parent

local Fusion = require(Packages.Fusion)

local Value = Fusion.Value
local Computed = Fusion.Computed

local function Runtime<T>(func: (old: T?) -> T, set: ((new: T) -> ())?): Fusion.Computed<T>
	local result, _ = func(nil)
	local realValue = Value(result)
	local wrapper = Computed(function()
		return realValue:get()
	end, Fusion.doNothing)

	local function update()
		local result, success = func(realValue:get(false))
		if success == false then
			return
		end
		realValue:set(result)
	end

	wrapper._connection = RunService.Heartbeat:Connect(function()
		-- If there is nothing left in the dependentSet, we'll disconnnect the
		-- connection because nobody depends on it anymore.
		if next(wrapper.dependentSet) then
			update()
		else
			wrapper._connection:Disconnect()
		end
	end)

	function wrapper:set(new)
		assert(set, "Attempted to set a read-only Runtime state.")
		set(new)
		update()
	end

	wrapper.kind = "Runtime"

	return wrapper
end

return Runtime
