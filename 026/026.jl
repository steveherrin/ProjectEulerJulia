using Base.Test

function get_length_of_inverse_cycle(divisor::Integer)
    divisor = abs(divisor)
    numerator = 1
    seen = Int[]
    # If we're using the same numerator, we've cycled
    while !in(numerator, seen)
        push!(seen, numerator)
        # long division step for 1/n
        divided = 10 * numerator
        d, r = divrem(divided, divisor)
        if r == 0
            return 0
        end
        numerator = divided - d*divisor
    end
    cycle_start = minimum(find(x -> x == numerator, seen))
    return length(seen) - cycle_start + 1
end

@test map(get_length_of_inverse_cycle, 2:10) == [0,1,0,0,1,6,0,1,0]
@test get_length_of_inverse_cycle(261) == 28

N = 999
cycle_lengths = map(get_length_of_inverse_cycle, 1:N)
max_cycle, max_d = findmax(cycle_lengths)
println("The longest cycle in 1/d for d <= $(N) is for ",
        "d = $(max_d) with a cycle of length $(max_cycle)")
