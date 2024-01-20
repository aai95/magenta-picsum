import Foundation

struct PictureModel {
    let id: String
    let link: String
    let isFavorite: Bool
    
    init(id: String, link: String, isFavorite: Bool) {
        self.id = id
        self.link = link
        self.isFavorite = isFavorite
    }
    
    init(from body: PictureBody) {
        self.id = body.id
        self.link = "\(baseURL.absoluteString)/id/\(body.id)/600/300"
        self.isFavorite = false
    }
}
