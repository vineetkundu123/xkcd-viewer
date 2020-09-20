import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case notFound = "Requested URL does not exist."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<NetworkResponse> {
    case success
    case failure(NetworkResponse)
}

struct NetworkManager {
    static let sharedNetworkManager = NetworkManager()

    //Decode network response and return the mapped data
    func decodeNetworkResponse<T: Decodable>(_ data: Data?, _ response: URLResponse?,
                                             _ error: Error?,
                                             _: T.Type,
                                             completion: @escaping (_ response: T?,
                                                                    _ responseData: Data?,
                                                                    _ isFailed: Bool,
                                                                    _ networkResponseType: NetworkResponse) -> Void) {
        if error != nil {
            completion(nil, nil, true, .failed)
        }

        if let response = response as? HTTPURLResponse {
            let result = handleNetworkResponse(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    completion(nil, nil, false, .noData)
                    return
                }
                do {
                    let apiData = try JSONDecoder().decode(T.self, from: responseData)
                    completion(apiData, responseData, false, .success)
                } catch {
                    completion(nil, responseData, false, .unableToDecode)
                }
            case let .failure(failureResponse):
                completion(nil, nil, true, failureResponse)
            }
        }
    }

    //More https status codes can be handled here
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<NetworkResponse> {
        switch response.statusCode {
        case 200 ... 299: return .success
        case 400: return .failure(.badRequest)
        case 404: return .failure(.notFound)
        case 401 ... 499: return .failure(.authenticationError)
        case 600: return .failure(.outdated)
        default: return .failure(.failed)
        }
    }
}
