//
//  CuisineListResponse.swift
//  Xeat
//
//  Created by apple on 11/04/22.
//

import Foundation

// MARK: - CuisineListResponse
struct CuisineListResponse: Codable {
    let code, message: String
    let data: [DatumCuisine]
}

// MARK: - Datum
struct DatumCuisine: Codable {
    let id: Int
    let cuisine: String
    let cuisineImage: String

    enum CodingKeys: String, CodingKey {
        case id, cuisine
        case cuisineImage = "cuisine_image"
    }
}

