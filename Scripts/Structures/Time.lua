
class "Time"

function Time:Time(hour, min, pm)
	if type(hour) == "string" then
		self:toTime(hour)
	elseif type(hour) == "Time" then
		self = Time.fromString(hour)
	else
		self.hour = hour
		self.min = min
		self.pm = pm
	end
end

function Time.toTime(time, str)
	
end

function Time.fromString(str)
	
end

--to24 and to12 functions unnecessary for program's use


class "Date"

function Date:Date(month, day, year)
	self.month = month
	self.day = day
	self.year = year
end
