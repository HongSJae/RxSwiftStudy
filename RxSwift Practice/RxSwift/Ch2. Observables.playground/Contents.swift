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

// MARK: - Observable 구독
example(of: "subscribe") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable = Observable.of(one, two, three)
    observable.subscribe { event in
        print(event)
    }
    observable.subscribe { event in
        if let event = event.element {
            print(event)
        }
    }
    observable.subscribe(onNext: { element in
        print(element)
    })
}

example(of: "empty") {
    let observable = Observable<Void>.empty()
    
    observable.subscribe(
        onNext: { element in
            print(element)
        },
        onCompleted: {
            print("Completed!")
        }
    )
}

example(of: "never") {
    let observable = Observable<Void>.never()
    
    observable.subscribe(
        onNext: { element in
            print(element)
        },
        onCompleted: {
            print("Completed!")
        }
    )
}

example(of: "range") {
    let observable = Observable<Int>.range(start: 1, count: 10)
    observable.subscribe(onNext: { i in
        let n = Double(i)
        let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
        print(fibonacci)
    })
}

// MARK: - DisposeBag과 종료
example(of: "DisposeBag") {
    let disposeBag = DisposeBag()

    Observable.of("A", "B", "C")
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
        /// 안쓰면 메모리 누수 일어남
}

enum MyError: Error {
    case anError
}

example(of: "create") {
    let disposeBag = DisposeBag()
    
    Observable<String>.create { observer -> Disposable in
        observer.onNext("1")
//        observer.onError(MyError.anError)
//        observer.onCompleted()
        observer.onNext("?")
        return Disposables.create()
    }
    .subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Compoleted") },
        onDisposed: { print("Disposed") }
    )
//    .disposed(by: disposeBag)
}

}
