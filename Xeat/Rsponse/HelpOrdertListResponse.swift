//
//  HelpOrdertListResponse.swift
//  Xeat
//
//  Created by apple on 05/01/22.
//

import Foundation

// MARK: - HelpOrdertListResponse
struct HelpOrdertListResponse: Codable {
    let code, message: String
    let data: [DatumHelpOrder]
}

// MARK: - Datum
struct DatumHelpOrder: Codable {
    let id, userID, orderID, comment: String
    let status, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case orderID = "order_id"
        case comment, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
