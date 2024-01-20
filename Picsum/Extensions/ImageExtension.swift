import UIKit

extension UIImage {
    
    enum TabBar {
        static let feed = UIImage(systemName: "photo.stack")
        static let favorite = UIImage(systemName: "sparkles.rectangle.stack")
    }
    
    enum TabPicture {
        static let favorite = UIImage(systemName: "sparkle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
    }
}
