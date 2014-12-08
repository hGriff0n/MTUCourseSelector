--require "Scripts/InProgress/Schedule"

class "Student"

function Student:Student(name, username, password)
	self.name = name or ""
	--self.pic = ""
	self.username = username or ""
	self.password = password or ""
	self.credits = 0
	self.major = nil
	self.minors = { }
	self.certs = nil

	self.taking = Schedule()
	self.taken = { }
	self.plans = { }

	self.handle = function(self, key, value)
		local fails = nil

		if key == "minor" then
			self:addMinor(value)
		elseif key == "major" then
			self:addMajor(value)
		elseif key == "certs" then
			self:addCertificate(value)
		elseif key == "taking" then
			self.taking, fails = Schedule.constructFrom(value:split("%"))
		elseif key == "plan" then
			self.plans[#self.plans + 1], fails = Schedule.constructFrom(value:split("%"))
		elseif key == "taken" then
			for _, crse in ipairs(value:split("%")) do
				self.taken[#self.taken + 1] = crse
			end
		elseif key == "credits" then
			self.credits = tonumber(value)
		else
			self[key] = value
		end

		return fails
	end

	self.locate = function(t, value)
		for i, v in ipairs(t) do
			if v == value then
				return i
			end
		end
	end
end

function Student.constructFrom(attrList)
	local student, failures = Student(), {}

	for _, attr in pairs(attrList) do
		failures = table.append(failures, student:handle(table.unpack(attr:split(": "))))
	end

	return student
end

-- returns the list of where the student does not meet the requirements
function Student:passes(reqs)
	local t = table.append(nil, table.unique(reqs:prereqs(), self.taken))
	t = table.append(t, table.unique(reqs:coreqs(), table.append(self.taken, self.taking:courses())))

	t[#t + 1] = reqs:rightClass(self.credits)
	t[#t + 1] = reqs:rightMajor(self.major)

	return table.append(t, reqs:testOther(self))
end

-- returns the list of all degrees student is attempting
function Student:degreeList()
	return {
		majors = self.majors,
		minors = self.minors,
		certificates = self.certs
	}
end

-- Minor interaction functions
function Student:addMinor(minor)
	local minor = (system.type(minor) == "Minor" and minor.info.title or minor)

	if type(minor) == "string" then
		self.minors[#self.minors + 1] = minor
	end
end

function Student:removeMinor(minor)
	local minor = (system.type(minor) == "Minor" and minor.info.title or minor)

	if table.findIn(self.minors, minor) then
		local where = self.locate(self.minors, minor)
		self.minors[where], self.minors[#self.minors] = self.minors[#self.minors]
	end
end

-- Major interaction functions
function Student:addMajor(major)
	local major = (system.type(major) == "Major" and major.info.title or major)

	if self.major then
		if type(self.major) ~= "table" then
			self.major = { self.major }
		end

		self.major[#self.major + 1] = major
	else
		self.major = major
	end
end

function Student:changeMajor(major)
	self.major = (system.type(major) == "Major" and major.info.title or major)
end

function Student:dropMajor(major)
	local major = (system.type(major) == "Major" and major.info.title or major)

	if type(self.major) == "string" then
		if self.major = major then
			self.major = nil
		end
	elseif type(self.major) = "table" then
		if table.findIn(self.major, major) then
			local where = self.locate(self.major, major)
			self.major[where], self.major[#self.major] = self.major[#self.major]
		end
	else
		return "Sorry, Dave. I can't do that."
	end
end

-- Certificate interaction functions
	-- If I ever add certificates
function Student:addCertificate(cert)
	return "Sorry, Dave. I can't do that."
end

function Student:dropCertificate(cert)
	return "Sorry, Dave. I can' do that."
end

-- Plan interaction functions
function Student:nextPlan()
	self.selected = self.selected + 1
	
	if self.selected > #self.plans then
		self.selected = 1
	end
end

function Student:prevPlan()
	self.selected = self.selected - 1
	
	if self.selected < 1 then
		self.selected = #self.plans
	end
end

function Student:newPlan()
	self.plans[#self.plans + 1] = Schedule()
	self.selected = #self.plans
end

function Student:getCurrentPlan()
	return self.plans[self.selected]
end

-- Updating student and the real world functions
function Student:register()
	return table.unpack(self.plans[self.selected]:crns())
end

function Student:newSemester()
	local courses = self.taking:courses()

	self.credits = self.credits + table.reduce(courses, function(n, v) return n + credits(v) end)
	--self.past = table.append(self.past, self.taking)
	self.taken = table.append(self.taken, courses)

	self.taking = self.plans[self.selected]
	self.plans = { Schedule() }
	self.selected = 1
end

-- Various other functions
function Student:addCreditFor(cred)
	self.taken = table.append(self.taken, mtu.degrees.getCredit(cred))
end

function Student:login(password)
	return self.password == password
end
