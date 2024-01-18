import Foundation

final class PictureViewModel {
    
    // MARK: Private properties
    
    @Published
    private(set) var pictureModels: Array<PictureModel> = []
    
    // MARK: Internal functions
    
    func loadPictures(onlyFavorites: Bool) {
        let fetchedPictures = fetchPictures()
        pictureModels = onlyFavorites ? fetchedPictures.filter({ $0.isFavorite }) : fetchedPictures
    }
    
    // MARK: Private functions
    
    private func fetchPictures() -> Array<PictureModel> {
        return [
            PictureModel(id: 0, name: "Mountain", isFavorite: true),
            PictureModel(id: 1, name: "Walrus", isFavorite: false),
        ]
    }
}
