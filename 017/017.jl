using Base.Test

function write_out_under_1000(n::Integer)
    number_to_word = [0 => "",  # since it's mostly a placeholder
                      1 => "one",
                      2 => "two",
                      3 => "three",
                      4 => "four",
                      5 => "five",
                      6 => "six",
                      7 => "seven",
                      8 => "eight",
                      9 => "nine",
                     10 => "ten",
                     11 => "eleven",
                     12 => "twelve",
                     14 => "fourteen"]
    number_to_prefix = [2 => "twen",
                        3 => "thir",
                        4 => "for",
                        5 => "fif"]
    words = ""
    n = n % 1000
    if n >= 100
        hund, n = divrem(n, 100)
        words *= number_to_word[hund] * " hundred "
        if n != 0
            words *= "and "
        end
    end
    if n >= 20
        tens, n = divrem(n, 10)
        # twenty, thirty, forty, fifty are special
        words *= get(number_to_prefix, tens,
                     number_to_word[tens]) * "ty "
    end
    if haskey(number_to_word, n)
        words *= number_to_word[n]
    else
        last = n % 10
        # Again, thirteen, fifteen are special
        words *= get(number_to_prefix, last,
                     number_to_word[last]) * "teen"
    end
    return strip(words)
end

function write_out(n::Integer)
    if n == 0
        return "zero"
    end
    scales = [(1000000000, "billion"),
              (   1000000, "million"),
              (      1000, "thousand"),
              (         1, "")]
    words = ""
    for (bignum, word) in scales
        if n >= bignum
            words *= write_out_under_1000(div(n, bignum))
            words *= " " * word * " "
        end
    end
    return strip(words)
end

@test write_out(1) == "one"
@test write_out(15) == "fifteen"
@test write_out(16) == "sixteen"
@test write_out(100) == "one hundred"
@test write_out(360) == "three hundred and sixty"
@test write_out(412) == "four hundred and twelve"
@test write_out(942) == "nine hundred and forty two"
@test write_out(1000) == "one thousand"
@test write_out(1234567) == ("one million two hundred and thirty four " *
                             "thousand five hundred and sixty seven")

function count_letters_in_number_word(n::Integer)
    words = write_out(n)
    just_letters = replace(words, " ", "")
    return length(just_letters)
end

@test count_letters_in_number_word(1) == 3
@test count_letters_in_number_word(342) == 23
@test count_letters_in_number_word(115) == 20


function count_letters_in_number_words_upto(n::Integer)
    count = 0
    for i in 1:n
        count += count_letters_in_number_word(i)
    end
    return count
end

@test count_letters_in_number_words_upto(1) == 3
@test count_letters_in_number_words_upto(5) == 19
N = 1000
println("The sum of all letters in all written-out numbers ",
        "between 1 and $(N) is ",
        "$(count_letters_in_number_words_upto(N))")
