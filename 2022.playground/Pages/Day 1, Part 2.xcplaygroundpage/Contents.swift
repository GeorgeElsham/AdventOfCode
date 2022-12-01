func getInput(string: String) -> [[Int]] {
    string
        .split(separator: "\n", omittingEmptySubsequences: false)
        .split(separator: "")
        .map { group in
            group.map { Int($0)! }
        }
}

func topThreeCalories(input: String) -> Int {
    getInput(string: input)
        .map { group in
            group.reduce(0, +)
        }
        .sorted(by: >)
        .prefix(3)
        .reduce(0, +)
}

let result = topThreeCalories(input: """
<input>
""")
print(result)
