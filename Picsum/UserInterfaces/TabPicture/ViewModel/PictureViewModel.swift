import Foundation

final class PictureViewModel {
    
    // MARK: Private properties
    
    @Published
    private(set) var pictureModels: Array<PictureModel> = []
    
    private let session = URLSession.shared
    private let perPage = 10
    private let onlyFavorites: Bool
    
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    
    // MARK: Initializers
    
    init(forFavorites value: Bool) {
        self.onlyFavorites = value
    }
    
    // MARK: Internal functions
    
    func loadNextPictures() {
        if onlyFavorites {
            readFromCache()
        } else {
            fetchNextPage()
        }
    }
    
    // MARK: Private functions
    
    private func readFromCache() {
        let testCache = [
            PictureModel(id: "483", link: "\(baseURL.absoluteString)/id/483/600/300", isFavorite: true),
            PictureModel(id: "566", link: "\(baseURL.absoluteString)/id/566/600/300", isFavorite: true),
        ]
        if pictureModels.count != testCache.count {
            pictureModels = testCache
        }
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
                
                self.pictureModels.append(contentsOf: bodies.map({ PictureModel(from: $0) }))
                self.lastLoadedPage = nextPage
                self.currentTask = nil
                
            case .failure(let error):
                print(error)
            }
        }
        
        currentTask = task
        task.resume()
    }
    
    private func makePictureRequest(for page: Int) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "/v2/list"
            + "?page=\(page)"
            + "&limit=\(perPage)"
        )
    }
}
