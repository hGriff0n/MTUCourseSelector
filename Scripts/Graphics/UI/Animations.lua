require "Scripts/UI/Primitives"

-- then work on improving the development chain
	-- is there a way to take advantage of the ui.easers.raw override functionality ???
	-- would there be a way to chain animations and easers ???
		-- or otherwise combine them so they could use each other
		-- maybe make it so that they are not required to add the operation to the rendering pipeline
		-- maybe make them have an "update" member to advance iteration in some way
			-- this would be a unifying syntax (object heirarchy)
			-- animations and easers return a table with an update method defined to resume a coroutine (other details unfinished)
			-- this object could then be used all over the place (pipeline being the main option

-- first:
	-- change the name of the easing folder (to better represent its contents)

-- second:
	-- work on the OO-syntax idea
	-- plan out the screens after the loading section
		-- will involve experimenting with the UIScrollableContainer (see the forum post)

-- define the operations

ui.animate = {}

ui.animate.addAnimation = function(obj, fn, delta)
	local t, fns = 0, (type(fn) == "table") and fn or { timed = function() return fn() end }

	return ui.render(function(dt, obj)
			t = t + dt

			if t > delta then
				t = fns.timed()
			end

			if fns.iter then
				fns.iter(t)
			end
		end, obj)
end


ui.animate.loadingDots = ui.makeFunctor{
	run = function(self, obj, min, max, delta, stopFn)
		-- Generate animation values
		local text, iter = obj:getText(), self.getAppendTable(".", min, max)
		local t, counter = 0, min		-- set t to 1 for a smoother animation ???

		-- Add animation to pipeline
		local pos = ui.animate.addAnimation(obj, function()
							counter = (counter == max and min or counter + 1)
							obj:setText(text .. iter[counter])
							return 0
						end, delta)

		-- Generate animation stop function
		return function()
			if stopFn then stopFn() end

			obj:setText(text)
			ui.stopRendering(pos)
		end
	end,
	-- Generates the series of dots to append to the text string at differing levels of execution
	getAppendTable = function(ch, min, max)
		local t = {}
		for i=min, max do
			t[i] = string.rep(ch, i)
		end
		return t
	end,
}