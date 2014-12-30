
ui = {
	xRes = Services.Core:getXRes(),
	yRes = Services.Core:getYRes(),
	renderPipeline = {}
}

ui.xMid = ui.xRes / 2
ui.yMid = ui.yRes / 2


scene = Scene(Scene.SCENE_2D)
scene:getActiveCamera():setOrthoSize(ui.xRes, ui.yRes)

function toString(vec)
	return vec.x .. " - " .. vec.y
end

curr = 1
function onKeyDown(key)
	if type(presentation) == "table" and type(presentation[curr]) == "function" then
		presentation[curr]()
		curr = curr + 1
	end
end


-- performs three types of tests regarding a given objects type
	-- Test 1: Is the object a class (as defined by the Polycode framework)
	-- Test 2: Is the object a specific class (if given the class name as a string)
	-- Test 3: Is the object the same class as another object (if given another class)
function isClass(obj, klass)
	if obj.__prototype then
		return (not klass) or (isClass(klass) and obj:isClass(klass) or obj.__classname == klass)
	end
end

typename = function(obj)
	if isClass(obj) then
		return obj.__classname
	end

	return type(obj)
end
