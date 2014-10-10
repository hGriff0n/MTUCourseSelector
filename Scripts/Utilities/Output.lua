
function out(str)
	local s = str or "nil"

	print(s)
end

function table.print(t, buffer)
	local buf = buffer or ""

	for k, v in pairs(t) do
		local str = buf .. "[" .. k .. "] = "
		if type(v) == "table" then
			out(str .. "{ ")
			table.print(v, buf .. " ")
		else
			out(str .. v)
		end
	end
end
