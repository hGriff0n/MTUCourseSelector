require "Data/HtmlNode"
require "Data/parser"

-- move to Utilities/Table ???
	-- convert to table.map ???
function search(t, str)
	for i, v in ipairs(t) do
		if type(v) == "table" then
			local t = search(v, str)
			if t then
				return { i, (type(t) == "table" and table.unpack(t) or t) }
			end

		elseif type(v) == "string" then
			if v:find(str) then return i end

		else
			out(i)
		end
	end
end

class "HtmlDoc"

function HtmlDoc:HtmlDoc(htmlString)
	self.html = parse(htmlString)

	self.html = table.map(self.html, function(v)
							  	if type(v) == "string" then
							  		v = v:remove("<br> *")
							  		if v == "" then v = nil end
							  	end

							  	return v end, true)
end

function HtmlDoc:nodes(r)
	if type(r) ~= "function" then r = range(r or 1, #(self.html)) end
	--table.print(table.foreach(self.html, r, function(v) return HtmlNode(v) end))

	local t = {}

	for i in r do
		t[#t + 1] = HtmlNode(self.html[i])
	end

	return t
end

function HtmlDoc:node(n)
	return HtmlNode(self.html[n])
end

function HtmlDoc:find(str)
	--return table.map(self.html, function(v) end, false, true)
	return search(self.html, str)
end
