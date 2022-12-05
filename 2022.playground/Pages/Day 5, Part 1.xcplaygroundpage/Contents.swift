struct Instruction {
    let count: Int
    let original: Int
    let destination: Int

    init(move count: Int, from original: Int, to destination: Int) {
        self.count = count
        self.original = original
        self.destination = destination
    }
}

func getInput(string: String) -> (crates: [[Character]], instructions: [Instruction]) {
    let sections = string.split(separator: "\n\n")

    let filteredCrates = sections[0]
        .split(separator: "\n")
        .dropLast()

    let stackCount = (filteredCrates.last!.count + 1) / 4
    var crates = [[Character]](repeating: [], count: stackCount)
    for line in filteredCrates {
        for (index, char) in line.enumerated().filter({ $0.offset % 4 == 1 }) where char != " " {
            crates[(index + 1) / 4].insert(char, at: 0)
        }
    }

    let instructions = sections[1]
        .split(separator: "\n")
        .map { line in
            let split = line.split(separator: " ")
            return Instruction(move: Int(split[1])!, from: Int(split[3])!, to: Int(split[5])!)
        }

    return (crates, instructions)
}

func getTopCrates(input: String) -> String {
    let input = getInput(string: input)
    var crates = input.crates

    for instruction in input.instructions {
        for _ in 0 ..< instruction.count {
            let top = crates[instruction.original - 1].removeLast()
            crates[instruction.destination - 1].append(top)
        }
    }

    return String(crates.compactMap(\.last))
}

let result = getTopCrates(input: """
<input>
""")
print(result)
