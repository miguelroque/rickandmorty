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

    func lastItemReached()
    func retryButtonClicked()
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

    private var page: Int = 1

    init(networkingApi: RickAndMortyCharacterFetcher = RickAndMortyNetworking()) {

        self.networkingApi = networkingApi

        self.loadCharacters()
    }

    func loadCharacters() {

        self.state = .loading

        Task {
            do {
                let results = try await self.networkingApi.fetchCharacters(page: self.page)

                let newCharacters = results.results
                let nextPage = results.info.next

                self.characters += newCharacters.compactMap { Character(id: $0.id,
                                                                        name: $0.name,
                                                                        imageURL: URL(string: $0.image),
                                                                        status: $0.status,
                                                                        species: $0.species,
                                                                        location: $0.location,
                                                                        episodes: $0.episode) }

                if nextPage == nil {

                    self.state = .reachedLimit

                } else {

                    self.state = .loaded
                    self.page += 1
                }

            } catch {

                self.state = .failed
            }
        }
    }
}

// MARK: - CharacterListViewModelProtocol

extension CharacterListViewModel: CharacterListViewModelProtocol {

    func lastItemReached() {

        guard self.state.canLoadMore else { return }

        self.loadCharacters()
    }

    func retryButtonClicked() {

        self.loadCharacters()
    }
}
