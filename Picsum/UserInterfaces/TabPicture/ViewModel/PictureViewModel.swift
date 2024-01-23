import Foundation

protocol PictureViewModelProtocol: AnyObject {
    
    var feedPictureModelsPublisher: Published<Array<PictureModel>>.Publisher { get }
    var favoritePictureModelsPublisher: Published<Array<PictureModel>>.Publisher { get }
    var networkErrorPublisher: Published<NetworkError?>.Publisher { get }
    
    var feedPictureModels: Array<PictureModel> { get }
    var favoritePictureModels: Array<PictureModel> { get }
    var networkError: NetworkError? { get }
    
    func readFromStorage()
    func fetchNextPage()
    func toggleFavoriteForPicture(with id: String)
}

final class PictureViewModel: PictureViewModelProtocol {
    
    // MARK: Internal properties
    
    var feedPictureModelsPublisher: Published<Array<PictureModel>>.Publisher { $feedPictureModels }
    var favoritePictureModelsPublisher: Published<Array<PictureModel>>.Publisher { $favoritePictureModels }
    var networkErrorPublisher: Published<NetworkError?>.Publisher { $networkError }
    
    @Published private(set) var feedPictureModels: Array<PictureModel> = []
    @Published private(set) var favoritePictureModels: Array<PictureModel> = []
    @Published private(set) var networkError: NetworkError?
    
    // MARK: Private properties
    
    private let storage = PictureStorage.shared
    private let session = URLSession.shared
    private let perPage = 10
    
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    
    // MARK: Internal functions
    
    func readFromStorage() {
        favoritePictureModels = storage.storedPictureModels
    }
    
    func fetchNextPage() {
        guard currentTask == nil else {
            return
        }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        let request = makePictureRequest(for: nextPage)
        
        let task = session.decodeTask(from: request) { [weak self] (result: Result<[PictureBody], Error>) in
            guard let self else {
                return
            }
            switch result {
            case .success(let bodies):
                assert(Thread.isMainThread, "This code must be executed on the main thread")
                
                self.feedPictureModels.append(contentsOf: convert(from: bodies))
                self.lastLoadedPage = nextPage
                self.currentTask = nil
                
            case .failure(let error):
                self.networkError = error as? NetworkError
                self.currentTask = nil
            }
        }
        
        currentTask = task
        task.resume()
    }
    
    func toggleFavoriteForPicture(with id: String) {
        var modelToStore: PictureModel?
        
        if let index = feedPictureModels.firstIndex(where: { $0.id == id }) { // Toggle on Feed
            let old = feedPictureModels[index]
            let new = old.toggleIsFavorite()
            feedPictureModels[index] = new
            modelToStore = new
        }
        
        if let index = favoritePictureModels.firstIndex(where: { $0.id == id }) { // Remove from Favorite
            let old = favoritePictureModels[index]
            let new = old.toggleIsFavorite()
            favoritePictureModels.remove(at: index)
            modelToStore = new
        } else if let model = modelToStore { // Add to Favorite
            favoritePictureModels.append(model)
        }
        
        if let model = modelToStore { // Update in Storage
            storage.updateStorage(using: model)
        }
    }
    
    // MARK: Private functions
    
    private func makePictureRequest(for page: Int) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "/v2/list"
            + "?page=\(page)"
            + "&limit=\(perPage)"
        )
    }
    
    private func convert(from bodies: [PictureBody]) -> [PictureModel] {
        return bodies.map { body in
            PictureModel(
                id: body.id,
                link: "\(baseURL.absoluteString)/id/\(body.id)/600/300",
                isFavorite: favoritePictureModels.contains(where: { $0.id == body.id })
            )
        }
    }
}
