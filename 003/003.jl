using Base.Test

function primes_up_to(n::Integer)
    # Use the sieve of Eratosthenes to generate primes up to n
    crossed_out = falses(n)
    primes = Int[]
    for i in 2:n
        if crossed_out[i]
            continue
        end
        stride = i
        append!(primes, [stride])
        for j in (i+stride):stride:n
            crossed_out[j] = true
        end
    end
    return primes
end

@test primes_up_to(2) == [2]
@test primes_up_to(3) == [2, 3]
@test primes_up_to(4) == [2, 3]
@test primes_up_to(10) == [2, 3, 5, 7]

function prime_factors(n::Integer)
    # return prime factors of n
    max_factor = int(floor(n / 2))
    possible_factors = primes_up_to(max_factor)
    factors = Int[]
    for factor in possible_factors
        if n % factor == 0 && factor != n
            append!(factors, [factor])
        end
    end
    return factors
end

@test prime_factors(2) == []
@test prime_factors(10) == [2, 5]
@test prime_factors(13195) == [5, 7, 13, 29]

N = 600851475143
println("Largest prime factor of $(N) is $(prime_factors(N)[end]).")
