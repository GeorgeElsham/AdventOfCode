enum Square: Equatable {
    case start
    case end
    case height(Int)

    var height: Int {
        switch self {
        case .start: return 0
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
                    return .start
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
    var endPosition: Position?
    let start: Position = {
        let row = map.firstIndex { $0.contains(.start) }!
        let column = map[row].firstIndex(of: .start)!
        return Position(x: column, y: row)
    }()

    // Key: current, value: previous
    var paths: [Position: Position] = [start: start]

    while endPosition == nil {
        for current in paths.keys {
            for newPosition in current.surroundingPositions(in: size) {
                if paths[newPosition] == nil {
                    switch newPosition.square(from: map) {
                    case .start:
                        fatalError()
                    case .end:
                        guard current.square(from: map).height >= 24 else {
                            break
                        }
                        paths[newPosition] = current
                        endPosition = newPosition
                    case .height(let height):
                        let previousHeight = current.square(from: map).height
                        guard height <= previousHeight + 1 else {
                            break
                        }
                        paths[newPosition] = current
                    }
                }
            }
        }
    }

    var current = [endPosition!]
    while current.last! != start {
        current.append(paths[current.last!]!)
    }

    return current.count - 1
}

let result = getStepCount(input: """
<input>
""")
print(result)
