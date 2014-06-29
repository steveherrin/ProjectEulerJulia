export BigDecimal

import Base: dec, show, string, +, *, ^, push!, div, abs, factorial, <, <=, ==, isequal, hash

# Arbitrary precision decimal numbers

type BigDecimal <: Integer
    digits::Vector{Uint8}
    negative::Bool
end

function nines_complement(digits::Vector{Uint8}, desired_length=0)
    complement = Uint8[9 - digit for digit in digits]
    while length(complement) < desired_length
        push!(complement, 9)
    end
    return complement
end

function remove_trailing_zeros(digits::Vector{Uint8})
    digits_copy = digits
    while length(digits_copy) > 1 && digits_copy[end] == 0
        pop!(digits_copy)
    end
    return digits_copy
end

function BigDecimal(x::Integer)
    digits = Uint8[]
    negative = x < 0
    x = abs(x)
    while x > 0
        push!(digits, x % 10)
        x = div(x, 10)
    end
    if length(digits) == 0
        push!(digits, 0)
    end
    digits = remove_trailing_zeros(digits)
    return BigDecimal(digits, negative)
end

function BigDecimal(x::String)
    digits = Uint8[]
    negative = x[1] == '-'
    start = 1
    if negative
        start = 2
    end
    for i in length(x):-1:start
        push!(digits, parseint(x[i:i]))
    end
    digits = remove_trailing_zeros(digits)
    return BigDecimal(digits, negative)
end

function dec(x::BigDecimal)
    if x.negative
        s = "-"
    else
        s = ""
    end
    if length(x.digits) == 1
        s *= dec(x.digits[1])
    else
        s *= reduce(*, map(dec, reverse(x.digits)))
    end
    return s
end
string(x::BigDecimal) = dec(x)
show(io::IO, x::BigDecimal) = print(io, string(x))
hash(x::BigDecimal) = hash(string(x))

function -(x::BigDecimal)
    negative = !x.negative
    return BigDecimal(x.digits, negative)
end

function abs(x::BigDecimal)
    if !x.negative
        return x
    else
        return -x
    end
end

function +(x::BigDecimal, y::BigDecimal)
    if abs(y) > abs(x)
        # simplifies the logic
        return y + x
    end
    if !x.negative && y.negative
        return x - abs(y)
    end
    digits = Uint8[]
    N = length(x.digits)
    carry = 0
    for i in 1:N
        a = x.digits[i]
        if i > length(y.digits)
            b = 0
        else
            b = y.digits[i]
        end
        s = carry + a + b
        carry = div(s, 10)
        s = s % 10
        push!(digits, s)
    end
    if carry > 0
        push!(digits, carry)
    end
    return BigDecimal(digits, x.negative)
end

function -(x::BigDecimal, y::BigDecimal)
    if abs(x) < abs(y)
        # simplifies the logic
	return -(y - x)
    end
    if !x.negative && y.negative
        return x + abs(y)
    elseif x.negative && !y.negative
        return x + (-y)
    end
    y_nc = BigDecimal(nines_complement(y.digits, length(x.digits)), x.negative)
    difference = x + y_nc
    difference += BigDecimal(1)
    pop!(difference.digits)  # remove extra 1
    difference.digits = remove_trailing_zeros(difference.digits)
    return difference
end

function *(x::BigDecimal, y::BigDecimal)
    product = BigDecimal(0)
    count = abs(y)
    abs_x = abs(x)
    while count > BigDecimal(0)
        product += abs(x)
        count -= BigDecimal(1)
    end
    product.negative = x.negative $ y.negative
    return product
end

function ^(x::BigDecimal, y::BigDecimal)
    if x == BigDecimal(1)
        return BigDecimal(1)
    end
    if y < BigDecimal(0)
        return BigDecimal(0)
    end
    count = copy(y)
    result = BigDecimal(1)
    while count > BigDecimal(0)
        result *= x
        count -= BigDecimal(1)
    end
    return result
end


function factorial(x::BigDecimal)
    product = BigDecimal(1)
    count = BigDecimal(1)
    while count <= x
        product *= count
        count += BigDecimal(1)
    end
    return product
end


function <(x::BigDecimal, y::BigDecimal)
    if x.negative && !y.negative
        return true
    end
    if length(x.digits) < length(y.digits)
        return true
    elseif length(x.digits) == length(y.digits)
        for (xd, yd) in zip(reverse(x.digits), reverse(y.digits))
            if xd < yd
                return true
            elseif xd > yd
                return false
            end
        end
    end
    return false
end

function ==(x::BigDecimal, y::BigDecimal)
    return (x.negative == y.negative) && (x.digits == y.digits)
end
isequal(x::BigDecimal, y::BigDecimal) = ==(x, y)

function <=(x::BigDecimal, y::BigDecimal)
    return (x == y) || (x < y)
end

using Base.Test

function test_BigDecimal()
    a = BigDecimal(123456)
    b = BigDecimal("123456")
    @test a == b
    @test a <= b
    @test a <= b + BigDecimal(1)
    @test a < b + BigDecimal(1)
    @test -(-b) == b
    @test -a < b
    @test -a == -b
    @test !(BigDecimal("211") < BigDecimal("112"))
    @test BigDecimal("112") < BigDecimal("211")
    @test a + b == BigDecimal(reverse(Uint8[2,4,6,9,1,2]), false)
    @test a - b == BigDecimal(0)
    @test a - BigDecimal(1) == BigDecimal(123455)
    @test (-a) - BigDecimal(1) == BigDecimal(-123457)
    @test BigDecimal(1) - a == BigDecimal(-123455)
    @test a * b == BigDecimal("15241383936")
    @test a * (-b) == BigDecimal("-15241383936")
    @test (-a) * (-b) == BigDecimal("15241383936")
    @test (-a) * b == -BigDecimal("15241383936")
    @test BigDecimal(1) ^ a == BigDecimal(1)
    @test a ^ BigDecimal(0) == BigDecimal(1)
    @test BigDecimal(2) ^ BigDecimal(4) == BigDecimal(16)
    @test factorial(BigDecimal(4)) == BigDecimal(24)
    return true
end
