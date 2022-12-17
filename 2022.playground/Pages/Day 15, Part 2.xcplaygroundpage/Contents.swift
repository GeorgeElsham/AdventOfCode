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
Sensor at x=3972136, y=2425195: closest beacon is at x=4263070, y=2991690
Sensor at x=3063440, y=2824421: closest beacon is at x=2870962, y=2380928
Sensor at x=982575, y=3224220: closest beacon is at x=883832, y=2000000
Sensor at x=3987876, y=3879097: closest beacon is at x=4101142, y=3623324
Sensor at x=2202219, y=115239: closest beacon is at x=2756860, y=-955842
Sensor at x=2337255, y=2939761: closest beacon is at x=2870962, y=2380928
Sensor at x=1942286, y=3935612: closest beacon is at x=2942943, y=3548053
Sensor at x=228100, y=3955166: closest beacon is at x=-7488, y=4058847
Sensor at x=2114394, y=2368537: closest beacon is at x=2870962, y=2380928
Sensor at x=3658485, y=2855273: closest beacon is at x=4263070, y=2991690
Sensor at x=3731843, y=3995527: closest beacon is at x=4101142, y=3623324
Sensor at x=1311535, y=1294676: closest beacon is at x=883832, y=2000000
Sensor at x=3533617, y=3590533: closest beacon is at x=4101142, y=3623324
Sensor at x=341495, y=287725: closest beacon is at x=110643, y=-1160614
Sensor at x=1533864, y=2131620: closest beacon is at x=883832, y=2000000
Sensor at x=1179951, y=1876387: closest beacon is at x=883832, y=2000000
Sensor at x=3403590, y=1619877: closest beacon is at x=2870962, y=2380928
Sensor at x=2756782, y=3344622: closest beacon is at x=2942943, y=3548053
Sensor at x=14753, y=3818113: closest beacon is at x=-7488, y=4058847
Sensor at x=3808841, y=388411: closest beacon is at x=4559391, y=972750
Sensor at x=3129774, y=3401225: closest beacon is at x=2942943, y=3548053
Sensor at x=2710780, y=3978709: closest beacon is at x=2942943, y=3548053
Sensor at x=88084, y=2475915: closest beacon is at x=883832, y=2000000
Sensor at x=2503969, y=3564612: closest beacon is at x=2942943, y=3548053
Sensor at x=3954448, y=3360708: closest beacon is at x=4101142, y=3623324
Sensor at x=2724475, y=1736595: closest beacon is at x=2870962, y=2380928
""")
print(result)