import XCTest
@testable import RickAndMortyNetworking

final class RickAndMortyParserTests: XCTestCase {

    func testValidParsing() {

        let json = """
        {
            "name": "Earth",
            "url": "https://rickandmortyapi.com/api/location/1"
        }
        """.data(using: .utf8)!

        do {

            let location: Location = try RickAndMortyParser.parse(data: json)

            XCTAssertEqual(location.name, "Earth")
            XCTAssertEqual(location.url, "https://rickandmortyapi.com/api/location/1")

        } catch {

            XCTFail("Unexpected error: \(error)")
        }
    }

    func testInvalidParsing() {

        let invalidJson = """
        {
            "name": 12345,
            "url": "https://rickandmortyapi.com/api/location/1"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try RickAndMortyParser.parse(data: invalidJson) as Location) { error in

            XCTAssertTrue(error is RickAndMortyNetworkingError)
            XCTAssertEqual(error as? RickAndMortyNetworkingError, RickAndMortyNetworkingError.JSONDecodingError)
        }
    }
}
