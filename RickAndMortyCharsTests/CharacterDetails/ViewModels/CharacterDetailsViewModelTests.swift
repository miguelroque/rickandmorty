//
//  CharacterDetailsViewModelTests.swift
//  RickAndMortyCharsTests
//
//  Created by Miguel Roque Ferreira on 27/03/2024.
//

import XCTest
import Foundation
import RickAndMortyNetworking
import Combine
@testable import RickAndMortyChars

class CharacterDetailsViewModelTests: XCTestCase { 

    private enum Constants {

        static let timeout = 2.0
    }

    private var cancellables: Set<AnyCancellable>!

    override func setUp() {

        super.setUp()
        self.cancellables = []
    }

    func testLocationError() throws {

        let expectation = XCTestExpectation(description: "Load location failure")

        let viewModel = try self.characterDetailsViewModel(shouldReturnLocation: false)

        viewModel.currentState
            .sink { state in

                if state == .failed {

                    expectation.fulfill()
                }
            }
            .store(in: &self.cancellables)

        viewModel.loadLocation()

        wait(for: [expectation], timeout: Constants.timeout)
    }

    func testLocationErrorDueToInvalidURL() throws {

        let expectation = XCTestExpectation(description: "Load location failure due to invalid URL")

        let viewModel = try self.characterDetailsViewModel(shouldReturnLocation: true,
                                                           hasInvalidURL: true)

        viewModel.currentState
            .sink { state in

                switch state {

                case .loaded(let url, let detailSections):
                    XCTAssertEqual(url, URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
                    XCTAssertEqual(detailSections[0].title, "Status")
                    XCTAssertEqual(detailSections[0].description, "Alive")
                    XCTAssertEqual(detailSections[1].title, "Species")
                    XCTAssertEqual(detailSections[1].description, "Human")
                    XCTAssertEqual(detailSections[2].title, "Number of episodes")
                    XCTAssertEqual(detailSections[2].description, "2")
                    expectation.fulfill()

                case .loading:
                    break

                default:
                    XCTFail("Wrong state")
                }
            }
            .store(in: &self.cancellables)

        viewModel.loadLocation()

        wait(for: [expectation], timeout: Constants.timeout)
    }

    func testLocationCorrectLoad() throws {

        let expectation = XCTestExpectation(description: "Load location has successfull")

        let viewModel = try self.characterDetailsViewModel(shouldReturnLocation: true,
                                                           hasInvalidURL: false)

        viewModel.currentState
            .sink { state in

                switch state {

                case .loaded(let url, let detailSections):
                    XCTAssertEqual(url, URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
                    XCTAssertEqual(detailSections[0].title, "Status")
                    XCTAssertEqual(detailSections[0].description, "Alive")
                    XCTAssertEqual(detailSections[1].title, "Species")
                    XCTAssertEqual(detailSections[1].description, "Human")
                    XCTAssertEqual(detailSections[2].title, "Number of episodes")
                    XCTAssertEqual(detailSections[2].description, "2")
                    XCTAssertEqual(detailSections[3].title, "Location")
                    XCTAssertEqual(detailSections[3].description, "Earth (C-137), Planet")
                    expectation.fulfill()

                case .loading:
                    break

                default:
                    XCTFail("Wrong state")
                }
            }
            .store(in: &self.cancellables)

        viewModel.loadLocation()

        wait(for: [expectation], timeout: Constants.timeout)
    }
}


extension CharacterDetailsViewModelTests {

    func characterDetailsViewModel(shouldReturnLocation: Bool,
                                   hasInvalidURL: Bool = false) throws -> CharacterDetailsViewModel {

        let rickAndMortyCharacter = try RickAndMortyCharsMocks.character()
        let character = Character(id: rickAndMortyCharacter.id,
                                  name: rickAndMortyCharacter.name,
                                  imageURL: URL(string: rickAndMortyCharacter.image),
                                  status: rickAndMortyCharacter.status,
                                  species: rickAndMortyCharacter.species,
                                  location: rickAndMortyCharacter.location,
                                  episodes: rickAndMortyCharacter.episode)

        let location = try RickAndMortyCharsMocks.location()

        let networkingAPI = RickAndMortyCharacterLocationFetcherMock()

        if shouldReturnLocation { networkingAPI.rickAndMortyCharacterLocationInjection = location }
        networkingAPI.hasInvalidURL = hasInvalidURL

        return CharacterDetailsViewModel(character: character,
                                         networkingAPI: networkingAPI)
    }
}

class RickAndMortyCharacterLocationFetcherMock: RickAndMortyCharacterLocationFetcher {

    var rickAndMortyCharacterLocationInjection: RickAndMortyCharacterLocation?
    var hasInvalidURL: Bool = false

    func fetchLocation(url: String) async throws -> RickAndMortyCharacterLocation {

        guard let rickAndMortyCharacterLocationInjection else {

            throw RickAndMortyNetworkingError.GeneralError
        }

        if hasInvalidURL {

            throw RickAndMortyNetworkingError.InvalidURL
        }

        return rickAndMortyCharacterLocationInjection
    }
}
