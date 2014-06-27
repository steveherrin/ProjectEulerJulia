using Base.Test

include("../divisors.jl")

function get_abundant_numbers_upto(n::Integer)
    number_to_divisors = get_proper_divisors_upto(n)
    sums_of_divisors = sum_proper_divisors(number_to_divisors)
    # a little clumsy looking, since I don't think I can put
    # filter((num, divisor_sum) -> num < divisor_sum, ...)
    abundant_nums_and_sums = collect(filter(n_sum-> n_sum[1] < n_sum[2],
                                            enumerate(sums_of_divisors)))
    abundant_numbers = [n_sum[1] for n_sum in abundant_nums_and_sums]

    return abundant_numbers
end

@test get_abundant_numbers_upto(10) == []
@test get_abundant_numbers_upto(13) == [12]

function get_all_pairwise_sums(A, B)
    all_sums = Set{Int}()
    for a in A
        for b in B
            push!(all_sums, a+b)
        end
    end
    return all_sums
end

@test get_all_pairwise_sums(1:2, 2:3) == Set(3, 4, 5)
@test get_all_pairwise_sums(1:10, [0]) == Set(1:10...)

function get_nonsums_of_abundant()
    max_n = 28123  # given in the problem as maximum
    numbers = Set(1:max_n...)
    abundant_numbers = get_abundant_numbers_upto(max_n)
    sums_of_2 = get_all_pairwise_sums(abundant_numbers, abundant_numbers)
    # There might be a better way to take sums of 2 abundant numbers
    # out of the set of all numbers. Actually checking to see if a number
    # is a sum of two seems slower, and the number of pairwise sums isn't
    # too large, though.
    return setdiff(numbers, sums_of_2)
end

println("The sum of all positive integers that cannot be written ",
        "as the sum of 2 abundant numbers is ",
        "$(sum(get_nonsums_of_abundant()))")
