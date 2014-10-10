require "Scripts/Utilities/Utils"

function cleanHTMLTable(t)
	for i, v in ipairs(t) do
		t[i] = v:trim()
	end
	--t = table.map(t, function(v) return v:trim() end)
	
	removeEndTags(t)
	groupBR(t)

	table.compact(t)
end

function removeEndTags(t)
	local open = { }
	
	for i, v in ipairs(t) do
		if type(v) == "string" then
			if v[2] == "/" then
				if open[#open] and open[#open][1] == v:substr(3, -2) then
					table.condense(t, range(open[#open][2], i - 1))
					open[#open] = nil
				end

				t[i] = nil
			else
				open[#open + 1] = { v:substr(2, v:find("[ >]") - 1), i }
			end
		end
	end
end

-- moves all lines that begin with <br> into a table
function groupBR(t)
	for i, v in pairs(t) do
		local loc = i - 1
		if type(v) == "string" and v:find("<br>") then
			while t[i] ~= "<br>" do i = i + 1 end
			table.condense(t, range(loc, i))
			table.condense(t, range(loc - 1, loc))
		end
	end
end

-- removes unwanted sections
function removeUnwantedTags(str)
	return str:gsub("<A[^>]*>",""):gsub("</A[^>]*>",""):gsub("<b>",""):gsub("<I[^>]*>",""):gsub("<BR>",""):gsub("</FORM>",""):gsub("</b>","")
end

function parse(str)
	local t = str:split("%b<>[^<]*")

	cleanHTMLTable(t)

	return t
end

function data(str)
	local loc = str:find([===[<CAPTION class="captiontext">Sections Found</CAPTION>]===], 1, true)
	--<TABLE CLASS="plaintable" SUMMARY="This is table displays line separator at end of the page." WIDTH="100%" cellSpacing=0 cellPadding=0 border=0>]===],

	return removeUnwantedTags(str:substr(loc, str:find([===[<!-- ** START OF twbkwbis.P_CloseDoc ** -->]===], loc + 1, true) - 1):gsub("[\n\t]",""))
end
