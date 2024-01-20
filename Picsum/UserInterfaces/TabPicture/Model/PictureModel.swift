import Foundation

struct PictureModel: Codable {
    let id: String
    let link: String
    let isFavorite: Bool
    
    func toggleIsFavorite() -> PictureModel {
        return PictureModel(
            id: self.id,
            link: self.link,
            isFavorite: !self.isFavorite
        )
    }
}
