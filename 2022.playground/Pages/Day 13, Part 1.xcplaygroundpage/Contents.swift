enum Part {
    case element(Int)
    case array([Part])

    var asArray: [Part] {
        switch self {
        case .element(_): return [self]
        case .array(let parts): return parts
        }
    }

    init(_ input: Substring) {
        if let value = Int(input) {
            self = .element(value)
        } else {
            var index = 1
            var leftBrackets = 1
            var rightBrackets = 0
            var commas = 0
            var removeFrom: Substring.Index?
            var removing = [(index: Int, range: ClosedRange<Substring.Index>)]()

            loop: while true {
                let inputIndex = input.index(input.startIndex, offsetBy: index)

                switch input[inputIndex] {
                case "[":
                    leftBrackets += 1
                    if leftBrackets - rightBrackets == 2 {
                        removeFrom = inputIndex
                    }
                case "]":
                    rightBrackets += 1
                    if leftBrackets == rightBrackets {
                        break loop
                    } else if leftBrackets - rightBrackets == 1 {
                        let range = removeFrom! ... inputIndex
                        removing.append((index: commas, range: range))
                        removeFrom = nil
                    }
                case ",":
                    if removeFrom == nil {
                        commas += 1
                    }
                default:
                    break
                }

                index += 1
            }

            var cleanInput = input
            for range in removing.reversed().map(\.range) {
                cleanInput.removeSubrange(range)
            }

            var arr = cleanInput
                .dropFirst()
                .dropLast()
                .split(separator: ",", omittingEmptySubsequences: false)
                .map { $0.isEmpty ? nil : Part($0) }

            for nestedArray in removing {
                let removed = input[nestedArray.range]
                arr[nestedArray.index] = Part(removed)
            }

            self = .array(arr.compactMap { $0 })
        }
    }
}

extension Part: Comparable {
    static func < (lhs: Part, rhs: Part) -> Bool {
        switch (lhs, rhs) {
        case (.element(let lv), .element(let rv)):
            return lv < rv
        case (.element, .array):
            return .array([lhs]) < rhs
        case (.array, .element):
            return lhs < .array([rhs])
        case (.array(let left), .array(let right)):
            for index in 0 ..< max(left.count, right.count) {
                if index == left.count {
                    return true
                } else if index == right.count {
                    return false
                } else {
                    if left[index] < right[index] {
                        return true
                    } else if left[index] > right[index] {
                        return false
                    }
                }
            }
            return false
        }
    }
}

func getInput(string: String) -> [(left: Part, right: Part)] {
    string
        .split(separator: "\n\n")
        .map { line in
            let parts = line.split(separator: "\n")
            return (
                left: Part(parts[0]),
                right: Part(parts[1])
            )
        }
}

func getIndicesSum(input: String) -> Int {
    let packetPairs = getInput(string: input)
    var sum = 0

    for (index, pair) in zip(1..., packetPairs) {
        if pair.left < pair.right {
            sum += index
        }
    }

    return sum
}

let result = getIndicesSum(input: """
<input>
""")
print(result)
