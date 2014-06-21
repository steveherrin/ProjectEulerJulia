using Base.Test
using Iterators

# To get the smallest number that can be divided by
# each number in some set A = {a1, a2, a3, ...},
# first factor each of those numbers into
# prime factors: a1 = 2^(n2,1) * 3^(n3,1)* 5^(n5,1) * ...
# The smallest number that can be evenly divided is
# the product of the maximum of the exponents of the
# factors: 2^(max over m of n2,m) * 3^(max of n3,m) * ...

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

function smallest_evenly_divisible(numbers)
    factors = Dict{Int,Int}()
    for number in numbers
        factorization = prime_factorization(number)
        factors = merge_with_max_values(factors, factorization)
    end
    solution = 1
    for (factor, power) in zip(keys(factors), values(factors))
        solution *= factor^power
    end
    return solution
end

function merge_with_max_values{T, U}(coll1::Dict{T,U}, coll2::Dict{T,U})
    new_coll = Dict{T, U}()
    for k in chain(keys(coll1), keys(coll2))
        if !haskey(coll1, k)
            new_coll[k] = coll2[k]
        elseif !haskey(coll2, k)
            new_coll[k] = coll1[k]
        else
            new_coll[k] = max(coll1[k], coll2[k])
        end
    end
    return new_coll
end

@test merge_with_max_values([1=>2], [1=>0]) == [1=>2]
@test merge_with_max_values([1=>2], [2=>0]) == [1=>2,2=>0]

@test smallest_evenly_divisible(1:2) == 2
@test smallest_evenly_divisible([1, 8]) == 8
@test smallest_evenly_divisible(1:10) == 2520
println("Smallest number evenly divisible by 1:20 ",
        "is $(smallest_evenly_divisible(1:20))")
