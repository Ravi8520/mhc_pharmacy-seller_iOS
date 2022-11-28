//
//  ImagePicker.swift
//  My Pharmacy
//
//  Created by Jat42 on 17/09/21.
//  Copyright © 2021 iOS Dev. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class MediaPicker: NSObject,
                   UIImagePickerControllerDelegate,
                   UIDocumentPickerDelegate,
                   UINavigationControllerDelegate {
    
    static let shared = MediaPicker()
    
    var delegate: MediaPickerDelegate?
    
    func chooseOptionForMediaType(delegate: MediaPickerDelegate, isAllowedPdf: Bool = false) {
        
        self.delegate = delegate
        
        var actionController: UIAlertController?
        
        //var alertController = UIAlertController (title: nil, message: "Select Option", preferredStyle: .actionSheet)
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            actionController = UIAlertController (title: nil, message: Strings.selectOption, preferredStyle: .alert)
        } else {
            actionController = UIAlertController (title: nil, message: Strings.selectOption, preferredStyle: .actionSheet)
        }
        
        let cameraAction = UIAlertAction(title: Strings.cameraOption, style: .default) { [self] _ in
            self.requestCameraAuthorisation()
        }
        
        let photosAction = UIAlertAction(title: Strings.galleryOption, style: .default) { _ in
            self.chooseFromPhotos()
        }
        
        let documentAction = UIAlertAction(title: Strings.pdfOption, style: .default) { _ in
            self.chooseFromDocuments()
        }
        
        let cancelAction = UIAlertAction(title: Strings.cancelOption, style: .cancel)
        
        actionController?.addAction(cameraAction)
        actionController?.addAction(photosAction)
        if isAllowedPdf {
            actionController?.addAction(documentAction)
        }
        actionController?.addAction(cancelAction)
        
        AppConfig.sceneDelegate?.window?.rootViewController?.present(actionController!, animated: true, completion: nil)
        
    }
    
    private func requestCameraAuthorisation() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
            case .authorized:
                
                chooseFromCamera()
                
            case  .denied:
                
                DispatchQueue.main.async { [self] in
                    openCemeraSettings()
                }
                
            case .notDetermined:
                
                AVCaptureDevice.requestAccess(for: .video) { [self] granted in
                    
                    if granted {
                        DispatchQueue.main.async { [self] in
                            chooseFromCamera()
                        }
                    } else {
                        Log.e("Access not granted")
                    }
                }
                
            case .restricted:
                Log.e("Access is restricted...")
                
            @unknown default:
                break
        }
    }
    
    private func openCemeraSettings() {
        
        AlertHelper.shared.showConfirmAlert(
            title: Strings.alertTitle,
            message: Strings.cameraPermission,
            yesActionTitle: Strings.okConfirmation,
            noActionTitle: Strings.cancelOption,
            yesActionStyle: .default,
            noActionStyle: .cancel
        ) { yesAction in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
            
        } NoAction: { noAction in }
        
    }
    
    private func chooseFromCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .camera
            AppConfig.sceneDelegate?.window?.rootViewController?.present(imagePickerController, animated: true)
            
        } else {
            
            DispatchQueue.main.async {
                AlertHelper.shared.showAlert(message: Strings.sourceTypeNotAvailabel)
            }
            
        }
    }
    
    private func chooseFromPhotos() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            AppConfig.sceneDelegate?.window?.rootViewController?.present(imagePickerController, animated: true)
            
        } else {
            AlertHelper.shared.showAlert(message: Strings.sourceTypeNotAvailabel)
        }
    }
    
    private func chooseFromDocuments() {
        let types: [String] = [kUTTypePDF as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .open)
        documentPicker.modalPresentationStyle = .formSheet
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = self
        AppConfig.sceneDelegate?.window?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    // Image Picker delegates
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided following: \(info)")
        }
        
        let cropperViewController = CropperViewController.instantiate()
        cropperViewController.image = image
        cropperViewController.delegate = delegate
        picker.pushViewController(cropperViewController, animated: true)
        
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Document Picker delegates
    
    internal func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let myURL = urls.first else {
            return
        }
        
        guard myURL.startAccessingSecurityScopedResource() else {
            return
        }
        
        let mediaData =  MediaData(
            image: nil,
            imageData: nil,
            pdfData: try? Data(contentsOf: myURL),
            fileType: .pdf
        )
        
        myURL.stopAccessingSecurityScopedResource()
        
        Log.m("Pdf url : \(myURL)")
        
        delegate?.mediaPicked(media: mediaData)
        
    }
    
    internal func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

