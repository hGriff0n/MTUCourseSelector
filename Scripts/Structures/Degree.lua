class "Major"

-- add accessors like "name", etc. that interact with the info block
--[[
function Major:name()
	return system.type(self) .. " in " .. self.info.title .. (self.conc and (" with a focus in " .. self.concentrations[self.conc].info.title) or "")
end
--]]

function Major:Major(desc, genEds)
	self.info, desc.info = desc.info
	self.core, desc.core = desc.core
	self.restrict, desc.restrict = desc.restrict

	if not mtu.degrees.majors.genEds then
		mtu.degrees.majors.genEds = 2
		mtu.degrees.majors.genEds = Major(mtu.degrees.majorDesc.genEds, Major.noGenEds)
	end
	self.genEds = genEds or mtu.degrees.majors.genEds	

	self.concentrations = desc

	-- other stuff here ???
	self.testFocus = function(crses, flag)
		local comp, t = true, {}

		if flag then
			comp = true
			for _, v in pairs(self.concentrations) do
				local c, add = v(crses, flag)
				t = table.append(t, add)
			end
		elseif self.conc then
			comp, t = self.concentrations[self.conc](crses, flag)
		end

		return comp, t
	end

	self.completion = function(res)
		return table.reduce(res, function(n, v) return n + credits(v) end) > (self.info.credits or -1)
	end

end

function Major:setConcentration(conc)
	self.conc = conc
end

function Major:test(crses, flag)
	if self.restrict and not flag then
		for i, v in ipairs(self.restrict) do
			local _, t = v(crses)
			crses = table.removeIf(crses, function(v) return table.findIn(t[3], v) end)
		end
	end

	local comp, tbl = self.core(crses, flag)
	local gComp, gTbl = self.genEds:test(crses, flag)
	local cComp, cTbl = self.testFocus(table.removeIf(crses, function(v) return table.findIn(tbl, v) or table.findIn(gTbl, v) end), flag)

	result = table.append(table.append(tbl, gTbl), cTbl)
	-- prettify the result ???

	if flag then return result end

	local iComp = self.completion(result)

	return (comp and gComp and cComp and iComp), result
end

function Major:meets()
	if not self.all then
		local tbl = self:test(mtu.courses.allCourses(), true)

		self.all = { }		
		for _, v in pairs(tbl) do
			self.all = table.append(self.all, v[2])
		end
	end

	return self.all
end

function Major:overlap(degree)
	return table.intersect(self:meets(), degree:meets())
end

function Major:info()
	return table.set(self.info, "concentration", self.concentrations[self.conc])
end

Major.noGenEds = {
	test = function() return true end
}


class "Minor" (Major)

function Minor:Minor(desc)
	Major.Major(self, desc, Major.noGenEds)
end

function Minor:setFocus(focus)
	Major.setConcentration(self, focus)
end

function Minor:test(crses, flag)
	return Major.test(self, crses, flag)
end

function Minor:meets()
	return Major.meets(self)
end

function Minor:overlap(degree)
	return Major.overlap(self, degree)
end

function Minor:info()
	return Major.info(self)
end
