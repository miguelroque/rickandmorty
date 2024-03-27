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

        let requestData = try RickAndMortyCharsMocks.requestDataForFinalPage()
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

        let requestData = try RickAndMortyCharsMocks.requestData()
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

        let requestData = try RickAndMortyCharsMocks.requestDataForFinalPage()
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

        let requestData = try RickAndMortyCharsMocks.requestData()
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
