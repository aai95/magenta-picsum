import UIKit

extension UIImage {
    
    enum Tab {
        static let feed = UIImage(systemName: "photo.stack.fill")
        static let favorite = UIImage(systemName: "sparkles.rectangle.stack.fill")
    }
    
    enum Button {
        static let favorite = UIImage(systemName: "sparkle")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 32))
    }
    
    enum Placeholder {
        static let feed = UIImage(systemName: "photo.stack")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 128))
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        static let favorite = UIImage(systemName: "sparkles.rectangle.stack")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 128))
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        
        static let picture = UIImage(systemName: "photo")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 128))
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    }
}
