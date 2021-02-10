local insertInGap = function(array, value)
	--[[
		@Description
			Searches an array for a nil field to insert the value in.
		@Parameters
			[table] array
			[any] value
		@Returns
			[number] index
				Where it was placed in.
	--]]
	local index = 1

	while array[index] ~= nil do index = index + 1 end

	array[index] = value
	return index
end

return insertInGap