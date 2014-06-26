using Base.Test

include("../divisors.jl")

function get_amicable_numbers_upto(n::Integer)
    number_to_divisors = get_proper_divisors_upto(n)
    sums_of_divisors = sum_proper_divisors(number_to_divisors)
    amicable_numbers = Set{Int}()
    for (number, div_sum) in enumerate(sums_of_divisors)
        if div_sum == number
            # can't be a pair
            continue 
        end
        if div_sum > 0 && div_sum <= n
            if sums_of_divisors[div_sum] == number
                push!(amicable_numbers, number)
                push!(amicable_numbers, div_sum)
            end
        end
    end
    return amicable_numbers
end

@test get_amicable_numbers_upto(30) == Set()
@test get_amicable_numbers_upto(250) == Set()
@test get_amicable_numbers_upto(300) == Set(220, 284)

N = 10000
println("The sum of all amicable numbers below $(N) is ",
        "$(sum(get_amicable_numbers_upto(N-1)))")

