if not ui then ui = {} end

-- if i make a function to add a ui element to the screen
-- i'll have to make sure to not use render

-- starts the rendering process by adding a coroutine to the pipeline
function ui.startRendering(fn)
	table.insert(ui.renderPipeline, coroutine.create(fn))
	return #ui.renderPipeline
end

-- removes the function at the given index
function ui.stopRendering(idx)
	ui.renderPipeline[idx] = nil
end

-- updates the rendering pipeline, removing "dead" functions
function ui.update(d)
	for i, f in pairs(ui.renderPipeline) do
		coroutine.resume(ui.renderPipeline[i], d)
		
		if coroutine.status(ui.renderPipeline[i]) == "dead" then
			ui.renderPipeline[i] = nil			-- the next easer will be fitted into this spot
		end
	end
end

-- generates a coroutine to structure iterative updates on an object as defined by a given "capture" function
function ui.render(fn, obj, tbl)
	if type(fn) ~= "function" then return end

	return ui.startRendering(function()
		local t = 0
		while not fn(t, obj, tbl) do
			t = coroutine.yield()
		end
	end)
end

function ui.makeFunctor(t)
	return setmetatable(t, ui.callable)
end

-- Encapsulates the necessary changes to make the render functors
	-- Overrides __call for standard behavior and __index/__newindex for precise control
ui.callable = {
	-- allows for overloading the "raw" behavior
	-- does restrict future possibilities
	__index = function(t, fn)
		return ui.render
		-- allows overriding the "default" behavior by implementing a "raw" method
	end,
	__newindex = function(t, fn, v)				  -- raw control
		return t.render(fn, v, t)		-- relies on the above overload to work
	end,
	__call = function(t, ...)						-- standard behavior
		return t:run(...)
	end,
}


-- Default easing operations
ui.easers = {
	primitive = ui.makeFunctor{
		run = function(self, obj, fn)
			self[fn] = obj
		end
	}
}
