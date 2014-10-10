--require "Scripts/Structures/Class"
--require "Scripts/Structures/Degree"
--require "Scripts/Structures/Time"

--require "Scripts/Constants"
require "Scripts/DataMine"

require "Scripts/Utilities/File"
require "Scripts/Utilities/Output"

require "Data/Class CS2321"
require "Data/Course2 CS2321"
require "Data/html"

require "Scripts/InProgress/Course"

screen = Screen()
screen.rootEntity.snapToPixels = true

label = ScreenLabel("It Compiles!", 64, "mono")
label.positionAtBaseline = false
label:setPositionMode(ScreenEntity.POSITION_CENTER)
screen:addChild(label)
label.position.x = 300
label.position.y = 200


--file = io.open(filepath .. "Data/toWrite4.txt", "w")

function typeFile(t, file, buffer)
	local buf = buffer or ""

	for i, v in ipairs(t) do
		file:write("|" .. buf .. i .. ": ")
		if type(v) ~= "string" then
			file:write("table -> |\n")
			typeFile(v, file, buf .. " ")
		else
			file:write(v .. "|\n")
		end
	end
end

function badSection(v)
	local s = v[1]

	return s == "Select" or s == "Cred" or s == "Rem" or s == "Cmp"
end

function getContent(v)
	return v:getContent()
end

--need to write file i/o functions to deal with html files
--write a tonumber that considers "" to be 0

--works perfectly
test = { course = HtmlDoc(data(class2)), _class = HtmlDoc(data(course)) }

out("Hello")

-- work on data mining functionality
-- 	docType - what class type does the document define

data = {
	-- need to get course number
	-- you cannot get course number from the course page
	-- you can match with the course title if necessary
	course = test.course:node(2):subNode(),
	_class = {
		desc = test._class:node(3),
		data = test._class:nodes(4)
	}
}

function makeCourse(course)
	local title = course:getContent()
	local t = table.map(table.map(course:subNodes(), getContent), function(v) return v:sep(":", true) end)		-- can combine these two
	t = table.removeIf(t, function(v) return v[1] == "" end)

	-- create Course here
	local c = Course(course:getContent(), t)

	return c, t
end

c, t = makeCourse(data.course)
out(c.title)
out(c.desc)

--table.print(makeCourse(data.course))

--Course(data.course:getContent(), test)


function makeClasses(classes)
	local ta = table.map(classes.desc:subNodes(), getContent)

	local t = table.map(classes.data, function(v) return table.map(v:subNodes(), getContent) end)
	t = table.map(t, function(v) return table.map(v, function(v, i) return { ta[i], v } end) end)
	-- might want to return { [ta[i]] = v }
	t = table.map(t, function(v) return table.removeIf(v, badSection) end)

	-- create Classes here
	return t
end

--typeFile(makeClasses(data._class), file)
--table.print(makeClasses(data._class)[1])

--Class(test[1])



-- integrate with respective classes

out("done")
--file:close()
