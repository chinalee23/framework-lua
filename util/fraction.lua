-- 分数计算

require 'ut_string'

-- 精度
local precision = 2
local denominator = math.pow(10, precision)


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
		x = fraction.new(x, 0)
	end
	return x
end

local function part(n)
	assert(type(n) == 'number')
	local s = tostring(n)
	local p = string.split(s, '.')
	local integer = tonumber(p[1])
	if p[2] then
		local numerator = tonumber(string.sub(p[2], 1, precision))
		if #p[2] < precision then
			numerator = numerator * math.pow(10, precision - #p[2])
		end
		return integer, numerator
	else
		return integer, 0
	end
end

function fraction.new(integer, numerator)
	local t = {
		integer or 0, numerator or 0,
	}
	setmetatable(t, fraction)
	return t
end

function fraction.newn(n)
	local integer, numerator = part(n)
	return fraction.new(integer, numerator)
end

function fraction:tonumber( ... )
	return self[1] + self[2] / denominator
end

function fraction.__tostring(a)
	return string.format('%.0f[%.0f/%.0f] = %f', a[1], a[2], denominator, a:tonumber())
end

function fraction.__eq(a, b)
	a = transform(a)
	b = transform(b)
	return a[1] == b[1] and a[2] == b[2]
end

function fraction.__lt(a, b)
	a = transform(a)
	b = transform(b)
	return a[1] < b[1] or a[2] < b[2]
end

function fraction.__add(a, b)
	a = transform(a)
	b = transform(b)
	local integer = a[1] + b[1]
	local numerator = a[2] + b[2]
	return fraction.new(integer + math.floor(numerator / denominator), numerator % denominator)
end

function fraction.__sub(a, b)
	a = transform(a)
	b = transform(b)
	local integer = a[1] - b[1]
	local numerator = a[2] - b[2]
	while integer > 0 and numerator < 0 do
		integer = integer - 1
		numerator = denominator + numerator
	end
	return fraction.new(integer, numerator)
end

function fraction.__mul(a, b)
	a = transform(a)
	b = transform(b)
	local x = a[1]*b[1]*denominator*denominator
	x = x + a[1]*b[2]*denominator
	x = x + a[2]*b[1]*denominator
	x = x + a[2]*b[2]
	local y = denominator * denominator
	local integer, numerator = part(x/y)
	return fraction.new(integer, numerator)
end

function fraction.__div(a, b)
	a = transform(a)
	b = transform(b)
end

local a = fraction.newn(-0.3)
local b = fraction.newn(1.4)

print(a)