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

func getScreen(input: String) -> String {
    let instructions = getInput(string: input)
    var x = 1
    var crt = ""
    var instructionIndex = 0
    var adding: Int?

    for cycle in 1 ... 240 {
        crt.append(abs((cycle - 1) % 40 - x) <= 1 ? "#" : ".")
        if cycle != 240 && cycle.isMultiple(of: 40) {
            crt.append("\n")
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

    return crt
}

let result = getScreen(input: """
<input>
""")
print(result)
