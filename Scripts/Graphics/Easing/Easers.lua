require "Scripts/Easing/Bezier"

local bezEaser = ui.easers.bezier

-- changes the location of the object
ui.easers.move = ui.easers.makeFunctor{
	run = function(self, obj, x, y, time)
		return bezEaser(obj, self.getBezier(obj, x, y), self.setPos, time)
	end,
	getBezier = function(obj, x, y)
		return bezEaser:create():addPoint(obj:getPosition()):addPoint2d(x, y):finalize()
	end,
	setPos = function(obj, pos)
		obj:setPosition(pos.x, pos.y)
	end
}

-- changes the size of the object
ui.easers.zoom = ui.easers.makeFunctor{
	run = function(self, obj, sX, sY, time)
		return bezEaser(obj, self.getBezier(obj, sX, sY), self.setScale, time)
	end,
	getBezier = function(obj, sX, sY)
		return bezEaser:create():addPoint(obj:getScale()):addPoint2d(sX, sY):finalize()
	end,
	setScale = function(obj, scale)
		obj:setScaleX(scale.x)
		obj:setScaleY(scale.y or scale.x)
	end,
}

-- changes the rotation of the object
ui.easers.rotate = ui.easers.makeFunctor{
	run = function(self, obj, angle, time)
		return bezEaser(obj, self.getBezier(obj, angle), self.setRoll, time)
	end,
	getBezier = function(obj, angle)
		local roll = obj:getRoll()
		return bezEaser:create():addPoint2d(roll, 0):addPoint2d(roll + angle, 0):finalize()
	end,
	setRoll = function(obj, roll)
		obj:setRoll(roll.x)
	end
}

-- changes the color of the object
ui.easers.color = ui.easers.makeFunctor{
	run = function(self, obj, r, b, g, time)
		return bezEaser(obj, self.getBezier(obj, r, b, g), self.setColor, time)
	end,
	getBezier = function(obj, red, blue, green)
		local color = obj.color
		return bezEaser:create():addPoint3d(color.r, color.b, color.g):addPoint3d(ui.easers.color.decimals(red, blue, green)):finalize()
	end,
	decimals = function(r, b, g)
		return (r > 1 and r / 255 or r), (b > 1 and b / 255 or b), (g > 1 and g / 255 or g)
	end,
	setColor = function(obj, col)
		obj.color.r = col.x
		obj.color.b = col.y
		obj.color.g = col.z
	end
}

-- changes the transparency of the object
ui.easers.fade = ui.easers.makeFunctor{
	run = function(self, obj, alpha, time)
		return bezEaser(obj, self.getBezier(obj, alpha), self.setFade, time)
	end,
	getBezier = function(obj, a)
		return bezEaser:create():addPoint2d(obj.color.a, 0):addPoint2d((a > 1 and a / 255 or a), 0):finalize()
	end,
	setFade = function(obj, pos)
		obj.color.a = pos.x
	end
}
