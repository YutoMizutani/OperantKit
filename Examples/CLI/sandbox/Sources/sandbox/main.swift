import Foundation
import OperantKit

print(Experiment.availables())
while true {
    print("\nWhich number would you like run?\n> ", terminator: "")

    let input = readLine() ?? ""
    let num = Int(input) ?? -1
    guard input != "q", num != 0 else { exit(0) }
    guard let experiment = Experiment(rawValue: num) else { continue }

    print("\(experiment.rawValue). \(experiment.longName) schedule")
    experiment.run()
    break
}
