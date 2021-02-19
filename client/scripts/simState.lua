-- By utrain
--[[
	@Description
		Creates a new simState. Essentially, a simplified version of state. 
	@Parameters
		[any?] startingState
	@Returns
		[table] simState
	@Interface
		[nil] set([table] simState, [any] newState)
		[any] get([table] simState)
		[function unhook] hook([table] simState, [function] callback)
--]]

local deepClone = require("./deepClone.lua")
local insertInGap = require("./insertInGap.lua")

local get = function(self)
	--[[
		@Description
			Deep clones and returns the given simState's state.
		@Parameter
			[table] self
		@Returns
			[any] state
	]]
	return deepClone(self._state)
end

local set = function(self, newState)
	--[[
		@Description
			Sets the state of the given simState. Hooks are informed.
		@Parameter
			[table] self
			[any] newState
		@Returns
			[nil]
	]]
	
	if type(newState) == "function" then
		newState = newState(self:get())
	end

	for _, callback in next, self._subscribers do
		callback(newState, self._state)
	end

	self._state = newState
end

local hook = function(self, subscriber)
	--[[
		@Description
			Hooks a subscriber to the given simState.
		@Parameters
			[table] self
			[function] subscriber
		@Returns
			[function] [nil] unhook()
	]]
	local placement = insertInGap(self._subscribers, subscriber)
	return function()
		self._subscribers[placement] = nil
	end
end

return function(startingState)
	return {
		get = get,
		set = set,
		hook = hook,
		_subscribers = {},
		_state = startingState,
	}
end