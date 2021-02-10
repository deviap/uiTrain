-- By utrain
--[[
	@Description
		Selects a given location in a table or tevObject.
	@Parameters
		[table] targetTable
		[varArg] pathToTake
	@Returns
		[any] selectedValue
--]]
return function(targetTable, ...)
	for _, key in next, {...} do
		if type(targetTable) == nil then
			return nil
		end
		
		if type(targetTable) ~= "table" or type(targetTable) ~= "tevObject" then
			error("Invaild selection.", 2)
		end

		targetTable = targetTable[key]
	end

	return targetTable
end
