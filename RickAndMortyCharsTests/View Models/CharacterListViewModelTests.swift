//
//  CharacterListViewModelTests.swift
//  RickAndMortyCharsTests
//
//  Created by Miguel Roque Ferreira on 25/03/2024.
//

import XCTest
import RickAndMortyNetworking
@testable import RickAndMortyChars

class CharacterListViewModelTests: XCTestCase {

    private enum Constants {

        static let loadTime = 1.0
        static let timeout = 2.0
    }

    func testCharacterDownloadError() throws {

        let expectation = expectation(description: "Download characters error")

        let characterFetcher = self.mockRickAndMortyCharacterFetcher()
        let viewModel = self.mockViewModel(characterFetcher: characterFetcher)

        viewModel.loadCharacters()

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.loadTime) {

            XCTAssertTrue(viewModel.characters.isEmpty)
            XCTAssertEqual(viewModel.state, .failed)

            expectation.fulfill()
        }

        waitForExpectations(timeout: Constants.timeout) { error in
            if let error = error {
                XCTFail("Timeout waiting for characters to load: \(error)")
            }
        }
    }

    func testCharacterLimitReached() throws {

        let expectation = expectation(description: "Download characters limit reached")

        let character = try self.mockRickAndMortyCharacter()
        let characterFetcher = self.mockRickAndMortyCharacterFetcher(characters: [character],
                                                                     nextPage: nil)
        let viewModel = self.mockViewModel(characterFetcher: characterFetcher)

        viewModel.loadCharacters()

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.loadTime) {

            XCTAssertFalse(viewModel.characters.isEmpty)
            XCTAssertEqual(viewModel.state, .reachedLimit)

            expectation.fulfill()
        }

        waitForExpectations(timeout: Constants.timeout) { error in
            if let error = error {
                XCTFail("Timeout waiting for characters to load: \(error)")
            }
        }
    }

    func testCharacterDownload() throws {

        let expectation = expectation(description: "Download characters")

        let character = try self.mockRickAndMortyCharacter()
        let characterFetcher = self.mockRickAndMortyCharacterFetcher(characters: [character],
                                                                     nextPage: "nextPage")
        let viewModel = self.mockViewModel(characterFetcher: characterFetcher)

        viewModel.loadCharacters()

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.loadTime) {

            XCTAssertFalse(viewModel.characters.isEmpty)
            XCTAssertEqual(viewModel.state, .loaded)

            expectation.fulfill()
        }

        waitForExpectations(timeout: Constants.timeout) { error in
            if let error = error {
                XCTFail("Timeout waiting for characters to load: \(error)")
            }
        }
    }

    func testLastItemReachedWhenCharacterLimitReached() throws {

        let expectation = expectation(description: "Should not load more characters because limit has been reached")

        let character = try self.mockRickAndMortyCharacter()
        let characterFetcher = self.mockRickAndMortyCharacterFetcher(characters: [character],
                                                                     nextPage: nil)
        let viewModel = self.mockViewModel(characterFetcher: characterFetcher)

        viewModel.loadCharacters()

        viewModel.hasLoadedCharacters = false

        viewModel.lastItemReached()

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.loadTime) {

            XCTAssertFalse(viewModel.characters.isEmpty)
            XCTAssertEqual(viewModel.state, .reachedLimit)
            XCTAssertEqual(viewModel.hasLoadedCharacters, false)

            expectation.fulfill()
        }

        waitForExpectations(timeout: Constants.timeout) { error in
            if let error = error {
                XCTFail("Timeout waiting for characters to load: \(error)")
            }
        }
    }

    func testLastItemReachedWhenCharacterLimitNotReached() throws {

        let expectation = expectation(description: "Should load more characters because limit has not been reached")

        let character = try self.mockRickAndMortyCharacter()
        let characterFetcher = self.mockRickAndMortyCharacterFetcher(characters: [character],
                                                                     nextPage: "nextPage")
        let viewModel = self.mockViewModel(characterFetcher: characterFetcher)

        viewModel.lastItemReached()

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.loadTime) {

            XCTAssertFalse(viewModel.characters.isEmpty)
            XCTAssertEqual(viewModel.state, .loaded)
            XCTAssertEqual(viewModel.hasLoadedCharacters, true)

            expectation.fulfill()
        }

        waitForExpectations(timeout: Constants.timeout) { error in
            if let error = error {
                XCTFail("Timeout waiting for characters to load: \(error)")
            }
        }
    }
}

extension CharacterListViewModelTests {

    func mockViewModel(characterFetcher: RickAndMortyCharacterFetcher) -> CharacterListViewModelMock {

        return CharacterListViewModelMock(networkingApi: characterFetcher)
    }

    func mockRickAndMortyCharacterFetcher(characters: [RickAndMortyCharacter] = [],
                                          nextPage: String? = nil) -> RickAndMortyCharacterFetcher {

        let fetcherMock = RickAndMortyCharacterFetcherMock()
        fetcherMock.rickAndMortyCharactersInjection = characters
        fetcherMock.nextPageInjection = nextPage

        return fetcherMock
    }

    func mockRickAndMortyCharacter() throws -> RickAndMortyCharacter {

        let jsonData = """
        {
          "id": 1,
          "name": "Rick Sanchez",
          "status": "Alive",
          "species": "Human",
          "type": "Mad scientist",
          "gender": "Male",
          "origin": {
            "name": "Earth (C-137)",
            "url": "https://rickandmortyapi.com/api/location/1"
          },
          "location": {
            "name": "Earth (Replacement Dimension)",
            "url": "https://rickandmortyapi.com/api/location/20"
          },
          "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
          "episode": [
            "https://rickandmortyapi.com/api/episode/1"
          ],
          "url": "https://rickandmortyapi.com/api/character/1",
          "created": "2017-11-04T18:48:46.250Z"
        }
        """.data(using: .utf8)!

        let character = try JSONDecoder().decode(RickAndMortyCharacter.self, from: jsonData)
        return character
    }
}

class RickAndMortyCharacterFetcherMock: RickAndMortyCharacterFetcher {

    var rickAndMortyCharactersInjection: [RickAndMortyCharacter] = []
    var nextPageInjection: String? = ""

    func fetchCharacters() async throws -> ([RickAndMortyCharacter], String?) {

        if rickAndMortyCharactersInjection.isEmpty { throw RickAndMortyNetworkingError.GeneralError }

        return (rickAndMortyCharactersInjection, nextPageInjection)
    }
}

class CharacterListViewModelMock: CharacterListViewModel {

    var hasLoadedCharacters: Bool = false

    override func loadCharacters() {

        super.loadCharacters()

        self.hasLoadedCharacters = true
    }
}
