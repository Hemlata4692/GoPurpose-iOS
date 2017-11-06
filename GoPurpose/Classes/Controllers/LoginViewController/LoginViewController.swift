//
//  LoginViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 01/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,BSKeyboardControlsDelegate,UITextFieldDelegate {
    
     // MARK: - IBOutlets
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var keyBoardControl:BSKeyboardControls?
     // MARK: - end
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewCustomisation()
        // Do any additional setup after loading the view.
    }
    
    func viewCustomisation() {
        //set keyboard controller text field array
        let textField=[emailField,passwordField]
        keyBoardControl = BSKeyboardControls(fields: textField as! [UITextField])
        keyBoardControl?.delegate=self
        emailField.addCornerRadius(radius: 25)
        passwordField.addCornerRadius(radius: 25)
        loginButton.addButtonCornerRadius(radius: 25)
        // forgotPasswordButton.translatesAutoresizingMaskIntoConstraints=true;
        //        CGRect(x:(UIScreen.main.bounds.origin.x+(UIScreen.main.bounds.size.width/2)-(forgotPasswordButton.frame.size.width/2)), y:forgotPasswordButton.frame.size.height - 1, width: forgotPasswordButton.frame.size.width, height: 1)
        forgotPasswordButton.addBottomBorderWithColor(color: UIColor.white)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.isHidden=true;
    }
    // MARK: - end
    
    // MARK: - IBActions
    @IBAction func loginbuttonAction(_ sender: Any) {
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        UIApplication.shared.keyWindow?.rootViewController = nextViewController
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        //push view
        loginScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    // MARK: - end
    
    // MARK: - BSKeboard delegate methods
    func keyboardControls(keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
        view=(field.superview?.superview?.superview)!
    }
    
    func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls) {
        keyboardControls.activeField?.resignFirstResponder()
        loginScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    // MARK: - end
    
    // MARK: - Textfield delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        keyBoardControl?.activeField = textField
        //Scroll view with keyboard height
        if (textField.frame.origin.y + textField.frame.size.height + 15 < (kScreenHeight - 256)) {
            loginScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        } else {
            loginScrollView.setContentOffset(CGPoint(x:0, y:((textField.frame.origin.y + textField.frame.size.height + 15) - (kScreenHeight - 256))), animated: false)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        textField .resignFirstResponder()
        return true
    }
    // MARK: - end
}
