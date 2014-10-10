require "Scripts/Utilities/File"
require "Scripts/Utilities/Output"
require "Scripts/Utilities/String"
require "Scripts/Utilities/Table"

range = function(i, to, inc)
	if not i then return end

	if not to then
		to = i
		i = to == 0 and 0 or (to > 0 and 1 or -1)
	end

	inc = inc or (i < to and 1 or -1)

	i = i - inc

	return function()
				if i == to then return nil end
				i = i + inc
				return i, i --return i, inc
		   end
end
