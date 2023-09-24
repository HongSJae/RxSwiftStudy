import Foundation
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

// MARK: - Observable 만들기

example(of: "just, of, from") {
    <#code#>
}
