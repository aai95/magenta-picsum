import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarItems()
    }
    
    private func setupTabBarItems() {
        let randomController = RandomPictureViewController()
        let favoriteController = FavoritePictureViewController()
        
        randomController.tabBarItem = UITabBarItem(
            title: nil,
            image: .TabBar.random,
            tag: 0
        )
        favoriteController.tabBarItem = UITabBarItem(
            title: nil,
            image: .TabBar.favorite,
            tag: 1
        )
        viewControllers = [randomController, favoriteController]
    }
}
