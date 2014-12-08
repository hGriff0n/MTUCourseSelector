
-- holds all data and functions necessar to ensure program stability (move later)
if not system then system = {} end

system.ensureLocation = function(location, screen)

end

-- holds all data and functions necessary to perform the program's objective
mtu = {
	degrees = {
		minorDesc = {},
		majorDesc = {},
		minors = {},
		majors = {}
	},

	Semester = {
		Fall = 1,
		Spring = 2,
		Summer = 3
	},

	Credits = {
		Freshman = 0,
		Sophmore = 1,
		Junior = 2,
		Senior = 3,
		Graduate = 4
	},

	Day = {
		Sunday = 1,
		Monday = 2,			M = 2,
		Tuesday = 3,		   T = 3,
		Wednesday = 4,		 W = 4,
		Thursday = 5,		  R = 5,
		Friday = 6,			F = 6,
		Saturday = 7
	},

	-- What's the MEEM number ???
	Buildings = {
		[1] = "Administration Building",
		[4] = "ROTC Building",
		[5] = "Academic Office Building",
		[7] = "EERC",
		[8] = "DOW",
		[9] = "Alumni House",
		[10] = "Rosza Center",
		[11] = "Walker",
		[12] = "MME Building",
		[13] = "Hamar House",
		[14] = "Dillman Hall",
		[15] = "Fisher Hall",
		[16] = "Widmaier House",
		[17] = "Library",
		[18] = "Forestry Building",
		[19] = "CSE Building",
		[20] = "RL Smith Building",
		[24] = "SDC",
		[25] = "Sherman Field",
		[28] = "Rekhi Hall",
		[31] = "DHH",
		[32] = "Daniel Heights",
		[34] = "MUB",
		[37] = "Wadsworth",
		[38] = "West McNair",
		[40] = "East McNair",
		[50] = "Gates Tennis Center",
		[51] = "OAP House",
		[82] = "Honors House",
		[84] = "Harold Meese Center"
	},

	Departments = {
		["Accounting"] = "ACC",										ACC = "Accounting",
		["Air Force ROTC"] = "AF",									 AF = "Air Force ROTC",
		["Army ROTC"] = "AR",										  AR = "Army ROTC",
		["Atmospheric Science"] = "ATM",							   ATM = "Atmospheric Science",
		["Biochem & Molecular Biology"] = "BMB",					   BMB = "Biochem & Molecular Biology",
		["Biomedical Engineering"] = "BE",							 BE = "Biomedical Engineering",
		["Biological Sciences"] = "BL",								BL = "Biological Sciences",
		["Business"] = "BUS",										  BUS = "Business",
		["Business Administration"] = "BA",							BA = "Business Administration",
		["Civil Engineering"] = "CE",								  CE = "Civil Engineering",
		["Chemistry"] = "CH",										  CH = "Chemistry",
		["Chemical Engineering"] = "CM",							   CM = "Chemical Engineering",
		["Construction Management"] = "CMG",						   CMG = "Construction Management",		
		["Computer Science"] = "CS",								   CS = "Computer Science",
		["Computational Science & Engr"] = "CSE",					  CSE = "Computational Science & Engr",
		["Economics"] = "EC",										  EC = "Economics",
		["Education"] = "ED",										  ED = "Education",
		["Electrical & Computer Engineering"] = "EE",				  EE = "Electrical & Computer Engineering",
		["Electrical Engineering Technology"] = "EET",				 EET = "Electrical Engineering Technology",
		["Kinesiology and Integrative Physiology"] = "EH",			 EH = "Kinesiology and Integrative Physiology",
		["Engineering Fundamentals"] = "ENG",						  ENG = "Engineering Fundamentals",
		["Enterprise"] = "ENT",										ENT = "Enterprise",
		["Environmental Engineering"] = "ENVE",						ENVE = "Environmental Engineering",
		["English as a Second Language"] = "ESL",					  ESL = "English as a Second Language",
		["Visual and Performing Arts"] = "FA",						 FA = "Visual and Performing Arts",
		["Finance"] = "FIN",										   FIN = "Finance",
		["Forest Resources & Environmental Science"] = "FW",		   FW = "Forest Resources & Environmental Science",
		["Geological & Mining Engineering & Sciences"] = "GE",		 GE = "Geological & Mining Engineering & Sciences",
		["Humanities"] = "HU",										 HU = "Humanities",
		["Mathematical Sciences"] = "MA",							  MA = "Mathematical Sciences",
		["Mechanical Engineering - Engineering Mechanics"] = "MEEM",   MEEM = "Mechanical Engineering - Engineering Mechanics",
		["Mechanical Engineering Technology"] = "MET",				 MET = "Mechanical Engineering Technology",
		["Management"] = "MGT",										MGT = "Management",
		["Management Information Systems"] = "MIS",					MIS = "Management Information Systems",
		["Marketing"] = "MKT",										 MKT = "Marketing",
		["Materials Science & Engineering"] = "MY",					MY = "Materials Science & Engineering",
		["Operations & Supply Chain Management"] = "OSM",			  OSM = "Operations & Supply Chain Management",
		["Physical Education"] = "PE",								 PE = "Physical Education",
		["Physics"] = "PH",											PH = "Physics",
		["Psychology"] = "PSY",										PSY = "Psychology",
		["Sciences and Arts"] = "SA",								  SA = "Sciences and Arts",
		["Systems Administration Technology"] = "SAT",				 SAT = "Systems Administration Technology",
		["Social Sciences"] = "SS",									SS = "Social Sciences",
		["Service Systems Engineering"] = "SSE",					   SSE = "Service Systems Engineering",
		["Surveying"] = "SU",										  SU = "Surveying",
		["Technology"] = "TE",										 TE = "Technology",
		["University Wide"] = "UN",									UN = "University Wide",
	},
}
