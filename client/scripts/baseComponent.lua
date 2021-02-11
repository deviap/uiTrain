-- By utrain
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
local newState = require("./state.lua")
local newMaid = require("./maid.lua")

local noop = function()
end

local destroy = function(self)
	--[[
		@Description
			Cleans up object with maid.
		@Parameters
			[table] self
				Object
		@Returns
			nil
	]]

	self.maid:cleanUp()
end

local extend = function(self)
	--[[
		@Description
			Shallowly clones the given table.
		@Parameters
			[table] self
		@Returns
			[table] newObject
	--]]
	local newObject = {}

	for key, value in next, self do newObject[key] = value end

	return newObject
end

local new
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

	newObject.maid = newMaid()

	if newObject.init then newObject:init(...) end

	-- State should be inserted in :init(). If it is, bind the redraw function.
	if newObject.state then
		newObject.maid:giveCallback(
			newObject.state:listen(
				function()
					newObject:redraw()
				end
			)
		)
	end

	newObject:redraw()

	return newObject
end

return {
	new = new,
	extend = extend,
	redraw = noop,
	destroy = destroy,
}
