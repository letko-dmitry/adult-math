import Foundation

struct PriceTagData: Codable {
    let storeName: String
    let items: [PriceTagItem]
    let discountPercent: Int?
    let discountLabel: String?
    let hideSalePrices: Bool?
}

struct PriceTagItem: Codable {
    let name: String
    let price: Double
    let originalPrice: Double?
    let unit: String?
}
