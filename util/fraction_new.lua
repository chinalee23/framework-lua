-- 分数
-- 不允许分数与小数计算
-- 因为 metamethod 的限制，比较运算符，只能是分数与分数比较
-- 取模只允许分数与整数运算


require 'ut_string'

local fraction = {}
setmetatable(fraction, fraction)
fraction.__index = fraction
fraction.__metatable = 'fraction'

local function is_integer(x)
	return type(x) == 'number' and x == math.ceil(x) and x == math.floor(x)
end

local function valid(x)
	assert(is_integer(x) or getmetatable(x) == 'fraction', "the operand's type is invalid, expect a number or a fraction")
end

local function transform(x)
	valid(x)
	if type(x) == 'number' then
		x = fraction.new(x, 1)
	end
	return x
end

local function retransform(x)
	valid(x)
	if getmetatable(x) == 'fraction' then
		assert(x[2] == 1)
		x = x[1]
	end
	return x
end

local function ext_enclid(d, f)
	if d > f then d, f = f, d end
	local x1 = 1
	local x2 = 0
	local x3 = f
	local y1 = 0
	local y2 = 1
	local y3 = d
	local t1, t2, t3, k
	
	local rnt
	while true do
		if y3 == 0 then
			return 0
		end
		if y3 == 1 then
			return y2
		end
		k = math.floor(x3/y3)
		t1 = x1-k*y1
		t2 = x2-k*y2
		t3 = x3-k*y3
		x1 = y1
		x2 = y2
		x3 = y3
		y1 = t1
		y2 = t2
		y3 = t3
	end
end

function max_common_divisor(a, b)
	assert(a ~= 0 and b ~= 0)
	local c = a % b
	while c ~= 0 do
		a = b
		b = c
		c = a % b
	end
	return b
end

function fraction.new(numerator, denominator)
	assert(numerator and denominator)
	assert(type(numerator) == 'number' and type(denominator) == 'number')
	assert(denominator ~= 0)

	if numerator == 0 then
		denominator = 1
	else
		local divisor = max_common_divisor(numerator, denominator)
		numerator = numerator / divisor
		denominator = denominator / divisor
	end
	
	local t = {
		numerator, denominator
	}
	setmetatable(t, fraction)
	return t
end

function fraction.newn(n)
	assert(type(n) == 'number')
	local integer, fractional = math.modf(n)
	if fractional == 0 then
		return fraction.new(integer, 1)
	else
		local s = tostring(fractional)
		s = string.split(s, '.')[2]
		local denominator = math.pow(10, #s)
		local numerator = integer * denominator + fractional * denominator
		return fraction.new(numerator, denominator)
	end
end

function fraction:tonumber( ... )
	return self[1] / self[2]
end

function fraction.__tostring(a)
	return string.format('%.0f/%.0f', a[1], a[2])
end

function fraction.__eq(a, b)
	return a[1] == b[1] and a[2] == b[2]
end

function fraction.__lt(a, b)
	return a:tonumber() < b:tonumber()
end

function fraction.__add(a, b)
	b = transform(b)
	return fraction.new(a[1]*b[2] + b[1]*a[2], a[2]*b[2])
end

function fraction.__sub(a, b)
	b = transform(b)
	return fraction.new(a[1]*b[2] - b[1]*a[2], a[2]*b[2])
end

function fraction.__mul(a, b)
	b = transform(b)
	return fraction.new(a[1]*b[1], a[2]*b[2])
end

function fraction.__div(a, b)
	b = transform(b)
	assert(b[1] ~= 0, 'divisor should not be 0')
	return fraction.new(a[1]*b[2], a[2]*b[1])
end

function fraction.__pow(a, b)
	b = retransform(b)
	return fraction.new(math.pow(a[1], b), math.pow(a[2], b))
end

function fraction.__mod(a, b)
	b = retransform(b)
	if a[2] == 1 then
		return a[1] % b
	else

	end
end
