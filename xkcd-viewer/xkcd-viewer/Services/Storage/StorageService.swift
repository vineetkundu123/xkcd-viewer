import Foundation

final class StorageService {
    private let fullPath: URL
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    init(fileName: String) {
        self.fullPath = documentsDirectory.appendingPathComponent(fileName)
    }
    
    func save<T: Codable>(object: T) {
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: fullPath)
        } catch {
            print("Couldn't write file")
        }
    }
    
    func fetch<T: Codable>() -> T? {
        do {
            let data = try Data(contentsOf: fullPath)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Couldn't read file.")
        }
        return nil
    }
}
