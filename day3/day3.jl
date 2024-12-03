function import_data(full_path::String)::String
    input = read(full_path, String) 

    return input
end

function extract_mul(input::String)
    re = r"mul\((\d{1,3}),(\d{1,3})\)"

    return [[m[1], m[2]] for m in eachmatch(re, input)] 
end

function calc_val(input)::Int
    input_ints = parse.(Int, input)
    return prod(input_ints)
end

function part1(input::String)
    matches = extract_mul(input)
    result = calc_val.(matches)

    return result
end

function find_offsets(input, reg::Regex)
    return [m.offset for m in eachmatch(reg, input)]
end

function create_do_range(do_val, donts)
    dont_val = donts[findfirst(do_val .< donts)]
    return do_val, dont_val
end

function create_filter(mul, range)
    return any(getindex.(range,1) .< mul .< getindex.(range,2))
end

function part2(input::String)
    dos = find_offsets(input, r"do\(\)")
    donts = find_offsets(input, r"don\'t\(\)")

    pushfirst!(dos, 0)

    if maximum(dos) > maximum(donts)
        push!(donts, length(input))
    end
    muls = find_offsets(input, r"mul\(\d{1,3},\d{1,3}\)")

    results = part1(input)

    range = create_do_range.(dos, Ref(donts))

    filt = create_filter.(muls, Ref(range))

    return results[filt]

end

function run_day(part::String, file_name::String, day::String = "day3")
    full_path = joinpath(pwd(), day, file_name)
    input = import_data(full_path)

    if part == "1"
        result = part1(input)
    elseif part == "2"
        result = part2(input)
    end

    println(sum(result))
end

run_day(ARGS[1], ARGS[2])