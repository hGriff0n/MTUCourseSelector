
function translateBanwebShorthand(short)
	if short == "Electrical & Computer Engrg" then
		return "Electrical & Computer Engineering"
	elseif short == "Electrical Engrg Technology" then
		return "Electrical Engineering Technology"
	elseif short == "Kinesiology/Integ Physiology" then
		return "Kinesiology and Integrative Physiology"
	elseif short == "Forest Resources & Env Science" then
		return "Forest Resources & Environmental Science"
	elseif short == "Geolog. & Mining Engrg & Sci." then
		return "Geological & Mining Engineering & Sciences"
	elseif short == "Mechanical Eng. - Engrg. Mech." then
		return "Mechanical Engineering - Engineering Mechanics"
	elseif short == "Mechanical Engrg Technology" then
		return "Mechanical Engineering Technology"
	elseif short == "Materials Science & Engrg" then
		return "Materials Science & Engineering"
	elseif short == "Operations & Supply Chaim Mgmt" then
		return "Operations & Supply Chain Management"
	elseif short == "Systems Admin. Technology" then
		return "Systems Administration Technology"
	else
		return short
	end
end
