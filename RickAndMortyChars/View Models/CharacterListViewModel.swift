//
//  CharacterListViewModel.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 24/03/2024.
//

import Foundation
import SwiftUI
import RickAndMortyNetworking

protocol CharacterListViewModelProtocol {

    var characters: [Character] { get }
    var state: CharacterListViewState { get }

    func loadCharacters()
    func lastItemReached()
}

enum CharacterListViewState {

    case idle
    case loading
    case failed
    case loaded
    case reachedLimit

    var canLoadMore: Bool {

        switch self {

        case .idle,
                .loaded,
                .failed:
            return true

        case .loading,
                .reachedLimit:
            return false
        }
    }
}

@Observable
class CharacterListViewModel {

    var characters: [Character] = []

    private(set) var state = CharacterListViewState.idle
    private let networkingApi: RickAndMortyCharacterFetcher

    init(networkingApi: RickAndMortyCharacterFetcher) {

        self.networkingApi = networkingApi

        self.loadCharacters()
    }

    func loadCharacters() {

        self.state = .loading

        Task {
            do {
                let (newCharacters, nextPage) = try await self.networkingApi.fetchCharacters()

                self.characters += newCharacters.compactMap { Character(name: $0.name,
                                                                        imageURL: URL(string: $0.image),
                                                                        id: $0.id) }

                if nextPage == nil {

                    self.state = .reachedLimit

                } else {

                    self.state = .loaded
                }

            } catch {

                self.state = .failed
            }
        }
    }

    func lastItemReached() { 

        guard self.state.canLoadMore else { return }

        self.loadCharacters()
    }
}

extension CharacterListViewModel: CharacterListViewModelProtocol { }
