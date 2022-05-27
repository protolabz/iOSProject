//
//  HelpRevertListResponse.swift
//  Xeat
//
//  Created by apple on 31/12/21.
//

import Foundation

// MARK: - HelpRevertListResponse
struct HelpRevertListResponse: Codable {
    let code, message: String
    let data: [DatumRevert]
}

// MARK: - Datum
struct DatumRevert: Codable {
    let id, userID, helpTitle, comment: String
    let adminAns, status, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case helpTitle = "help_title"
        case comment
        case adminAns = "admin_ans"
        case status
        case createdAt = "created_at"
    }
}
