require "Scripts/DegreeSpecParser"

-- just use the full names for genEds
local either = mtu.degrees.specs.either
local each = mtu.degrees.specs.each
local level = mtu.degrees.specs.level
local exclude = mtu.degrees.specs.exclude
local select = mtu.degrees.specs.select
local limit = mtu.degrees.specs.limit
local wrap = mtu.degrees.specs.eachT

-- where do I store hass ???
hass = {
	all = {
		"BL 3970", "EC 2001", "EC 3002", "EC 3003", "EC 3100", "EC 3300", "EC 3400", "EC 4050", "EC 4500", "EC 4620", "EC 4630", "GE 4630", "EC 4640", "EC 4650", "EC 4710", "ED 3110", "EH 3010",
		"ENT 4954", "FA 2112", "FA 2222", "FA 2300", "FA 2330", "FA 2500", "FA 2520", "FA 2820", "FA 3133", "FA 3300", "FA 3330", "FA 3340", "FA 3530", "FA 3550", "FA 3560", "FA 3625", "FA 3630",
		"FA 3810", "FA 3821", "FA 3830", "FW 3760", "SSW 3760", "HU 2110", "HU 2130", "HU 2201", "HU 2202", "HU 2241", "HU 2242", "HU 2271", "HU 2272", "HU 2273", "HU 2281", "HU 2282", "HU 2291",
		"HU 2292", "HU 2293", "HU 2324", "HU 2400", "HU 2501", "HU 2505", "HU 2520", "HU 2538", "HU 2540", "HU 2548", "HU 2700", "HU 2701", "HU 2702", "HU 2820", "HU 2910", "HU 2920", "HU 3110",
		"HU 3130", "HU 3150", "HU 3151", "HU 3201", "HU 3202", "HU 3204", "HU 3241", "HU 3242", "HU 3253", "HU 3261", "HU 3262", "HU 3263", "HU 3264", "HU 3265", "HU 3271", "HU 3272", "HU 3273",
		"HU 3274", "HU 3275", "HU 3280", "HU 3281", "HU 3282", "HU 3283", "HU 3284", "HU 3285", "HU 3291", "HU 3292", "HU 3293", "HU 3294", "HU 3295", "HU 3325", "HU 3326", "HU 3400", "HU 3401",
		"HU 3501", "HU 3502", "HU 3504", "HU 3510", "HU 3513", "HU 3517", "HU 3540", "HU 3541", "HU 3545", "HU 3554", "HU 3555", "HU 3556", "HU 3621", "HU 3700", "HU 3701", "HU 3702", "HU 3710",
		"HU 3711", "HU 3800", "HU 3810", "HU 3820", "HU 3830", "HU 3840", "HU 3860", "HU 3871", "HU 3890", "HU 3910", "HU 3940", "HU 4271", "HU 4272", "HU 4273", "HU 4281", "HU 4282", "HU 4283",
		"HU 4291", "HU 4292", "HU 4293", "HU 4510", "HU 4625", "HU 4700", "HU 4701", "HU 4800", "HU 4850", "HU 4890", "IS 2001", "IS 3001", "MA 4945", "PSY 2000", "PSY 2400", "PSY 2600",
		"PSY 3010", "PSY 3030", "PSY 3040", "PSY 3070", "PSY 3720", "SS 3720", "PSY 3750", "PSY 3800", "PSY 3850", "PSY 3870", "PSY 4010", "SS 2100", "SS 2200", "SS 2400", "SS 2500", "SS 2501",
		"SS 2502", "SS 2503", "SS 2504", "SS 2505", "SS 2600", "SS 2610", "SS 2635", "SS 2700", "SS 3110", "SS 3200", "SS 3230", "SS 3240", "SS 3250", "SS 3260", "SS 3270", "SS 3300", "SS 3313",
		"SS 3315", "SS 3400", "SS 3410", "SS 3500", "SS 3505", "SS 3510", "SS 3511", "SS 3512", "SS 3515", "SS 3520", "SS 3521", "SS 3530", "SS 3540", "SS 3541", "SS 3552", "SS 3560", "SS 3561",
		"SS 3570", "SS 3580", "SS 3581", "SS 3600", "SS 3610", "SS 3612", "SS 3630", "SS 3630", "SS 3660", "SS 3661", "SS 3700", "SS 3710", "SS 3750", "SS 3800", "SS 3801", "SS 3820", "SS 3910",
		"SS 3920", "SS 3950", "SS 3951", "SS 3952", "SS 3960", "SS 3990", "SS 4001", "SS 4200", "SS 4210", "SS 4700", "UN 2900", "UN 3404", "UN 3900", "FA 2050", "FA 2150", "FA 2200", "FA 2305",
		"FA 2430", "FA 2580", "FA 2600", "FA 2610", "FA 3150", "FA 3200", "FA 3305", "FA 3333", "FA 3335", "FA 3360", "FA 3400", "FA 3401", "FA 3430", "FA 3510", "HU 2631", "HU 2632", "SS 3210",
		"AF 2001", "AF 2002", "AF 2010", "AF 2020", "AF 3001", "AF 3010", "AF 4001", "AF 4010", "AR 4001", "CM 3410", "ED 3510", "ED 3511", "ENT 2961", "ENT 2962", "ENT 3958", "ENT 3961",
		"ENT 3962", "FA 2080", "FA 2830", "GE 2100", "HU 2830", "HU 3120", "MGT 3100", "MGT 3650", "SS 3650", "PSY 3700", "SS 3640", "UN 2200", "UN 3200"
	}, creative = {
		"FA 2050", "FA 2150", "FA 2200", "FA 2305", "FA 2430", "FA 2580", "FA 2600", "FA 2610", "FA 3150", "FA 3200", "FA 3305", "FA 3333", "FA 3335", "FA 3360", "FA 3400", "FA 3401",
		"FA 3430", "FA 3510", "HU 2631", "HU 2632", "SS 3210"
	}, supplemental = {
		"AF 2001", "AF 2002", "AF 2010", "AF 2020", "AF 3001", "AF 3010", "AF 4001", "AF 4010", "AR 4001", "CM 3410", "ED 3510", "ED 3511", "ENT 2961", "ENT 2962", "ENT 3958", "ENT 3961",
		"ENT 3962", "FA 2080", "FA 2830", "GE 2100", "HU 2830", "HU 3120", "MGT 3100", "MGT 3650", "SS 3650", "PSY 3700", "SS 3640", "UN 2200", "UN 3200"
	}
}

-- General major definitions
mtu.degrees.majorDesc.genEds = {
	info = {
	}, core = wrap{			  			-- mtu.courses.languages ???
		"UN 1015", either("UN 1025", select(1).classes.from(level(mtu.degrees.languages, 3000)), each("UN 1003", either({}))),
		select(3).credits.from("FA 2330", "FA 2520", "FA 2720", "FA 2820", "HU 2130",
								"HU 2501", "HU 2538", "HU 2700", "HU 2820", "HU 2910"),
		select(3).credits.from("EC 2001", "PSY 2000", "SS 2100", "SS 2200", "SS 2400", "SS 2500",
								"SS 2501", "SS 2502", "SS 2503", "SS 2504", "SS 2505", "SS 2600", "SS 2700"),
		select(6).credits.from(hass.all), select(6).credits.from(level(hass.all, 3000)),		-- possible problem: { "SS 3960", "SS 4001" }	Will this match the test ???
		select(3).credits.from(mtu.degrees.depCourses("PE"))
	}, restrict = {
		limit.credits(hass.supplemental, 3),
		limit.credits(hass.creative, 3)
	}
}
