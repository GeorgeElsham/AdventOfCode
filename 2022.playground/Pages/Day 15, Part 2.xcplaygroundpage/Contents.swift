struct Position {
    let x: Int
    let y: Int
}

struct Pair {
    let sensor: Position
    let beacon: Position

    var manhattanDistance: Int {
        abs(beacon.x - sensor.x) + abs(beacon.y - sensor.y)
    }

    func nonBeaconRange(at y: Int) -> ClosedRange<Int>? {
        let horizontalMovement = manhattanDistance - abs(y - sensor.y)
        guard horizontalMovement >= 0 else {
            return nil
        }

        return sensor.x - horizontalMovement ... sensor.x + horizontalMovement
    }
}

func getInput(string: String) -> [Pair] {
    string
        .split(separator: "\n")
        .map { line in
            let regex = #/
                x=(?<x1>-?\d+).*
                y=(?<y1>-?\d+).*
                x=(?<x2>-?\d+).*
                y=(?<y2>-?\d+)
            /#
            let match = line.firstMatch(of: regex)!.output
            return Pair(
                sensor: Position(x: Int(match.x1)!, y: Int(match.y1)!),
                beacon: Position(x: Int(match.x2)!, y: Int(match.y2)!)
            )
        }
}

func getHiddenCount(input: String) -> Int {
    let pairs = getInput(string: input)

    for rowInspected in 0 ... 4_000_000 {
        var ranges = [ClosedRange<Int>]()

        for pair in pairs {
            if let notBeacons = pair.nonBeaconRange(at: rowInspected)?.clamped(to: 0 ... 4_000_000) {
                ranges.append(notBeacons)
            }
        }

        var lastUpperBound = -1
        for range in ranges.sorted(by: { $0.lowerBound < $1.lowerBound }) {
            if range.upperBound > lastUpperBound {
                if range.lowerBound - lastUpperBound == 2 {
                    return (range.lowerBound - 1) * 4_000_000 + rowInspected
                }
                lastUpperBound = range.upperBound
            }
        }
    }

    fatalError()
}

let result = getHiddenCount(input: """
<input>
""")
print(result)
