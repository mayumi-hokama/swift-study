//: Playground - noun: a place where people can play

import UIKit

protocol ChoiceTypeProtocol {}
protocol QuestionInputDataType {}
protocol ChoiceInputDataType {
    associatedtype ChoiceType: ChoiceTypeProtocol
    var choices: [ChoiceType] { get set }
}
protocol checkDataProtocol {}

struct CheckInputTypeData: QuestionInputDataType, ChoiceInputDataType {
    
    typealias ChoiceType = CheckInputTypeData.Choice
    
    let choiceMin: Int?
    let choiceMax: Int?
    var choices: [ChoiceType]
    
    
    struct Choice: checkDataProtocol, ChoiceTypeProtocol {
        let choiceId: Int
        let name: String
        let description: String?
    }
}
struct LoanCheckInputTypeData: QuestionInputDataType, ChoiceInputDataType {
    
    typealias ChoiceType = LoanCheckInputTypeData.Choice
    
    let choiceMin: Int?
    let choiceMax: Int?
    var choices: [ChoiceType]
    
    
    struct Choice: checkDataProtocol, ChoiceTypeProtocol {
        let choiceId: Int
        let name: String
    }
}

class TestClass<ChoiceInputDataType>: UIView {
    
    var data: ChoiceInputDataType!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(data: ChoiceInputDataType) {
        self.init(frame: .zero)
        self.data = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let choice = CheckInputTypeData.Choice(choiceId: 1, name: "aaa", description: nil)
let model = CheckInputTypeData(choiceMin: 1, choiceMax: 2, choices: [choice])

let tclass = TestClass(data: model)
tclass.data.choices.count


let loanChoice = LoanCheckInputTypeData.Choice(choiceId: 2, name: "てすと")
let loanModel  = LoanCheckInputTypeData(choiceMin: 2, choiceMax: 5, choices: [loanChoice])
let loanTest = TestClass(data: loanModel)
loanTest.data.choices
