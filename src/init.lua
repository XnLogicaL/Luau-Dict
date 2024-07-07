export type Constructor = (t: {any?}?) -> Dict
export type Dict = {
	keys: (self: Dict) -> {any?};
	values: (self: Dict) -> {any?};
	get: (self: Dict, pos: number) -> any?;
	set: (self: Dict, key: any, value: any) -> ();
	pop: (self: Dict, pos: number) -> any?;
	find: (self: Dict, value: any, init: number?) -> any?;
	len: (self: Dict) -> number;
	unpack: (self: Dict) -> (...any?);
	maxn: (self: Dict) -> number?;
	clear: (self: Dict) -> ();
	slice: (self: Dict, start: number, stop: number) -> Dict;
	remove: (self: Dict, key: any) -> ();
	concat: (self: Dict) -> string;
	copy: (self: Dict) -> {any?};
	fromKeys: <T>(self: Dict, value: T) -> {[string]: T}
}

local tbl = require(script.TableUtil)

local function createLengthBuffer()
	local buf = buffer.create(8)
	return {
		read = function(offset: number)
			return buffer.readu32(buf, offset)
		end,
		write = function(offset: number, value: number)
			return buffer.writeu32(buf, offset, value)
		end,
	}
end

local Internal = {
	__lencache = {}
}
local Dict, Constructor

do -- Dict Metatable
	Dict = {
		__len = function(t)
			if Is(t) then
				return t:len()
			end
		end,
		__unm = function(t)
			return Constructor(tbl.reverse(t))
		end,
		__newindex = function(t, k, v)
			if Is(t) then
				t:set(k, v)
			end
		end,
		__eq = function(t1, t2)
			if Is(t1) and Is(t2) then
				return rawequal(t1, t2)
			end
		end,
		__add = function(t1, t2)
			if Is(t1) and Is(t2) then
				return Constructor(tbl.join(t1, t2))
			end
		end,
		__sub = function(t1, t2)
			if Is(t1) and Is(t2) then
				return Constructor(tbl.subtract(t1, t2))
			end
		end,
	}
	Dict.__index = Dict
	
	function Is(obj)
		return typeof(obj) == "table" and getmetatable(obj) == Dict
	end

	function Dict:keys(): {any?}
		return tbl.keys(self)
	end

	function Dict:values(): {any?}
		return tbl.values(self)
	end

	function Dict:get(pos: number): any?
		local keys = self:keys()
		local idx = keys[pos]
		return if idx then self[idx] else nil
	end

	function Dict:set(key: any, value: any): ()
		local lencache = Internal.__lencache[self]
		local wasnil = self[key] == nil
		rawset(self, key, value)
		if value ~= nil and wasnil then
			lencache.write(0, lencache.read(0) + 1)
		elseif value == nil and not wasnil then
			lencache.write(0, lencache.read(0) - 1)
		end
	end

	function Dict:pop(pos: number): any?
		local keys = self:keys()
		local idx = keys[pos]
		local val = if idx then self[idx] else nil
		if idx then
			self[idx] = nil
		end
		return val
	end

	function Dict:len(): number
		return Internal.__lencache[self].read(0)
	end

	function Dict:find(value: any, init: number?): any?
		local init = init or 1
		local keys = self:keys()
		for i = init, #keys do
			local k = keys[i]
			local v = self[k]
			if v == value then
				return k
			end
		end
		return nil
	end

	function Dict:unpack(): (...any?)
		return table.unpack(self:values())
	end

	function Dict:maxn(): number?
		return table.maxn(self:values())
	end

	function Dict:clear(): ()
		table.clear(self)
		Internal.__lencache[self].write(0, 0)
	end

	function Dict:slice(start: number, stop: number)
		return Constructor(tbl.move(self, start, stop, {}))
	end

	function Dict:remove(key: any): ()
		if key ~= nil then
			local lencache = Internal.__lencache[self]
			self[key] = nil
			lencache.write(0, lencache.read(0) - 1)
		end
	end
	
	function Dict:concat(): string
		return table.concat(self:values())
	end
	
	function Dict:copy(value: any): {any?}
		return Constructor(tbl.deepCopy(self))
	end
	
	function Dict:fromKeys<T>(value: T): {[any]: T}
		local t = {}
		local keys = self:keys()
		for _, k in keys do
			t[k] = value
		end
		return t
	end
end

Constructor = function(t)
	local lencache = Internal.__lencache
	if t ~= nil then
		lencache[t] = createLengthBuffer()
		lencache[t].write(0, #tbl.keys(t))
		return setmetatable(t, Dict)
	else
		local t = {}
		lencache[t] = createLengthBuffer()
		return setmetatable(t, Dict)
	end
end

return Constructor :: Constructor
