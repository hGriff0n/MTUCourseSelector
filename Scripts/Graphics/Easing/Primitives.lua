
ui.easers = {
	pipeline = {},									-- the rendering pipeline
	raw = function(fn, obj, easer)					-- direct control with a function
		if type(fn) ~= "function" then return end

		ui.easers.render(function()
			local t = 0
			while not fn(t, obj, easer) do
				t = coroutine.yield()
			end
		end)

		return i
	end,
	makeFunctor = function(t)						-- makes the past table callable
		return setmetatable(t, ui.easers.callable)
	end
}

-- Encapsulates the necessary changes to make the easing functors
	-- Overrides __call for standard behavior and __index/__newindex for precise control
ui.easers.callable = {
	__index = function(t, fn)						-- create a "lambda" or something (doesn't call the function)
		return ui.easers.raw(fn, nil, t)
	end,
	__newindex = function(t, fn, v)				  -- raw control
		return ui.easers.raw(fn, v, t)
	end,
	__call = function(t, ...)						-- standard behavior
		return t:run(...)
	end,
}

-- Default easing operations
ui.easers.primitive = ui.easers.makeFunctor{
	run = function(self, obj, fn)
		self[fn] = obj
	end
}

ui.easers.stopIf = {
	input = function(input)
		-- return if key is down
	end,
}

-- Pipeline interaction functions
function ui.easers.update(d)
	for i in pairs(ui.easers.pipeline) do
		coroutine.resume(ui.easers.pipeline[i], d)
		
		if coroutine.status(ui.easers.pipeline[i]) == "dead" then
			ui.easers.pipeline[i] = nil			-- the next easer will be fitted into this spot
		end
	end
end

function ui.easers.render(fn)
	ui.easers.pipeline[#ui.easers.pipeline + 1] = coroutine.create(fn)
end