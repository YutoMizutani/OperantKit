import Foundation

public func example(_ description: String, action: () -> Void) {
    printExampleHeader(description)
    action()
    printExampleFooter()
}

public func printExampleHeader(_ description: String) {
    print("\nExample: \(description)")
    print("[")
}

public func printExampleFooter() {
    print("]")
}
