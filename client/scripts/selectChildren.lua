local selectChildren = function(tevObject, ...)
	--[[
		@Description
			It does a nested search through the child of target object. The
			varArgs passed will provide the path to select the desired child.
		@Parameters
			[table] tevObject
			[varArg?] path
		@Returns
			[tevObject] selectedTevObject
	--]]
	for _, name in next, {...} do tevObject = tevObject:child(name) end
	return tevObject
end

return selectChildren