local INVALID_TASK_ADDED_ERROR = "Task given is the invalid type %s."
local INVALID_ID_ERROR = "There's no task with the id of %s."
local INVALID_TASK_CLEANED_ERROR = 
	"The task with an id of %s has the invalid type of %s"

local VALID_TYPES = {
	tevObj = true,
	table = true,
	number = true,
	["function"] = true,
}

local baseObj = require("./baseObj.lua")

return baseObj:extend {
	addTask = function(self, task, id)
		if not VALID_TYPES[type(task)] then 
			error(INVALID_TASK_ADDED_ERROR:format(type(task))) 
		end
		
		id = id or #self._tasks + 1

		if self._tasks[id] then
			self:cleanTask(id)
		end

		self._tasks[id] = task

		return task, id
	end,

	addTasks = function(self, tasks)
		for key, value in next, tasks do
			self:addTask(value)
		end
	end,

	cleanTask = function(self, id)
		local target = self._tasks[id] 
			or error(INVALID_ID_ERROR:format(tostring(id)))
		local targetType = type(target)

		if targetType == "tevObj" then
			target:destroy()
		elseif targetType == "table" then
			target:destroy()
		elseif targetType == "function" then
			target()
		elseif targetType == "number" then
			core.disconnect(target)
		else
			error(INVALID_TASK_CLEANED_ERROR:format(tostring(id), targetType))
		end

		self._tasks[id] = nil
	end,
	
	cleanAll = function(self)
		-- Events first, as they're sure to be cleaned up. And, other tasks may get
		-- to them first without us knowing.
		for id, task in next, self._tasks do
			if type(task) == "number" then
				core.disconnect(task)
				self._tasks[id] = nil
			end
		end

		-- Cleaning up tasks may add more tasks to this maid, so we want to get
		-- get them as well.
		local id, _ = next(self._tasks, nil)

		while id do
			self:cleanTask(id)
			id, _ = next(self._tasks, id)
		end
	end,

	destroy = function(self)
		self:cleanAll()
	end,

	init = function(self)
		self._tasks = {}
	end
}