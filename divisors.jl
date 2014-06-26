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
