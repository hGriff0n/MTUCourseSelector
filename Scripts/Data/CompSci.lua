require "Data/InProgress/SpecParser"

local either = mtu.degrees.specs.either
local each = mtu.degrees.specs.each
local level = mtu.degrees.specs.level
local exclude = mtu.degrees.specs.exclude
local select = mtu.degrees.specs.select
local limit = mtu.degrees.specs.limit
local wrap = mtu.degrees.specs.eachT


-- Computer Science major definition
mtu.degrees.majorDesc.compSci = {
	info = {
		title = "Computer Science",
		credits = 123,
		degree = "BS",
		college = "College of Science" 	-- I don't actually know if this is right
	}, core = wrap{
		"CS 1000", "CS 1141", "CS 2311", "CS 2321", "CS 3000", "CS 3141", "CS 3311", "CS 3331",
		"CS 3411", "CS 3421", "CS 3425", "CS 4121", "CS 4321", "HU 3120", select(1).classes.from(level("CS", 4000)),    -- would level("CS", 4) more understandable ???
		either(each("CS 1121", "CS 1122"), "CS 1131"), select(1).classes.from("SS 3510", "SS 3511", 					-- should it be all("CS 1131") or just "CS 1131"
		"SS 3520", "SS 3530", "SS 3630", "SS 3640", "SS 3800", "SS 3801", "SS 3820", "HU 3701"), 					   -- select(1) is like either ???
		select(8).credits.from(mtu.degrees.labSciences), select(6).credits.from(mtu.degrees.techElectives("CS"))
	},		-- the free electives bit isn't defined because it is a catch-all area
}

-- Concentration definitions
mtu.degrees.majorDesc.compSci["Computer Science"] = {
	info = {
		title = "Computer Science",
	}, core = wrap{
		"MA 2160", "MA 2330", select(1).classes.from(level("CS", 4000)), either("MA 1160", "MA 1161"), either("MA 2720", "MA 3710"),
		select(3).credits.from(mtu.degrees.depElectives("MA")), select(3).credits.from(mtu.degrees.techElectives("CS"))
	}
}

mtu.degrees.majorDesc.compSci["Software Engineering"] = {
	info = {
	}, core = wrap{

	}
}
