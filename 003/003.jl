using Base.Test

function is_prime(n::Integer, memo::Dict=Dict())
    if haskey(memo, n)
        return memo[n]
    end
    if n == 2
        memo[n] = true
        return true
    end
    for i in 2:int(floor(sqrt(n)))
        if n % i == 0
            memo[n] = false
            return false
        end
    end
    memo[n] = true
    return true
end

@test is_prime(2) == true
@test is_prime(3) == true
@test is_prime(4) == false
@test is_prime(17) == true
@test is_prime(21) == false

function largest_prime_factor(n::Integer)
    i = 2
    memo = Dict{Int64,Bool}()
    largest_prime = 0
    while i <= n
        if is_prime(i, memo)
            # remove the factor completely
            while n % i == 0
                n = div(n, i)
                # we've removed all smaller factors, so this is largest
                largest_prime = i
            end
        end
        i += 1
    end
    return largest_prime
end

@test largest_prime_factor(6) == 3
@test largest_prime_factor(9) == 3
@test largest_prime_factor(10) == 5
@test largest_prime_factor(17) == 17
@test largest_prime_factor(13195) == 29
@test largest_prime_factor(2^55) == 2

N = 600851475143
println("Largest prime factor of $(N) is $(largest_prime_factor(N)).")
