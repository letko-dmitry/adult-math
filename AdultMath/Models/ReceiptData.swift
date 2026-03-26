import Foundation

struct ReceiptData: Codable {
    let restaurantName: String
    let lineItems: [ReceiptLineItem]
    let subtotal: Double
    let tipPercentage: Int?
    let total: Double?
}

struct ReceiptLineItem: Codable {
    let name: String
    let price: Double
}
