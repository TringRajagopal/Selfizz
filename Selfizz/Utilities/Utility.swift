
import UIKit

class Utility: NSObject {
    
    //Shared Instance
    class var sharedInstance: Utility {
        struct Static {
            static let instance = Utility()
        }
        return Static.instance
    }
    
    //Valid Email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //Alert
    func displayAlert(alertDetails: (title: String, desc: String), viewController: UIViewController) {
        let alert = UIAlertController(title: alertDetails.title, message: alertDetails.desc, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
