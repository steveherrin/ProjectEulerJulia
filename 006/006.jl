# Sum of squares = A = 1^2 + 2^2 + ... + n^2
#                    = 1/6*(2*n^3 + 3*n^2 + n)
# Square of sum = B = (1 + 2 + ... + n)^2
#                   = [n*(n+1)/2]^2

using Base.Test

function diff_ssq(first_n)
    n = first_n  # shorthand
    return div(n^2 * (n + 1)^2, 4) - div(n * (n + 1) * (2*n + 1), 6)
end

@test diff_ssq(1) == 0
@test diff_ssq(2) == 9 - 5
@test diff_ssq(10) == 2640

N = 100
println("Difference between sum of squares and square of sum for ",
        "first $(N) natural numbers is $(diff_ssq(N))")
