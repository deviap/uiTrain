-- By utrain
-- Gathering of all of the modules
return {
	baseObj = require("./baseObj.lua"),
	baseComponent = require("./baseComponent.lua"),
	quickBind = require("./quickBind.lua"), --Considering reworking this.
	maid = require("./maid.lua"),

	state = require("./state.lua"),
	combineReducers = require("./combineReducers.lua"),

	simState = require("./simState.lua"),
	none = require("./none.lua"),

	build = require("./build.lua"),
	selectChildren = require("./selectChildren.lua"),

	deepClone = require("./deepClone.lua"),
	nestedSearch = require("./nestedSearch.lua"),

	import = function(self, ...)
		--[[
			@Description
				Import the selected modules.
			@Parameters
				[table] self
					The table this import function is placed in.
				[varArg] toImport
			@Returns
				[varArg] importedModules
		--]]
		local imports = {}
		for _, value in next, {...} do imports[#imports + 1] = self[value] end
		return unpack(imports)
	end
}