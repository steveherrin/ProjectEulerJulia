using Base.Test

include("../primes.jl")

function get_Nth_prime(N::Integer)
    up_to = N
    primes = Int[]
    while length(primes) < N
        primes = primes_up_to(up_to)
        up_to *= 2
    end
    return primes[N]
end

function ordinal_suffix(N::Integer)
    least_sig = N % 10
    if least_sig == 1
        return "st"
    elseif least_sig == 2
        return "nd"
    elseif least_sid == 3
        return "rd"
    else
        return "th"
    end
end

@test map(get_Nth_prime, 1:6) == [2, 3, 5, 7, 11, 13]
N = 10001
println("$(N)$(ordinal_suffix(N)) prime is $(get_Nth_prime(N))")
