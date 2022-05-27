//
//  SizeAddOnResponse.swift
//  Xeat
//
//  Created by apple on 27/04/22.
//

import Foundation

// MARK: - SizeAddOnResponse
struct SizeAddOnResponse: Codable {
    let code, message: String
    let data: [DatumAddon]
}

// MARK: - Datum
struct DatumAddon: Codable {
    let title: String
    let menuID, id: Int
    let isRequired, isSize : String
    let selection: [Selection]

    enum CodingKeys: String, CodingKey {
        case title
        case menuID = "menu_id"
        case id, selection
        case isRequired = "is_required"
        case isSize = "is_size"
    }
}

// MARK: - Selection
struct Selection: Codable {
    let name, variantSize, variantPrice: String
    let id : Int
    enum CodingKeys: String, CodingKey {
        case name, id
        case variantSize = "variant_size"
        case variantPrice = "variant_price"
    }
}
