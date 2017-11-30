//
//  GlobalBackViewController.swift
//  GoPurpose
//
//  Created by Ranosys-Mac on 10/11/17.
//  Copyright © 2017 Ranosys-Mac. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class GlobalBackViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    //MARK: - IBOutlets
    var controller: BottomTabViewController = BottomTabViewController()
    
    open var isCameraAccess: Bool = true
    open var isGalleryAccess: Bool = true
    open var imageCropRect: CGSize = CGSize(width: 1.0, height: 1.0)
    
    private let appName = "GoPurpose"
    private let cameraNotAvailable = "Device has no camera."
    private var imageSelectionMessage = "Choose Photo"
    private let takePhoto = "Take Photo"
    private let selectFromGallery = "Select From Gallery"
    private let settings = "Settings"
    private let cancel = "Cancel"
    private let ok = "OK"
    private let cameraPermissionAlertTitle = kCameraPermission
    private let cameraPermissionAlertMessage = kCameraUsageMessage
    private let photoLibraryPermissionAlertTitle = kGalleryPermission
    private let photoLibraryPermissionAlertMessage = kGalleryUsageMessage
    var userImage = UIImage()
    var imagePickerController: UIImagePickerController?
    
    //MARK: - end
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.isNavigationBarHidden = false
        self.addNavigationBottomImage()
        self.addBottomTab()
        self.addBackButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        controller.willMove(toParentViewController: self)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    //MARK: - end
    
    //MARK: - Custom methods to add navigation image, bottom tab and menu button
    func addNavigationBottomImage()  {
        let bottomImage = UIImageView(frame: CGRect(x:self.view.frame.origin.x, y:UIScreen.main.bounds.origin.y-1, width:kScreenWidth, height:7))
        bottomImage.contentMode=UIViewContentMode.scaleAspectFit
        bottomImage.image=UIImage(named:"color-strip")
        self.view.addSubview(bottomImage)
    }
    
    func addBottomTab() {
        controller = BottomTabViewController(nibName: "BottomTabViewController", bundle: nil)
        self.addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints=true
        controller.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height-129, width: self.view.frame.size.width, height: 65);
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    func addBackButton() {
        let backBtn = UIButton(type: .custom)
        backBtn.addTarget(self, action:#selector(backButtonAction(sender:)), for: .touchUpInside)
        backBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backBtn.setImage(UIImage(named: "back"), for: .normal)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backBtnItem
    }
    
    func showSelectedTab(item: Int) {
        controller.showSelectedTab(item: item)
    }
    
    @objc func backButtonAction(sender: UIButton) {
        //pop view
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - end
    
    //MARK: - Load image picker
    open func loadImagePicker(cameraAccess: Bool = true, galleryAccess: Bool = true, selectMessage:String) {
        isCameraAccess = cameraAccess
        isGalleryAccess = galleryAccess
        imageSelectionMessage = selectMessage
        guard isCameraAccess == false && isGalleryAccess == false else {
            setupView()
            return
        }
    }
    //MARK: - end
    
    // MARK: Image picker methods
    open func setupView() {
        
        // Show picker if both modes selected
        // If either 1 of image picker type is enabled, direct open image picker with type
        if isCameraAccess && isGalleryAccess {
            let imageSelectionAlert = UIAlertController.init(title: imageSelectionMessage, message: nil, preferredStyle: .actionSheet)
            let takePhotoAction = UIAlertAction.init(title: takePhoto, style: .default, handler: { (action: UIAlertAction) in
                self.checkForPermissions(type: .camera)
            })
            
            let selectFromGalleryAction = UIAlertAction.init(title: selectFromGallery, style: .default, handler: { (action: UIAlertAction) in
                self.checkForPermissions(type: .photoLibrary)
            })
            
            let cancelAction = UIAlertAction.init(title: cancel, style: .destructive, handler: nil)
            imageSelectionAlert.addAction(takePhotoAction)
            imageSelectionAlert.addAction(selectFromGalleryAction)
            imageSelectionAlert.addAction(cancelAction)
            self.present(imageSelectionAlert, animated: true, completion: nil)
            
        } else {
            self.checkForPermissions(type: isCameraAccess ? .camera : .photoLibrary)
        }
    }
    
    func checkForPermissions(type: UIImagePickerControllerSourceType) {
        if type == .camera {
            checkCameraPermissons()
        } else if type == .photoLibrary {
            callPhotoLibrary()
        }
    }
    
    func openImagePickerWith(type: UIImagePickerControllerSourceType) {
        if imagePickerController == nil {
            imagePickerController = UIImagePickerController()
            imagePickerController?.delegate = self
        }
        imagePickerController?.allowsEditing = true
        imagePickerController?.sourceType = type
        self.present(imagePickerController!, animated: true, completion: nil)
    }
    
    // Image picker delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        userImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true)
    }
    // *****
    // Check camera permissions
    // *****
    open func checkCameraPermissons() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            callCamera()
        } else {
            SCLAlertView().showWarning(NSLocalizedText(key: "alertTitle"), subTitle:cameraNotAvailable, closeButtonTitle: NSLocalizedText(key: "alertOk"))
        }
    }
    
    fileprivate func callCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            openImagePickerWith(type: .camera)
        case .denied:
            alertForCameraAccess()
        case .notDetermined:
            alertForAllowCameraAccessViaSetting()
        default:
            alertForCameraAccess()
        }
    }
    
    fileprivate func alertForCameraAccess() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton(settings) {
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url as URL)
            }
        }
        _ = alert.showSuccess(cameraPermissionAlertTitle, subTitle: cameraPermissionAlertMessage, closeButtonTitle: nil)
        
    }
    
    fileprivate func alertForAllowCameraAccessViaSetting() {
        if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                DispatchQueue.main.async() {
                    self.callCamera()
                }
            }
        }
    }
    
    // *****
    // Check photo library
    // *****
    fileprivate func callPhotoLibrary() {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .authorized:
            openImagePickerWith(type: .photoLibrary)
        case .denied:
            alertForPhotoLibraryAccess()
        case .notDetermined:
            alertForAllowPhotoLibraryAccessViaSettings()
        default:
            alertForPhotoLibraryAccess()
        }
    }
    
    fileprivate func alertForPhotoLibraryAccess() {
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton(settings) {
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url as URL)
            }
        }
        _ = alert.showSuccess(photoLibraryPermissionAlertTitle, subTitle: photoLibraryPermissionAlertMessage, closeButtonTitle: nil)
    }
    
    fileprivate func alertForAllowPhotoLibraryAccessViaSettings() {
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.callPhotoLibrary()
            }
        }
    }
    // MARK: end
}
