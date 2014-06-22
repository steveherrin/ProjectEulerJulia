using Base.Test

include("../big_decimal.jl")

function read_data()
    return readdlm("data.txt", ' ', String)
end


function first_digits_sum(data, N_digits::Integer)
    numbers = map(BigDecimal, data)
    total = BigDecimal(0)
    for number in numbers
        total += number
    end
    sum_str = string(total)
    l = min(length(sum_str), N_digits)
    return parseint(sum_str[1:l])
end

@test first_digits_sum(["1999", "1999"], 1) == 3
@test first_digits_sum(["1999", "2002"], 1) == 4
@test first_digits_sum(["5", "5"], 1) == 1
@test first_digits_sum(["5", "5"], 1) == 1

N = 10
println("First $(N) digits of the sum of the numbers are ",
        "$(first_digits_sum(read_data(), N))")
