
table.unpack = unpack


table.compact = function(t, recurse)
	local i = 1

	for k in pairs(t) do
		t[i] = t[k]

		if type(t[i]) == "table" and recurse then
			table.compact(t[i], recurse)
		end

		if k ~= i then
			t[k] = nil
		end

		i = i + 1
	end
end


-- currently assumes an array is given
-- creates a table at t[idx1] filled with the contents from t[idx1] to t[idx2 - 1]
table.condense = function(t, range, keepNils)
	local loc, tmp = range(), {}

	for i in range do
		if t[i] or keepNils then
			tmp[#tmp + 1] = t[i]
			t[i] = nil
		end
	end

	if #tmp ~= 0 then
		t[loc] = { t[loc], table.unpack(tmp) }
	end
end


-- need to write so I'm guaranteed that compact and recurse do what they're supposed to
-- don't technically need a recursion flag (for static depth), you can call table.map within f 
table.map = function(tbl, f, compact, recurse)
	local r, t = recurse and true or nil, {}

	for k, v in pairs(tbl) do
		t[k] = f(v, k)

		if type(t[k]) == "table" and type(v) == "table" and r then
			t[k] = table.map(v, f, compact, r)
		end
	end

	if compact then table.compact(t) end

	return t
end


table.foreach = function(tbl, range, f, compact, recurse)
	local t = {}

	-- make sure range is valid

	for i in range do
		t[i] = f(tbl[i])		
	end

	if compact then table.compact(t) end

	return t
end


table.removeIf = function(t, test)
	return table.map(t, function(v) if not test(v) then return v end end)
end
