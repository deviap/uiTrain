-- By utrain
--[[
	@Description
		This object is helpeful in cleaning up mess. Consider it as a finalizer.
	@Parameters
		[nil]
	@Returns
		[table] maid
	@Interface
		[function] giveCallback([function] callback)
		[number, function] giveEvent([number] eventId)
		[table, function] giveObject([table] object)
		[nil] cleanUp()
		[nil] destroy()
			Alias of cleanUp
		[nil] cleanUpTarget([function] target)
--]]
local ADD_CALLBACK_TYPE_ERROR =
	"Argument #2's type is %s, expected function instead."
local ADD_EVENT_TYPE_ERROR =
	"Argument #2's type is %s, expected integer instead."
local ADD_OBJECT_TYPE_ERROR =
	"Argument #2's type is %s, expected table or tevObject instead."
local ADD_OBJECT_MISSING_DESTROY_ERROR =
	"Argument #2 is missing 'destroy' method."

local giveCallback = function(self, callback)
	--[[
		@Description
			Adds a function to be invoked whenever maid cleans up.
		@Parameters
			[table] maid
			[function] callback()
		@Returns
			[function] callback
	--]]

	if type(callback) ~= "function" then
		error(ADD_CALLBACK_TYPE_ERROR:format(type(callback)), 2)
	end

	self._tasks[callback] = true
	return callback
end

local giveEvent = function(self, eventId)
	--[[
		@Description
			Pass an eventId to be disconnected when maid cleans up.
		@Parameters
			[table] maid
			[number] eventId
		@Returns
			[number] eventId
			[function] callback
				This is the callback that will be invoked to disconnect the
				event. Techincally, this is what is being added to the maid.
	--]]

	if type(eventId) ~= "number" then
		error(ADD_EVENT_TYPE_ERROR:format(type(eventId)), 2)
	end

	self._tasks[eventId] = true
	return eventId
end

local giveObject = function(self, object)
	--[[
		@Description
			Pass an table to be cleaned up when maid cleans up. Requires that
			it has a :destroy() method.
		@Parameters
			[table] maid
			[table] object
		@Returns
			[table] object
			[function] callback
				This is the callback that will be invoked to clean the object. 
				Techincally, this is what is being added to the maid.
	--]]

	if type(object) ~= "tevObj" then
		if type(object) ~= "table" then
			error(ADD_OBJECT_TYPE_ERROR:format(type(object)), 2)
		end
	end

	if not object.destroy then error(ADD_OBJECT_MISSING_DESTROY_ERROR, 2) end

	self._tasks[object] = true
	return object
end

local cleanUp = function(self)
	--[[
		@Description
			Cleans up the queued functions in maid asynchronously.
		@Parameters
			[table] maid
		@Returns
			[nil]
	--]]

	for target, _ in next, self._tasks do
		local targetType = type(target)

		if targetType == "table" then
			target:destroy()
		elseif targetType == "tevObject" then
			target:destroy()
		elseif targetType == "number" then
			core.disconnect(target)
		elseif targetType == "function" then
			target()
		end

		self._tasks[target] = nil
	end
end

local cleanUpTarget = function(self, target)
	--[[
		@Description
			Cleans up the targeted function in maid.
		@Parameters
			[table] maid
			[function] target
		@Returns
			[nil]	
	--]]

	for possibleTarget, _ in next, self._tasks do
		if possibleTarget == target then
			local targetType = type(target)

			if targetType == "table" then
				target:destroy()
			elseif targetType == "tevObject" then
				target:destroy()
			elseif targetType == "number" then
				core.disconnect(target)
			elseif targetType == "function" then
				target()
			end

			self._tasks[target] = nil
		end
	end
end

return function()
	return {
		_tasks = {},
		giveCallback = giveCallback,
		giveEvent = giveEvent,
		giveObject = giveObject,
		cleanUp = cleanUp,
		destroy = cleanUp, -- Alias
		cleanUpTarget = cleanUpTarget
	}
end
