--[[
	@Description
		This is the base component that all other components can be derived 
		from.
	@Interface
		[table] new([table] self, [varArg?] properties)
			This clones the table and intializes it.
		[table] extend([table] self)
		[nil] destroy([table] self)
			Calls self.maid:cleanUp() by default.
		[nil] redraw()
			Implement this function when you extend this component! By default,
			it is a noop function.
		[nil] init([table] self, [varArg?] properties)
			Preferably implement this function when you extend this component! 
			By default, it is not implemented at all nor does it need to be.
--]]
local simState = require("./simState.lua")
local maid = require("./maid.lua")
local baseObj = require("./baseObj.lua")

local noop = function()
end

return baseObj:extend {
	destroy = function(self)
		--[[
			@Description
				Cleans up object with maid.
			@Parameters
				[table] self
					Object
			@Returns
				nil
		]]

		self.maid:cleanAll()
	end,

	setState = function(self, ...)
		self.state:set(...)
	end,

	new = function(self, ...)
		--[[
			@Description
				Builds a new UI element based off the given object.
			@Parameters
				[table] self
					Object
				[varArg?] properties
					This is where the user can pass in properties to 'init' if it
					does exist.
			@Returns
				[table] newObject
		--]]

		local newObject = self:extend()

		newObject.maid = maid:new()
		newObject.state = simState:new()

		if newObject.init then newObject:init(...) end

		newObject.maid:addTask(
			newObject.state:hook(function(oldState, newState)
				if oldState == newState then return end
				newObject:redraw()
			end)
		)

		newObject:redraw()

		return newObject
	end,
}