require "Scripts/Structures/Course"

class "Degree"

function Degree:Degree()
	-- General Education Requirements
end


class "Major" (Degree)

function Major:Major(title)
	Degree.Degree(self)

	self.title = title
	-- Major Specific Requirements
end


class "Minor" (Degree)

function Minor:Minor(title)
	Degree.Degree(self)

	self.title = title
	-- Minor Specific Requirements
end
