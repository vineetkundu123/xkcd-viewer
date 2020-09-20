import Foundation

enum ComicAPI {
    case getComic(withId: String)
    case getComicStrip(withUrlString: String)
    case findComics(withSearchString: String)
}

extension ComicAPI: EndPointType {
    var url: URL {
        switch self {
        case .getComic(let identifier):
            guard let url = URL(string: "http://xkcd.com/\(identifier)/info.0.json")
            else { fatalError("baseURL could not be configured.") }
            return url
        case .getComicStrip(let urlString):
            guard let url = URL(string: urlString)
            else { fatalError("baseURL could not be configured.") }
            return url
        case .findComics:
            guard let url = URL(string: "https://relevantxkcd.appspot.com/process")
            else { fatalError("baseURL could not be configured.") }
            return url
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getComic, .getComicStrip, .findComics:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .getComic, .getComicStrip:
            return .request
        case .findComics(let searchString):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["action": "xkcd",
                                                      "query": searchString])
        }
    }
}
