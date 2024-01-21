import Foundation

extension String {
    
    enum RetryAlert {
        static let title = NSLocalizedString("", value: "Что-то пошло не так", comment: "")
        static let message = NSLocalizedString("", value: "Проверьте доступность сети и VPN\nПопробовать ещё раз?", comment: "")
    }
    
    enum ButtonTitle {
        static let cancel = NSLocalizedString("", value: "Отменить", comment: "")
        static let retry = NSLocalizedString("", value: "Повторить", comment: "")
    }
}
