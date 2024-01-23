import Foundation

protocol PictureStorageProtocol: AnyObject {
    
    static var shared: PictureStorageProtocol { get }
    
    var storedPictureModels: Array<PictureModel> { get set }
    
    func updateStorage(using picture: PictureModel)
}

final class PictureStorage: PictureStorageProtocol {
    
    // MARK: Internal properties
    
    static var shared: PictureStorageProtocol = PictureStorage()
    
    var storedPictureModels: Array<PictureModel> {
        get {
            guard let data = storage.data(forKey: Key.favoritePictures.rawValue),
                  let models = try? decoder.decode([PictureModel].self, from: data)
            else {
                return []
            }
            return models
        }
        set {
            guard let data = try? encoder.encode(newValue) else {
                return
            }
            storage.set(data, forKey: Key.favoritePictures.rawValue)
        }
    }
    
    // MARK: Private properties
    
    private let storage = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    // MARK: Initializers
    
    private init() {}
    
    // MARK: Internal functions
    
    func updateStorage(using picture: PictureModel) {
        var models = storedPictureModels
        
        if let index = models.firstIndex(where: { $0.id == picture.id }) {
            models.remove(at: index)
            storedPictureModels = models
        } else {
            models.append(picture)
            storedPictureModels = models
        }
    }
}

// MARK: - Key

private enum Key: String {
    case favoritePictures
}
