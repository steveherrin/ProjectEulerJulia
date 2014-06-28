using Base.Test

include("../primes.jl")

MAX_PRIME = 20000
PRIMES = primes_up_to(MAX_PRIME)

function is_prime(n::Integer)
    global MAX_PRIME
    global PRIMES
    if n > MAX_PRIME
        MAX_PRIME = 2*n
        PRIMES = primes_up_to(MAX_PRIME)
    end
    return in(n, PRIMES)
end

function get_num_primes_generated(f::Function)
    n_generated = 0
    i = 0
    while is_prime(f(i))
        n_generated += 1
        i += 1
    end
    return n_generated
end

@test get_num_primes_generated(n -> n^2 + n + 41) == 40
@test get_num_primes_generated(n -> n^2 - 79*n + 1601) == 80

function get_most_prime_generating_coefficients(coeff_limit::Number)
    # Dumb brute force. There's probably a better way.
    max_coeff = coeff_limit - 1
    most_generated = 0
    best_coefficients = 0
    for a in -max_coeff:max_coeff
        for b in -max_coeff:max_coeff
            f = n -> n^2 + a*n + b
            n_generated = get_num_primes_generated(f)
            if n_generated > most_generated
                best_coefficients = (a, b)
                most_generated = n_generated
            end
        end
    end
    return best_coefficients
end

@test get_most_prime_generating_coefficients(42) == (-1, 41)  # Euler's

N = 1000
a, b = get_most_prime_generating_coefficients(1000)
println("For |a| < $(N) and |b| < $(N), the formula ",
        "n^2 + $(a)*n + $(b) produces the most primes in a row.")
