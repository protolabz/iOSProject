//
//  TopCategoryResponse.swift
//  Xeat
//
//  Created by apple on 21/12/21.
//

import Foundation

// MARK: - TopCategoryResponse
struct TopCategoryResponse: Codable {
    let code, message: String
    let data: [DatumTopCategory]
}

// MARK: - Datum
struct DatumTopCategory: Codable {
    let id, rID, cName, cFranchName: String
    let image: String
    let inTop, createdOn: String

    enum CodingKeys: String, CodingKey {
        case id
        case rID = "r_id"
        case cName = "c_name"
        case cFranchName = "c_franch_name"
        case image
        case inTop = "in_top"
        case createdOn = "created_on"
    }
}
