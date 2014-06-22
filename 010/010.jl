using Base.Test

include("../primes.jl")

N = 2000000
println("Sum of primes up to $(N) is $(sum(primes_up_to(N)))")

