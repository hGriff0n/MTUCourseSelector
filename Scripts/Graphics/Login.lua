require "Scripts/Main"
require "Scripts/UI/Easers"
require "Scripts/UI/Animations"
require "Scripts/DesignTest"

-- Main user button
loginButton = Entity()

userBack = SceneImage("Resources/Circle.png")
userBack:Scale(.75, .75)

userImg = SceneImage("Resources/user.png")
userImg:Scale(.8, .8)
userImg:setPosition(10, 10, 0)

userIcon = nil

userBack:addChild(userImg)
loginButton:addChild(userBack)

loginButton:setOwnsChildrenRecursive(true)

-- Buton hint
hint = SceneLabel("LOGIN", 72, "Modern", 1, 70, false)


-- Temporaries to indicate the future existence of something
holders = {
	SceneLabel("TITLE", 28, "sans", 1, 28, false),
	SceneLabel("Details", 28, "sans", 1, 28, false),
	SceneLabel("Something", 28, "sans", 1, 28, false),
	SceneLabel("Something", 28, "sans", 1, 28, false)
}

holders[1]:setPosition(0, 450)
holders[2]:setPosition(0, -450)
holders[3]:setPosition(700,0)
holders[4]:setPosition(-700,0)

for i in ipairs(holders) do scene:addChild(holders[i]) end


-- Login detail box
loginDetails = Entity()

backing = SceneImage("Resources/square.png")
backing:Scale(.3, .15)
backing:setColor(.3, .3, .3, .2)
loginDetails:addChild(backing)

username = SceneLabel("Username", 26, "Modern", 1, 26, false)
username:setPositionY(16)
loginDetails:addChild(username)

password = SceneLabel("Password", 26, "Modern", 1, 26, false)
password:setPositionY(-32)
username:addChild(password)

login = SceneLabel("Login", 32, "sans", 1, 32, false)
login:setPosition(165, -83)
loginDetails:addChild(login)


-- Search and login feedback
--searching = SceneLabel("Searching for profile...", 32, "Modern", 1, 32, false)
searching = SceneLabel("Searching", 32, "Modern", 1, 32, false)
searching:setPosition(5, -45)

failure = {
	password = SceneLabel("Invalid Password", 32, "Modern", 1, 32, false),
	username = SceneLabel("Profile Not Found", 32, "Modern", 1, 32, false)
}
failure.password:setPosition(0, -45)
failure.username:setPosition(0, -45)

success = SceneLabel("Profile Found", 32, "Modern", 1, 32, false)
success:setPosition(0, -45)

loading = SceneLabel("Loading Profile", 36, "Modern", 1, 36, false)


-- have a "back signifier" that I could add to the icon ???
back = SceneImage("Resources/reverse.png")
back:Scale(1.3, 1.3)
back:setPosition(210, -210)



-- I might have to actually work on the stoppable animations for the "searching" and "loading" messages
	-- should I make a "animation" sub-table of ui that could have more facilities to handle some of these operations ???
	-- could "mirror"/extend the operations present in ui.easers with some extra facilities
		-- eg. have render store/return the location of the animation within the easer pipeline so that the animation can be deleted when stopped

--.04 might be too fast to see any animations occur (possible optimization)
-- edit bezier to call a "onStart" function if one is defined in the function table ???

-- fairly primitive and hackish methods (I feel)
ui.easers.add = ui.makeFunctor{
	run = function(self, obj, to, opt, time)
		to:addChild(obj)
		return self[opt](obj, time)
	end,
	fade = function(obj, time)			-- have this change the fade to the current level (have to make sure obj is at the desired level before calling)
		local alpha = obj.color.a
		obj.color.a = 0
		return ui.easers.fade(obj, alpha, time)
	end,
	zoom = function(obj, time)
		local vec = obj:getScale()
		ui.easers.zoom.setScale(obj, { x = 0 })
		return ui.easers.zoom(obj, vec.x, vec.y, time)
	end,
}

-- possible to have the individual specifiers as functors themselves (slightly more expensive and unnecessary, but more flexible)
local bezEaser = ui.easers.bezier

ui.easers.remove = ui.makeFunctor{
	run = function(self, obj, from, opt, time)
		return self[opt](obj, time, self.opTable(obj, from))
	end,
	opTable = function(obj, from)
		return function(op, start)
			return {
				onExit = function() from[isClass(from, "Scene") and "removeEntity" or "removeChild"](from, obj) op(obj, start) end,
				update = op
			}
		end
	end,
	fade = function(obj, time, rmvOps)
		local fade = ui.easers.fade
		return bezEaser(obj, fade.getBezier(obj, 0), rmvOps(fade.setFade, obj.color.a), time)
	end,
	zoom = function(obj, time, rmvOps)
		local zm = ui.easers.zoom
		return bezEaser(obj, zm.getBezier(obj, 0, 0), rmvOps(zm.setScale, obj:getScale()), time)
	end
}

-- rewrite to handle the string case
function isPolymorphicTo(obj, klass)
	if isClass(obj) then
		if isClass(klass) then
			return obj:isKindOfClass(klass)
		end

		--string handling
	end
end

-- Begin Presentation
scene:addChild(loginButton)
presentation = {
	function()		-- set up presentation
		Services.Core:warpCursor(ui.xMid - 250, ui.yMid)
		for i in ipairs(holders) do scene:removeEntity(holders[i]) end
	end,
	function()		-- demonstrate mouseover
		Services.Core:warpCursor(ui.xMid - 130, ui.yMid)

		ui.easers.add(hint, loginButton, "fade",
			ui.easers.color(userBack, .27, .27, .27, .04))
	end,
	function()		-- demonstrate mouseover
		Services.Core:warpCursor(ui.xMid - 250, ui.yMid)

		ui.easers.remove(hint, loginButton, "fade",
			ui.easers.color(userBack, 1, 1, 1, .04))
	end,
	function()		-- setup next scene
		Services.Core:warpCursor(ui.xMid - 130, ui.yMid)

		ui.easers.add(hint, loginButton, "fade",
			ui.easers.color(userBack, .27, .27, .27, .04))
	end,
	function()		-- demonstrate login screen
		loginButton:removeChild(hint)
		userImg:addChild(back)						-- might want to fade this in

		ui.easers.color(userBack, 1, 1, 1,
			ui.easers.zoom(loginButton, .3, .3,
				ui.easers.move(loginButton, -215, 105,
					ui.easers.add(loginDetails, scene, "zoom", .25))))	-- I don't like the look of this (maybe combine with a move so that it looks like the box is coming from the button)
	end,																  -- It might be a timing thing as well (but I doubt it accounts for the biggest chunk)
	function()		-- demonstrate the back button
		Services.Core:warpCursor(ui.xMid - 215, ui.yMid - 105)
		ui.easers.color(userBack, .27, .27, .27, .04)
	end,
	function()		-- demonstrate the back behavior
		userImg:removeChild(back)

		ui.easers.color(userBack, 1, 1, 1,
			ui.easers.zoom(loginButton, 1, 1,
				ui.easers.move(loginButton, 0, 0,
					ui.easers.remove(loginDetails, scene, "zoom", .25))))
	end,
	function()		-- setup next scene
		Services.Core:warpCursor(ui.xMid - 130, ui.yMid)

		ui.easers.add(hint, loginButton, "fade",
			ui.easers.color(userBack, .27, .27, .27, .04))
	end,
	function()		-- setup next scene
		loginButton:removeChild(hint)
		userImg:addChild(back)

		ui.easers.color(userBack, 1, 1, 1,
			ui.easers.zoom(loginButton, .3, .3,
				ui.easers.move(loginButton, -215, 105,
					ui.easers.add(loginDetails, scene, "zoom", .25))))

		Services.Core:warpCursor(ui.xMid - 43, ui.yMid - 16)
	end,
	function()		-- demonstrate logging on
		username:setText("gahooper")
		Services.Core:warpCursor(ui.xMid - 40, ui.yMid + 16)
	end,
	function()		-- demonstrate logging on
		password:setText("************")
		Services.Core:warpCursor(ui.xMid + 180, ui.yMid + 85)
	end,
	function()		-- setup the next scene
		loginDetails:removeChild(login)
		username:removeChild(password)

		scene:addChild(searching)
		
		stop = ui.animate.loadingDots(searching, 0, 3, .2)		-- do loadingDots animation on searching, minimum dots: 1, maximum: 3, time between updates: .1

		Services.Core:warpCursor(ui.xMid + 135, ui.yMid + 80)
	end,
	function()		-- demonstrate failure state
		scene:removeEntity(searching)
		stop()
		scene:addChild(failure.password)
	end,
	function()
		scene:removeEntity(failure.password)
		password:setText("Password")
		username:addChild(password)
		loginDetails:addChild(login)
		Services.Core:warpCursor(ui.xMid - 40, ui.yMid + 16)
	end,
	function()		-- demonstrate failure state and setup for next scene
		password:setText("************")
		Services.Core:warpCursor(ui.xMid + 180, ui.yMid + 85)
	end,
	function()		-- setup the next scene
		loginDetails:removeChild(login)
		username:removeChild(password)
		scene:addChild(searching)
		stop = ui.animate.loadingDots(searching, 0, 3, .2)
		Services.Core:warpCursor(ui.xMid + 135, ui.yMid + 80)
	end,
	function()		-- demonstrate success state
		scene:removeEntity(searching)
		stop()
		scene:addChild(success)

		userBack:removeChild(userImg)
		userImg:removeChild(back)
		userIcon = SceneImage("Resources/alt_user.png")
		userIcon:Scale(1.27, 1.27)
		userBack:addChild(userIcon)
		--userImg = SceneImage("Resources/alt_user.png")		-- change userImg to user's profile picture
		--userImg:Scale(1.27, 1.27)
		--userBack:addChild(userImg)
	end,
	function()		-- setup the outro (the next event after this would be the "main" gui)
		scene:removeEntity(success)
		loginDetails:removeChild(username)
		username:addChild(password)
		scene:addChild(loading)
		stop = ui.animate.loadingDots(loading, 0, 3, .2)
	end,
	function()		-- Outro of the userImg
		scene:removeEntity(loading)
		loginDetails:addChild(username)		-- to reset previous operations
		stop()

		ui.easers.move(loginButton, -880, 450, --.25 +
			ui.easers.remove(loginDetails, scene, "zoom", .25))
		-- change event listener, etc.
	end,
	function()
		loadTestingSuite()
	end
}

function Update(d)
	ui.update(d)
end
