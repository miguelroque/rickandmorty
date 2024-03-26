//
//  RickAndMortyCharacterLocation.swift
//
//
//  Created by Miguel Roque Ferreira on 25/03/2024.
//

import Foundation

public struct RickAndMortyCharacterLocation: Codable {

    public let id: Int
    public let name: String
    public let type: String
    public let dimension: String
    public let residents: [String]
    public let url: String
    public let created: String
}
