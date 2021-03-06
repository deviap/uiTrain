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

		if type(targetTable) ~= "table" then
			if type(targetTable) ~= "tevObj" then
				error("Invaild selection.", 2)
			end
		end

		targetTable = targetTable[key]
	end

	return targetTable
end
