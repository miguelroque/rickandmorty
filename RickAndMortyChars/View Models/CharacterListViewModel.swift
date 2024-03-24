//
//  CharacterListViewModel.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 24/03/2024.
//

import Foundation
import SwiftUI
import RickAndMortyNetworking

@Observable
class CharacterListViewModel {

    enum State {

        case idle
        case loading
        case failed
        case loaded
    }

    var characters: [Character] = []

    private(set) var state = State.idle

    private let networkingApi: RickAndMortyCharacterFetcher = RickAndMortyNetworking()

    init() {

        self.loadCharacters()
    }

    func loadCharacters() {

        self.state = .loading

        Task {
            do {
                let newCharacters = try await self.networkingApi.fetchCharacters()
                self.characters += newCharacters.compactMap { Character(name: $0.name,
                                                                        imageURL: URL(string: $0.image) ?? URL(fileURLWithPath: "https://www.google.com")) }
                self.state = .loaded

            } catch {

                self.state = .failed
            }
        }
    }
}
