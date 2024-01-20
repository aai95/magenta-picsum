import UIKit
import Combine

final class PictureViewController: UIViewController {
    
    // MARK: Private properties
    
    private let viewModel: PictureViewModel
    private let onlyFavorites: Bool
    
    private var subscribers = Array<AnyCancellable>()
    
    private lazy var pictureTable: UITableView = {
        let table = UITableView(frame: .zero)
        
        table.registerDefault(PictureTableViewCell.self)
        table.separatorStyle = .none
        
        table.dataSource = self
        table.delegate = self
        
        return table
    }()
    
    // MARK: Initializers
    
    init(viewModel: PictureViewModel, onlyFavorites: Bool = false) {
        self.viewModel = viewModel
        self.onlyFavorites = onlyFavorites
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override functions
    
    override func loadView() {
        super.loadView()
        
        addSubviews()
        activateConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        subscribeToPublishers()
        viewModel.readFromStorage()
        
        if !onlyFavorites {
            viewModel.fetchNextPage()
        }
    }
    
    // MARK: Private functions
    
    private func addSubviews() {
        view.addSubview(pictureTable)
    }
    
    private func activateConstraints() {
        pictureTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pictureTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pictureTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pictureTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pictureTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func subscribeToPublishers() {
        if onlyFavorites {
            viewModel.$favoritePictureModels
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] _ in
                    guard let self else {
                        return
                    }
                    self.pictureTable.reloadData()
                })
                .store(in: &subscribers)
        } else {
            viewModel.$feedPictureModels
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] _ in
                    guard let self else {
                        return
                    }
                    self.pictureTable.reloadData()
                })
                .store(in: &subscribers)
        }
    }
}

// MARK: - UITableViewDataSource

extension PictureViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        
        if indexPath.row == lastRowIndex && !onlyFavorites {
            viewModel.fetchNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onlyFavorites ? viewModel.favoritePictureModels.count : viewModel.feedPictureModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PictureTableViewCell = tableView.dequeueDefaultReusableCell()
        let models = onlyFavorites ? viewModel.favoritePictureModels : viewModel.feedPictureModels
        
        cell.pictureModel = models[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PictureViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - PictureTableViewCellDelegate

extension PictureViewController: PictureTableViewCellDelegate {
    
    func didTapFavorite(in cell: PictureTableViewCell) {
        guard let id = cell.pictureModel?.id else {
            return
        }
        viewModel.toggleFavoriteForPicture(with: id)
    }
}
