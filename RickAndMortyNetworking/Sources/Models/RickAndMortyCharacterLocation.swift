//
//  RickAndMortyCharacterLocation.swift
//
//
//  Created by Miguel Roque Ferreira on 25/03/2024.
//

import Foundation

public struct RickAndMortyCharacterLocation: Codable {

    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
