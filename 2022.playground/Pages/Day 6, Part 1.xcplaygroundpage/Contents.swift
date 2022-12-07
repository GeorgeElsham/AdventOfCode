import Combine

func getMarkerPosition(input: String) -> Int {
    let result = input.publisher
        .scan((0, "")) { partial, char in
            var newStr = partial.1.suffix(3)
            newStr.append(char)
            return (partial.0 + 1, String(newStr))
        }
        .first { current in
            Set(current.1).count == 4
        }

    return result.output!.0
}

let result = getMarkerPosition(input: """
<input>
""")
print(result)
