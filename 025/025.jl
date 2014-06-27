using Base.Test

include("../big_decimal.jl")

function get_first_fibonacci_number_with_n_digits(n::Integer)
    if n == 1
        return 1, BigDecimal(1)
    end
    # Initial conditions for Fibonacci sequency
    previous_2 = BigDecimal(1)
    previous_1 = BigDecimal(1)
    # Use them to compute the 3rd term
    current = previous_2 + previous_1
    term = 3
    while length(current.digits) < n
        previous_2 = previous_1
        previous_1 = current
        current = previous_2 + previous_1
        term += 1
    end
    return term, current
end

@test get_first_fibonacci_number_with_n_digits(1) == (1, BigDecimal(1))
@test get_first_fibonacci_number_with_n_digits(2) == (7, BigDecimal(13))
@test get_first_fibonacci_number_with_n_digits(3) == (12, BigDecimal(144))

N = 1000
println("The first Fibonacci number with $(N) digits is ",
        "F_$(get_first_fibonacci_number_with_n_digits(N)[1])")
