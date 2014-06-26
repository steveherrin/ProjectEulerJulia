using Base.Test

function get_proper_divisors_upto(n::Integer)
    number_to_divisors = [Set{Int}() for i in 1:n]

    half_n = div(n, 2) 
    # Go through all possible divisors
    # Each one is a divisor for all of its multiples, so add
    # it to the appropriate sets
    for divisor in 1:half_n
        # proper divisors must be strictly less than, so
        # we'll skip the case where current_number == divisor
        current_number = 2*divisor
        while current_number <= n
            push!(number_to_divisors[current_number], divisor)
            current_number += divisor
        end
    end
    return number_to_divisors
end

@test get_proper_divisors_upto(6) == [Set(), Set(1), Set(1),
                                      Set(1,2), Set(1), Set(1,2,3)]

function sum_proper_divisors(number_to_divisors::Vector)
    sums = [sum(divisors) for divisors in number_to_divisors]
    return sums
end

@test sum_proper_divisors([Set(), Set(1), Set(1,2,3,4)]) == [0, 1, 10]

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

