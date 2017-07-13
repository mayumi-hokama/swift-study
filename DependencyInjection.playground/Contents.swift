//: Playground - noun: a place where people can play

import UIKit

/// DIのProtocol
protocol DependencyInjectionProtocol: class {
    // viewModelは色々あるのでassociatedtype
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func inject(viewModel: ViewModelType)
}
/// extension、変数にセットするだけ
extension DependencyInjectionProtocol where Self: UIViewController {

    func inject(viewModel: ViewModelType) {
        self.viewModel = viewModel
    }
}

/// 外部から注入するようの処理メソッド
struct WelcomeBuilder {
    static func build() -> WelcomeViewModel {
        let useCase = AccountUseCase(dataStore: AccountDataStore())
        let viewModel = WelcomeViewModel(useCase: useCase)
        return viewModel
    }
}

/// viewModelはすべて、こちらを採用するようにする。
protocol DIViewModelProtocol: class {}

/// viewmodel
class WelcomeViewModel: DIViewModelProtocol {
    let useCase: AccountUseCaseProtorol
    init(useCase: AccountUseCaseProtorol) {
        self.useCase = useCase
    }
}

/// usecase
protocol AccountUseCaseProtorol {

}
class AccountUseCase: AccountUseCaseProtorol {
    let dataStore: AccountDataStoreProtocol

    init(dataStore: AccountDataStoreProtocol) {
        self.dataStore = dataStore
    }
}

/// datastore
protocol AccountDataStoreProtocol {
}
struct AccountDataStore: AccountDataStoreProtocol {
}


/// viewcontroller
class WelcomeViewController: UIViewController, DependencyInjectionProtocol {
    typealias ViewModelType = WelcomeViewModel
    var viewModel: ViewModelType!

    override func viewDidLoad() {
        inject(viewModel: WelcomeBuilder.build())
    }
}

