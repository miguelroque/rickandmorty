import XCTest
@testable import RickAndMortyNetworking

final class RickAndMortyAPITests: XCTestCase {

    // Mock data for testing
    let validData = """
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
            "episode": ["https://rickandmortyapi.com/api/episode/1"],
            "url": "https://rickandmortyapi.com/api/character/1",
            "created": "2017-11-04T18:48:46.250Z"
        }
        """.data(using: .utf8)!

    let invalidData = "Invalid JSON data".data(using: .utf8)!
    let invalidURL = "https://invalid-url.com"

    // Test fetchCharacters with valid response
    @available(iOS 15.0, *)
    func testFetchCharacters_SuccessfulResponse() {
        let api = RickAndMortyNetworking()
        let expectation = XCTestExpectation(description: "Fetch characters successful")

        Task {
            do {
                let character = try await api.fetchCharacters()
                XCTAssertNotNil(character)
                XCTAssertEqual(character.id, 1)
                XCTAssertEqual(character.name, "Rick Sanchez")
                // Add more assertions as needed
                expectation.fulfill()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    @available(iOS 15.0, *)
    func testFetchCharacters_InvalidURL() {
        let api = RickAndMortyNetworking()
        let expectation = XCTestExpectation(description: "Fetch characters with invalid URL")

        Task {
            do {
                _ = try await api.fetchCharacters()
                XCTFail("Expected error due to invalid URL")
            } catch {
                XCTAssertTrue(error.localizedDescription.contains("Invalid URL"))
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
    // Add more tests for other scenarios such as network errors, JSON decoding errors, etc.
}
