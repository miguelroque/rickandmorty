import XCTest
@testable import RickAndMortyNetworking

class RickAndMortyRequestTests: XCTestCase {

    func testRequestEndpoints() {

        let charactersRequest = RickAndMortyRequest.characters(page: 1)
        let hypermediaRequest = RickAndMortyRequest.hypermedia(url: "https://www.example.com")

        let charactersEndpoint = charactersRequest.endpoint
        let hypermediaEndpoint = hypermediaRequest.endpoint

        XCTAssertEqual(charactersEndpoint, "character")
        XCTAssertEqual(hypermediaEndpoint, "")
    }

    func testRequestPage() {

        let charactersRequest = RickAndMortyRequest.characters(page: 1)
        let hypermediaRequest = RickAndMortyRequest.hypermedia(url: "https://www.example.com")

        let charactersPage = charactersRequest.page
        let hypermediaPage = hypermediaRequest.page

        XCTAssertEqual(charactersPage, "/?page=1")
        XCTAssertEqual(hypermediaPage, "")
    }

    func testRequestURL() {

        let charactersRequest = RickAndMortyRequest.characters(page: 1)
        let hypermediaRequest = RickAndMortyRequest.hypermedia(url: "https://www.example.com")

        let charactersURL = charactersRequest.url
        let hypermediaURL = hypermediaRequest.url

        XCTAssertEqual(charactersURL, URL(string: "https://rickandmortyapi.com/api/character/?page=1"))
        XCTAssertEqual(hypermediaURL, URL(string: "https://www.example.com"))
    }
}

