import Foundation


enum RickAndMortyNetworkingError: Error {
    case InvalidURL
    case JSONDecodingError
    case RequestError(String)
    case UnknownError
}

class RickAndMortyNetworking {

    private enum Constants {

        static let url = "https://rickandmortyapi.com/api/character/?page=%@"
    }

    private var page = 1

    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    func fetchCharacters() async throws -> [RickAndMortyCharacter] {

        let urlString = String(format: Constants.url, String(self.page))

        guard let url = URL(string: urlString) else {

            throw RickAndMortyNetworkingError.InvalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let requestData = try JSONDecoder().decode(RequestData.self, from: data)

        return requestData.results
    }
}
