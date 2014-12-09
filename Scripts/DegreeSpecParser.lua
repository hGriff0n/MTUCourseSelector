-- Still need to "pretty"-up the return ???
if not mtu then mtu = {} end
if not mtu.degrees then mtu.degrees = {} end

-- Need to delay the parsing
	-- Til after files loaded and class structure is created
	-- That's why these three functions are here
-- determines the level of the class
function classLevel(sec)
	return type(sec) == "string" and tonumber(sec:sep(" ")[2][1]) or -1
end

-- does this class pass n-level requirements
function nLevel(sec, n)
	return classLevel(sec) >= n
end

function credits(crse)
	return 3
end

mtu.degrees.specs = {
	either = function(...)
		local test = table.map({ ... }, function(v) if type(v) ~= "function" then return mtu.degrees.specs.each(v) end return v end)
		local tracker, comp, tbl = 0, 0, 0

		return function(crses, flag)
			if flag then return mtu.degrees.specs.each(table.unpack(test))(crses) end
			tracker = { }

			for i, f in ipairs(test) do
				comp, tbl = f(crses)
				if comp then
					return comp, tbl
				else
					tracker[#tracker + 1] = comp
					tracker[#tracker] = table.append(tracker[#tracker], tbl)
				end
			end

			return false, tracker
		end
	end,
	each = function(...)
		local tbl = { ... }
		local sections, funcs = table.removeIf(tbl, NotType("string")), table.removeIf(tbl, NotType("function"))
		local tracker, comp = 0, 0, 0

		return function(crses, flag)
			local has = table.intersect(sections, crses)
			local needs = table.unique(sections, has)
			tracker = { { table.size(needs) == 0, has, needs } }

			for i, f in pairs(funcs) do
				comp, tbl = f(crses, flag)
				tracker[#tracker + 1] = { comp }
				tracker[#tracker] = table.append(tracker[#tracker], tbl)
			end

			return table.reduce(tracker, TrueReduce(1)), tracker
		end
	end,
	eachT = function(t) return mtu.degrees.specs.each(table.unpack(t)) end,
	select = function(min, maxim)
		local max = maxim or min
		local f = function(sel, addr)
			local has, n, needs, over = 0, 0

			return function(crses, flag)
				if flag then return mtu.degrees.specs.each(table.unpack(sel))(crses) end

				has = table.intersect(crses, sel)
				needs = table.unique(sel, has)
				
				n = table.reduce(has, function(n, v) return n + addr(v) end)

				if n > max then
					over = { }
					has = table.toArray(has)
					table.sort(has, function(a, b) return credits(a) > credits(b) end)

					while n > max do
						over[#over + 1], has[#has] = has[#has]
						n = n - addr(over[#over])
					end

					if n < min then
						has[#has + 1], over[#over] = over[#over]
					end
				end

				return n >= min, { has, needs, over }
			end
		end

		return {
			credits = {
				from = function(...) return f({...}, function(v) return credits(v) end) end
			},
			classes = {
				from = function(...) return f({...}, function() return 1 end) end
			}
		}
	end,
	limit = {
		credits = function(from, to)
			return mtu.degrees.specs.select(0, to).credits.from(table.unpack(from))
		end,
		classes = function(from, to)
			return mtu.degrees.specs.select(0, to).classes.from(table.unpack(from))
		end
	},
	level = function(tbl, lvl)
		local l = lvl > 999 and lvl / 1000 or lvl
		if type(tbl) == "string" then tbl = mtu.degrees.depCourses(tbl) end
		return table.removeIf(tbl, function(v) return not nLevel(v, l) end)
	end,
	exclude = function(tbl, rem)
		local remove = type(rem) == "table" and rem or { rem }
		return table.removeIf(tbl, function(v) return table.findIn(remove, v) end)
	end,
}
