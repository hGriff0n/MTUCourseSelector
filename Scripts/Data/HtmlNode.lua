class "HtmlNode"

function HtmlNode:HtmlNode(html)
	self.html = html

	local str

	if type(self.html) == "table" then
		str = self.html[1]
		self.html[1] = nil
		table.compact(self.html)

	else
		str = self.html
	end

	self.tag, self.content, self.token, self.attr = table.unpack(parseTag(str))
end

function HtmlNode:getAttr()
	return self.attr
end

function HtmlNode:getToken()
	return self.token
end

function HtmlNode:getTag()
	return self.tag
end

function HtmlNode:getContent()
	return self.content and self.content or self.tag
end

function HtmlNode:subNodes(r)		-- same question as HtmlDoc:subNode
	if self.html then
		if type(r) ~= "function" then r = range(r or 1, #(self.html)) end

		local t = {}

		for i in r do
			t[#t + 1] = HtmlNode(self.html[i])
		end

		return t
	end
end

function HtmlNode:subNode(n)
	if type(self.html) == "table" then
		return HtmlNode(self.html[n or 1])
	end
end

-- [1] = tag, [2] = content, [3] = token, [4] = attr
-- change to put all attr into a table (not necessary)
function parseTag(str)
	local t = str:sep("> *")

	if #t ~= 2 then
		if t[1]:find(">") then
			t[2] = ""
		else
			t[1], t[2] = "", t[1]
		end
	end

	t[#t + 1] = str:sub(2, str:find("[ >]") - 1)

	for i, v in ipairs(str:split(" [^>]*>")) do
		t[#t + 1] = v:substr(2, -2)
	end
	
	--table.condense(t, range(4, #t + 1))

	return t
end
