ui.functorTest = {
	pipeline = {}
}

ui.functorTest.update = function(d)
	for _, f in pairs(ui.functorTest.pipeline) do
		if f:update(d) then
			ui.functorTest.pipeline[_] = nil
		end
	end	
end

ui.functorTest.loadingDots = {
	func = function(dt)
		return fn(dt, obj, animator)
	end,
	update = function(self, dt)
		coroutine.resume(self.func, dt)
		return coroutine.status(self.func) == "dead"
	end
}