/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupActive = true

    @IBOutlet var userName: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var registeredText: UILabel!
    @IBOutlet var loginButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @available(iOS 8.0, *)
    func displayAlert(title: String, message: String) {
    
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                
            self.dismissViewControllerAnimated(true, completion: nil)
                
        }))

        
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    @available(iOS 8.0, *)
    @IBAction func signUp(sender: AnyObject) {
        
        if userName.text == "" || password.text == "" {
        
            displayAlert("Error in form", message: "Please enter a username and password")
        
        } else {
        
            // spinner
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            // for generic error message
            var errorMessage = "Please try again later"
            
            if signupActive == true {
            
            // sign user
            var user = PFUser()
            user.username = userName.text
            user.password = password.text
            

            
            user.signUpInBackgroundWithBlock({ (success, error) in
                
                
                if error == nil {
                
                    // sign up successful
                    
                } else {
                
                    // if we have an error, unwrap and cast it as a string
                    if let errorString = error!.userInfo["error"] as? String {
                        
                        // parse provided error message
                        errorMessage = errorString
                    
                    }
                    
                    self.displayAlert("Failed sign up", message: errorMessage)
                
                }
                
            })
                
            } else {
            
                PFUser.logInWithUsernameInBackground(userName.text!, password: password.text!, block: {(user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()

                    
                    if user != nil {
                    
                        // Logged in!
                    
                    } else {
                    
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            // parse provided error message
                            errorMessage = errorString
                            
                        }
                        
                        self.displayAlert("Failed sign up", message: errorMessage)
                    
                    }
                
                })
            
            }
        
        }
        
        
        
    }
    
    @IBAction func logIn(sender: AnyObject) {
        
        if signupActive == true {
        
            signupButton.setTitle("Log In", forState: UIControlState.Normal)
            
            registeredText.text = "Not registered?"
            
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signupActive = false
        
        } else {
        
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            registeredText.text = "Already registered?"
            
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            
            signupActive = true
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
