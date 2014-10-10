require "Scripts/Structures/Course"

class "Class"

function Class:Class(course, crn, sec, left, days, time_slot, location, instructor)
	self.course = course
	self.section = sec

	self.crn = crn
	self.space_left = left

	self.instructor = { name = instructor }
	self.location = location
	self.days = daysOfTheWeek(days)
	self.time = time_slot

	self.campus = 1
end

function Class:isLab()
	return self.section[1] == 'l'
end
