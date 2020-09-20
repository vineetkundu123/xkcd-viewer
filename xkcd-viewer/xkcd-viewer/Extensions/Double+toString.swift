import Foundation

extension Double {
    func toString(withDecimalPlaces decimalPlaces: Int = 0) -> String {
        return String(format: "%.\(decimalPlaces)f", self)
    }
}
