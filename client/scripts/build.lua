-- By utrain
--[[
	@Description
		This function takes in a className and returns another function which
		you pass the properties into. You can place children under the children
		field. It takes in an array of tevObjects to parent.
	@Parameters
		[string] className
	@Returns
		[function] [tevObject] passProperties([table] properties)
--]]
return function(className)
	return function(properties)
		local children = properties.children or {}
		properties.children = nil

		local object = core.construct(className, properties)
		for _, child in next, children do child.parent = object end

		return object
	end
end
