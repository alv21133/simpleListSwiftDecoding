//
//  RestoDetail.swift
//  GoFood
//
//  Created by Wahyu on 23/07/21.
//

import Foundation


struct RestoDetail: Codable {
    let error: Bool
    let message: String
    let restaurant: detailInfo
}

// Restaurant
struct detailInfo: Codable {
    let id, name, restaurantDescription, city: String
    let address, pictureID: String
    let categories: [Category]
    let menus: Menus
    let rating: Double
    let customerReviews: [CustomerReview]

    enum CodingKeys: String, CodingKey {
        case id, name
        case restaurantDescription = "description"
        case city, address
        case pictureID = "pictureId"
        case categories, menus, rating, customerReviews
    }
}

// Category
struct Category: Codable {
    let name: String
}

// CustomerReview
struct CustomerReview: Codable {
    let name, review, date: String
}

// Menus
struct Menus: Codable {
    let foods, drinks: [Category]
}
