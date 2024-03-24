//
//  RequestData.swift
//  
//
//  Created by Miguel Roque Ferreira on 24/03/2024.
//

import Foundation

public struct RequestData: Codable {

    let info: Info
    let results: [RickAndMortyCharacter]
}
