func getInput(string: String) -> [[Int]] {
    string
        .split(separator: "\n")
        .map { line in
            line.map { Int(String($0))! }
        }
}

struct Location {
    let x: Int
    let y: Int
}

func getOtherTreesOnRow(trees: [[Int]], location: Location) -> (left: ArraySlice<Int>, right: ArraySlice<Int>) {
    let row = trees[location.y]
    return (
        left: row.prefix(upTo: location.x),
        right: row.suffix(from: location.x + 1)
    )
}

func getOtherTreesOnColumn(trees: [[Int]], location: Location) -> (top: ArraySlice<Int>, bottom: ArraySlice<Int>) {
    let column = trees.map(\.[location.x])
    return (
        top: column.prefix(upTo: location.y),
        bottom: column.suffix(from: location.y + 1)
    )
}

func scenicScore(trees: [[Int]], location: Location) -> Int {
    let current = trees[location.y][location.x]
    let row = getOtherTreesOnRow(trees: trees, location: location)
    let column = getOtherTreesOnColumn(trees: trees, location: location)

    let left = row.left
        .reversed()
        .firstIndex { $0 >= current }
        .map { $0 + 1 }
    ?? row.left.count

    let right = row.right
        .firstIndex { $0 >= current }
        .map { $0 + 1 - row.right.startIndex }
    ?? row.right.count

    let top = column.top
        .reversed()
        .firstIndex { $0 >= current }
        .map { $0 + 1 }
    ?? column.top.count

    let bottom = column.bottom
        .firstIndex { $0 >= current }
        .map { $0 + 1 - column.bottom.startIndex }
    ?? column.bottom.count

    return left * right * top * bottom
}

func getTotalVisible(input: String) -> Int {
    let trees = getInput(string: input)
    var highestScore: (location: Location, score: Int)!

    let rowIndices = trees.first!.indices
    for columnIndex in trees.indices {
        for rowIndex in rowIndices {
            let location = Location(x: columnIndex, y: rowIndex)
            let score = scenicScore(trees: trees, location: location)

            if highestScore == nil || score > highestScore.score {
                highestScore = (location: location, score: score)
            }
        }
    }

    return highestScore.score
}

let result = getTotalVisible(input: """
<input>
""")
print(result)
