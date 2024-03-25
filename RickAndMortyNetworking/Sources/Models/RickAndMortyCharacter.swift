//
//  RickAndMortyCharacter.swift
//
//
//  Created by Miguel Roque Ferreira on 24/03/2024.
//

import Foundation

public struct RickAndMortyCharacter: Codable {

    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let type: String
    public let gender: String
    public let origin: Location
    public let location: Location
    public let image: String
    public let episode: [String]
    public let url: String
    public let created: String
}

