# Sum of squares = A = 1^2 + 2^2 + ... + n^2
# Square of sum = B = (1 + 2 + ... + n)^2
#                   = A + 2*(1*2 + 1*3 + ... + 1*n + 2*3 + ... + (n-1)*n)
# So difference is B - A = 2(1*2 + 1*3 + ... + 1*n + 2*3 + ... + (n-1)*n)

using Base.Test

function diff_ssq(numbers)
    N = length(numbers)
    sum_pairs = 0
    for i in 1:(N-1)
        for j in (i+1):N
            sum_pairs += i*j
        end
    end
    return 2 * sum_pairs
end

@test diff_ssq([1]) == 0
@test diff_ssq([1, 2]) == 9 - 5
@test diff_ssq(1:10) == 2640
N = 100
println("Difference between sum of squares and square of sum for ",
        "first $(N) natural numbers is $(diff_ssq(1:N))")
