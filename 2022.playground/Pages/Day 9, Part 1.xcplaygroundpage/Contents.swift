enum Direction {
    case left
    case right
    case up
    case down

    init(char: Character) {
        switch char {
        case "L": self = .left
        case "R": self = .right
        case "U": self = .up
        case "D": self = .down
        default: fatalError()
        }
    }
}

struct Move {
    let direction: Direction
    let steps: Int
}

func getInput(string: String) -> [Move] {
    string
        .split(separator: "\n")
        .map { line in
            Move(
                direction: Direction(char: line.first!),
                steps: Int(line.dropFirst(2))!
            )
        }
}

struct Position: Hashable {
    static let zero = Position(x: 0, y: 0)

    var x: Int
    var y: Int

    mutating func move(in direction: Direction) {
        switch direction {
        case .left: x -= 1
        case .right: x += 1
        case .up: y += 1
        case .down: y -= 1
        }
    }

    mutating func chase(position: Position) {
        let dx = position.x - x
        let dy = position.y - y

        if dx == 0 {
            y += dy / 2
        } else if dy == 0 {
            x += dx / 2
        } else if abs(dx) == 2 {
            x += dx / 2
            y += dy
        } else if abs(dy) == 2 {
            x += dx
            y += dy / 2
        }
    }
}

func getPositionCount(input: String) -> Int {
    let moves = getInput(string: input)
    var head = Position.zero
    var tail = Position.zero
    var visited = Set<Position>()

    for move in moves {
        for _ in 0 ..< move.steps {
            head.move(in: move.direction)
            tail.chase(position: head)
            visited.insert(tail)
        }
    }

    return visited.count
}

let result = getPositionCount(input: """
<input>
""")
print(result)
