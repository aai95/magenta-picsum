import Foundation

final class PictureViewModel {
    
    // MARK: Private properties
    
    @Published
    private(set) var pictureModels: Array<PictureModel> = []
    
    private let session = URLSession.shared
    private let perPage = 5
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
        pictureModels = [
            PictureModel(id: "0", downloadURL: "Mountain", isFavorite: true),
            PictureModel(id: "1", downloadURL: "Walrus", isFavorite: true),
        ]
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
                
                bodies.forEach({ print($0) })
                
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
