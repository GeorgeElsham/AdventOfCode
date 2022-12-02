enum Game: Int {
    case rock = 1
    case paper = 2
    case scissors = 3

    init(char: Character) {
        switch char {
        case "A", "X": self = .rock
        case "B", "Y": self = .paper
        case "C", "Z": self = .scissors
        default: fatalError()
        }
    }

    static func score(games: (Game, Game)) -> Int {
        switch games {
        case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
            return games.1.rawValue + 6
        case (.paper, .paper), (.scissors, .scissors), (.rock, .rock):
            return games.1.rawValue + 3
        case (.paper, .rock), (.scissors, .paper), (.rock, .scissors):
            return games.1.rawValue
        }
    }
}

func getInput(string: String) -> [(Game, Game)] {
    string
        .split(separator: "\n")
        .map { line in
            (Game(char: line.first!), Game(char: line[line.index(line.startIndex, offsetBy: 2)]))
        }
}

func totalScore(input: String) -> Int {
    let games = getInput(string: input)
    let scores = games.map(Game.score(games:))
    return scores.reduce(0, +)
}

let result = totalScore(input: """
<result>
""")
print(result)
