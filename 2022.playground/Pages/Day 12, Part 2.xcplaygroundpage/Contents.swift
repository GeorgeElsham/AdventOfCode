enum Square: Equatable {
    case end
    case height(Int)

    var height: Int {
        switch self {
        case .end: return 25
        case .height(let height): return height
        }
    }
}

func getInput(string: String) -> [[Square]] {
    string
        .split(separator: "\n")
        .map { line in
            line.map { char in
                if char == "S" {
                    return .height(0)
                } else if char == "E" {
                    return .end
                } else {
                    return .height(Int(char.asciiValue! - 97))
                }
            }
        }
}

struct Position: Hashable {
    let x: Int
    let y: Int

    func surroundingPositions(in size: (Int, Int)) -> [Position] {
        var positions = [Position]()

        if x - 1 >= 0 {
            positions.append(Position(x: x - 1, y: y))
        }
        if x + 1 < size.0 {
            positions.append(Position(x: x + 1, y: y))
        }
        if y - 1 >= 0 {
            positions.append(Position(x: x, y: y - 1))
        }
        if y + 1 < size.1 {
            positions.append(Position(x: x, y: y + 1))
        }

        return positions
    }

    func square(from map: [[Square]]) -> Square {
        map[y][x]
    }
}

func getStepCount(input: String) -> Int {
    let map = getInput(string: input)
    let size = (map.first!.count, map.count)
    var startPosition: Position?
    let end: Position = {
        let row = map.firstIndex { $0.contains(.end) }!
        let column = map[row].firstIndex(of: .end)!
        return Position(x: column, y: row)
    }()

    // Key: current, value: previous
    var paths: [Position: Position] = [end: end]

    while startPosition == nil {
        for current in paths.keys {
            for newPosition in current.surroundingPositions(in: size) {
                if paths[newPosition] == nil {
                    switch newPosition.square(from: map) {
                    case .end:
                        fatalError()
                    case .height(let height):
                        let previousHeight = current.square(from: map).height
                        guard height >= previousHeight - 1 else {
                            break
                        }
                        paths[newPosition] = current

                        if height == 0 {
                            startPosition = newPosition
                        }
                    }
                }
            }
        }
    }

    var current = [startPosition!]
    while current.last! != end {
        current.append(paths[current.last!]!)
    }

    return current.count - 1
}

let result = getStepCount(input: """
<input>
""")
print(result)
