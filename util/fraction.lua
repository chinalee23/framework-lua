-- 分数计算

-- 精度
local precision = 1
local denominator = math.pow(10, precision)


local fraction = {}
setmetatable(fraction, fraction)
fraction.__index = fraction

function fraction.new(integer, numerator)
	local t = {
		integer or 0, numerator or 0,
	}
	setmetatable(t, fraction)
	return t
end

function fraction.newn(n)
	assert(type(n) == 'number')
	local integer, fractional = math.modf(n)
	local numerator = fractional * denominator
	return fraction.new(integer, numerator)
end

function fraction:tonumber( ... )
	return self[1] + self[2] / denominator
end

function fraction.__tostring(a)
	return string.format('%.0f[%.0f/%.0f] = %f', a[1], a[2], denominator, a:tonumber())
end

function fraction.__eq(a, b)
	return a[1] == b[1] and a[2] == b[2]
end

function fraction.__lt(a, b)
	return a[1] < b[1] or a[2] < b[2]
end

function fraction.__le(a, b)
	return a == b or a < b
end

function fraction.__add(a, b)
	local integer = a[1] + b[1]
	local numerator = a[2] + b[2]
	return fraction.new(integer + math.floor(numerator / denominator), math.mod(numerator, denominator))
end

function fraction.__sub(a, b)
	local integer = a[1] - b[1]
	local numerator = a[2] - b[2]
	while integer > 0 and numerator < 0 do
		integer = integer - 1
		numerator = denominator + numerator
	end
	return fraction.new(integer, numerator)
end

function fraction.__mul(a, b)
	
end

print(b-a)
