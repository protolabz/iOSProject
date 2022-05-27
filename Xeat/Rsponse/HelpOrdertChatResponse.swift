//
//  HelpOrdertChatResponse.swift
//  Xeat
//
//  Created by apple on 05/01/22.
//

import Foundation

// MARK: - HelpOrdertChatResponse
struct HelpOrdertChatResponse: Codable {
    let code, message: String
    let data: [DatumOrderChat]
}

// MARK: - Datum
struct DatumOrderChat: Codable {
    let id, userID, orderHelpID, comment: String
    let type, from, status, createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case orderHelpID = "order_help_id"
        case comment, type, from, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
