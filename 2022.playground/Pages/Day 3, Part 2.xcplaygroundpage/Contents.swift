func getInput(string: String) -> [String] {
    string
        .split(separator: "\n")
        .map(String.init)
}

func itemScore(char: Character) -> Int {
    if char.isLowercase {
        return Int(char.asciiValue! - 96)
    } else if char.isUppercase {
        return Int(char.asciiValue! - 38)
    } else {
        fatalError()
    }
}

func getItemSum(input: String) -> Int {
    let input = getInput(string: input)
    var scores = 0
    for i in stride(from: input.startIndex, to: input.endIndex, by: 3) {
        let r1 = input[i]
        let r2 = input[i + 1]
        let r3 = input[i + 2]
        scores += Set(r1)
            .intersection(r2)
            .intersection(r3)
            .map(itemScore(char:))
            .reduce(0, +)
    }
    return scores
}

let result = getItemSum(input: """
<input>
""")
print(result)
