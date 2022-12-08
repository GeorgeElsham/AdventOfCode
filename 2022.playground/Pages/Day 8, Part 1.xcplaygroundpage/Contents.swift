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

func isVisible(trees: [[Int]], location: Location) -> Bool {
    let current = trees[location.y][location.x]
    let row = getOtherTreesOnRow(trees: trees, location: location)
    let column = getOtherTreesOnColumn(trees: trees, location: location)

    let allMax = [
        row.left.max() ?? -1,
        row.right.max() ?? -1,
        column.top.max() ?? -1,
        column.bottom.max() ?? -1
    ]

    return allMax.contains { max in
        current > max
    }
}

func getTotalVisible(input: String) -> Int {
    let trees = getInput(string: input)
    var total = 0

    let rowIndices = trees.first!.indices
    for columnIndex in trees.indices {
        for rowIndex in rowIndices {
            if isVisible(trees: trees, location: Location(x: columnIndex, y: rowIndex)) {
                total += 1
            }
        }
    }

    return total
}

let result = getTotalVisible(input: """
<input>
""")
print(result)
