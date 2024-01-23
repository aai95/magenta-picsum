import XCTest

@testable import Picsum

final class PictureViewControllerTests: XCTestCase {
    
    func testControllerCallsReadFromStorageAndFetchNextPage() {
        // Given
        let viewModelSpy = PictureViewModelSpy()
        let feedController = PictureViewController(viewModel: viewModelSpy)
        
        // When
        _ = feedController.view
        
        // Then
        XCTAssertTrue(viewModelSpy.wasCalledReadFromStorage)
        XCTAssertTrue(viewModelSpy.wasCalledFetchNextPage)
    }
    
    func testControllerCallsReadFromStorageOnly() {
        // Given
        let viewModelSpy = PictureViewModelSpy()
        let favoriteController = PictureViewController(viewModel: viewModelSpy, onlyFavorites: true)
        
        // When
        _ = favoriteController.view
        
        // Then
        XCTAssertTrue(viewModelSpy.wasCalledReadFromStorage)
        XCTAssertTrue(!viewModelSpy.wasCalledFetchNextPage)
    }
    
    func testControllerCallsToggleFavoriteForPicture() {
        // Given
        let viewModelSpy = PictureViewModelSpy()
        let viewController = PictureViewController(viewModel: viewModelSpy)
        
        let cellDummy = PictureTableViewCell()
        cellDummy.pictureModel = PictureModel(id: "", link: "", isFavorite: false)
        
        // When
        viewController.didTapFavorite(in: cellDummy)
        
        // Then
        XCTAssertTrue(viewModelSpy.wasCalledToggleFavoriteForPicture)
    }
}

// MARK: - PictureViewModelSpy

private final class PictureViewModelSpy: PictureViewModelProtocol {
    
    // MARK: Internal properties
    
    var feedPictureModelsPublisher: Published<Array<PictureModel>>.Publisher { $feedPictureModels }
    var favoritePictureModelsPublisher: Published<Array<PictureModel>>.Publisher { $favoritePictureModels }
    var networkErrorPublisher: Published<NetworkError?>.Publisher { $networkError }
    
    @Published private(set) var feedPictureModels: Array<PictureModel> = []
    @Published private(set) var favoritePictureModels: Array<PictureModel> = []
    @Published private(set) var networkError: NetworkError?
    
    var wasCalledReadFromStorage = false
    var wasCalledFetchNextPage = false
    var wasCalledToggleFavoriteForPicture = false
    
    // MARK: Internal functions
    
    func readFromStorage() {
        wasCalledReadFromStorage = true
    }
    
    func fetchNextPage() {
        wasCalledFetchNextPage = true
    }
    
    func toggleFavoriteForPicture(with id: String) {
        wasCalledToggleFavoriteForPicture = true
    }
}
