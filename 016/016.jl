using Base.Test

include("../big_decimal.jl")

function pow2(N::Integer)
    result = BigDecimal(1)
    for i in 1:N
        result += result
    end
    return result
end

@test pow2(0) == BigDecimal(1)
@test pow2(1) == BigDecimal(2)
@test pow2(2) == BigDecimal(4)
@test pow2(15) == BigDecimal(32768)

function digit_sum(N::Integer)
    str_N = string(N)
    total = 0
    for digit in str_N
        total += parseint(string(digit))
    end
    return total
end

@test digit_sum(123) == 6
@test digit_sum(32768) == 26

N = 1000
println("The sum of the digits in 2^$(N) is $(digit_sum(pow2(N)))")
