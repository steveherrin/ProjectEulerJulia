using Base.Test
using Iterators

# To get the smallest number that can be divided by
# each number in some set A = {a1, a2, a3, ...},
# first factor each of those numbers into
# prime factors: a1 = 2^(n2,1) * 3^(n3,1)* 5^(n5,1) * ...
# The smallest number that can be evenly divided is
# the product of the maximum of the exponents of the
# factors: 2^(max over m of n2,m) * 3^(max of n3,m) * ...

include("../primes.jl")

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
