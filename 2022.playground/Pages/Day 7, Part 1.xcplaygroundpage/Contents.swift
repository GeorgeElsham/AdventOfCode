enum Line {
    case input(Input)
    case output(Output)

    init(line: Substring) {
        if line.first == "$" {
            self = .input(Input(line: line.dropFirst(2)))
        } else {
            self = .output(Output(line: line))
        }
    }
}

enum Input {
    case cdDir(Substring)
    case cdOut
    case cdRoot
    case ls

    init(line: Substring) {
        if line == "cd .." {
            self = .cdOut
        } else if line == "cd /" {
            self = .cdRoot
        } else if line.hasPrefix("cd ") {
            self = .cdDir(line.dropFirst(3))
        } else if line == "ls" {
            self = .ls
        } else {
            fatalError()
        }
    }
}

enum Output {
    case file(Int)
    case dir(Substring)

    init(line: Substring) {
        let split = line.split(separator: " ")
        guard split.count == 2 else {
            fatalError()
        }

        if let size = Int(split[0]) {
            self = .file(size)
        } else if split[0] == "dir" {
            self = .dir(split[1])
        } else {
            fatalError()
        }
    }
}

func getInput(string: String) -> [Line] {
    string
        .split(separator: "\n")
        .map(Line.init)
}

func getTotalSize(input: String) -> Int {
    var dirs = ["/"]
    var files = [(dir: String, size: Int)]()
    var currentDir = ""

    for line in getInput(string: input) {
        switch line {
        case .input(let input):
            switch input {
            case .cdDir(let name):
                currentDir.append("/\(name)")
            case .cdOut:
                let lastSlash = currentDir.lastIndex(of: "/")!
                let newDir = currentDir.prefix(upTo: lastSlash)
                currentDir = String(newDir)
            case .cdRoot:
                currentDir = ""
            case .ls:
                break
            }
        case .output(let output):
            switch output {
            case .dir(let name):
                let newDir = "\(currentDir)/\(name)"
                dirs.append(newDir)
            case .file(let size):
                let newFile = currentDir.isEmpty ? "/" : currentDir
                files.append((newFile, size))
            }
        }
    }

    return dirs
        .map { dir in
            files
                .filter { $0.dir.hasPrefix(dir) }
                .reduce(0, { $0 + $1.size })
        }
        .filter { $0 <= 100_000 }
        .reduce(0, +)
}

let result = getTotalSize(input: """
<input>
""")
print(result)
