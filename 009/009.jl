using Base.Test

function are_pythagorean(a::Integer, b::Integer, c::Integer)
    return a^2 + b^2 == c^2
end

function find_pythagorean_triple_sums_to(N::Integer)
    #    a^2 + b^c = c^2
    # => a^2 + b^2 + 2*a*b > c^2
    # => (a+b)^2 > c^2
    # => a + b > c
    # also assuming WOLOG b > a, then
    # => b > c / 2
    # And no one can be greater than half N since they're nonnegative
    half_N = div(N, 2)
    for c in 1:(half_N - 1)
        half_c = div(c, 2)
        for b in (half_c + 1):half_N
            a = N - (b + c)
            if are_pythagorean(a, b, c)
                a, b = min(a,b), max(a,b)  # so they're in order for testing
                return (a, b, c)
            end
        end
    end
    return (0, 0, 0)
end

@test find_pythagorean_triple_sums_to(3+4+5) == (3,4,5)
@test find_pythagorean_triple_sums_to(5+12+13) == (5,12,13)

N = 1000
println("Product of Pythagorean triple summing to $(N) ",
        "is $(prod(find_pythagorean_triple_sums_to(N)))")

