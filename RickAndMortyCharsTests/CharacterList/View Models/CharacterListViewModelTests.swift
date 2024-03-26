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

        static let loadTime = 2.0
        static let timeout = 3.0
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

        let requestData = try self.mockRequestDataForFinalPage()
        let characterFetcher = self.mockRickAndMortyCharacterFetcher(requestData: requestData)
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

        let requestData = try self.mockRequestData()
        let characterFetcher = self.mockRickAndMortyCharacterFetcher(requestData: requestData)
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

        let requestData = try self.mockRequestDataForFinalPage()
        let characterFetcher = self.mockRickAndMortyCharacterFetcher(requestData: requestData)
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

        let requestData = try self.mockRequestData()
        let characterFetcher = self.mockRickAndMortyCharacterFetcher(requestData: requestData)
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

    func mockRickAndMortyCharacterFetcher(requestData: RickAndMortyCharacterRequestData? = nil) -> RickAndMortyCharacterFetcher {

        let fetcherMock = RickAndMortyCharacterFetcherMock()
        fetcherMock.rickAndMortyCharactersRequestDataInjection = requestData

        return fetcherMock
    }

    func mockRequestData() throws -> RickAndMortyCharacterRequestData {

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

        let requestData = try JSONDecoder().decode(RickAndMortyCharacterRequestData.self, from: jsonData)
        return requestData
    }

    func mockRequestDataForFinalPage() throws -> RickAndMortyCharacterRequestData {

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

        let requestData = try JSONDecoder().decode(RickAndMortyCharacterRequestData.self, from: jsonData)
        return requestData
    }
}

class RickAndMortyCharacterFetcherMock: RickAndMortyCharacterFetcher {

    var rickAndMortyCharactersRequestDataInjection: RickAndMortyCharacterRequestData? = nil

    func fetchCharacters(page: Int) async throws -> RickAndMortyCharacterRequestData {

        guard let rickAndMortyCharactersRequestDataInjection = self.rickAndMortyCharactersRequestDataInjection else {

            throw RickAndMortyNetworkingError.GeneralError
        }

        return rickAndMortyCharactersRequestDataInjection
    }
}

class CharacterListViewModelMock: CharacterListViewModel {

    var hasLoadedCharacters: Bool = false

    override func loadCharacters() {

        super.loadCharacters()

        self.hasLoadedCharacters = true
    }
}
