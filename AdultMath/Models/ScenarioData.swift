import Foundation

enum ScenarioData: Codable {
    case receipt(ReceiptData)
    case nutrition(NutritionData)
    case priceTag(PriceTagData)

    private enum CodingKeys: String, CodingKey {
        case receipt, nutrition, priceTag
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let data = try container.decodeIfPresent(ReceiptData.self, forKey: .receipt) {
            self = .receipt(data)
        } else if let data = try container.decodeIfPresent(NutritionData.self, forKey: .nutrition) {
            self = .nutrition(data)
        } else if let data = try container.decodeIfPresent(PriceTagData.self, forKey: .priceTag) {
            self = .priceTag(data)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "No matching scenario type"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .receipt(let data): try container.encode(data, forKey: .receipt)
        case .nutrition(let data): try container.encode(data, forKey: .nutrition)
        case .priceTag(let data): try container.encode(data, forKey: .priceTag)
        }
    }
}
