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

// MARK: - Observable Factory 만들기
example(of: "deferred") {
    let disposeBag = DisposeBag()
    
    var flip = false
    
    let factory: Observable<Int> = Observable.deferred {
        flip.toggle()

        return flip ? Observable.of(1, 2, 3) : .of(4, 5, 6)
    }

    for _ in 0...3 {
        factory.subscribe(onNext: { element in
            print(element, terminator: "")
        })
        .disposed(by: disposeBag)

        print("")
    }
}

// MARK: - Traits 사용
/* Single
- .success(value) or.error
- .success = .next and .complete
- 사용: 성공 또는 실패로 확인될 수 있는 1회성 프로세스 (예. 데이터 다운로드, 디스크에서 데이터 로딩)
*/

/* Completable
- .complete or .error
- 사용: 연산이 제대로 완료되었는지만 확인하고 싶을 때 (예. 파일 쓰기)
*/

/* Maybe
- Single + Completable
- success(value), .completed, .error를 모두 방출할 수 있다.
- 사용: 프로세스가 성공, 실패 여부와 더불어 출력된 값도 내뱉을 수 있을 때
- 자세한 내용은 Ch4. 부터 더 접할 수 있으며 지금은 아주 간단한 예제로만 확인하자
*/

example(of: "Single") {
    
    let disposeBag = DisposeBag()
    
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    func loadText(from name: String) -> Single<String> {
        return Single.create{ single in
            let disposable = Disposables.create()
            
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.failure(FileReadError.fileNotFound))
                return disposable
            }
            
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.failure(FileReadError.unreadable))
                return disposable
            }
            
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.failure(FileReadError.encodingFailed))
                return disposable
            }
            
            single(.success(contents))
            return disposable
        }
    }

    loadText(from: "Copyright")
        .subscribe(
            onSuccess: { print($0) },
            onFailure: { print($0) }
        )
        .disposed(by: disposeBag)
}

//MARK: - Challenges

/// Q. 앞선 never 예제에 do 연산자의 onSubscribe 핸들러를 이용해서 프린트 해 볼 것. dispose bag을 subscription에 추가하도록 할 것.
example(of: "never") {
    let observable = Observable<Any>.never()

    let disposeBag = DisposeBag()
    
    observable
        .do(
            onSubscribe: { print("Subscribe") }
        )
        .subscribe(
            onNext: { print($0) },
            onCompleted: { print("Completed") }
        )
        .disposed(by: disposeBag)
}

/// Q. 1번 문제를 debug 연산자를 통해 프린트 해 볼 것.
example(of: "never") {
    let observable = Observable<Any>.never()

    let disposeBag = DisposeBag()
    
    observable
        .debug("never 확인")
        .subscribe()
        .disposed(by: disposeBag)
}
