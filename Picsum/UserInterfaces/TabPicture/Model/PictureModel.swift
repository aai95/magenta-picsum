import Foundation

struct PictureModel {
    let id: String
    let downloadURL: String
    let isFavorite: Bool
    
    init(id: String, downloadURL: String, isFavorite: Bool) {
        self.id = id
        self.downloadURL = downloadURL
        self.isFavorite = isFavorite
    }
    
    init(from body: PictureBody) {
        self.id = body.id
        self.downloadURL = body.downloadURL
        self.isFavorite = false
    }
}
