
filepath = "C:/Users/Grayson/Documents/Polycode/CourseSelector/"

function open(filename)
	return io.open(filename, "r")
end

--fileExists

-- rename ???
function wipe(filename)
	io.open(filename, "w"):close()
end

-- lua-users.org/wiki/IoLibraryTutorial
function read(file)
	return file:read()
end
