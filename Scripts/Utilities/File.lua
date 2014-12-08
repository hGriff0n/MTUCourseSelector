
filepath = "C:/Users/Grayson/Documents/Polycode/CourseSelector/"

function readAll(loc, sifter)
	local sift, t = fileExtension(sifter or ""), {}

	for file in directory(loc, sift) do
		local input = io.open(loc .. "/" .. file, "r")
		t[#t + 1] = input:read("*a")
		input:close()
	end

	return t
end

function allFiles(directory)
	local t = {}

	for file in io.popen([[dir "]] .. directory .. [[" /b]]):lines() do
		t[file] = true
	end

	return t
end

-- directory iterator
function directory(loc, sifter)
	local sift = sifter and function(v, i) return not sifter(i) end or function() end
	return pairs(table.removeIf(allFiles(loc), sift))
end

-- directory sifters
function fileExtension(ext)
	return function(file) return file:find(ext) end
end

table.toFile = function(t, file, mode)
	local f = io.open(file, mode or "w")

	f:write(table.tostring(t):gsub("[\n]+", "\n"))

	f:close()
end
