enum Operation {
    case add(Int)
    case multiply(Int)
    case square
}

struct Test {
    let divisor: Int
    let trueMonkey: Int
    let falseMonkey: Int
}

struct Monkey {
    var items: [Int]
    let operation: Operation
    let test: Test
}

func getInput(string: String) -> [Monkey] {
    string
        .split(separator: "\n\n")
        .map { chunk in
            let lines = chunk.split(separator: "\n")
            let items = lines[1].dropFirst(18).split(separator: ", ").map { Int(String($0))! }
            let operation: Operation = {
                let opLine = lines[2]
                if opLine[opLine.index(opLine.startIndex, offsetBy: 25)] == "o" {
                    return .square
                } else if opLine[opLine.index(opLine.startIndex, offsetBy: 23)] == "+" {
                    return .add(Int(String(opLine.dropFirst(25)))!)
                } else {
                    return .multiply(Int(String(opLine.dropFirst(25)))!)
                }
            }()
            let test = Test(
                divisor: Int(lines[3].dropFirst(21))!,
                trueMonkey: Int(String(lines[4].last!))!,
                falseMonkey: Int(String(lines[5].last!))!
            )
            return Monkey(items: items, operation: operation, test: test)
        }
}

func getMonkeyBusiness(input: String) -> Int {
    var monkeys = getInput(string: input)
    var inspections = [Int](repeating: 0, count: monkeys.count)

    for _ in 1 ... 20 {
        for monkeyIndex in monkeys.indices {
            let monkey = monkeys[monkeyIndex]
            inspections[monkeyIndex] += monkey.items.count

            for item in monkey.items {
                var worryLevel: Int

                switch monkey.operation {
                case .add(let value): worryLevel = item + value
                case .multiply(let value): worryLevel = item * value
                case .square: worryLevel = item * item
                }

                worryLevel /= 3

                if worryLevel.isMultiple(of: monkey.test.divisor) {
                    monkeys[monkey.test.trueMonkey].items.append(worryLevel)
                } else {
                    monkeys[monkey.test.falseMonkey].items.append(worryLevel)
                }
            }

            monkeys[monkeyIndex].items.removeAll()
        }
    }

    return inspections
        .sorted(by: >)
        .prefix(2)
        .reduce(1, *)
}

let result = getMonkeyBusiness(input: """
<input>
""")
print(result)
