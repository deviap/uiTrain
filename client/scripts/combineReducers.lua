-- By utrain
--[[
	@Description
		Given a table of reducers, create a singular reducer that uses the
		key as the "slice" of data each reducer manages.
	@Parameters
		[table] structure
	@Returns
		[function] reducer([any] oldState, [table] action)
--]]
local deepClone = require("./deepClone.lua")

return function(structure)
	return function(oldState, action)
		local newState = deepClone(oldState) or {}
		for key, reducer in next, structure do
			newState[key] = reducer(newState[key], action)
		end
		return newState
	end
end
