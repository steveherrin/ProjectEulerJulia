using Base.Test

# Given a number N with prime factorization N = prod(p_i^n_i)
# Then any product prod(p_i^m_i) where m_i <= n_i is a factor
# of N.
# So we can find all factors by incrementing m_1 between 0 and n_1
# then m_2 between 0 and n_2, and so on.
# This gives n_i + 1 factors for each p_i
# So there are prod(n_i + 1) factors
#
# Example: 84 = 2^2 * 3 * 7
#          and it has (2+1)*(1+1)*(1+1) = 12 factors
#          (they are 1, 2, 3, 4, 6, 7, 12, 14, 21, 28, 42, 84)

include("../primes.jl")

function get_number_factors(n::Integer)
    factorization = prime_factorization(n)
    n_factors = 1
    for m in values(factorization)
        n_factors *= m + 1
    end
    return n_factors
end

@test get_number_factors(1) == 1
@test get_number_factors(3) == 2
@test get_number_factors(6) == 4
@test get_number_factors(28) == 6

function get_ith_triangle_number(i::Integer)
    return div(i*(i+1), 2)
end

@test map(get_ith_triangle_number, 1:10) == [1,3,6,10,15,21,28,36,45,55]

function get_1st_triangle_number_with_n_factors(n::Integer)
    i = 1
    triangle_num = get_ith_triangle_number(i)
    while get_number_factors(triangle_num) < n
        i += 1
        triangle_num = get_ith_triangle_number(i)
    end
    return triangle_num
end

@test get_1st_triangle_number_with_n_factors(1) == 1
@test get_1st_triangle_number_with_n_factors(2) == 3
@test get_1st_triangle_number_with_n_factors(3) == 6
@test get_1st_triangle_number_with_n_factors(4) == 6
@test get_1st_triangle_number_with_n_factors(5) == 28

N = 500
println("The first triangle number with over $(N) factors ",
        "is $(get_1st_triangle_number_with_n_factors(N))")

