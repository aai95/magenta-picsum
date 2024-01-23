import XCTest

@testable import Picsum

final class AlertHelperTests: XCTestCase {
    
    func testAlertHelperMakesCorrectRetryModel() {
        // Given
        let alertHelper = AlertHelper(delegate: DelegateMock())
        
        // When
        let model = alertHelper.makeRetryAlertModel { _ in }
        
        // Then
        XCTAssertEqual(model.title, .RetryAlert.title)
        XCTAssertEqual(model.message, .RetryAlert.message)
        
        XCTAssertEqual(model.actions[0].title, .ButtonTitle.cancel)
        XCTAssertEqual(model.actions[1].title, .ButtonTitle.retry)
        
        XCTAssertTrue(model.actions[1].isPreferred)
    }
    
    func testAlertHelperNotifiesDelegate() {
        // Given
        var wasPerformedAction = false
        
        let mock = DelegateMock() // to keep in memory
        let alertHelper = AlertHelper(delegate: mock)
        
        // When
        let alertModel = alertHelper.makeRetryAlertModel { _ in
            wasPerformedAction = true
        }
        alertHelper.makeAlertController(from: alertModel)
        
        // Then
        XCTAssertTrue(wasPerformedAction)
    }
}

// MARK: - DelegateMock

private final class DelegateMock: AlertHelperDelegate {
    
    func didMakeAlert(controller: UIAlertController) {
        controller.tapButton(at: 1)
    }
}

// MARK: - UIAlertController

extension UIAlertController {
    
    typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
    
    func tapButton(at index: Int) {
        guard let block = actions[index].value(forKey: "handler") else {
            XCTFail("There is no handler")
            return
        }
        let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
        handler(actions[index])
    }
}
