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
local none = require("./none.lua")

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

local diffTable
diffTable = function(destination, origin)
	--[[
		@Description
			Merge the two given tables into destination. Modifies destination
			instead of creating a new table.
		@Parameters
			[table] destination
			[table] origin
		@Returns
			[table] destination
	]]

	for key, value in next, origin do
		if value == none then
			destination[key] = nil
		elseif type(value) == "table" then
			diffTable(destination[key], value)
		else
			destination[key] = value
		end
	end

	return destination
end

local set = function(self, incomingState)
	--[[
		@Description
			Sets the state of the given simState. Hooks are informed.
		@Parameter
			[table] self
			[any] incomingState
		@Returns
			[nil]
	]]

	local newState = self:get()

	if type(incomingState) == "function" then
		incomingState(newState)
	elseif type(incomingState) == "table" then
		diffTable(newState, incomingState)
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