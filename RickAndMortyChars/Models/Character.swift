//
//  Character.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 22/03/2024.
//

import Foundation
import RickAndMortyNetworking

public struct Character: Equatable {

    let id: Int
    let name: String
    let imageURL: URL?
    let status: String
    let species: String
    let location: Location
    let episodes: [String]
}
