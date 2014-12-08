require "Scripts/Utilities/File"
require "Scripts/Utilities/Output"
require "Scripts/Utilities/Overloads"
require "Scripts/Utilities/String"
require "Scripts/Utilities/Table"
require "Scripts/Utilities/Various"

range = function(i, to, inc)
	if not i then return end

	if not to then
		to = i
		i = to == 0 and 0 or (to > 0 and 1 or -1)
	end

	local abs = function(x) return x < 0 and -x or x end		-- for some reason math.abs is sometimes nil ???

	inc = inc or (i < to and 1 or -1)

	i = i - inc

	local s = (to - i) / abs(to - i)

	return function()
				i = i + inc

				if (s * (to - i)) ~= abs(to - i) then return nil end

				return i, i --return i, inc
		   end
end
