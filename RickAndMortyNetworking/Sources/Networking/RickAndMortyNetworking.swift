import Foundation

public protocol RickAndMortyCharacterFetcher {

    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    func fetchCharacters() async throws -> ([RickAndMortyCharacter], String?)
}

public enum RickAndMortyNetworkingError: Error {

    case InvalidURL
    case GeneralError
}

public class RickAndMortyNetworking {

    private enum Constants {

        static let baseURL = "https://rickandmortyapi.com/api/"
    }

    enum Request {

        case characters(page: Int)

        var endpoint: String {

            switch self {

            case .characters: return "character"
            }
        }

        var page: String {

            switch self {

            case .characters(let page): return "/?page=\(page)"
            }
        }
    }

    private var page: Int

    public init() { self.page = 1 }

    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    private func getAPIResults(request: Request) async throws -> Data {

        let urlComponents = URLComponents(string: Constants.baseURL + request.endpoint + request.page)

        guard let url = urlComponents?.url else { throw RickAndMortyNetworkingError.InvalidURL }

        let (data, _) = try await URLSession.shared.data(from: url)

        return data
    }

    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    public func fetchCharacters() async throws -> ([RickAndMortyCharacter], String?) {

        let data = try await self.getAPIResults(request: .characters(page: self.page))

        let requestData = try JSONDecoder().decode(RequestData.self, from: data)

        self.page += 1

        return (requestData.results, requestData.info.next)
    }
}

extension RickAndMortyNetworking: RickAndMortyCharacterFetcher { }
