using Base.Test

include("../big_decimal.jl")

# This is dumb and doesn't scale at all.
function distinct_numbers_for_a_to_b(a_values, b_values)
    numbers = Set{BigDecimal}()
    a_bigdecimals = [BigDecimal(a) for a in a_values]
    b_bigdecimals = [BigDecimal(b) for b in b_values]
    for a in a_bigdecimals
        if a == BigDecimal(100)
            println("$(a)")
        end
        for b in b_bigdecimals
            push!(numbers, a^b)
        end
    end
    return numbers
end

@test distinct_numbers_for_a_to_b(1:2, 1:2) == Set([BigDecimal(x)
                                                    for x in [1, 2, 4]]...)
@test distinct_numbers_for_a_to_b(2:5, 2:5) == Set([BigDecimal(x)
                                                    for x in [4, 8, 9, 16, 25,
                                                              27, 32, 64, 81,
                                                              125, 243, 256,
                                                              625, 1024,
                                                              3125]]...)
# This will take something like half a day :(
N = 1000
println("For 2 <= a <= $(N), 2 <= b <= $(N), there are ",
        "$(length(distinct_numbers_for_a_to_b(2:N, 2:N))) ",
        "distinct numbers a^b.")
