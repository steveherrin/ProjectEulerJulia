using Base.Test

function is_palindrome(n::String)
    return n == reverse(n)
end

@test is_palindrome("aba") == true
@test is_palindrome("abba") == true
@test is_palindrome("abc") == false
@test is_palindrome("abca") == false

function is_palindrome(n::Integer)
    return is_palindrome(string(n))
end

@test is_palindrome(121) == true
@test is_palindrome(1221) == true
@test is_palindrome(123) == false
@test is_palindrome(1231) == false
@test is_palindrome(91*99) == true

function largest_palindrome(n_digits::Integer)
    max_num = 10^(n_digits) - 1
    largest = 0
    # this obviously doesn't scale because it scales
    # like (10^n_digits)^2. But it works for 3.
    for i in 1:max_num
        for j in i:max_num
            num = i*j
            if is_palindrome(num)
                largest = max(num, largest)
            end
        end
    end
    return largest
end

@test largest_palindrome(1) == 9
@test largest_palindrome(2) == 9009

N = 3
println("Largest palindromic product of $(N) ",
        "digit numbers is $(largest_palindrome(N))")
