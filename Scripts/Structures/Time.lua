
class "Time"

function Time:Time(str)
	if type(str) == "string" then
		self.hour = str:match("%d%d")
		self.min = str:match(":(%d%d)")
		self.pm = str:match("[ap]m")
	elseif type(str) == "Time" then
		self = str
	end
end

function Time:between(t1, t2)
	
end

function makeTime(t)
	return table.map(t, function(v) return Time(v) end)
end


class "Date"

function Date:Date(str)
	if type(str) == "string" then
		self.month = str:match("%d%d")
		self.day = str:match("/(%d%d)")
	elseif type(str) == "Date" then
		self = str
	end
end

function makeDays(t)
	return table.map(t, function(v) return Date(v) end)
end
