//
//  MainDepartmentResponse.swift
//  Xeat
//
//  Created by apple on 27/05/22.
//

import Foundation
struct MainDepartmentResponse: Codable {
    let code: String
    let data: [DatumMainCategory]
    let message: String
}

// MARK: - Datum
struct DatumMainCategory: Codable {
    let categoryImage: String
    let createdAt, updatedAt, categoryName: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case categoryImage = "category_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoryName = "category_name"
        case id
    }
}
