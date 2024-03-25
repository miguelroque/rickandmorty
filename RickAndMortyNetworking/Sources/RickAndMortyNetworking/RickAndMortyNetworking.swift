import Foundation

public protocol RickAndMortyCharacterFetcher {

    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    func fetchCharacters() async throws -> ([RickAndMortyCharacter], String?)
}

public enum RickAndMortyNetworkingError: Error {
    case InvalidURL
    case JSONDecodingError
    case RequestError(String)
    case UnknownError
}

public class RickAndMortyNetworking {

    private enum Constants {

        static let url = "https://rickandmortyapi.com/api/character/?page=%@"
    }

    private var page: Int

    public init() { self.page = 1 }

    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    public func fetchCharacters() async throws -> ([RickAndMortyCharacter], String?) {

        let urlString = String(format: Constants.url, String(self.page))

        guard let url = URL(string: urlString) else {

            throw RickAndMortyNetworkingError.InvalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let requestData = try JSONDecoder().decode(RequestData.self, from: data)

        self.page += 1

        return (requestData.results, requestData.info.next)
    }
}

extension RickAndMortyNetworking: RickAndMortyCharacterFetcher { }
