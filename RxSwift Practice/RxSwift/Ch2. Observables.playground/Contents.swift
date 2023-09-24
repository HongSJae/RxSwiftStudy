import Foundation
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

// MARK: - Observable 만들기
example(of: "just, of, from") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable: Observable<Int> = Observable<Int>.just(one)
    /// one 정수를 이용한 just method를 통해 Int 타입의 Observable Sequence를 생성
    /// one은 오직 하나의 요소를 갖는 Sequence를 생성

    let observable2 = Observable.of(one, two, three)
    let observable3 = Observable.of([one, two, three])
    /// Observable Array 만들고 싶으면 이거 쓰면 됨

    let observable4 = Observable.from([one, two, three])
    /// Array만 담을 수 있음
    
}

example(of: "just, of, from") {
    <#code#>
}
