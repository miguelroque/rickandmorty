//
//  RickAndMortyCharsMocks.swift
//  RickAndMortyCharsTests
//
//  Created by Miguel Roque Ferreira on 27/03/2024.
//

import Foundation
import RickAndMortyNetworking

enum RickAndMortyCharsMocks {

    static func requestDataForFinalPage() throws -> RickAndMortyCharacterRequestData {

        let jsonData = """
        {
          "info": {
            "count": 826,
            "pages": 42,
            "next": null,
            "prev": "https://rickandmortyapi.com/api/character/?page=2"
          },
          "results": [
            {
              "id": 1,
              "name": "Rick Sanchez",
              "status": "Alive",
              "species": "Human",
              "type": "",
              "gender": "Male",
              "origin": {
                "name": "Earth",
                "url": "https://rickandmortyapi.com/api/location/1"
              },
              "location": {
                "name": "Earth",
                "url": "https://rickandmortyapi.com/api/location/20"
              },
              "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
              "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
              ],
              "url": "https://rickandmortyapi.com/api/character/1",
              "created": "2017-11-04T18:48:46.250Z"
            }
          ]
        }
        """.data(using: .utf8)!

        return try RickAndMortyParser.parse(data: jsonData)
    }

    static func requestData() throws -> RickAndMortyCharacterRequestData {

        let jsonData = """
        {
          "info": {
            "count": 826,
            "pages": 42,
            "next": "https://rickandmortyapi.com/api/character/?page=2",
            "prev": null
          },
          "results": [
            {
              "id": 1,
              "name": "Rick Sanchez",
              "status": "Alive",
              "species": "Human",
              "type": "",
              "gender": "Male",
              "origin": {
                "name": "Earth",
                "url": "https://rickandmortyapi.com/api/location/1"
              },
              "location": {
                "name": "Earth",
                "url": "https://rickandmortyapi.com/api/location/20"
              },
              "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
              "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
              ],
              "url": "https://rickandmortyapi.com/api/character/1",
              "created": "2017-11-04T18:48:46.250Z"
            }
          ]
        }
        """.data(using: .utf8)!

        return try RickAndMortyParser.parse(data: jsonData)
    }

    static func character() throws -> RickAndMortyCharacter {

        let jsonData = """
            {
              "id": 1,
              "name": "Rick Sanchez",
              "status": "Alive",
              "species": "Human",
              "type": "",
              "gender": "Male",
              "origin": {
                "name": "Earth",
                "url": "https://rickandmortyapi.com/api/location/1"
              },
              "location": {
                "name": "Earth",
                "url": "https://rickandmortyapi.com/api/location/20"
              },
              "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
              "episode": [
                "https://rickandmortyapi.com/api/episode/1",
                "https://rickandmortyapi.com/api/episode/2"
              ],
              "url": "https://rickandmortyapi.com/api/character/1",
              "created": "2017-11-04T18:48:46.250Z"
            }
        """.data(using: .utf8)!

        return try RickAndMortyParser.parse(data: jsonData)
    }

    static func location() throws -> RickAndMortyCharacterLocation {

        let jsonData = """
        {
          "id": 1,
          "name": "Earth (C-137)",
          "type": "Planet",
          "dimension": "Dimension C-137",
          "residents": [
            "https://rickandmortyapi.com/api/character/1",
            "https://rickandmortyapi.com/api/character/2",
            "https://rickandmortyapi.com/api/character/3"
          ],
          "url": "https://rickandmortyapi.com/api/location/1",
          "created": "2017-11-10T12:42:04.162Z"
        }
        """.data(using: .utf8)!

        return try RickAndMortyParser.parse(data: jsonData)
    }
}
