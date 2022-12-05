func getInput(string: String) -> [(ClosedRange<Int>, ClosedRange<Int>)] {
    string
        .split(separator: "\n")
        .map { line in
            let split = line.split(separator: ",")
            let leftSplit = split[0].split(separator: "-")
            let rightSplit = split[1].split(separator: "-")
            let left = Int(leftSplit[0])! ... Int(leftSplit[1])!
            let right = Int(rightSplit[0])! ... Int(rightSplit[1])!
            return (left, right)
        }
}

func getCount(input: String) -> Int {
    getInput(string: input)
        .filter { ranges in
            let inside = ranges.0.lowerBound >= ranges.1.lowerBound && ranges.0.upperBound <= ranges.1.upperBound
            let outside = ranges.0.lowerBound <= ranges.1.lowerBound && ranges.0.upperBound >= ranges.1.upperBound
            return inside || outside
        }
        .count
}

let result = getCount(input: """
<input>
""")
print(result)
