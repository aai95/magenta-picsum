import XCTest

@testable import Picsum

final class PictureViewModelTests: XCTestCase {
    
    func testViewModelReadsFavoritePicturesFromStorage() {
        // Given
        let viewModel = PictureViewModel(storage: PictureStorageStub())
        
        // When
        viewModel.readFromStorage()
        
        // Then
        XCTAssertEqual(viewModel.favoritePictureModels.count, 2)
    }
    
    func testViewModelRemovesFromFavoriteAndCallsUpdateStorage() {
        // Given
        let storageStub = PictureStorageStub()
        let viewModel = PictureViewModel(storage: storageStub)
        
        viewModel.readFromStorage()
        
        // When
        viewModel.toggleFavoriteForPicture(with: "1")
        
        // Then
        XCTAssertEqual(viewModel.favoritePictureModels.count, 1)
        XCTAssertTrue(storageStub.wasCalledUpdateStorage)
    }
}

// MARK: - PictureStorageStub

private final class PictureStorageStub: PictureStorageProtocol {
    
    // MARK: Internal properties
    
    static var shared: PictureStorageProtocol = PictureStorageStub()
    
    var storedPictureModels: Array<PictureModel> = [
        PictureModel(id: "1", link: "http://example.com/", isFavorite: true),
        PictureModel(id: "2", link: "http://example.com/", isFavorite: true),
    ]
    
    var wasCalledUpdateStorage = false
    
    // MARK: Internal functions
    
    func updateStorage(using picture: PictureModel) {
        wasCalledUpdateStorage = true
    }
}
