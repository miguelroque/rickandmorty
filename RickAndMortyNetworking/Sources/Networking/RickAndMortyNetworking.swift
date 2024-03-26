import Foundation

public protocol RickAndMortyCharacterFetcher {

    func fetchCharacters(page: Int) async throws -> RickAndMortyCharacterRequestData
}

public protocol RickAndMortyCharacterLocationFetcher {

    func fetchLocation(url: String) async throws -> RickAndMortyCharacterLocation
}

public enum RickAndMortyNetworkingError: Error {

    case InvalidURL
    case GeneralError
    case JSONDecodingError
}

public class RickAndMortyNetworking {

    public init() { }

    private func getAPIResult<T: Decodable>(request: RickAndMortyRequest) async throws -> T {

        guard let url = request.url else { throw RickAndMortyNetworkingError.InvalidURL }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try RickAndMortyParser.parse(data: data)
    }

    public func fetchCharacters(page: Int) async throws -> RickAndMortyCharacterRequestData {

        return try await self.getAPIResult(request: .characters(page: page))
    }

    public func fetchLocation(url: String) async throws -> RickAndMortyCharacterLocation {

        return try await self.getAPIResult(request: .hypermedia(url: url))
    }
}

extension RickAndMortyNetworking: RickAndMortyCharacterFetcher, RickAndMortyCharacterLocationFetcher { }
