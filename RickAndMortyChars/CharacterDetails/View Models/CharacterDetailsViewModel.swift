//
//  CharacterDetailsViewModel.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 26/03/2024.
//

import Foundation
import RickAndMortyNetworking
import Combine

protocol CharacterDetailsViewModelProtocol {

    var currentState: PassthroughSubject<CharacterDetailsViewState, Never> { get }

    func loadLocation()
}

enum CharacterDetailsViewState {

    case loading
    case failed
    case loaded(URL?, [DetailSection])
}

class CharacterDetailsViewModel {

    private let character: Character
    private let networkingAPI: RickAndMortyCharacterLocationFetcher

    private(set) var currentState = PassthroughSubject<CharacterDetailsViewState, Never>()

    init(character: Character,
         networkingAPI: RickAndMortyCharacterLocationFetcher = RickAndMortyNetworking()) {

        self.character = character
        self.networkingAPI = networkingAPI
    }

    func loadLocation() {

        Task { [weak self] in

            guard let self else { return }

            Task { @MainActor in

                self.currentState.send(.loading)
            }

            do {

                let characterLocation = try await self.networkingAPI.fetchLocation(url: self.character.location.url)

                let detailSections = self.detailSectionConfig(characterLocation: characterLocation)
                let imageURL = self.character.imageURL

                Task { @MainActor in

                    self.currentState.send(.loaded(imageURL, detailSections))
                }

            } catch {

                guard let error = error as? RickAndMortyNetworkingError else { return }

                if error == .InvalidURL {

                    let detailSections = self.detailSectionConfig(characterLocation: nil)
                    let imageURL = self.character.imageURL

                    Task { @MainActor in

                        self.currentState.send(.loaded(imageURL, detailSections))
                    }

                } else {

                    self.currentState.send(.failed)
                }
            }
        }
    }
}

private extension CharacterDetailsViewModel {

    func numberOfEpisodes(of character: Character) -> String {

        let episodes = character.episodes

        guard episodes.isEmpty == false else { return "0" }

        return String(episodes.count)
    }

    func location(from characterLocation: RickAndMortyCharacterLocation) -> String {

        return characterLocation.name + ", " + characterLocation.type
    }

    func detailSectionConfig(characterLocation: RickAndMortyCharacterLocation?) -> [DetailSection] {

        var detailSections = [DetailSectionConfig(title: "Status",
                                                  description: self.character.status),
                              DetailSectionConfig(title: "Species",
                                                  description: self.character.species),
                              DetailSectionConfig(title: "Number of episodes",
                                                  description: self.numberOfEpisodes(of: self.character))]

        if let characterLocation { detailSections.append(DetailSectionConfig(title: "Location",
                                                                             description: self.location(from: characterLocation))) }

        return detailSections
    }
}

extension CharacterDetailsViewModel: CharacterDetailsViewModelProtocol { }
