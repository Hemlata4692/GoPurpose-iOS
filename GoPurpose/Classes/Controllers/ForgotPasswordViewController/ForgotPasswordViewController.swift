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
        self.setLocalisedText()
        if (kScreenHeight<=568){
            forgotPasswordScrollView.isScrollEnabled=true }
        else {
            forgotPasswordScrollView.isScrollEnabled=false }
        forgotPasswordView.isHidden=false
        resetPasswordView.isHidden=true
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
    
    func setLocalisedText() {
        forgotPasswordEmailField.placeholder=NSLocalizedText(key: "email")
        resetPasswordEmailField.placeholder=NSLocalizedText(key: "email")
        confirmPasswordFiled.placeholder=NSLocalizedText(key: "confirmPassword")
        currentPasswordField.placeholder=NSLocalizedText(key: "password")
        otpNumberField.placeholder=NSLocalizedText(key: "otp")
        forgotPasswordButton.titleLabel?.text=NSLocalizedText(key: "submitButton")
        resetPasswordButton.titleLabel?.text=NSLocalizedText(key: "resetPassword")
        resendOTPButton.titleLabel?.text=NSLocalizedText(key: "resendOTP")
        backToLoginButton.titleLabel?.text=NSLocalizedText(key: "backToLogin")
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
    
    // MARK: - Email validation
    func performForgotPasswordValidations() -> Bool {
        if forgotPasswordEmailField.isEmpty() {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "emptyFieldMessage"), closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        } else if forgotPasswordEmailField.isValidEmail() == false {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "validEmailMessage"), closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        }
        return true
    }
    
    func performResetPasswordValidations() -> Bool {
        if resetPasswordEmailField.isEmpty() || currentPasswordField.isEmpty() || confirmPasswordFiled.isEmpty() || otpNumberField.isEmpty() {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "emptyFieldMessage"), closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        } else if resetPasswordEmailField.isValidEmail() == false {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "validEmailMessage"), closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        }
        else if ((otpNumberField.text?.count)!<6) {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "invalidOTP"),closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        }
        else if (currentPasswordField.text?.count)!<8 {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "validPassword"), closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        }
        else if (currentPasswordField.isValidPassword() == false) {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "validPassword"),closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        }
        else if !(currentPasswordField.text==confirmPasswordFiled.text) {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "passwordMatchMessage"), closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        }
        return true
    }
    // MARK: - end
    
    // MARK: - IBActions
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        keyBoardControl?.activeField?.resignFirstResponder()
        if performForgotPasswordValidations() {
            AppDelegate().showIndicator()
            self.perform(#selector(forgotPassword), with: nil, afterDelay: 0.1)
        }
    }
    
    @IBAction func backToLoginbuttonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func resetPasswordButtonAction(_ sender: Any) {
        keyBoardControl?.activeField?.resignFirstResponder()
        if performResetPasswordValidations() {
            AppDelegate().showIndicator()
            self.perform(#selector(resetPassword), with: nil, afterDelay: 0.1)
        }
    }
    
    @IBAction func resendOtpButtonAction(_ sender: Any) {
        forgotPasswordScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        let moveForgotView: UIView? = self.resetPasswordView
        self.addRightAnimationPresent(moveForgotView!)
        forgotPasswordView.isHidden=false
        resetPasswordView.isHidden=true
    }
    // MARK: - end
    
    // MARK: - Webservices
    //Forgot password webservice called
    @objc func forgotPassword() {
        let userLogin = LoginDataModel()
        userLogin.email = forgotPasswordEmailField.text
        LoginDataModel().forgotPasswordService(userLogin, success: { (response) in
            AppDelegate().stopIndicator()
            self.resetPasswordEmailField.text = self.forgotPasswordEmailField.text
            let moveForgotView: UIView? = self.resetPasswordView
            self.addLeftAnimationPresent(moveForgotView!)
            self.resetPasswordView.isHidden = false
            self.forgotPasswordView.isHidden = true
            self.keyBoardControl = BSKeyboardControls(fields: [self.resetPasswordEmailField,self.currentPasswordField,self.confirmPasswordFiled,self.otpNumberField] as! [UITextField])
            self.keyBoardControl?.delegate=self
            //currentView = resetPasswordView
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    
    //Reset password webservice called
    @objc func resetPassword() {
        let userLogin = LoginDataModel()
        userLogin.email = resetPasswordEmailField.text
        userLogin.otpNumber = otpNumberField.text
        userLogin.password = currentPasswordField.text
        LoginDataModel().resetPasswordService(userLogin, success: { (response) in
            AppDelegate().stopIndicator()
            let alert = SCLAlertView()
            _ = alert.addButton(NSLocalizedText(key: "alertOk")) {
                self.navigationController?.popViewController(animated:true)
            }
            _ = alert.showSuccess(NSLocalizedText(key: "alertTitle"), subTitle: NSLocalizedText(key: "resetPasswordSuccess"), closeButtonTitle: NSLocalizedText(key: "alertCancel"))
            
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
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
    
    // MARK: - Swipe view
    //Adding left animation to view
    func addLeftAnimationPresent(_ viewTobeAnimatedLeft: UIView) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.setValue("IntroSwipeIn", forKey: "IntroAnimation")
        transition.fillMode = kCAFillModeForwards
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        viewTobeAnimatedLeft.layer.add(transition, forKey: nil)
        //parentView.addSubview(myVC.view)
    }
    
    //Adding right animation to view
    func addRightAnimationPresent(_ viewTobeAnimatedRight: UIView) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.setValue("IntroSwipeIn", forKey: "IntroAnimation")
        transition.fillMode = kCAFillModeForwards
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        viewTobeAnimatedRight.layer.add(transition, forKey: nil)
    }
    // MARK: end
}
