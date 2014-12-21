require "Scripts/HTML/HtmlDoc"
require "Scripts/Curry"
require "Scripts/Constants"

require "Scripts/Structures/Course"
require "Scripts/Structures/Section"
require "Scripts/DataMine"

require "Scripts/Utilities/Utils"

-- rework the file structure
	-- put the course/section stuff into a sub-folder
	-- put the course descriptions into another sub-folder
-- dataMine(filepath .. "Data", mtu.courses)
	-- make sure that no "dead" courses exist as requirements


-- require "Data/Degrees"
-- require "Scripts/Structures/Degree"

-- parseDegrees(mtu.degrees.majorDesc, mtu.degrees.majors)
-- parseDegrees(mtu.degrees.minorDesc, mtu.degrees.minors)
	-- need to make the parseDegrees function (also could i do the parsing so that i don't have to have the genEds check in Major ???)

--require "Scripts/InProgress/Student"

scene = Scene(Scene.SCENE_2D)
scene.rootEntity.snapToPixels = true

-- CREATE FUNCTION STRUCTURE FOR DEGREE CLASSES (PLACEHOLDERS IN COURSE DESCS)
	-- replace type with system.type
	-- mtu.degrees.depElectives = function(dep) end
	-- mtu.degrees.depCourses = function(dep) end
	-- mtu.degrees.techElectives = function(dep) end
	-- mtu.degrees.languages = {}
	-- mtu.degrees.getCredit = function(cred) end
	-- mtu.degrees.labSciences = {}
	-- determining class level in DegreeSpecParser
	-- WHAT WILL THEY DO, HOW ARE THEY CALLED, HOW WILL THEY WORK

-- FIGURE THE ABSOLUTE MINIMUM INFORMATION I NEED TO WORK WITH
	-- The information necessary for communication and not display

-- CHANGE DATA MINE TO PUT THE COURSE AND CLASSES UNDER THE COURSE NUMBER
	-- ie. ["CS 1131"] = { course = Course, sections = { Section() } }

-- CODE CLEAN-UP
	-- Focus on Utilities/Table
	-- Also work on function naming


-- SYSTEMS I HAVE
	-- HTML parser
	-- Course Class (Need to add accessors)
	-- Section Class (Need to add accessors)
	-- Requirement Class (Need to implement the testers)
	-- Degree Description
	-- Degree Tester Classes
	-- Student class

-- SYSTEMS I NEED
	-- Schedule class (Prelimary work done)
	-- Advanced Search/Filter Facilities
		-- Pair down the data to what I absolutely need
	-- Robust input handling
	-- Error Handling mechanism

	-- MOVED TO COURSESELECTORGUI
		-- Pop-up/Helper functions
		-- Display system
		-- Grid Schedule framework (with Time/Date integration)


-- FUTURE SYSTEMS TO WORK ON
	-- PREREQ TRACKER: A way to iterate through a courses prereqs
		-- Could be extended to a visual web in the ui
	-- STUDENT: Getting information, Handling Special cases, etc.
	-- SELECT: A way to search the course list

-- NEED TO DELAY THE CONSTRUCTION OF THE DEGREES UNTIL AFTER ALL THE FILES HAVE BEEN PARSED AND THE COURSE STRUCTURE CREATED

-- WHAT IF THE SCHOOL CHANGES THE COURSE TIMES AND STUDENTS SCHEDULES NOW ARE IN CONFLICT ???

-- (possible) problem with matches from another block
	-- pass a list of courses not to use ???
-- also need to keep unmatched tags in sub ???

-- problems with computability
	-- im using "algebra" to put the restriction in traits and derive it in [1]

-- download the actual html files to Data
	-- need to copy-paste html for classes since banweb sucks

-- work on selection functions


-- add "long-term" view ???

out("done")
