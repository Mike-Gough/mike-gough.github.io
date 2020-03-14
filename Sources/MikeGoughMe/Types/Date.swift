import Foundation

extension Date {
    var australianFormatted : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: self)
    }
}