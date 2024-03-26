//
//  RickAndMortyRequest.swift
//
//
//  Created by Miguel Roque Ferreira on 26/03/2024.
//

import Foundation

enum RickAndMortyRequest {

    private enum Constants {

        static let baseURL = "https://rickandmortyapi.com/api/"
    }

    case characters(page: Int)
    case hypermedia(url: String)

    var endpoint: String {

        switch self {

        case .characters: return "character"
        case .hypermedia: return ""
        }
    }

    var page: String {

        switch self {

        case .characters(let page): return "/?page=\(page)"
        case.hypermedia: return ""
        }
    }

    var url:  URL? {

        switch self {

        case .characters: return URLComponents(string: Constants.baseURL + self.endpoint + self.page)?.url

        case .hypermedia(let url): return URL(string: url)
        }
    }
}
