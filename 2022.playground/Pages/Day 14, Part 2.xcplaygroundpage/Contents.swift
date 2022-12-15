struct Position: Hashable {
    let x: Int
    let y: Int

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }

    init(_ s: Substring) {
        let split = s.split(separator: ",")
        self.init(x: Int(split[0])!, y: Int(split[1])!)
    }
}

func getInput(string: String) -> Set<Position> {
    var allPositions = Set<Position>()

    for line in string.split(separator: "\n") {
        let ends = line
            .split(separator: " -> ")
            .map(Position.init)

        var currentEnd = ends.first!
        for end in ends.dropFirst() {
            if currentEnd.x == end.x {
                for y in stride(from: currentEnd.y, through: end.y, by: (end.y - currentEnd.y).signum()) {
                    allPositions.insert(Position(x: end.x, y: y))
                }
            } else {
                for x in stride(from: currentEnd.x, through: end.x, by: (end.x - currentEnd.x).signum()) {
                    allPositions.insert(Position(x: x, y: end.y))
                }
            }
            currentEnd = end
        }
    }

    return allPositions
}

func getRestingSand(input: String) -> Int {
    var rocks = getInput(string: input)
    let yAbyss = rocks.map(\.y).max()! + 1
    var unitsOfSand = 0

    loop: while true {
        var current = Position(x: 500, y: 0)

        while current.y < yAbyss {
            if rocks.contains(current) {
                break loop
            }
            let down = Position(x: current.x, y: current.y + 1)
            let downLeft = Position(x: current.x - 1, y: current.y + 1)
            let downRight = Position(x: current.x + 1, y: current.y + 1)

            if !rocks.contains(down) {
                current = down
            } else if !rocks.contains(downLeft) {
                current = downLeft
            } else if !rocks.contains(downRight) {
                current = downRight
            } else {
                rocks.insert(current)
                break
            }
        }
        if current.y == yAbyss {
            rocks.insert(current)
        }

        unitsOfSand += 1
    }

    return unitsOfSand
}

let result = getRestingSand(input: """
<input>
""")
print(result)
