//
//  CategoryList.swift
//  Xeat
//
//  Created by apple on 08/04/22.
//

import Foundation
// MARK: - CategoryList
struct CategoryList: Codable {
    let code, message: String
    let data: [DatumCategory]
}

// MARK: - Datum
struct DatumCategory: Codable {
    let id, rID: Int
    let cName, cFranchName, image: String
    let inTop: Int
    let createdOn: String

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
