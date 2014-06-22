using Base.Test

# Same as in problem 7, and maybe some others
function primes_up_to(n::Integer)
    crossed_out = falses(n)
    primes = Int[]
    for i in 2:n
        if crossed_out[i]
            continue
        end
        push!(primes, i)
        for j in 2*i:i:n
            crossed_out[j] = true
        end
    end
    return primes
end

@test primes_up_to(2) == [2]
@test primes_up_to(4) == [2, 3]
@test primes_up_to(10) == [2, 3, 5, 7]

N = 2000000
println("Sum of primes up to $(N) is $(sum(primes_up_to(N)))")

