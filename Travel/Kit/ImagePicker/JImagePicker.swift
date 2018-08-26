//
//  JImagePicker.swift
//  Jouz
//
//  Created by doubll on 2018/5/17.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

extension UIAlertController {
    class func makeAlert(titles: (String, String), actionClosure: ((UInt)->Void)?) -> UIAlertController {
        let alert = UIAlertController(title: "image picker", message: "where image from", preferredStyle: .actionSheet)
        let act1 = UIAlertAction.init(title: titles.0, style: .default) { (action) in
            actionClosure?(0)
        }

        let act2 = UIAlertAction.init(title: titles.1, style: .default) { (action) in
            actionClosure?(1)
        }

        let act3 = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }

        alert.addAction(act1)
        alert.addAction(act2)
        alert.addAction(act3)
        return alert
    }

}

extension JImagePicker {
    func authorizedCamera(authorizedClosure:(()->Void)?, notDeterminedClosure:(()->Void)?, deniedClosure:(()->Void)?) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            authorizedClosure?()
        } else if status == .notDetermined {
            notDeterminedClosure?()
        } else {
            deniedClosure?()
        }
    }

    func authorizedPhotoLibrary(authorizedClosure:(()->Void)?, notDeterminedClosure:(()->Void)?, deniedClosure:(()->Void)?) {
        if #available(iOS 9, *) {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized {
                authorizedClosure?()
            } else if status == .notDetermined {
                notDeterminedClosure?()
            } else {
                deniedClosure?()
            }
        }
    }
}

class JImagePicker: NSObject {
    private(set) lazy var imgPicker: UIImagePickerController? = {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            return picker
        }
        return nil
    }()

    private(set) lazy var cameraPicker: UIImagePickerController? = {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if UIImagePickerController.isCameraDeviceAvailable(.rear) && UIImagePickerController.isCameraDeviceAvailable(.front) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                picker.allowsEditing = true
                return picker
            }
        }
        return nil
    }()

    private var vc: UIViewController!
    init(on viewController: UIViewController) {
        super.init()
        vc = viewController
    }

    private var alert: UIAlertController?

    func show() {
        self.alert = UIAlertController.makeAlert(titles: ("Albumn", "Camera")) { (idx) in
            if idx == 0 {
                if let imgPkr = self.imgPicker {
                    self.authorizedPhotoLibrary(authorizedClosure: {
                        self.vc.present(imgPkr, animated: true, completion: nil)
                    }, notDeterminedClosure: {
                        // 第一次触发授权 alert
                        if #available(iOS 9, *) {
                            PHPhotoLibrary.requestAuthorization({ (status) in
                                if status == .authorized {
                                    self.vc.present(imgPkr, animated: true, completion: nil)
                                }
                            })
                        }
                    }, deniedClosure: {
                        // 未授权
                        
                    })
                }
            }
            if idx == 1 {
                if let cameraPkr = self.cameraPicker {
                    self.authorizedCamera(authorizedClosure: {
                        self.vc.present(cameraPkr, animated: true, completion: nil)
                    }, notDeterminedClosure: {
                        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (access) in
                            if access {
                                self.vc.present(cameraPkr, animated: true, completion: nil)
                            }
                        })
                    }, deniedClosure: {
                        // 未授权
                        
                    })
                }
            }
        }
        self.vc.present(alert!, animated: true, completion: nil)
    }
    var delegate: JImagePickerDelegate?
}

protocol JImagePickerDelegate {
    func pickerChoosed(_ image: UIImage) -> Void
    func pickerCancelled() -> Void
}

extension JImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage]
        self.delegate?.pickerChoosed(image as! UIImage)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
