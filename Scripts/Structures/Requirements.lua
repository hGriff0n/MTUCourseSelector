require "Scripts/Structures/Various"

class "CourseReq"

function CourseReq:CourseReq(...)
	self.courses = { ... }
end

function CourseReq:contains(course)
	local department = course.department or course[1]
	local number = course.number or course[2]

	for dep, num in pairs(self.courses) do
		if dep == department and num == number then
			return true
		end
	end

	return false
end


class "Requirement"

function Requirement:Requirement(pre, co, enrollment_level, semester, year_cond, major, skip)
	self.pre_requisites = self.parseRequirement(pre)
	self.co_requisites = self.parseRequirement(co)

	self.enrollment = Credits[enrollment_level] or enrollment_level
	self.semester = semester
	self.year = year_cond

	self.major = major
	self.skip_condition = skip
end

function Requirement.parseRequirement(courses)
	local tmp = {}

	for course in ipairs(course) do
		if type(course) == "table" then
			tmp[#tmp + 1] = CourseReq(table.unpack(course))
		else
			tmp[#tmp + 1] = course
		end
	end

	return tmp
end

function getRequirements(course, reqs)

end
