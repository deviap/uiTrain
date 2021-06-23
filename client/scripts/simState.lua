--[[
	@Description
		Creates a new simState.
	@Parameters
		[any?] startingState
	@Returns
		[table] simState
	@Interface
		[nil] set([table] simState, [any] newState)
		[any] get([table] simState, [...any] path)
		[function unhook] hook([table] simState, [function] callback)
--]]

local baseObj = require("./baseObj.lua")
local deepClone = require("./deepClone.lua")
local insertInGap = require("./insertInGap.lua")
local nestedSearch = require("./nestedSearch.lua")
local none = require("./none.lua")

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

return baseObj:extend {
	get = function(self, ...)
		--[[
			@Description
				Deep clones and returns the given simState's state.
			@Parameter
				[table] self
				[...any] path
			@Returns
				[any] state
		]]
		return deepClone(nestedSearch(self._state, ...))
	end,

	set = function(self, incomingState)
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
	end,

	hook = function(self, subscriber)
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
	end,

	init = function(self, startingState)
		self._subscribers = {}
		self._state = startingState or {}
	end
}