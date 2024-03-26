//
//  RickAndMortyParser.swift
//
//
//  Created by Miguel Roque Ferreira on 26/03/2024.
//

import Foundation

enum RickAndMortyParser {

    static func parse<T: Decodable>(data: Data) throws -> T {

        let decoder = JSONDecoder()

        do {

            return try decoder.decode(T.self, from: data)

        } catch {

            throw RickAndMortyNetworkingError.JSONDecodingError
        }
    }
}
