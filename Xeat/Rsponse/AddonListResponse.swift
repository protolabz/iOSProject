//
//  AddonListResponse.swift
//  Xeat
//
//  Created by apple on 10/01/22.
//

import Foundation

// MARK: - AddOnListResponse
struct AddOnListResponse: Codable {
    let status, message: String
    let data: [DatumAddOn]
    let sizeAddon: [SizeAddon]

    enum CodingKeys: String, CodingKey {
        case status, message, data
        case sizeAddon = "size_addon"
    }
}

// MARK: - Datum
struct DatumAddOn: Codable {
    let id, rID, subItem: Int
    let name, franchName, fPrice, category: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case rID = "r_id"
        case subItem = "sub_item"
        case name
        case franchName = "franch_name"
        case fPrice = "f_price"
        case category
        case createdAt = "created_at"
    }
    
}
  // MARK: - SizeAddon
    struct SizeAddon: Codable {
        let id, rItemID: Int
        let itemSize, itemPrice: String
        let sizeAddon, rID: Int
        let createdAt, updatedAt: String

        enum CodingKeys: String, CodingKey {
            case id
            case rItemID = "r_item_id"
            case itemSize = "item_size"
            case itemPrice = "item_price"
            case sizeAddon = "size_addon"
            case rID = "r_id"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }


