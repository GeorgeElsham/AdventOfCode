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
    getInput(string: input)
        .flatMap { rucksack in
            let size = rucksack.count / 2
            let p1 = rucksack.prefix(size)
            let p2 = rucksack.suffix(size)
            let intersection = Set(p1).intersection(p2)
            return intersection.map(itemScore(char:))
        }
        .reduce(0, +)
}

let result = getItemSum(input: """
<input>
""")
print(result)
