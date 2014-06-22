using Base.Test

# You can just do this problem by summing a vector of 64-bit
# floats. But that feels too easy. So be a little smarter.
# Although the float addition is pretty much doing what I'm doing
# in a more sophisticated way.
# I'm not doing anything to check for overflow, so this could
# cause problems if there are a lot of big numbers.
# Better might be to make a big number type.

function read_data()
    return readdlm("data.txt", ' ', String)
end

function trim_and_parse(data, N_digits::Integer)
    # take only the first N digits of the strings in data
    output = Int64[]
    for s::String in data
        l = min(length(s), N_digits)
        push!(output, parseint(s[1:l]))
    end
    return output
end

@test trim_and_parse(["123456"], 3) == [123]
@test trim_and_parse(["123456", "654321"], 2) == [12, 65]

function first_digits_sum(data, N_digits::Integer)
    # We know that the less significant numbers can't
    # ever sum to something significant unless there're a lot
    # of them. So chop off any that aren't going to add up
    # to affect the numbers we're adding.
    digits_needed = N_digits + int(ceil(log10(length(data)))) + 2
    data = trim_and_parse(data, digits_needed)
    sum_str = string(sum(data))
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
