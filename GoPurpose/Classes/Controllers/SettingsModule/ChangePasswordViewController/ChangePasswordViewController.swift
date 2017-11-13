//
//  ChangePasswordViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 10/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class ChangePasswordViewController: GlobalBackViewController,BSKeyboardControlsDelegate,UITextFieldDelegate {
    
    // MARK: - Outlets and declarations
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    var keyBoardControl:BSKeyboardControls?
    // MARK: - end
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NSLocalizedText(key: "changePasswordProfile")
        self.viewCustomisation()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewCustomisation() {
        self.setLocalisedText()
        //set keyboard controller text field array
        let textField=[currentPasswordField,newPasswordField,confirmPasswordField]
        keyBoardControl = BSKeyboardControls(fields: textField as! [UITextField])
        keyBoardControl?.delegate=self
        //add corner radius and border
        currentPasswordField.addBorderRadius(radius: 20, color: UIColor (red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 0.7))
        newPasswordField.addBorderRadius(radius: 20, color: UIColor (red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 0.7))
        confirmPasswordField.addBorderRadius(radius: 20, color: UIColor (red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 0.7))
        //set padding to text filed
        changePasswordButton.addButtonCornerRadius(radius: 20)
        currentPasswordField.setLeftPaddingPoints(12)
        newPasswordField.setLeftPaddingPoints(12)
        confirmPasswordField.setLeftPaddingPoints(12)
    }
    
    func setLocalisedText() {
        currentPasswordField.placeholder=NSLocalizedText(key: "currentPasswordPlaceholder")
        newPasswordField.placeholder=NSLocalizedText(key: "newPasswordPlaceholder")
        confirmPasswordField.placeholder=NSLocalizedText(key: "confirmPassword")
        changePasswordButton.titleLabel?.text=NSLocalizedText(key: "changePasswordProfile")
    }
    // MARK: - end
    
    // MARK: - IBActions
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        keyBoardControl?.activeField?.resignFirstResponder()
        if performChangePasswordValidations() {
            AppDelegate().showIndicator()
            self.perform(#selector(changePasswordService), with: nil, afterDelay: 0.1)
        }
    }
    // MARK: - end
    
    // MARK: - Webservice
    //Change user password
    @objc func changePasswordService() {
        let changePasswordModel = ProfileDataModel()
        changePasswordModel.currentPassword = currentPasswordField.text
        changePasswordModel.newPassword = newPasswordField.text
        ProfileDataModel().changePasswordService(changePasswordModel, success: { (response) in
            AppDelegate().stopIndicator()
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton(NSLocalizedText(key: "alertOk")) {
                self.navigationController?.popViewController(animated:true)
            }
            _ = alert.showSuccess(NSLocalizedText(key: "alertTitle"), subTitle: NSLocalizedText(key: "resetPasswordSuccess"), closeButtonTitle: nil)
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    // MARK: - end
    
    // MARK: - Email validation
    func performChangePasswordValidations() -> Bool {
        if currentPasswordField.isEmpty() ||  newPasswordField.isEmpty() ||  confirmPasswordField.isEmpty(){
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "emptyFieldMessage"), closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        } else if (currentPasswordField.text?.count)!<8 || (newPasswordField.text?.count)!<8{
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "validPassword"), closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        }
        else if (newPasswordField.isValidPassword() == false) ||  (currentPasswordField.isValidPassword() == false) ||  (confirmPasswordField.isValidPassword() == false) {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "validPassword"),closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        }
        else if currentPasswordField.text==newPasswordField.text {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "oldPasswordMatchMessage"),closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        }
        else if currentPasswordField.text==confirmPasswordField.text {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:NSLocalizedText(key: "passwordMatchMessage"),closeButtonTitle: NSLocalizedText(key: "alertOk"))
            return false
        }
        return true
    }
    // MARK: - end
    
    // MARK: - BSKeboard delegate methods
    func keyboardControls(keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
        view=(field.superview?.superview?.superview)!
    }
    
    func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls) {
        keyboardControls.activeField?.resignFirstResponder()
    }
    // MARK: - end
    
    // MARK: - Textfield delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        keyBoardControl?.activeField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }
    // MARK: - end
}
