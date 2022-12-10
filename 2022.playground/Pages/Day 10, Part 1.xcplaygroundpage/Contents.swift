enum Instruction {
    case addx(Int)
    case noop
}

func getInput(string: String) -> [Instruction] {
    string
        .split(separator: "\n")
        .map { line in
            if line == "noop" {
                return Instruction.noop
            } else {
                return Instruction.addx(Int(line.dropFirst(5))!)
            }
        }
}

func getTotalSignalStrength(input: String) -> Int {
    let instructions = getInput(string: input)
    var x = 1
    var totalSignalStrength = 0
    var instructionIndex = 0
    var adding: Int?

    for cycle in 1 ... 220 {
        if (cycle - 20).isMultiple(of: 40) {
            totalSignalStrength += x * cycle
        }

        if let v = adding {
            x += v
            adding = nil
            instructionIndex += 1
        } else {
            switch instructions[instructionIndex] {
            case .addx(let v):
                adding = v
            case .noop:
                instructionIndex += 1
            }
        }
    }

    return totalSignalStrength
}

let result = getTotalSignalStrength(input: """
<input>
""")
print(result)
