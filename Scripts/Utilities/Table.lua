
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

--table.condenseIf ???


-- need to write so I'm guaranteed that compact and recurse do what they're supposed to
-- don't technically need a recursion flag (for static depth), you can call table.map within f 
table.map = function(tbl, f, compact, recurse)
	if type(tbl) == "table" then
		-- return table.foreach(tbl, pairs(tbl), f, compact, recurse and true or nil)
		local r, t = recurse and true or nil, {}

		for k, v in pairs(tbl) do
			t[k] = f(v, k)

			if type(t[k]) == "table" and type(v) == "table" and r then		-- kind of hacky (not sure about what behavior is desired
				t[k] = table.map(v, f, compact, r)
			end
		end

		if compact then table.compact(t) end

		return t
	else 
		table.map({ tbl }, f, compact, recurse)
	end
end

-- table.map over a specified range
table.foreach = function(tbl, range, f, compact, recurse)
	local t = {}

	-- make sure range is valid

	for i in range do
		t[i] = f(tbl[i], i)		
	end

	if compact then table.compact(t) end

	return t
end


table.removeIf = function(t, test)
	return table.map(t, function(v, i) if not test(v, i) then return v end end)
end

table.selectIf = function(t, test)
	return table.map(t, function(v, i) if test(v, i) then return v end end)
end

table.generate = function(t, val, keyGen)
	local key = keyGen or function(i) return i end

	local tbl = {}

	table.map(t, function(v, i) tbl[key(i, v)] = val(v, i) end)

	return tbl
end

table.size = function(t)
	if not t then return 0 end

	local n = 0
	for _ in pairs(t) do n = n + 1 end
	return n
end

-- these might be mis-named
table.findIn = function(t, str)
	return table.size(table.map(t, function(v) if v == str then return true end end)) ~= 0
end

table.findIf = function(t, f)
	return table.size(table.map(t, function(v, i) if f(v, i) then return v end end)) ~= 0
end

table.hasKey = function(t, key)
	return t[key] ~= nil and true or nil
end


-- new functions
	-- are they readable
	-- are they named correctly

-- there's a problem in here somewhere
	-- table.appen({}, { true, 5 }) -> { true, { true, 5 } }
table.append = function(t1, t2)
	if not t1 then return t2 end
	if not t2 then return t1 end

	local t = type(t1) == "table" and t1 or { t1 }
	local t2 = type(t2) == "table" and t2 or { t2 }

	table.map(t2, function(v) t[#t + 1] = v end)

	return t
end

-- returns table of all elements found in t1 and t2
-- works: X
table.intersect = function(t1, t2)
	return table.notEmpty(table.map(t1, function(v, i) if table.findIn(t2, v) then return v end end))
end

-- returns table of all elements found in t1 and not in t2
-- works: 
table.unique = function(t1, t2)
	return table.notEmpty(table.map(t1, function(v) if not table.findIn(t2, v) then return v end end))
end

-- returns table of all elements found in t1 or t2 but not in both	is this the correct name or does union refer to table.or below ???
-- works: 
table.union = function(t1, t2, inter)
	local all = inter or table.intersect(t1, t2)
	return table.append(table.unique(t1, all), table.unique(t2, all)), inter
end

--table.and = function(t1, t2) return table.intersect(t1, t2) end
--table.not = function(t1, t2) return table.unique(t1, t2) end
--table.or = function(t1, t2) return table.append(t1, table.unique(t2, t1)) end
--table.xor = function(t1, t2, inter) return table.union(t1, t2, inter) end

table.reduce = function(t, f, s)
	local n = s or 0
	
	-- add if table check
	table.map(t, function(v) n = f(n, v) end)

	return n
end

table.notEmpty = function(t)
	if table.size(t) == 0 then
		return
	end

	return t
end

table.single = function(t)
	if table.size(t) == 1 then
		for i in pairs(t) do
			return t[i]
		end
	end

	return t
end

table.array = function(t)
	if type(t) ~= "table" then
		return { t }
	end

	local array = {}

	for i, v in pairs(t) do
		if type(i) == "number" then
			array[i] = v
		end
	end

	return array
end

table.toArray = function(t)
	if type(t) ~= "table" then
		return { t }
	end

	local arr = { }
	for _, v in pairs(t) do
		arr[#arr + 1] = v
	end

	return arr
end

table.flatten = function(t)
	local tbl = {}

	table.map(t, function(v)
		if type(v) == "table" then
			table.map(v, function(v)
				tbl[#tbl + 1] = v
			end)
		else
			tbl[#tbl + 1] = v
		end
	end)

	return table.notEmpty(tbl)
end

-- doesn't work
table.seperate = function(t, f)
	local tbl = table.removeIf(t, function(v, i) return f(v, i) end)

	return table.removeIf(t, function(v, i) return not f(v, i) end), tbl
end

table.tostring = function(t, seper, buffer)
	local sep = seper or "\n"
	local buf = buffer or ""

	local t = table.map(t, function(v, i)
		local key = buf .. "[" .. i .. "] = "

		if _type(v) == "table" then
			key = key .. "{" .. sep
			v = table.tostring(v, sep, buf .. " ")
		elseif type(v) == "boolean" then
			v = v and "true" or "false"
		elseif table.findIn({ "nil", "function" }, type(v)) then
			v = type(v)
		end
		
		return key .. v
	end)

	return table.reduce(t, function(n, v) return n .. v .. sep end, "")
end

table.concat = function(t, seper)
	local sep = seper or " "
	return table.reduce(t, function(n, v) return n .. v .. sep end, "")
end

-- divorces keys from the values
table.noDup = function(t)
	if type(t) ~= "table" then return t end

	local hash = table.generate(t, function() return true end, function(i, v) return v end)

	return table.keys(hash)
end

table.keys = function(t)
	local i = 0
	return table.generate(t, function(v, k) return k end, function() i = i + 1 return i end)
end

table.set = function(tbl, key, value, inPlace)
	if inPlace then
		tbl[key] = value
	else
		local t = tbl
		tbl[key] = value
		return tbl
	end
end
