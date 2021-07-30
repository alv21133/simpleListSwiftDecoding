//
//  searchResult.swift
//  GoFood
//
//  Created by Wahyu on 23/07/21.
//


import Foundation

// MARK: - ResultResto
struct ResultResto: Codable {
    let error: Bool
    let founded: Int
    let restaurants: [Restaurant]
}


