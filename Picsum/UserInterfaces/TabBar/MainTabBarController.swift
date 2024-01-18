import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarItems()
    }
    
    // MARK: Private functions
    
    private func setupTabBarItems() {
        let feedController = PictureViewController()
        let favoriteController = PictureViewController()
        
        favoriteController.showFavorites = true
        
        feedController.tabBarItem = UITabBarItem(
            title: nil,
            image: .TabBar.feed,
            tag: 0
        )
        favoriteController.tabBarItem = UITabBarItem(
            title: nil,
            image: .TabBar.favorite,
            tag: 1
        )
        viewControllers = [feedController, favoriteController]
    }
}
