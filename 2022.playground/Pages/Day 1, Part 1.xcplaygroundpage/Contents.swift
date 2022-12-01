func getInput(string: String) -> [[Int]] {
    string
        .split(separator: "\n", omittingEmptySubsequences: false)
        .split(separator: "")
        .map { group in
            group.map { Int($0)! }
        }
}

func maxCalories(input: String) -> Int {
    getInput(string: input)
        .map { group in
            group.reduce(0, +)
        }
        .max()!
}

let result = maxCalories(input: """
<input>
""")
print(result)
