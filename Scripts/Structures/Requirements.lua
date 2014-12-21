class "Requirement"

-- add accessor functions that do tests for the data that's not guaranteed to exist

function Requirement:Requirement(data)
	table.map(data, function(v) table.condense(v, range(2, #v)) self[reqKey(v[1])] = v[2] end)

	if self.restrictions and type(self.restrictions) ~= "string" then
		self.restrictions = table.generate(self.restrictions, function(v, i) if i % 2 ~= 0 then return { self.restrictions[i + 1]:trim(), v:find("not") and true or false } end end,
															  function(i, v) local k = v:sep(" ", true) return k[#k]:sep("%(", true)[1] end)
	end

	self.co = self.co and table.map(self.co:sep("and", true), function(v) return v:trim() end)			-- mtu.<>.ifExists(v:trim())
	self.pre = self.pre and table.map(self.pre:sep("and", true), function(v) return v:trim() end)
	self.semesters = self.semesters and self.semesters:remove(" "):sep(",", true)
end

function Requirement:coreqs()
	return self.co
end

function Requirement:prereqs()
	return self.pre
end

function Requirement:rightClass(credits)

end

function Requirement:rightMajor(majors)

end

function Requirement:testOther(student)

end


function reqKey(key)
	if key:find("[%- ]") then
		key = key:sep("[%- ]", true)[1]
	end

	return key:lower()
end

function siftReqs(v)
	local s = v[1]
	return not (s == "Restrictions" or s == "Semesters Offered" or s == "Pre-Requisite(s)" or s == "Co-Requisite(s)")
end
