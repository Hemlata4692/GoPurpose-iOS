//
//  ForgotPasswordViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 01/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate,BSKeyboardControlsDelegate {
    
    // MARK: - IBOutlets and declarations
    @IBOutlet weak var forgotPasswordScrollView: UIScrollView!
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var resetPasswordView: UIView!
    @IBOutlet weak var forgotPasswordEmailField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var backToLoginButton: UIButton!
    @IBOutlet weak var resetPasswordEmailField: UITextField!
    @IBOutlet weak var confirmPasswordFiled: UITextField!
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var otpNumberField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    var keyBoardControl:BSKeyboardControls?
    
    // MARK: - end
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewCustomisation()
    }
    
    func viewCustomisation() {
        let forgotPasswordTextField=[resetPasswordEmailField,currentPasswordField,confirmPasswordFiled,otpNumberField]
        keyBoardControl = BSKeyboardControls(fields: forgotPasswordTextField as! [UITextField])
        keyBoardControl?.delegate=self
        if (kScreenHeight<=568){
            forgotPasswordScrollView.isScrollEnabled=true }
        else {
            forgotPasswordScrollView.isScrollEnabled=false }
        forgotPasswordView.isHidden=true
        forgotPasswordEmailField.addCornerRadius(radius: 25)
        resetPasswordEmailField.addCornerRadius(radius: 25)
        confirmPasswordFiled.addCornerRadius(radius: 25)
        currentPasswordField.addCornerRadius(radius: 25)
        otpNumberField.addCornerRadius(radius: 25)
        forgotPasswordButton.addButtonCornerRadius(radius: 25)
        resetPasswordButton.addButtonCornerRadius(radius: 25)
        resendOTPButton.addBottomBorderWithColor(color: UIColor.white)
        backToLoginButton.addBottomBorderWithColor(color: UIColor.white)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden=true;
    }
    // MARK: - end
    
    // MARK: - IBActions
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
    }
    
    @IBAction func backToLoginbuttonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func resetPasswordButtonAction(_ sender: Any) {
    }
    
    @IBAction func resendOtpButtonAction(_ sender: Any) {
        forgotPasswordScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        forgotPasswordView.isHidden=false
        resetPasswordView.isHidden=true
    }
    // MARK: - end
    
    // MARK: - BSKeyboardControl delegate method
    func keyboardControls(keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
        //view=(field.superview?.superview?.superview)!
    }
    
    func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls) {
        keyboardControls.activeField?.resignFirstResponder()
        forgotPasswordScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    // MARK: - end
    
    // MARK: - Textfield delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        keyBoardControl?.activeField = textField
        //Scroll view with keyboard height
        if (kScreenHeight<=568) {
            forgotPasswordScrollView.setContentOffset(CGPoint(x:0, y:(textField.frame.origin.y + textField.frame.size.height + 15)), animated: false)
        }
        else {
            if (textField.frame.origin.y + textField.frame.size.height + 15 < (resetPasswordView.frame.size.height - 256)) {
                forgotPasswordScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
            } else {
                forgotPasswordScrollView.setContentOffset(CGPoint(x:0, y:((textField.frame.origin.y + textField.frame.size.height + 15) - (resetPasswordView.frame.size.height - 256))), animated: false)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        forgotPasswordScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        textField .resignFirstResponder()
        return true
    }
    // MARK: end
}
