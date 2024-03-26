//
//  RickAndMortyCharacterRequestData.swift
//  
//
//  Created by Miguel Roque Ferreira on 24/03/2024.
//

import Foundation

public struct RickAndMortyCharacterRequestData: Codable {

    public let info: Info
    public let results: [RickAndMortyCharacter]
}
