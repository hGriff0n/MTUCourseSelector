require "Scripts/UI/Primitives"

--http://cubic-bezier.com/
--http://devmag.org.za/2011/06/23/bzier-path-algorithms/
--https://www.desmos.com/calculator/cahqdxeshd

-- might have to rename / adjust file organization

ui.easers.bezier = ui.makeFunctor{
	run = function(self, obj, bezier, func, time)
		--vcurve = SceneCurve.SceneCurveWithCurve(bezier)
		--scene:addChild(vcurve)

		local fn =
			type(func) == "table" and func or {
				onExit = func or ui.easers.move.setPos,
				update = func or ui.easers.move.setPos
			}

		--local curve, last = self.bezierFn(self.getAllHandles(bezier))
		local curve, last = self:bezierFn(bezier)
		local t, scale = 0, 1 / (time or 1)

		self[function(dt, obj)
			if t >= 1 then
				fn.onExit(obj, last)
				return true
			end

			t = t + (dt * scale)
			fn.update(obj, curve(t))
		end] = obj

		return time or 1
	end,

	-- Get all points specified for the bezier curve
	getAllPoints = function(bezier)
		local t = {}
		for i=0, (bezier:getNumControlPoints() - 1) do
			t[i + 1] = bezier:getControlPoint(i)
		end
		return t
	end,

	-- Get all handle points on the bezier curve
	getAllHandles = function(bezier)
		local t = {}
		for i, v in ipairs(ui.easers.bezier.getAllPoints(bezier)) do
			t[#t + 1] = v.p1
			t[#t + 1] = v.p3
		end
		return t, bezier:getControlPoint(bezier:getNumControlPoints() - 1).p2
	end,

	-- Generates the pascal numbers of degree n
	pascal = function(n)
		if not ui.easers.bezier.pascalTriangle[n] then
			local l, t = ui.easers.bezier.pascal(n - 1), {}
			
			for i=1, (#l + 1) do t[i] = (l[i] or 0) + (l[i - 1] or 0) end
			
			ui.easers.bezier.pascalTriangle[n] = t
		end
		
		return ui.easers.bezier.pascalTriangle[n]
	end,
	pascalTriangle = { { 1 }, { 1, 1 } },

	-- Generates the bezier algorithm for the given points
	bezierFn = function(self, bezier)
		return self.bezierFunction(self.getAllHandles(bezier))
	end,
	bezierFunction = function(points, last)
		local pascal = ui.easers.bezier.pascal(#points)

		return function(t)
			local s = 1 - t
			local r, l = 1, math.pow(s, (#points - 1))

			local x, y, z = 0, 0, 0
			for i, p in ipairs(points) do
				x = x + pascal[i] * l * r * p.x
				y = y + pascal[i] * l * r * p.y
				z = z + pascal[i] * l * r * p.z

				l = l / s
				r = r * t
			end

			return { x = x, y = y, z = z }
		end, last
	end,

	distance = function(p1, p2)
		return math.sqrt(math.pow(p2.x - p1.x, 2) + math.pow(p2.y - p1.y, 2))
	end,

	-- public functions
	-- turn the given points into a bezier curve
	interpolate = function(self, points, scale)
		scale = scale or .5
		self:create():addPoint(points[1])

		-- if points[i + 1] == points[i - 1] then this has some problems
		for i=2,(#points - 1) do
			local m = (points[i + 1].y - points[i -1].y) / (points[i + 1].x - points[i - 1].x)
			local d1 = self.distance(points[i], points[i - 1])
			local d2 = self.distance(points[i], points[i + 1])

			local h1 = { x = points[i].x - scale * d1, y = points[i].y - scale * d1 * m }
			local h2 = { x = points[i].x + scale * d2, y = points[i].y + scale * d2 * m }

			self:addPoint(points[i], h1, h2)
		end

		return self:addPoint(points[#points]):finalize()
	end,

	-- reduces the number of points
	simplify = function(self, ...)

	end,

	-- abstract bezier construction
	buildBezier = 3,
	create = function(self)
		self.buildBezier = BezierCurve()
		return self
	end,
	addPoint2d = function(self, px, py, hx1, hy1, hx2, hy2)
		return self:addPoint3d(px, py, 0, hx1, hy1, 0, hx2, hy2, 0)
	end,
	addPoint3d = function(self, px, py, pz, hx1, hy1, hz1, hx2, hy2, hz2)
		self.buildBezier:addControlPoint3dWithHandles(hx1 or px, hy1 or py, hz1 or pz,
														     px,        py,        pz,
													  hx2 or px, hy2 or py, hz2 or pz)
		return self
	end,
	addPoint = function(self, p1, h1, h2)
		p1.z = p1.z or 0
		h1, h2 = h1 or p1, h2 or p1
		return self:addPoint3d(p1.x, p1.y, p1.z, h1.x, h1.y, h1.z, h2.x, h2.y, h2.z)
	end,
	addCurve = function(self, bezier)
		-- get all points on the bezier
		-- loop addPoint, treating the passed bezier as a delta
		return self
	end,
	finalize = function(self)
		local t = self.buildBezier
		self.buildBezier = 3
		return t
	end
}
