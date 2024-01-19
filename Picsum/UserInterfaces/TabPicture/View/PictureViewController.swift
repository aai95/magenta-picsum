import UIKit
import Combine

final class PictureViewController: UIViewController {
    
    // MARK: Internal properties
    
    var showFavorites: Bool = false
    
    // MARK: Private properties
    
    private lazy var viewModel = PictureViewModel(forFavorites: showFavorites)
    private var subscribers = Array<AnyCancellable>()
    
    private lazy var pictureTable: UITableView = {
        let table = UITableView(frame: .zero)
        
        table.registerDefault(PictureTableViewCell.self)
        table.separatorStyle = .none
        
        table.dataSource = self
        table.delegate = self
        
        return table
    }()
    
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
        viewModel.loadNextPictures()
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
        viewModel.$pictureModels
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

// MARK: - UITableViewDataSource

extension PictureViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pictureModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PictureTableViewCell = tableView.dequeueDefaultReusableCell()
        cell.pictureModel = viewModel.pictureModels[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PictureViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
