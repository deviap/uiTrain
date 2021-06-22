return {
	extend = function(self, newObject)
		--[[
			@Description
				Extend the given object, with an optional newObject to base it
				off.
			@Parameters
				[table] self
				[table?] newObject
			@Returns
				[table] newObject
		]]
		local newObject = newObject or {}

		for key, value in next, self do
			newObject[key] = newObject[key] or value
		end

		return newObject
	end,
	new = function(self, ...)
		--[[
			@Description
				Instance a new object based on the given object. Runs the :init
				method.
			@Parameters
				[table] self
				[...any?] arguments
			@Returns
				[table] newObject 
		]]

		local newObject = self:extend()

		newObject:init(...)
		return newObject
	end,
	-- Override init function. By default, does nothing.
	init = function() end,
}