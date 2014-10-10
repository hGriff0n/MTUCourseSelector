require "Scripts/Structures/Requirements"
require "Scripts/Utilities/String"

class "Course"

function Course:Course(course, credits, fee, dates, reqs)
	self.department, self.number = table.unpack(course[1]:split())

	self.title = course[2]
	self.description = course[3]

	self.credit_split = credits
	self.linked_lab = nil
	self.fee = fee

	self.date = dates

	self.requirements = getRequirements(course, reqs)
	self.other_data = {}
end

function Course:name()
	return self.department:upper() .. self.number
end
