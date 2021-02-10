-- By utrain
--[[
	@Description
		Creates a new state.
	@Parameters
		[function] reducer([any] oldState, [table] action)
		[any?] startingState
	@Returns
		[table] stateObject
	@Interface
		[nil] dispatch([table] stateObject, [table] action)
		[any] getState([table] stateObject, [varArg?] path)
		[function unhook] hook([table] stateObject, [function] callback)
		[nil] applyMiddleware([table] stateObject, [function] middleware)
--]]
local deepClone = require("./deepClone.lua")
local nestedSearch = require("./nestedSearch.lua")
local insertInGap = require("./insertInGap.lua")

local identityMiddleware = function(action)
	--[[
		@Description
			Returns the action back to dispatch so that the reducer can act on
			it.
		@Parameters
			[table] action
		@Returns
			[table] action
	--]]
	return action
end

local dispatch = function(self, action)
	--[[
		@Description
			Peform a state change based on the passed action. It also invokes
			any callbacks listening for changes. It passes the new state,
			action, and the old state to the listener.
		@Parameters
			[table] self
				State object.
			[table] action
				Action data. The "type" field that states what the action is.
		@Returns
			nil
	--]]
	action = self._middlewareTop(action)

	if action then
		local newState = self._reducer(self._state, action)
		local oldState = self._state
		self._state = newState

		for _, callback in next, self._listeners do
			callback(newState, action, oldState)
		end
	end
end

local hook = function(self, callback)
	--[[
		@Description
			Hook a callback to state changes.
		@Parameters
			[table] self
				State object.
			[function] [nil] callback(
				[any] newState, 
				[table] action, 
				[any] oldState
			)
		@Returns
			[function] [nil] unhook()
				Unhooks the callback.
	--]]
	local index = insertInGap(self._listeners, callback)
	return function()
		self._listeners[index] = nil
	end
end

local getState = function(self, ...)
	--[[
		@Description
			Get a clone of the selected part of state.
		@Parameters
			[table] self
				State object.
			[varArg?] path
				The keys to use select within the state.
		@Returns
			[any] selectedState 
	--]]
	return deepClone(nestedSearch(self._state, ...))
end

local applyMiddleware = function(self, middleware)
	--[[
		@Description
			Applies a given middleware to the state object.
		@Parameters
			[table] self
				State object.
			[function] middleware
		@Returns
			nil
	--]]
	local next = middleware(self)
	self._middlewareTop = next(self._middlewareTop)
end

return function(reducer, startingState)
	return {
		_state = startingState or reducer(nil, {}),
		_reducer = reducer,
		_listeners = {},
		_middlewareTop = identityMiddleware,
		dispatch = dispatch,
		getState = getState,
		listen = listen,
		applyMiddleware = applyMiddleware
	}
end
