using Base.Test

function is_multiple_of_n(n, x)
    return x % n == 0
end

@test is_multiple_of_n(3, 3) == true
@test is_multiple_of_n(3, 2) == false
@test is_multiple_of_n(3, 6) == true
@test is_multiple_of_n(5, 10) == true
@test is_multiple_of_n(5, 6) == false

function is_multiple_of_3_or_5(x)
    return is_multiple_of_n(3, x) || is_multiple_of_n(5, x)
end

function sum_multiples_below(n)
    numbers = 1:(n-1)
    multiples = filter(x -> is_multiple_of_3_or_5(x), numbers)
    return sum(multiples)
end

@test sum_multiples_below(10) == 23

println("Sum of multiples of 3 or 5 below 100 is $(sum_multiples_below(100))")
