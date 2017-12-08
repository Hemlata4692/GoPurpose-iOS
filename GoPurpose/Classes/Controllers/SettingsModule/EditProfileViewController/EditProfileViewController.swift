//
//  EditProfileViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 10/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit

class EditProfileViewController: GlobalBackViewController,BSKeyboardControlsDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Outlets and declarations
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var businessNameFiled: UITextField!
    @IBOutlet weak var addressField1: UITextField!
    @IBOutlet weak var addressField2: UITextField!
    @IBOutlet weak var zipCodeFiled: UITextField!
    @IBOutlet weak var businessRegistrationNumberField: UITextField!
    @IBOutlet weak var businessDescriptionView: KMPlaceholderTextView!
    @IBOutlet weak var changeCurrencyField: UITextField!
    @IBOutlet weak var changeLanguageField: UITextField!
    @IBOutlet weak var contactNumberField: UITextField!
    @IBOutlet weak var businessCuntryField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editProfileScrollView: UIScrollView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerToolBar: UIToolbar!
    @IBOutlet weak var toolBarCancelButton: UIBarButtonItem!
    @IBOutlet weak var toolBarDoneButton: UIBarButtonItem!
    var groupId: Any?
    var websiteId: Any?
    var storeId: Any?
    var pickerType: Int?
    var languageType: Int?
    var pickerIndex1: Int?
    var pickerIndex2: Int?
    var addressArray:NSMutableArray = NSMutableArray()
    var customerDataArray:NSMutableArray=NSMutableArray()
    var countryPickerArray:NSMutableArray = NSMutableArray()
    var keyBoardControl:BSKeyboardControls?
    var changeLanguageArray = [NSLocalizedText(key: "gp_en"), NSLocalizedText(key: "gp_zh"), NSLocalizedText(key: "gp_cn")]
    //MARK: - end
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NSLocalizedText(key: "editProfile")
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.viewCustomisation()
        AppDelegate().showIndicator()
        self.perform(#selector(getCountryList), with: nil, afterDelay: 0.1)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewCustomisation() {
        self.setLocalisedText()
        //set keyboard controller text field array
        let textField=[firstNameField,lastNameField,businessNameFiled,addressField1,addressField2,businessRegistrationNumberField,zipCodeFiled,contactNumberField,businessDescriptionView] as [Any]
        keyBoardControl = BSKeyboardControls(fields: textField as! [UIView])
        keyBoardControl?.delegate=self
        //add corner radius and border
        firstNameField.addBorderRadius(radius: 20, color: kBorderColor)
        lastNameField.addBorderRadius(radius: 20, color: kBorderColor)
        businessNameFiled.addBorderRadius(radius: 20, color: kBorderColor)
        addressField1.addBorderRadius(radius: 20, color: kBorderColor)
        addressField2.addBorderRadius(radius: 20, color: kBorderColor)
        zipCodeFiled.addBorderRadius(radius: 20, color: kBorderColor)
        businessRegistrationNumberField.addBorderRadius(radius: 20, color: kBorderColor)
        changeCurrencyField.addBorderRadius(radius: 20, color: kBorderColor)
        changeLanguageField.addBorderRadius(radius: 20, color: kBorderColor)
        businessRegistrationNumberField.addBorderRadius(radius: 20, color: kBorderColor)
        contactNumberField.addBorderRadius(radius: 20, color: kBorderColor)
        businessCuntryField.addBorderRadius(radius: 20, color: kBorderColor)
        businessDescriptionView.addBorderRadius(radius: 10, color: kBorderColor)
        userProfileImageView.addBorderRadius(radius: 65, color: kBorderColor)
        userProfileImageView.clipsToBounds=true
        saveButton.addButtonCornerRadius(radius: 20)
        //set padding to text filed
        businessRegistrationNumberField.setLeftPaddingPoints(12)
        contactNumberField.setLeftPaddingPoints(12)
        businessCuntryField.setLeftPaddingPoints(12)
        changeLanguageField.setLeftPaddingPoints(12)
        changeCurrencyField.setLeftPaddingPoints(12)
        businessRegistrationNumberField.setLeftPaddingPoints(12)
        zipCodeFiled.setLeftPaddingPoints(12)
        addressField2.setLeftPaddingPoints(12)
        addressField1.setLeftPaddingPoints(12)
        businessNameFiled.setLeftPaddingPoints(12)
        lastNameField.setLeftPaddingPoints(12)
        firstNameField.setLeftPaddingPoints(12)
        businessDescriptionView.textContainerInset = UIEdgeInsets(top: 5, left: 8, bottom: 3, right: 5)
    }
    
    func setLocalisedText() {
        firstNameField.placeholder=NSLocalizedText(key: "firstName")
        lastNameField.placeholder=NSLocalizedText(key: "lastName")
        businessNameFiled.placeholder=NSLocalizedText(key: "businessName")
        addressField1.placeholder=NSLocalizedText(key: "businessAddress1")
        addressField2.placeholder=NSLocalizedText(key: "businessAddress2")
        zipCodeFiled.placeholder=NSLocalizedText(key: "zipCode")
        businessRegistrationNumberField.placeholder=NSLocalizedText(key: "businessRegisterNumber")
        contactNumberField.placeholder=NSLocalizedText(key: "contactPerson")
        businessCuntryField.placeholder=NSLocalizedText(key: "businessCountry")
        businessDescriptionView.placeholder=NSLocalizedText(key: "businessDescription")
        saveButton.setTitle(NSLocalizedText(key: "saveButton"),for: .normal)
    }
    //MARK: - end
    
    //MARK: - Webservices
    
    //Get country picker data
    @objc func getCountryList() {
        let userData = ProfileDataModel()
        ProfileDataModel().getCountryListData(userData, success: { (response) in
            self.countryPickerArray=userData.countryArray.mutableCopy() as! NSMutableArray
            self.getUserProfile()
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    
    //Get user profile
    func getUserProfile() {
        let userData = ProfileDataModel()
        ProfileDataModel().getUserProfile(userData, success: { (response) in
            AppDelegate().stopIndicator()
            self.displayData(profileData: userData)
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    
    //display user profile data
    func displayData(profileData:ProfileDataModel) {
        if ((UserDefaults().string(forKey: "userProfileImage")) != nil) {
            userProfileImageView?.downloadFrom(link: UserDefaults().string(forKey: "userProfileImage")!)
        }
        userEmailLabel.text=profileData.email
        firstNameField?.text=profileData.firstName
        lastNameField?.text=profileData.lastName
        businessNameFiled?.text=profileData.businessName
        businessRegistrationNumberField?.text=profileData.businessNumber
        businessDescriptionView?.text=profileData.businessDescription
        addressField1?.text=profileData.businessAddressLine1
        addressField2?.text=profileData.businessAddressLine2
        contactNumberField?.text=profileData.contactNumber
        businessCuntryField?.text=profileData.businessCountry
        let indexOfA = countryPickerArray.index(of: profileData.businessCountry as Any)
        pickerIndex2=indexOfA
        zipCodeFiled?.text=profileData.zipcode
        customerDataArray=profileData.customerAttributeArray.mutableCopy() as! NSMutableArray
        groupId=profileData.groupId
        storeId=profileData.storeId
        websiteId=profileData.websiteId
        addressArray=profileData.addressArray.mutableCopy() as! NSMutableArray
        if (profileData.defaultLanguage?.intValue == 4) {
            changeLanguageField?.text=NSLocalizedText(key: "gp_en")
            languageType = 4
            pickerIndex1 = 0
        }
        else if (profileData.defaultLanguage?.intValue  == 5) {
            changeLanguageField?.text=NSLocalizedText(key: "gp_zh")
            languageType = 5
            pickerIndex1 = 1
        }
        else if (profileData.defaultLanguage?.intValue  == 6) {
            changeLanguageField?.text=NSLocalizedText(key: "gp_cn")
            languageType = 6
            pickerIndex1 = 2
        }
    }
    
    func saveUserData(profileData:ProfileDataModel) -> ProfileDataModel {
        profileData.email=userEmailLabel.text
        profileData.firstName=firstNameField.text
        profileData.lastName=lastNameField.text
        profileData.businessName=businessNameFiled.text
        profileData.businessNumber=businessRegistrationNumberField.text
        profileData.businessDescription=businessDescriptionView.text
        profileData.businessAddressLine1=addressField1.text
        profileData.businessAddressLine2=addressField2.text
        profileData.contactNumber=contactNumberField.text
        profileData.businessCountry=businessCuntryField.text
        profileData.zipcode=zipCodeFiled.text
        profileData.storeId=storeId
        profileData.websiteId=websiteId
        profileData.groupId=groupId
        profileData.userId=UserDefaults().string(forKey: "userId")
        profileData.addressArray=addressArray.mutableCopy() as! NSMutableArray
        self.setCustomattributes()
        profileData.customerAttributeArray=customerDataArray.mutableCopy() as! NSMutableArray
        return profileData;
    }
    
    func setCustomattributes() {
        let searchPredicate1 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_name")
        let searchPredicate2 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_zipcode")
        let searchPredicate3 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_registration_number")
        let searchPredicate4 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_country")
        let searchPredicate5 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_address_line_one")
        let searchPredicate6 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_address_line_two")
        let searchPredicate7 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_description")
        let searchPredicate8 = NSPredicate(format: "attribute_code CONTAINS[C] %@", "business_contact_person")
        let array1 = (customerDataArray as NSMutableArray).filtered(using: searchPredicate1)
        if (array1.count>0) {
            let dict = array1[0] as! NSDictionary
            let index=customerDataArray.index(of:dict)
            let dictionary = [
                "attribute_code" : "business_name",
                "value" : businessNameFiled?.text
            ]
            customerDataArray.replaceObject(at: index, with: dictionary)
        }
        let array2 = (customerDataArray as NSMutableArray).filtered(using: searchPredicate2)
        if (array2.count>0) {
            let dict = array2[0] as! NSDictionary
            let index=customerDataArray.index(of:dict)
            let dictionary = [
                "attribute_code" : "business_zipcode",
                "value" : zipCodeFiled?.text
            ]
            customerDataArray.replaceObject(at: index, with: dictionary)
        }
        let array3 = (customerDataArray as NSMutableArray).filtered(using: searchPredicate3)
        if (array3.count>0) {
            let dict = array3[0] as! NSDictionary
            let index=customerDataArray.index(of:dict)
            let dictionary = [
                "attribute_code" : "business_registration_number",
                "value" : businessRegistrationNumberField?.text
            ]
            customerDataArray.replaceObject(at: index, with: dictionary)
        }
        
        let array4 = (customerDataArray as NSMutableArray).filtered(using: searchPredicate4)
        if (array4.count>0) {
            let dict = array4[0] as! NSDictionary
            let index=customerDataArray.index(of:dict)
            let dictionary = [
                "attribute_code" : "business_country",
                "value" : businessCuntryField?.text
            ]
            customerDataArray.replaceObject(at: index, with: dictionary)
        }
        let array5 = (customerDataArray as NSMutableArray).filtered(using: searchPredicate5)
        if (array5.count>0) {
            let dict = array5[0] as! NSDictionary
            let index=customerDataArray.index(of:dict)
            let dictionary = [
                "attribute_code" : "business_address_line_one",
                "value" : addressField1?.text
            ]
            customerDataArray.replaceObject(at: index, with: dictionary)
        }
        let array6 = (customerDataArray as NSMutableArray).filtered(using: searchPredicate6)
        if (array6.count>0) {
            let dict = array6[0] as! NSDictionary
            let index=customerDataArray.index(of:dict)
            let dictionary = [
                "attribute_code" : "business_address_line_two",
                "value" : addressField2?.text
            ]
            customerDataArray.replaceObject(at: index, with: dictionary)
        }
        let array7 = (customerDataArray as NSMutableArray).filtered(using: searchPredicate7)
        if (array7.count>0) {
            let dict = array7[0] as! NSDictionary
            let index=customerDataArray.index(of:dict)
            let dictionary = [
                "attribute_code" : "business_description",
                "value" : businessDescriptionView?.text
            ]
            customerDataArray.replaceObject(at: index, with: dictionary)
        }
        let array8 = (customerDataArray as NSMutableArray).filtered(using: searchPredicate8)
        if (array8.count>0) {
            let dict = array8[0] as! NSDictionary
            let index=customerDataArray.index(of:dict)
            let dictionary = [
                "attribute_code" : "business_contact_person",
                "value" : contactNumberField?.text
            ]
            customerDataArray.replaceObject(at: index, with: dictionary)
        }
        let array9 = (customerDataArray as NSMutableArray).filtered(using: searchPredicate8)
        if (array9.count>0) {
            let dict = array9[0] as! NSDictionary
            let index=customerDataArray.index(of:dict)
            let dictionary = [
                "attribute_code" : "DefaultLanguage",
                "value" : languageType!
                ] as [String : Any]
            customerDataArray.replaceObject(at: index, with: dictionary)
        }
        else {
            let dictionary = [
                "attribute_code" : "DefaultLanguage",
                "value" : languageType as Any
                ] as [String : Any]
            customerDataArray.add(dictionary)
        }
    }
    
    //Save user profile
    @objc func saveUserProfile() {
        var userData = ProfileDataModel()
        userData=self.saveUserData(profileData: userData)
        ProfileDataModel().saveUserProfile(userData, success: { (response) in
            AppDelegate().stopIndicator()
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton(NSLocalizedText(key: "alertOk")) {
                self.navigationController?.popViewController(animated:true)
            }
            _ = alert.showSuccess(NSLocalizedText(key: "alertTitle"), subTitle: NSLocalizedText(key: "editProfileSuccess"), closeButtonTitle: nil)
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    
    //Edit user profile image
    @objc func editUserProfileImage() {
        let userData = ProfileDataModel()
        userData.userProfileImage=userProfileImageView.image
        ProfileDataModel().updateUserProfileImage(userData, success: { (response) in
            AppDelegate().stopIndicator()
        }) { (error) in
            if error != nil {
                if error?.code == 200 {
                    _ = error?.userInfo["error"] as! String
                }
            }
        }
    }
    //MARK: - end
    
    // MARK: - BSKeboard delegate methods
    func keyboardControls(keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
        view=(field.superview?.superview?.superview)!
    }
    
    func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls) {
        keyboardControls.activeField?.resignFirstResponder()
        editProfileScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    // MARK: - end
    
    // MARK: - Textfield delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        keyBoardControl?.activeField = textView
        if (textView.frame.origin.y + textView.frame.size.height + 200 < (kScreenHeight - 256)) {
            editProfileScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        } else {
            editProfileScrollView.setContentOffset(CGPoint(x:0, y:((textView.frame.origin.y + textView.frame.size.height + 200) - (kScreenHeight - 256))), animated: false)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        keyBoardControl?.activeField = textField
        //Scroll view with keyboard height
        if (textField.frame.origin.y + textField.frame.size.height + 200 < (kScreenHeight - 256)) {
            editProfileScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        } else {
            editProfileScrollView.setContentOffset(CGPoint(x:0, y:((textField.frame.origin.y + textField.frame.size.height + 200) - (kScreenHeight - 256))), animated: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        editProfileScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        return true
    }
    // MARK: - end
    
    // MARK: - Picker delegates
    func showPickerWithAnimation(textField:UITextField) {
        pickerView.reloadAllComponents()
        if pickerType == 1 {
            pickerView.selectRow(pickerIndex1!, inComponent: 0, animated: true)
        }
        else {
            pickerView.selectRow(pickerIndex2!, inComponent: 0, animated: true)
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        editProfileScrollView.setContentOffset(CGPoint(x:0, y:((textField.frame.origin.y + textField.frame.size.height + 200) - (kScreenHeight - 200))), animated: false)
        pickerView.backgroundColor=UIColor(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        pickerView.frame = CGRect(x: pickerView.frame.origin.x, y: kScreenHeight - (pickerView.frame.size.height + 110), width: kScreenWidth, height: 200)
        pickerToolBar.frame = CGRect(x: pickerToolBar.frame.origin.x, y: pickerView.frame.origin.y - 44, width: kScreenWidth, height: 44)
        UIView.commitAnimations()
    }
    
    func hidePickerWithAnimation() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        editProfileScrollView.setContentOffset(CGPoint(x:0, y:0), animated: false)
        pickerView.backgroundColor=UIColor(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        pickerView.frame = CGRect(x: pickerView.frame.origin.x, y: 1000, width: kScreenWidth, height: 200)
        pickerToolBar.frame = CGRect(x: pickerToolBar.frame.origin.x, y: 1000, width: kScreenWidth, height: 44)
        UIView.commitAnimations()
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerType == 1 {
            return changeLanguageArray.count
        }
        else {
            return countryPickerArray.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerType == 1 {
            return changeLanguageArray[row]
        }
        else {
            return countryPickerArray[row] as? String
        }
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerType==1 {
            pickerIndex1=row
            changeLanguageField?.text=changeLanguageArray[row]
        }
        else {
            pickerIndex2=row
            businessCuntryField?.text=countryPickerArray[row] as? String
        }
    }
    // MARK: - end
    
    //MARK: - IBActions
    @IBAction func toolBarDoneAction(_ sender: Any) {
        self.hidePickerWithAnimation()
        if pickerType==1 {
            let index = pickerView.selectedRow(inComponent: 0)
            pickerIndex1=index
            changeLanguageField?.text=changeLanguageArray[index]
            if index==0 {
                languageType=4
            }
            else if index==1 {
                languageType=5
            }
            else {
                languageType=6
            }
        }
        else {
            let index = pickerView.selectedRow(inComponent: 0)
            pickerIndex2=index
            businessCuntryField?.text=(countryPickerArray[index] as? String)
        }
    }
    
    @IBAction func toolBatCancelAction(_ sender: Any) {
        self.hidePickerWithAnimation()
    }
    
    @IBAction func changeLanguageButtonAction(_ sender: Any) {
        pickerType=1
        self.showPickerWithAnimation(textField: changeLanguageField)
    }
    
    @IBAction func changeCurrencyButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        AppDelegate().showIndicator()
        self.perform(#selector(saveUserProfile), with: nil, afterDelay: 0.1)
    }
    
    @IBAction func changeCountryAction(_ sender: Any) {
        pickerType=2
        self.showPickerWithAnimation(textField: businessCuntryField)
    }
    
    @IBAction func changeProfileImageAction(_ sender: Any) {
        self.view.endEditing(true)
        self.loadImagePicker(cameraAccess: true, galleryAccess: true, selectMessage:NSLocalizedText(key: "selectPhoto"))
    }
    // MARK: - end
    
    // MARK: - Override image picker delegates
    override func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        userProfileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        userProfileImageView.contentMode = .scaleAspectFill
        self.dismiss(animated: true, completion: nil)
        AppDelegate().showIndicator()
        self.perform(#selector(editUserProfileImage), with: nil, afterDelay: 0.1)
    }
    // MARK: - end
}
