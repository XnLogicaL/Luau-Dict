local tbl = {}

function tbl.deepCopy<T>(t: T): T
	local copy = {}
	for k, v in t do
		if typeof(v) == "table" then
			copy[k] = tbl.deepCopy(v)
		else
			copy[k] = t[k]
		end
	end
	return copy
end

function tbl.keys(t)
	local keys = {}
	for k, _ in t do
		table.insert(keys, k)
	end
	return keys
end

function tbl.values(t)
	local vals = {}
	for _, v in t do
		table.insert(vals, v)
	end
	return vals
end

function tbl.reverse(t)
	local rev = tbl.deepCopy(t)
	local keys = tbl.keys(t)
	for idx = 1, math.floor(#keys/2) do
		local i, j = keys[idx], keys[#keys - idx + 1]
		rev[i], rev[j] = rev[j], rev[i]
	end
	return rev
end

function tbl.move(t1, start, stop, t2)
	local keys = tbl.keys(t1)
	local targetkeys = table.move(keys, start, stop, 1, {})
	for i, k in targetkeys do
		t2[targetkeys[i]] = t1[k]
	end
	return t2
end

function tbl.join(t1, t2)
	t1 = tbl.deepCopy(t1)
	for k, v in t2 do
		t1[k] = v
	end
	return t1
end

function tbl.subtract(t1, t2)
	t1 = tbl.deepCopy(t1)
	for k, _ in t2 do
		t1[k] = nil
	end
	return t1
end

return tbl
