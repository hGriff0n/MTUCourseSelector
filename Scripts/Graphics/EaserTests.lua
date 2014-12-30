require "Scripts/Main"
require "Scripts/UI/Easers"

-- testing ground for easers

test = SceneImage("Resources/polycode_logo.png")
test2 = SceneImage("Resources/polycode_logo.png")

scene:addChild(test)
scene:addChild(test2)

mouse = SceneLabel("Label", 26, "Modern", 1, 26, false)
mouse:setPositionY(400)

image = SceneLabel("", 26, "Modern", 1, 26, false)
image:setPositionY(430)

scene:addChild(mouse)
scene:addChild(image)

bezier = BezierCurve()	-- It's a curve
bTest = ui.easers.bezier:interpolate({
	{ x = 100, y = 100 },
	{ x = 40,  y = 40 },
	{ x = 100, y = 100 }
}, .35)

bcurve = SceneCurve.SceneCurveWithCurve(bTest)
scene:addChild(bcurve)
--bezier:addControlPoint2dWithHandles(0, 0, 0, 0, 44, 198)
--bezier:addControlPoint2dWithHandles(172, 273, 400, 300, 400, 300)

bezier:addControlPoint2dWithHandles(0, 0, 0, 0, 0, 0)
bezier:addControlPoint2dWithHandles(400, 300, 400, 300, 400, 300)

vcurve = SceneCurve.SceneCurveWithCurve(bezier)

curve = SceneCurve.SceneCurveWithCurve(bezier)

-- 1905 x 1046: resolution of my screen
-- 820 x 820: testing resolution

-- improve the granularity of the default operations
	-- might change [] syntax to [obj] = function from [function] = obj
		-- I feel I might lose composability through dropping this syntax (obj is not necessary in the second case)
			-- Having the second syntax only apply for __index would lose discoverability I feel
	-- have the __index return a special type that can be accessed for it's bezier, etc.
		-- this could be very useful in the resumable/repeatable functor
			-- I'd have to wrap the function in a coroutine function that resumes it and "redoes" it as needed

-- work on new features
	-- stoppable infinte functions
		-- have a "removeOn" table and add the function to the necessary lists
			-- fairly difficlt and unwieldy to implement, relies on eventDispatcher
		-- have a "stopIf" table and have the function check manually
			-- drop-in solution, but it can cause problems with slow framerates/quick input
	-- variable deltas

-- work on member functions for the default operations

-- adjust bezier to work on 2d and 3d points
	-- interpolate: the "slope" calculation
		-- are the points Vector3 objects ???
	-- addPoint
		-- slightly less ugly hack for addPoint

-- need to work on the "composability" solution

-- add named parameters table syntax to the easer functors ???
	-- use the isPolycodeClass function to determine if obj is a table or an Entity
	-- if its a table then the named parameter stuff would be run (recursively)

-- note: the crazy bezier that juts to the left is the bezier for the rotation

local bezEaser = ui.easers.bezier

-- not quite at stoppable yet
	-- just a quick hack to see the dificulties, etc.
	-- listener type that implements the more complex behavior ???

	-- what happens ???
ui.easers.again = ui.easers.makeFunctor{
	run = function(self, obj, bezier, num, time)
		vcurve = SceneCurve.SceneCurveWithCurve(bezier)
		scene:addChild(vcurve)

		local fn = ui.easers.move.setPos
		local curve, last = bezEaser.bezierFn(bezEaser.getAllHandles(bezier))
		local t, scale, n = 0, 1 / (time or 1), 1

		self[function(dt, obj)
			if t >= 1 then
				if n == num then
					fn(obj, last)
					return true
				else
					n = n + 1
					t = 0
				end
			end

			t = t + (dt * scale)
			fn(obj, curve(t))
		end] = obj

		return time
	end
}

ui.easers.oscillate = ui.easers.makeFunctor{
	run = function(self, obj, bezier, num, time)
		--ui.easers.bezier(obj, bezier, ui.easers.move.setPos, num, time)
		vcurve = SceneCurve.SceneCurveWithCurve(bezier)
		scene:addChild(vcurve)

		local fn = ui.easers.move.setPos
		local curve, last = bezEaser.bezierFn(bezEaser.getAllHandles(bezier))
		local start, n = obj:getPosition(), 1
		local t, scale = 0, 1 / (time or 1)

		self[function(dt, obj)
			if t >= 1 or t < 0 then
				if n == num then
					fn(obj, (num % 2 == 0 and start or last))
					return true
				else
					n = n + 1
					scale = -scale
				end
			end

			t = t + (dt * scale)
			fn(obj, curve(t))
		end] = obj

		return time or 1
	end
}

-- Various easing functions

-- pivot (combine bezierMove and rotate)
-- shear (move the top edge but not the bottom edge)

function ui.easers.bulgeZoom(obj, top, fin, half, time)
	local curve, last = bezEaser.bezierFn(bezEaser.getAllHandles(ui.easers.zoom.getBezier(obj, top, top)))
	local t, scale = 0, 1 / (half or 1)

	ui.easers.zoom[function(dt, obj, zm)
		if t >= 1 then
			zm(obj, fin, fin, (time or (2 * half)) - half)
			return true
		end

		t = t + (dt * scale)

		zm.setScale(obj, curve(t))
	end] = obj
end

function ui.easers.moveZoom(obj, x, y, scale, speed)
	return ui.easers.zoom(obj, scale, scale, ui.easers.move(obj, x, y, speed))
end
	
-- would this be better with a 'mod' argument that is multiplied with full to get the current half ???
function ui.easers.bulgeMove(obj, x, y, top, fin, half, full)
	return ui.easers.bulgeZoom(obj, top, fin, half, ui.easers.move(obj, x, y, full))
end



-- testing boilerplate
function Update(d)
	image:setText(toString(test:getPosition()))

	ui.easers.update(d)
end

presentation = {
	function()
		--ui.easers.move(test, 400, 300, 1)
		--ui.easers.bulgeMove(test, 400, 300, 1.5, .5, .6)
		--ui.easers.rotate(test, 60, ui.easers.move(test, 400, 300, 1))
		scene:removeEntity(vcurve)

		local bezier = BezierCurve()
		bezier:addControlPoint2dWithHandles(0, 0, 0, 0, 44, 198)
		bezier:addControlPoint2dWithHandles(172, 273, 400, 300, 400, 300)

		-- only problem:
			-- straight lines have a slight delay getting started
		ui.easers.bezier(test, bezier, ui.easers.move.setPos, ui.easers.fade(test, 30, 2))
		--ui.easers.bezier(test, bezier, nil, 2)
		ui.easers.rotate(test2, -520, ui.easers.move(test2, 400, 300, 2))
	end,
	function()
		ui.easers.bulgeMove(test, 0, 0, .4, 1, 1, 2)
		ui.easers.move(test2, 0, 0, 2)
		curr = 0
	end,
}

function onMouseDown(button, x, y)
	mouse:setText("" .. x .. " - " .. y)
	if button == 0 then
		ui.easers.moveZoom(test, x - ui.xMid, ui.yMid - y, .5)
	else
		ui.easers.moveZoom(test, x - ui.xMid, ui.yMid - y, 1)
	end
end
