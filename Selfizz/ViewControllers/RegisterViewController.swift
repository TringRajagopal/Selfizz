
import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseAuth

class RegisterViewController: UIViewController, FUIAuthDelegate {
    
    //IBOutlets
    @IBOutlet weak var registerButtonTapped: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //Variables
    let providers: [FUIAuthProvider] = [FUIGoogleAuth()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Custom Methods
    func setUPFirebaaseAuthUI() {
        if let defaultauthUI = FUIAuth.defaultAuthUI() {
            defaultauthUI.delegate = self
            defaultauthUI.providers = self.providers
            self.displayFirebaseAuthViewController(authUI_: defaultauthUI)
        }
    }
    
    func displayFirebaseAuthViewController(authUI_: FUIAuth) {
        let authViewController = authUI_.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    func validateUserAndProceedWithRegistration() {
        let isValidEmail = Utility.sharedInstance.isValidEmail(testStr: self.emailTextField.text!)
        if (isValidEmail) {
            Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordField.text!, completion: { (user, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                self.performSegue(withIdentifier: RegisterToHomePageSegueIdentifier, sender: user)
            })
        } else {
            let alertController = Utility.sharedInstance.getAlertInstance(alertDetails: (title: "Ohoo", desc: "That doesn't seems to be an valid email. Please try again"))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func alreadyHadAccountButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if (self.emailTextField.text?.characters.count == 0 || self.userNameField.text?.characters.count == 0 || self.passwordField.text?.characters.count == 0) {
            //Show alert
            let alertController = Utility.sharedInstance.getAlertInstance(alertDetails: (title: "SORRY", desc: "Fields shouldn't be empty"))
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.validateUserAndProceedWithRegistration()
        }
    }
    @IBAction func quickSignUpButtonTapped(_ sender: UIButton) {
        self.setUPFirebaaseAuthUI()
    }
    
    
    //Delegates
    //MARK: - FUIAuthDelegate Methods
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if (error != nil) {
            print(error.debugDescription)
            print(error?.localizedDescription)
            return
        }
        self.performSegue(withIdentifier: RegisterToHomePageSegueIdentifier, sender: user)
    }
    
    //MARK: - GOOGLE SIGNIN HANDLER
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
