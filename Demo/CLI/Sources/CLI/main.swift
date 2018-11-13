import Foundation
import OperantKit

func printAvailableExperiments() {
    print("""
    +--------+-------------------+
    |   Available experiments    |
    +--------+-------------------+
    | Number | Experiment Title  |
    +--------+-------------------+
    """)

    Experiment.allCases.forEach {
        print("""
            | \($0.rawValue)\(String(repeating: " ", count: 6 - "\($0.rawValue)".count)) | \($0.shortName)\(String(repeating: " ", count: 16 - "\($0.shortName)".count))  |
            """)
    }

    print("""
    |        |                   |
    | 0      | cancel            |
    +--------+-------------------+
    """)
}

printAvailableExperiments()
while true {
    print()
    print("Which number would you like run?")
    print("> ", terminator: "")

    let input = readLine() ?? ""
    let num = Int(input) ?? -1
    guard input != "q", num != 0 else { exit(0) }
    guard let experiment = Experiment(rawValue: num) else { continue }

    print("\(experiment.rawValue). \(experiment.longName) schedule")
    experiment.run()
}
