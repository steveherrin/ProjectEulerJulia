using Base.Test

function read_in_numbers(filename)
    raw_text = ""
    open(filename) do file
        raw_text = readall(file)
    end
    text_numbers = replace(raw_text, "\n", "")
    numbers = [parseint(string(n)) for n in text_numbers]
    return numbers
end

function get_largest_n_digit_product(n)
    numbers = read_in_numbers("data.txt")
    m = length(numbers)
    window = numbers[1:n]
    largest = prod(window)
    # take product in a sliding window
    # only need to worry about the new number entering and the old one leaving
    for new in numbers[n+1:m]
        splice!(window, 1)
        push!(window, new)
        largest = max(prod(window), largest)
    end
    return largest
end

@test get_largest_n_digit_product(1) == 9
@test get_largest_n_digit_product(2) == 9*9
@test get_largest_n_digit_product(4) == 5832
N = 13
println("Largest product of $(N) adjacent digits is ",
        "$(get_largest_n_digit_product(N))")
