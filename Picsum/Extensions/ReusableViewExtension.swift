import UIKit

protocol DefaultReusableView {
    static var defaultReuseIdentifier: String { get }
}

// MARK: - UITableViewCell

extension DefaultReusableView where Self: UITableViewCell {
    
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
}

extension UITableView {
    
    func registerDefault<Cell: UITableViewCell>(_: Cell.Type) where Cell: DefaultReusableView {
        register(Cell.self, forCellReuseIdentifier: Cell.defaultReuseIdentifier)
    }
    
    func dequeueDefaultReusableCell<Cell: UITableViewCell>() -> Cell where Cell: DefaultReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.defaultReuseIdentifier) as? Cell else {
            assertionFailure("Failed to dequeue reusable cell with identifier \(Cell.defaultReuseIdentifier)")
            return Cell()
        }
        return cell
    }
}
