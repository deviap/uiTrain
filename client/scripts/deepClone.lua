local deepClone
deepClone = function(target)
	--[[
		@Description
			Makes a deep clone of some value. Note, this will break with
			tevObjects!
		@Parameters
			[any] target
		@Returns
			[any] clonedTarget
	--]]

	if type(target) == "table" then
		local clone = {}

		for key, value in next, target do
			clone[key] = deepClone(value)
		end

		return clone
	end
	return target
end

return deepClone
