if not mtu then mtu = {} end

function docType(htmldoc)
	if htmldoc:find("<br>") then
		return "Course"
	else
		return "Section"
	end
end

-- this function calls table.map 19 times !!!
function dataMine(directory, book)
	local d = table.map(readAll(directory, ".html"), function(v) return HtmlDoc(data(v)) end)

	table.map(table.removeIf(d, function(v) return docType(v) == "Section" end), function(v) book.register(makeCourse(v:node(2):subNode())) end)
	table.map(table.removeIf(d, function(v) return docType(v) == "Course" end), function(v) book.assign(makeSections{desc = v:node(3), data = v:nodes(4) }) end)
	
	--store reference to key in associated table ???
end

mtu.courses = {
	assign = function(classes)
		courses[classes[1].title] = classes
	end,
	register = function(course)
		if type(course) == "Course" then -- if complete(course, "Course")
			rawset(courses, course, true)
		end
	end,
	course = function(crse)			-- can store "reference" to the key in the value table (but how? and for what?)
		crse = Course(crse)			-- course lookup: courses.course("Data Structures") -> courses["Data Structures"].course

		for k in pairs(courses) do
			if k == crse then
				return k
			end
		end
	end,
	allCourses = function()
		return table.map(courses, function(v, i)
			if type(i) == "Course" then
				return i.course
			end
		end)
	end,
}

mt = {
	__index = function(tbl, key)
		if type(key) == "Course" then -- or type(key) == "Section" then
			for k in pairs(tbl) do
				if k == key then return tbl[k] end
			end

		elseif type(key) == "Section" then
			return tbl[Course(key.title)]

		elseif type(key) == "string" then
			return tbl[Course(key)]
		end
	end,
	__newindex = function(tbl, key, val)
		if type(key) == "string" then
			key = Course(key)

			for k in pairs(tbl) do
				if k == key then
					k:glean(val)
					tbl[k] = val
				end
			end				

		elseif type(key) == "Course" and key.desc then
			for k in pairs(tbl) do
				if k == key then
					k:glean(val)
					tbl[k] = val
					return
				end
			end

			if type(val) == "Section" then
				key:glean(val)
			end

			rawset(tbl, key, val)
		end
	end
}

setmetatable(mtu.courses, mt)
