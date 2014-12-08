require "Scripts/Structures/Time"

function badSection(v)
	local s = v[1]

	return s == "Select" or s == "Cred" or s == "Rem" or s == "Cmp"
end


class "Section"

function Section:Section(data)
	table.map(data, function(v) self[v[1]:lower()] = handleSectionData(v[1], v[2]) end)

	-- Days
	-- Fee
	-- Time
	-- Location
	-- Act / Cap

	self.date, self["date (mm/dd)"] = self["date (mm/dd)"], nil
end

function Section:open()
	return self.cap - self.act
end

function Section:where()
	if type(self.location[1]) == "number" then
		self.location[1] = mtu.Buildings[self.location[1]]
	end

	table.concat(self.location, " ")
end

-- not entirely accurate (labs can be different classes)
function Section:type()
	return self.sec:find("R") and "Recital" or self.find("L") and "Lab" or "Lecture"
end

function Section:block()
	return table.unpack(self.Time)
end

function Section:days()
	return self.Days
end

function Section:course()
	if not self._course then
		self._course = self.subj .. " " .. self.crse
	end

	return self._course, self.title
end

function Section:__eq(sect)
	if type(sect) == "Section" then
		return self:course() == sect:course() and self.title == sect.title 
	elseif type(sect) == "string" then
		return sect:match("[^%d]*(%d*)") == self.CRN
	else
		return false
	end
end



function makeSections(classes)
	local ta = table.map(classes.desc:subNodes(), getContent)

	local t = table.map(classes.data, function(v) return table.map(v:subNodes(), getContent) end)
	t = table.map(t, function(v) return table.map(v, function(v, i) return { ta[i], v } end) end)	-- table.generate
	return table.map(t, function(v) return Section(table.removeIf(v, badSection)) end)	--return t
end

function handleSectionData(key, val)
	if key == "Act" or key == "Cap" then
		return val:remove("&nbsp;")

	elseif key == "Location" then
		return val:sep(" ", true)

	elseif key == "Time" then
		return makeTime(val:sep("-", true))

	elseif key == "Date (MM/DD)" then
		return makeDays(val:sep("-", true))

	elseif key == "Fee" then
		return tonumber(val)

	elseif key == "Days" then
		return table.removeIf(val:sep("."), function(v) return v == "" end)
	end

	return val
end
