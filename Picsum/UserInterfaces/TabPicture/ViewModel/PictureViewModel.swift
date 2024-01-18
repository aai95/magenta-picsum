import Foundation

final class PictureViewModel {
    
    // MARK: Private properties
    
    @Published
    private(set) var pictureModels: Array<PictureModel> = []
    
    // MARK: Internal functions
    
    func loadPictures() {
        fetchPictures()
    }
    
    // MARK: Private functions
    
    private func fetchPictures() {
        pictureModels = [
            PictureModel(id: 0, name: "Mountain", isFavorite: true),
            PictureModel(id: 1, name: "Walrus", isFavorite: false),
        ]
    }
}
