
-- rename sep and split
function string.sep(str, pattern, exclusive, output)
	local out, excl, start = output or {}, exclusive and 1 or 0, 1

	local splitStart, splitEnd = str:find(pattern)

	while splitStart do
		out[#out + 1] = str:sub(start, splitStart - excl)
		start = splitEnd + 1
		splitStart, splitEnd = str:find(pattern, start)
	end

	out[#out + 1] = str:sub(start)
	return out
end

function string.split(str, pattern, output)
	local out = (output or {})

	for w in str:gfind(pattern) do
		out[#out + 1] = w
	end

	return out
end

function string.trim(str)
	local from = str:match("^%s*()")
	return from > #str and "" or str:match(".*%S", from)
end

function string.remove(str, pattern)
	return str:gsub(pattern,"")
end

function string.substr(str, i, j)
	return string.sub(str, i or 1, j)
end

function string.length(str)
	return str:len()
end


getmetatable("").__index = function(str, i)
	if type(i) == "number" then
		return string.sub(str, i, i)
	else
		return string[i]
	end
end


--[[

lua-users.org/wiki/ValidateUnicodeString

--]]
