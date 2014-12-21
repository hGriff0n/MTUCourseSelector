
ui = {
	xRes = Services.Core:getXRes(),
	yRes = Services.Core:getYRes()
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

function isPolycodeClass(t)
	return type(t) == "table" and t.__prototype
end
