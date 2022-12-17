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

    func notBeaconPositions(at y: Int) -> Set<Int> {
        let horizontalMovement = manhattanDistance - abs(y - sensor.y)
        guard horizontalMovement >= 0 else {
            return []
        }

        var allPositions = Set<Int>()
        for dx in -horizontalMovement ... horizontalMovement {
            let new = sensor.x + dx
            if y != beacon.y || new != beacon.x {
                allPositions.insert(new)
            }
        }
        return allPositions
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
    let rowInspected = 2_000_000

    let noBeacons: Set<Int> = pairs.reduce(into: []) { partialResult, pair in
        partialResult.formUnion(pair.notBeaconPositions(at: rowInspected))
    }

    return noBeacons.count
}

let result = getHiddenCount(input: """
<input>
""")
print(result)
