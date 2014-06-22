export BigDecimal

import Base: dec, show, string, +, *, push!, div, abs

# Arbitrary precision decimal numbers

type BigDecimal <: Integer
    digits::Vector{Uint8}
    negative::Bool
end

function BigDecimal(x::Integer)
    digits = Uint8[]
    negative = x < 0
    x = abs(x)
    while x > 0
        push!(digits, x % 10)
        x = div(x, 10)
    end
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
    return BigDecimal(digits, negative)
end

function dec(x::BigDecimal)
    s = reduce(*, map(dec, reverse(x.digits)))
    if x.negative
        s = "-" * s
    end
    return s
end
string(x::BigDecimal) = dec(x)
show(io::IO, x::BigDecimal) = print(io, string(x))

function +(x::BigDecimal, y::BigDecimal)
    digits = Uint8[]
    N = max(length(x.digits), length(y.digits))
    carry = 0
    for i in 1:N
        if i > length(x.digits)
            a = 0
        else
            a = x.digits[i]
        end
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
    result = BigDecimal(digits, x.negative)
    return result
end

function ==(x::BigDecimal, y::BigDecimal)
    return (x.negative == y.negative) && (x.digits == y.digits)
end

using Base.Test

function test_BigDecimal()
    a = BigDecimal(123456)
    b = BigDecimal("123456")
    @test a + b == BigDecimal(reverse(Uint8[2,4,6,9,1,2]), false)
    return true
end
