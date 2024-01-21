import UIKit

protocol AlertHelperDelegate: AnyObject {
    func didMakeAlert(controller: UIAlertController)
}

struct AlertHelper {
    
    // MARK: Internal properties
    
    weak var delegate: AlertHelperDelegate?
    
    // MARK: Internal functions
    
    func makeAlertController(from model: AlertModel) {
        
        let controller = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        for actionModel in model.actions {
            
            let action = UIAlertAction(
                title: actionModel.title,
                style: actionModel.style,
                handler: actionModel.handler
            )
            controller.addAction(action)
            
            if actionModel.isPreferred {
                controller.preferredAction = action
            }
        }
        
        delegate?.didMakeAlert(controller: controller)
    }
    
    func makeRetryAlertModel(with action: @escaping (UIAlertAction) -> Void) -> AlertModel {
        let cancelActionModel = ActionModel(
            title: .ButtonTitle.cancel,
            style: .cancel
        )
        let retryActionModel = ActionModel(
            title: .ButtonTitle.retry,
            handler: action,
            isPreferred: true
        )
        let alertModel = AlertModel(
            title: .RetryAlert.title,
            message: .RetryAlert.message,
            actions: [cancelActionModel, retryActionModel]
        )
        return alertModel
    }
}

// MARK: - AlertModel

struct AlertModel {
    let title: String
    let message: String?
    let actions: Array<ActionModel>
}

// MARK: - ActionModel

struct ActionModel {
    let title: String
    var style: UIAlertAction.Style = .default
    var handler: ((UIAlertAction) -> Void)? = nil
    var isPreferred: Bool = false
}
