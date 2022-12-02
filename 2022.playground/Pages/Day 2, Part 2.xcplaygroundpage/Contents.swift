enum Game: Int {
    case rock = 1
    case paper = 2
    case scissors = 3

    init(char: Character) {
        switch char {
        case "A": self = .rock
        case "B": self = .paper
        case "C": self = .scissors
        default: fatalError()
        }
    }

    func winsTo() -> Game {
        switch self {
        case .rock: return .scissors
        case .paper: return .rock
        case .scissors: return .paper
        }
    }

    func losesTo() -> Game {
        switch self {
        case .rock: return .paper
        case .paper: return .scissors
        case .scissors: return .rock
        }
    }

    static func score(games: (Game, Result)) -> Int {
        switch games {
        case (.rock, .win), (.paper, .win), (.scissors, .win):
            return games.0.losesTo().rawValue + 6
        case (.paper, .draw), (.scissors, .draw), (.rock, .draw):
            return games.0.rawValue + 3
        case (.paper, .lose), (.scissors, .lose), (.rock, .lose):
            return games.0.winsTo().rawValue
        }
    }
}

enum Result {
    case lose
    case draw
    case win

    init(char: Character) {
        switch char {
        case "X": self = .lose
        case "Y": self = .draw
        case "Z": self = .win
        default: fatalError()
        }
    }
}

func getInput(string: String) -> [(Game, Result)] {
    string
        .split(separator: "\n")
        .map { line in
            (Game(char: line.first!), Result(char: line[line.index(line.startIndex, offsetBy: 2)]))
        }
}

func totalScore(input: String) -> Int {
    let games = getInput(string: input)
    let scores = games.map(Game.score(games:))
    return scores.reduce(0, +)
}

let result = totalScore(input: """
<input>
""")
print(result)
