//
//  AddressListResponse.swift
//  Xeat
//
//  Created by apple on 29/12/21.
//

import Foundation


// MARK: - AddressListResponse
struct AddressListResponse: Codable {
    let message: String
    let data: [DatumAddressList]
    let code: String
}

// MARK: - Datum
struct DatumAddressList: Codable {
    let id, userID, isPrimary, location: String
       let comAddress, address, landmark, houseNumber: String
       let buildingNumber, city, postalCode, phoneNumber: String
       let name, hte, aLat, aLong: String
       let status, createdAt: String

       enum CodingKeys: String, CodingKey {
           case id
           case userID = "user_id"
           case isPrimary = "is_primary"
           case location
           case comAddress = "com_address"
           case address, landmark
           case houseNumber = "house_number"
           case buildingNumber = "building_number"
           case city
           case postalCode = "postal_code"
           case phoneNumber = "phone_number"
           case name, hte
           case aLat = "a_lat"
           case aLong = "a_long"
           case status
           case createdAt = "created_at"
       }
}
