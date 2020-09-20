import Foundation

class APIManager {
    let networkManager = NetworkManager.sharedNetworkManager
    let router = Router<ComicAPI>()
    
    func fetchQuiz(withId identifier: String, completion: @escaping (_ response: Comic?, _ error: String?) -> Void) {
        router.request(.getComic(withId: identifier)) {data, response, error in
            self.networkManager.decodeNetworkResponse(data, response, error, Comic.self, completion: {comic, _, failed, response in
                guard let comic = comic, !failed else {
                    completion(nil, response.rawValue)
                    return
                }
                completion(comic, nil)
            })
        }
    }
    
    func findComics(withSearchString searchString: String, completion: @escaping (_ response: String?, _ error: String?) -> Void) {
        router.request(.findComics(withSearchString: searchString)) {_, _, error in
            completion("", error?.localizedDescription)
        }
    }
    
    func fetchComicStrip(fromUrl urlString: String, completion: @escaping (_ response: Data?, _ error: String?) -> Void) {
        router.request(.getComicStrip(withUrlString: urlString)) {data, _, error in
            completion(data, error?.localizedDescription)
        }
    }
}
