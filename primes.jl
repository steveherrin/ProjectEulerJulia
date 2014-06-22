using Base.Test

# Utilities for generating prime numbers and
# getting the prime factorization of a number

function primes_up_to(n::Integer)
    # Sieve of Eratosthenes
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

function factorize(n::Integer, factors)
    powers = Dict{Int,Int}()
    for factor in factors
        powers[factor] = 0
        while n % factor == 0
            powers[factor] = powers[factor] + 1
            n = div(n, factor)
        end
    end
    remainder = n
    return powers, remainder
end

@test factorize(8, [2]) == ([2 => 3], 1)
@test factorize(10, [2, 7]) == ([2 => 1, 7 => 0], 5)
@test factorize(10, [2, 5, 7]) == ([2 => 1, 5=> 1, 7 => 0], 1)

function prime_factorization(n::Integer)
    max_factor = 1
    remainder = n
    factorization = Dict{Int, Int}()
    while remainder > 1
        max_factor *= 2
        primes = primes_up_to(max_factor)
        factorization, remainder = factorize(n, primes)
    end
    factorization = remove_zero_values(factorization)
    return factorization
end

function remove_zero_values(collection::Dict)
    return filter((k, v) -> v != 0, collection)
end

@test remove_zero_values([1=>0]) == Dict{Int,Int}()
@test remove_zero_values([1=>0,2=>1,3=>0,4=>2,5=>1]) == [2=>1,4=>2,5=>1]

@test prime_factorization(2) == [2 => 1]
@test prime_factorization(24) == [2 => 3, 3 => 1]
@test prime_factorization(25) == [5 => 2]
