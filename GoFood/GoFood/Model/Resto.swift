//
//  Resto.swift
//  GoFood
//
//  Created by Wahyu on 04/07/21.
//
import Foundation


struct RestoData: Codable {
    let error: Bool
    let message: String
    let count: Int
    let restaurants: [Restaurant]
}

struct Restaurant: Codable {
    let id, name, restaurantDescription, pictureID: String 
    let city: String
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case id, name
        case restaurantDescription = "description"
        case pictureID = "pictureId"
        case city, rating
    }
}


