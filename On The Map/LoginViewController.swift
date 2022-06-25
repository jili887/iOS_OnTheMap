//
//  ViewController.swift
//  On The Map
//
//  Created by Jia Li on 6/5/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let signUpURL = URL(string: "https://auth.udacity.com/sign-up")!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: Login button
    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        APIClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleLoginResponse(success:error:))
    }

    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            emailTextField.text = ""
            passwordTextField.text = ""
            performSegue(withIdentifier: "LoginSuccess", sender: self)
        } else {
            showLoginError(title: "Oops", message: error?.localizedDescription ?? "Login Failed")
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func showLoginError(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
        setLoggingIn(false)
    }
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(self.signUpURL)
    }
}
