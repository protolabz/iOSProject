//
//  SearchResponse.swift
//  Xeat
//
//  Created by apple on 28/01/22.
//


import Foundation

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let code, message: String
    let data: [DatumSearch]
}

// MARK: - Datum
struct DatumSearch: Codable {
    let id, restName, restType, rLat: String
    let image: String
    let otime, ctime, rLong, contactNumber: String
    let countryCode, preparingT, minimumOrder, location: String
    let inDriver, restCommission, hallalCertified, foodHygieneRatings: String
    let token, rememberToken, createdAt, distance: String
    let rating: Double
    let status: Int

    enum CodingKeys: String, CodingKey {
        case id
        case restName = "rest_name"
        case restType = "rest_type"
        case rLat = "r_lat"
        case image, otime, ctime
        case rLong = "r_long"
        case contactNumber = "contact_number"
        case countryCode
        case preparingT = "preparing_t"
        case minimumOrder = "Minimum_Order"
        case location, inDriver
        case restCommission = "rest_commission"
        case hallalCertified
        case foodHygieneRatings = "food_hygiene_ratings"
        case token
        case rememberToken = "remember_token"
        case createdAt = "created_at"
        case distance, rating, status
    }
}
