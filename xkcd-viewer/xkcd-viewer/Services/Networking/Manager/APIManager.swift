import Foundation

class APIManager {
    let networkManager = NetworkManager.sharedNetworkManager
    let router = Router<ComicAPI>()
    
    func fetchComic(withId identifier: String, completion: @escaping (_ response: Comic?, _ error: String?) -> Void) {
        router.request(.getComic(withId: identifier)) {data, response, error in
            self.networkManager.decodeNetworkResponse(Constants.Mode.appMode == .live ? data : self.getMockData(forIdentifier: identifier),
                                                      response,
                                                      error,
                                                      Comic.self,
                                                      completion: {comic, _, failed, response in
                guard let comic = comic, !failed else {
                    completion(nil, response.rawValue)
                    return
                }
                completion(comic, nil)
            })
        }
    }
    
    func findComic(withSearchString searchString: String, completion: @escaping (_ response: Comic?, _ error: String?) -> Void) {
        router.request(.findComics(withSearchString: searchString)) {result, _, error in
            guard let resultData = result, error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }
            let resultString = String(decoding: resultData, as: UTF8.self)
            let results = resultString.split(whereSeparator: \.isNewline)
            
            //Assumption: third line in the response string has the most favorable comic here for the search string in the format "id imagePath"
            if results.count > 2 {
                let mostFavorableResult = results[2].split(separator: " ")
                if !mostFavorableResult.isEmpty {
                    let comicId = mostFavorableResult[0]
                    self.fetchComic(withId: String(comicId), completion: {comic, error in
                        guard let comic = comic, error == nil else {
                            completion(nil, error)
                            return
                        }
                        completion(comic, nil)
                    })
                } else {
                    completion(nil, error?.localizedDescription)
                }
            } else {
                completion(nil, error?.localizedDescription)
            }
        }
    }
    
    func fetchComicStrip(fromUrl urlString: String, completion: @escaping (_ response: Data?, _ error: String?) -> Void) {
        router.request(.getComicStrip(withUrlString: urlString)) {data, _, error in
            completion(data, error?.localizedDescription)
        }
    }
    
    private func getResourceName(forIdentifier identifier: String) -> String {
        var resourceName = "CurrentComic"
        switch Constants.Mode.appMode {
        case .mock:
            if !identifier.isEmpty {
                resourceName = "Comic_100"
            }
        default:
            break
        }
        return resourceName
    }
    
    private func getMockData(forIdentifier identifier: String) -> Data? {
        let fileName = self.getResourceName(forIdentifier: identifier)
        if let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                return try Data(contentsOf: fileUrl)
            } catch {
                return nil
            }
        }
        return nil
    }
}
