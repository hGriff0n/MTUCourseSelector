require "Scripts/Main"
require "Scripts/Easing/Easers"

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
searching = SceneLabel("Searching for profile...", 32, "Modern", 1, 32, false)
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


-- work on interweaving the easers into the presentation
function Update(d)
	ui.easers.update(d)
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
		userBack:setColor(.27, .27, .27, 1)
		loginButton:addChild(hint)
	end,
	function()		-- demonstrate mouseover
		Services.Core:warpCursor(ui.xMid - 250, ui.yMid)
		userBack:setColor(1, 1, 1, 1)
		loginButton:removeChild(hint)
	end,
	function()		-- setup next scene
		Services.Core:warpCursor(ui.xMid - 130, ui.yMid)
		ui.easers.color(userBack, .27, .27, .27, .04)
		loginButton:addChild(hint)
	end,
	function()		-- demonstrate login screen
		loginButton:removeChild(hint)
		loginButton:Scale(.3, .3)
		userBack:setColor(1, 1, 1, 1)
		loginButton:setPosition(-215, 105)
		scene:addChild(loginDetails)
		userImg:addChild(back)
	end,
	function()		-- demonstrate the back button
		Services.Core:warpCursor(ui.xMid - 215, ui.yMid - 105)
		userBack:setColor(.27, .27, .27, 1)
	end,
	function()		-- demonstrate the back behavior
		loginButton:Scale(3.3, 3.3)
		userBack:setColor(1, 1, 1, 1)
		loginButton:setPosition(0, 0)
		scene:removeEntity(loginDetails)
		userImg:removeChild(back)
	end,
	function()		-- setup next scene
		Services.Core:warpCursor(ui.xMid - 130, ui.yMid)
		userBack:setColor(.27, .27, .27, 1)
		loginButton:addChild(hint)
	end,
	function()		-- setup next scene
		loginButton:removeChild(hint)
		loginButton:Scale(.3, .3)
		userBack:setColor(1, 1, 1, 1)
		loginButton:setPosition(-215, 105)
		scene:addChild(loginDetails)
		userImg:addChild(back)
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
		Services.Core:warpCursor(ui.xMid + 135, ui.yMid + 80)
	end,
	function()		-- demonstrate failure state
		scene:removeEntity(searching)
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
		Services.Core:warpCursor(ui.xMid + 135, ui.yMid + 80)
	end,
	function()		-- demonstrate success state
		scene:removeEntity(searching)
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
	end,
	function()		-- Outro of the userImg
		scene:removeEntity(loading)
		scene:removeEntity(loginDetails)

		loginDetails:addChild(username)
		loginButton:setPosition(-880, 450)
		-- change event listener, etc.
	end
}
