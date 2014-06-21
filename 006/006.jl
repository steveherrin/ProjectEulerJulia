# Sum of squares = A = 1^2 + 2^2 + ... + n^2
# Square of sum = B = (1 + 2 + ... + n)^2
#                   = A + 2*(1*2 + 1*3 + ... + 1*n + 2*3 + ... + (n-1)*n)
# So difference is B - A = 2(1*2 + 1*3 + ... + 1*n + 2*3 + ... + (n-1)*n)

using Base.Test

# This is slower than the one below, but maybe less prone to overflow?
function diff_ssq(numbers)
    N = length(numbers)
    sum_pairs = sum(map(i->sum(map(x->i*x, numbers[i+1:N])), numbers[1:N-1]))
    return 2 * sum_pairs
end

# This is good up to something like 1:102568 when a 64-bit int overflows
function diff_ssq2(numbers)
    return sum(numbers)^2 - sum(map(x->x^2, numbers))
end

@test diff_ssq2([1]) == 0
@test diff_ssq2([1, 2]) == 9 - 5
@test diff_ssq2(1:10) == 2640

N = 100
println("Difference between sum of squares and square of sum for ",
        "first $(N) natural numbers is $(diff_ssq2(1:N))")
