import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarItems()
    }
    
    // MARK: Private functions
    
    private func setupTabBarItems() {
        let viewModel = PictureViewModel()
        
        let feedController = PictureViewController(viewModel: viewModel)
        let favoriteController = PictureViewController(viewModel: viewModel, onlyFavorites: true)
        
        feedController.tabBarItem = UITabBarItem(
            title: nil,
            image: .Tab.feed,
            tag: 0
        )
        favoriteController.tabBarItem = UITabBarItem(
            title: nil,
            image: .Tab.favorite,
            tag: 1
        )
        viewControllers = [feedController, favoriteController]
    }
}
