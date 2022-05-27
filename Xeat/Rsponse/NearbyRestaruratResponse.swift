//
//  NearbyRestaruratResponse.swift
//  Xeat
//
//  Created by apple on 22/12/21.
//

import Foundation
// MARK: - NearbyRestaurantResponse
struct NearbyRestaurantResponse: Codable {
    let code, message: String
    let data: [DatumNearBy]
}

// MARK: - Datum
struct DatumNearBy: Codable {
    let id, restName, restType, rLat: String
    let image: String
    let otime, ctime, rLong, contactNumber: String
    let countryCode, preparingT, minimumOrder, location: String
    let status: Int
    let inDriver, restCommission, hallalCertified, foodHygieneRatings: String
    let token, rememberToken, createdAt, distance: String
    let rating: String

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
        case location, status, inDriver
        case restCommission = "rest_commission"
        case hallalCertified
        case foodHygieneRatings = "food_hygiene_ratings"
        case token
        case rememberToken = "remember_token"
        case createdAt = "created_at"
        case distance, rating
    }
}
