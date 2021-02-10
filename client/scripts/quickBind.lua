-- By utrain
--[[
	@Description
		Quickly bind to events in a component. Note that the task to clean them
		up is automatically added. 
	@Parameters
		[table] component
		[table] bindCallbacks
			string<function>
		[varArg?] path
			It'll start at self.gui and select a child based off the given path.
	@Returns
		[nil]
--]] 
local selectChildren = require("./selectChildren.lua")
local appendArray = function(...)
	--[[
		@Description
			Creates a new array and appends it with the given array. The first
			one passed is the first one to get appended on.
		@Parameters
			[varArg] arrays
		@Returns
			[table] array
	--]]

	local new = {}
	local i = 1

	for _, array in next, {...} do
		for _, value in ipairs(array) do
			new[i] = value
			i = i + 1
		end
	end

	return new
end

local wrapFunction = function(targetFunction, ...)
	--[[
		@Description
			Wraps a given function and passes external arguments in.
		@Parameters
			[function] targetFunction
			[varArg?] externalArgs
		@Returns
			[function] [any] wrapper([varArg?] arguments)
	--]]
	local packaged = {
		n = select("#", ...),
		...
	}
	return function(...)
		local packaged2 = {
			n = select("#", ...),
			...
		}
		return targetFunction(self, unpack(appendArray(packaged, packaged2)))
	end
end

return function(self, events, ...)
	local gui = selectChildren(self.gui, ...)

	for eventName, callback in next, events do
		self.maid:giveEvent(gui:on(eventName, wrapFunction(callback, self)))
	end
end
