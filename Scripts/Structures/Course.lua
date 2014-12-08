require "Scripts/Structures/Requirements"

class "Course"

function Course:Course(title, data)
	self.title = title

	if data then
		self.desc = data[1][1]

		self.credits = table.generate(table.removeIf(data, siftCredits), function(v) return v[2]:substr(2) end, function(i, v) return v[1] end)

		self.requirements = Requirement(table.removeIf(data, siftReqs))
	end
end

function Course:__eq(c2)
	if type(c2) == type(self) then		-- might want to change to allow comparisons with Section
		return self.title == c2.title or self.course == c2.title or self.course == c2.course
	end
end

function Course:creditHours()
	if type(self.credits.Credits) == "string" then
		self.credits.Credits = tonumber(self.credits.Credits)
	end

	return self.credits.Credits
end

function Course:getSplit()
	if not self.split then
		local s = { "Lec", "Rec", "Lab" }
		self.split = table.generate(self.credits["Lec-Rec-Lab"]:substr(2, -2):sep("-", true), function(v) return tonumber(v) end, function(i) return s[i] end)
	end

	return self.split
end

function Course:glean(classes)
	self.course = classes[1]:course()
end

function Course:studentMeetsRequirements(student)
	return student:passes(self.requirements)
end

function Course:dependsOn(course)
	if type(course) == "Course" or type(course) == "Section" then
		course = course:course()
	end

	return table.findIn(self.requirements:prereqs(), course) or table.findIn(self.requirements:coreqs(), course)
end



function makeCourse(course)
	local title = course:getContent()
	local t = table.map(table.map(course:subNodes(), getContent), function(v) return v:sep("[:;]", true) end)

	return Course(course:getContent(), table.removeIf(t, function(v) return v[1] == "" end))
end


function siftCredits(v)
	return not (v[1] == "Credits" or v[1] == "Lec-Rec-Lab")
end
