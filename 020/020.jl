using Base.Test

function sum_digits_in_factorial(n)
    digits_str = string(factorial(n))
    digits = [parseint(string(digit)) for digit in digits_str]
    return sum(digits)
end

@test sum_digits_in_factorial(3) == 6
@test sum_digits_in_factorial(4) == 6
@test sum_digits_in_factorial(10) == 27

include("../big_decimal.jl")

N = BigDecimal(100)
println("The sum of the digits in $(N)! is $(sum_digits_in_factorial(N))")
