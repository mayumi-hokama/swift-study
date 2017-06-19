import UIKit

/// バリデーション用protocol
protocol Validator {
}
protocol ValidatorString: Validator {
    func validate(_ value: String?) -> ValidationResult
}
protocol ValidatorInt: Validator {
    func validate(_ value: Int) -> ValidationResult
}

// ValidationのRule
protocol ValidationRule {
    associatedtype InputType
    func validate(_ value: InputType) -> ValidationResult
}

/// いろんなruleを格納するstruct
struct AnyValidationRule<InputType>: ValidationRule {
    
    /// ValidationRuleのvalidateメソッドを格納しておく変数
    private let baseValidateInput: (_: InputType) -> ValidationResult
    
    /// TODO: ここの意味わからん
    init<R: ValidationRule>(base: R) where R.InputType == InputType {
        baseValidateInput = base.validate
    }
    
    func validate(_ value: InputType) -> ValidationResult {
        return baseValidateInput(value)
    }
}

/// Validationエラープロトコル
protocol ValidationErrorType: Error {
    var message: String { get }
}

/// Validationの結果enum
enum ValidationResult {
    case valid
    case invalid(of: ValidationErrorType)
}
enum CommonInputError: ValidationErrorType {
    case fatal
    
    var message: String {
        switch self {
        case .fatal:
            return "不正なエラーが発生しました。\n時間を置いて再度お試しください。"
        }
    }
}

enum NumberInputError: ValidationErrorType {
    case required
    case min(Int)
    case max(Int)
    case format
    
    var message: String {
        switch self {
        case .required:
            return "必須項目です。\n値を入力してください。"
        case .min(let num):
            return String(format: "%d以上で入力してください。", num)
        case .max(let num):
            return String(format: "%d以下で入力してください。", num)
        case .format:
            return "数値を入力してください。"
        }
    }
}

enum CheckInputError: ValidationErrorType {
    case required
    case min(Int)
    case max(Int)
    
    var message: String {
        switch self {
        case .required:
            return "必須項目です。\nいずれかを選択してください。"
        case .min(let num):
            return String(format: "最低%d個選択してください。", num)
        case .max(let num):
            return String(format: "%d個まで選択可能です。", num)
        }
    }
}
enum RadioInputError: ValidationErrorType {
    case none
    case required
    case selected
    case orSelected
    case duplicated
    
    var message: String {
        switch self {
        case .none:
            return ""
        case .required:
            return "必須項目です。\nいずれかを選択してください。"
        case .selected:
            return "いずれかを選択してください。"
        case .orSelected:
            return "いずれかを選択するか、入力項目に値を入力してください。"
        case .duplicated:
            return "選択値、入力値のいずれかをお選びください。"
        }
    }
}
enum FreeTextInputError: ValidationErrorType {
    case none
    case required
    
    var message: String {
        switch self {
        case .none:
            return ""
        case .required:
            return "必須項目です。\n値を入力してください。"
        }
    }
}

/// ruleを格納する配列を作る構造体
struct CompositeValidator<InputType> {
    
    // バリデーターをいれておく変数
    private var validators = [AnyValidationRule<InputType>]()
    
    public init() {
        
    }
    
    public init<R: ValidationRule>(rules: [R]) where R.InputType == InputType {
        self.validators = rules.map(AnyValidationRule.init)
    }
    
    public mutating func add<R: ValidationRule>(rule: R) where R.InputType == InputType {
        let anyRule = AnyValidationRule<InputType>(base: rule)
        validators.append(anyRule)
    }
    
    func validate(_ value: InputType) -> ValidationResult {
        
        for validator in validators {
            
            //            guard let validator = validator as? ValidatorInt else {
            //                return .invalid(of: CommonInputError.fatal)
            //            }
            print(validator.validate(value))
            switch validator.validate(value) {
            case .valid:
                return .valid
            case .invalid(let error):
                return .invalid(of: error)
            }
        }
        
        return .invalid(of: CommonInputError.fatal)
    }
}

struct CompositeValidatorForNumber: ValidatorInt {
    
    private let validators: [Validator]
    
    init(validators: Validator...) {
        self.validators = validators
    }
    
    init(validators: [Validator]) {
        self.validators = validators
    }
    
    func validate(_ value: Int) -> ValidationResult {
        
        for validator in validators {
            
            guard let validator = validator as? ValidatorInt else {
                return .invalid(of: CommonInputError.fatal)
            }
            switch validator.validate(value) {
            case .valid:
                break
            case .invalid(let error):
                return .invalid(of: error)
            }
        }
        
        return .valid
    }
}


/// 数値のValidation
struct NumberValidationFormat: ValidationRule {
    
    typealias InputType = String?
    
    private let invalidError: ValidationErrorType
    private let regexPhonePattern = "^\\d+$"
    
    init(invalidError: ValidationErrorType) {
        self.invalidError = invalidError
    }
    
    func validate(_ value: String?) -> ValidationResult {
        
        guard let num = value else {
            return .invalid(of: invalidError)
        }
        
        //        if !num.isMatch(pattern: regexPhonePattern) {
        //            return .invalid(of: invalidError)
        //        }
        
        return .valid
    }
}

/// 小数点込みの数値
struct DecimalValidationFormat: ValidatorString {
    
    private let invalidError: ValidationErrorType
    private let regexPhonePattern = "\\d+(\\.\\d+)?"
    
    init(invalidError: ValidationErrorType) {
        self.invalidError = invalidError
    }
    
    func validate(_ value: String?) -> ValidationResult {
        
        guard let num = value else {
            return .invalid(of: invalidError)
        }
        
        //        if !num.isMatch(pattern: regexPhonePattern) {
        //            return .invalid(of: invalidError)
        //        }
        
        return .valid
    }
}

struct ValidationMaximumForText: ValidationRule {
    
    typealias InputType = String?
    
    private let invalidError: ValidationErrorType
    private let maximum: Int
    
    init(invalidError: ValidationErrorType, maximum: Int) {
        self.invalidError = invalidError
        self.maximum      = maximum
    }
    
    func validate(_ value: String?) -> ValidationResult {
        
        guard let num = value else {
            return .invalid(of: invalidError)
        }
        
        // String -> Double
        guard let doubleVal: Double = Double(num) else {
            return .invalid(of: invalidError)
        }
        
        // Double -> Int
        let number: Int = Int(doubleVal)
        
        if number <= maximum {
            return .valid
        }
        
        return .invalid(of: invalidError)
    }
    
}

struct ValidationMaximumForNumber: ValidationRule {
    typealias InputType = Int
    
    private let invalidError: ValidationErrorType
    private let maximum: Int
    
    init(invalidError: ValidationErrorType, maximum: Int) {
        self.invalidError = invalidError
        self.maximum      = maximum
    }
    
    func validate(_ value: Int) -> ValidationResult {
        
        if value <= maximum {
            return .valid
        }
        
        return .invalid(of: invalidError)
    }
    
}


/// 最大値かどうかチェックするValidator
struct ValidationIsMaxForNumber: ValidationRule {
    typealias InputType = Int
    
    private let invalidError: ValidationErrorType
    private let maximum: Int
    
    init(invalidError: ValidationErrorType, maximum: Int) {
        self.invalidError = invalidError
        self.maximum      = maximum
    }
    
    func validate(_ value: Int) -> ValidationResult {
        
        if value < maximum {
            return .valid
        }
        
        return .invalid(of: invalidError)
    }
}
// 必須チェック用のバリデータ
struct ValidationRadio: ValidationRule {
    
    typealias InputType = Int
    
    private let other: Bool
    private let otherText: String?
    
    init(other: Bool, otherText: String?) {
        self.other = other
        self.otherText = otherText
    }
    
    func validate(_ value: Int) -> ValidationResult {
        
        if self.other {
            if let text = otherText {
                // どちらも選択/入力されていない場合はエラー
                if text.characters.count <= 0, value <= 0 {
                    return ValidationResult.invalid(of: RadioInputError.orSelected)
                    // 両方入っている場合もエラー
                } else if text.characters.count > 0, value > 0 {
                    return ValidationResult.invalid(of: RadioInputError.duplicated)
                }
            }
        } else {
            // otherがない場合はどれか選択する
            if value <= 0 {
                return ValidationResult.invalid(of: RadioInputError.selected)
            }
        }
        
        return ValidationResult.valid
    }
}



/// 最小値のバリデーション
struct ValidationMinimumForText: ValidationRule {
    
    typealias InputType = String?
    
    private let invalidError: ValidationErrorType
    private let minimum: Int
    
    init(invalidError: ValidationErrorType, minimum: Int) {
        self.invalidError = invalidError
        self.minimum      = minimum
    }
    
    func validate(_ value: String?) -> ValidationResult {
        
        guard let num = value else {
            return .invalid(of: invalidError)
        }
        
        // String -> Double
        guard let doubleVal: Double = Double(num) else {
            return .invalid(of: invalidError)
        }
        
        // Double -> Int
        let number: Int = Int(doubleVal)
        
        if number >= minimum {
            return .valid
        }
        
        return .invalid(of: invalidError)
    }
    
}

struct ValidationMinimumForNumber: ValidationRule {
    
    typealias InputType = Int
    private let invalidError: ValidationErrorType
    private let minimum: Int
    
    init(invalidError: ValidationErrorType, minimum: Int) {
        self.invalidError = invalidError
        self.minimum      = minimum
    }
    
    func validate(_ value: Int) -> ValidationResult {
        
        if value >= minimum {
            return .valid
        }
        
        return .invalid(of: invalidError)
    }
    
}

protocol ValidationQuestionProtocol: class {
    var required: Bool { get set }
    var other: Bool { get set }
    func numberValid(min: Int, max: Int, text: String?) -> ValidationResult
//    func checkValid(min: Int, max: Int, selectedCount: Int) -> ValidationResult
//    func radioValid(selectedCount: Int, otherText: String?) -> ValidationResult
//    func freeTextValid(text: String?) -> ValidationResult
//    func checkMaxValid(max: Int, selectedCount: Int) -> ValidationResult
//    func isMaxValid(max: Int, selectedCount: Int) -> ValidationResult
}

extension ValidationQuestionProtocol {
    
    func numberValid(min: Int, max: Int, text: String?) -> ValidationResult {
        
        // バリデーターの生成
        // バリデートが増えた場合は、ここにそれ用のバリデーターを追加してください。
        let requiredRule = ValidationRequiredForText(invalidError: NumberInputError.required, required: true)
//        let min = ValidationMaximumForNumber(invalidError: NumberInputError.max(1), maximum: 1)
        var rules = CompositeValidator<String>()
        rules.add(rule: requiredRule)
//        rules.add(rule: min)
        
        /*
         let validatorList: [AnyValidationRule] = [
         // 必須か否かのチェック
         AnyValidationRule(base: ValidationRequiredForText(invalidError: NumberInputError.required, required: true)),
         //AnyValidationRule(base: ValidationRequiredForText(invalidError: NumberInputError.required, required: true))
         // フォーマット
         //DecimalValidationFormat(invalidError: NumberInputError.format),
         // minのチェック
         //ValidationMinimumForText(invalidError: NumberInputError.min(min), minimum: min),
         // maxのチェック
         //ValidationMaximumForText(invalidError: NumberInputError.max(max), maximum: max)
         ]
         */
        //let validators = CompositeValidator<String?>(rules: validatorList)
        
        // バリデーションの実行
        return rules.validate(text ?? "")
    }
    /*
     func checkValid(min: Int, max: Int, selectedCount: Int) -> ValidationResult {
     
     // min/maxのチェック
     var min = min
     var max = max
     if min <= 0 {
     min = 1
     }
     if max <= 0 {
     max = selectedCount
     }
     
     // バリデーターの生成
     // バリデートが増えた場合は、ここにそれ用のバリデーターを追加してください。
     let validatorList: [Validator] = [
     // 必須か否かのチェック
     ValidationRequiredForNumber(invalidError: CheckInputError.required, required: required),
     // minのチェック
     ValidationMinimumForNumber(invalidError: CheckInputError.min(min), minimum: min),
     // maxのチェック
     ValidationMaximumForNumber(invalidError: CheckInputError.max(max), maximum: max)
     ]
     
     let validators = CompositeValidatorForNumber(validators: validatorList)
     
     // バリデーションの実行
     return validators.validate(selectedCount)
     
     }
     
     func radioValid(selectedCount: Int, otherText: String?) -> ValidationResult {
     
     // バリデーターの生成
     // バリデートが増えた場合は、ここにそれ用のバリデーターを追加してください。
     let validatorList: [Validator] = [
     ValidationRequiredForNumber(invalidError: RadioInputError.required, required: required),
     // ラジオだけ複雑使用のため特別
     ValidationRadio(other: other, otherText: otherText)
     ]
     
     let validators = CompositeValidatorForNumber(validators: validatorList)
     
     // バリデーションの実行
     return validators.validate(selectedCount)
     
     }
     
     func freeTextValid(text: String?) -> ValidationResult {
     
     // バリデーターの生成
     // バリデートが増えた場合は、ここにそれ用のバリデーターを追加してください。
     let validatorList: [Validator] = [
     // 必須か否かのチェック
     ValidationRequiredForText(invalidError: NumberInputError.required, required: required),
     ]
     
     let validators = CompositeValidatorForText(validators: validatorList)
     
     // バリデーションの実行
     return validators.validate(text)
     
     }
     
     func checkMaxValid(max: Int, selectedCount: Int) -> ValidationResult {
     
     // バリデーターの生成
     // バリデートが増えた場合は、ここにそれ用のバリデーターを追加してください。
     let validatorList: [Validator] = [
     // maxのチェック
     ValidationMaximumForNumber(invalidError: CheckInputError.max(max), maximum: max)
     ]
     
     let validators = CompositeValidatorForNumber(validators: validatorList)
     
     // バリデーションの実行
     return validators.validate(selectedCount)
     }
     
     func isMaxValid(max: Int, selectedCount: Int) -> ValidationResult {
     
     // バリデーターの生成
     // バリデートが増えた場合は、ここにそれ用のバリデーターを追加してください。
     let validatorList: [Validator] = [
     // maxのチェック
     ValidationIsMaxForNumber(invalidError: CheckInputError.max(max), maximum: max)
     ]
     
     let validators = CompositeValidatorForNumber(validators: validatorList)
     
     // バリデーションの実行
     return validators.validate(selectedCount)
     
     }
     */
}

// 必須チェック用のバリデータ
struct ValidationRequiredForText: ValidationRule {
    
    typealias InputType = String
    
    private let invalidError: ValidationErrorType
    private let required: Bool
    
    init(invalidError: ValidationErrorType, required: Bool) {
        self.invalidError = invalidError
        self.required = required
    }
    
    func validate(_ value: InputType) -> ValidationResult {
        
        if !required {
            return .valid
        }
        /*
         guard let value = value else {
         return .invalid(of: invalidError)
         }
         */
        if value.characters.count > 0 {
            return .valid
        }
        
        return .invalid(of: invalidError)
    }
}

struct ValidationRequiredForNumber: ValidationRule {
    
    typealias InputType = Int
    
    private let invalidError: ValidationErrorType
    private let required: Bool
    
    init(invalidError: ValidationErrorType, required: Bool) {
        self.invalidError = invalidError
        self.required = required
    }
    
    func validate(_ value: Int) -> ValidationResult {
        if !required {
            return .valid
        }
        
        if value > 0 {
            return .valid
        }
        
        return .invalid(of: invalidError)
    }
}

class Aclass: ValidationQuestionProtocol {

    internal var required: Bool = false
    var other: Bool = false
    
    init() {
        
    }
}

var a = Aclass()
a.numberValid(min: 1, max: 1, text: "")
