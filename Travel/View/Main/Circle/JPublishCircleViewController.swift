//
//  JPublishCircleViewController.swift
//  Travel
//
//  Created by ANKER on 2018/9/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster
import ALCameraViewController

class JPublishCircleViewController: UIViewController {

    @IBOutlet weak var actionTitleLabel: UITextField!
    @IBOutlet weak var actionSubTitleTextField: UITextField!
    @IBOutlet weak var circleDescTextView: UITextView!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locationDetailTextField: UITextField!
    @IBOutlet weak var gatherView: UIView!
    @IBOutlet weak var gatherViewHeightLCosntraint: NSLayoutConstraint!
    @IBOutlet weak var pictureViewHeightLConstraint: NSLayoutConstraint!
    
    private let service = JPublishCircleModelService()
    private var imageUrl: String?
    private var province = ""
    private var city = ""
    private var area = ""
    private var gatherCount = 1
    private var gatherList: [[String : String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        circleDescTextView.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        circleDescTextView.layer.borderWidth = 0.5
        circleDescTextView.layer.cornerRadius = 3
        circleDescTextView.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "999999")
        circleDescTextView.delegate = self
        
        pictureButton.layer.cornerRadius = 3
        pictureButton.layer.borderWidth = 0.5
        pictureButton.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "DCDCDC").cgColor
        
        let picker = CityPickerView()
        picker.tag = 0
        picker.cDelegate = self
        locationTextField.inputView = picker
        picker.initData()
        
        if let gView = Bundle.main.loadNibNamed("JGatherView", owner: nil, options: nil)?.first as? JGatherView {
            gView.translatesAutoresizingMaskIntoConstraints = false
            gatherView.addSubview(gView)
            gView.tag = 1
            gatherView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view" : gView]))
            gatherView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view(110)]", options: .directionLeadingToTrailing, metrics: nil, views: ["view" : gView]))
            
            let picker = CityPickerView()
            picker.tag = gatherCount
            picker.cDelegate = self
            gView.locationTextField.inputView = picker
            picker.initData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actionTitleLabel.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        actionTitleLabel.removeTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func pushToNextStep(_ sender: Any) {
        guard let actionTitle = actionTitleLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            Toast(text: "请填写活动标题").show()
            return
        }
        if imageUrl == nil {
            Toast(text: "请先上传活动海报").show()
            return
        }
        let introduce = circleDescTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if introduce.count == 0 {
            Toast(text: "请填写活动简介").show()
            return
        }
        guard let _ = locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  else {
            Toast(text: "请选择活动地点").show()
            return
        }
        guard let locationDetail = locationDetailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            Toast(text: "请填写活动详细地点").show()
            return
        }
        var value : [String : Any] = [:]
        value["imageUrl"] = kDEBUGUrl + (imageUrl ?? "")
        value["title"] = actionTitle
        value["subTitle"] = actionSubTitleTextField.text ?? ""
        value["description"] = locationDetail
        value["addressDetail"] = locationDetail
        value["city"] = city
        value["district"] = area
        value["province"] = province
        for i in 0..<gatherCount {
            if let gView = gatherView.viewWithTag(i + 1) as? JGatherView {
                if let location = gView.locationTextField.text, location.count > 0 {
                    let array = location.components(separatedBy: " ")
                    if array.count >= 3 {
                        let desc = gView.locationDetailTextField.text ?? ""
                        var gather : [String : String] = [:]
                        gather["province"] = array[0]
                        gather["city"] = array[1]
                        gather["district"] = array[2]
                        gather["addressDetail"] = desc
                        gatherList.append(gather)
                    }
                }
                
            }
        }
        if gatherList.count == 0 {
            Toast(text: "请填写集合地点").show()
            return
        }
        value["activityGatherList"] = gatherList
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "JPublishCircleBViewController") as? JPublishCircleBViewController {
            viewController.intent(value: value)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func addGatherView(_ sender: Any) {
        gatherCount += 1
        if let gView = Bundle.main.loadNibNamed("JGatherView", owner: nil, options: nil)?.first as? JGatherView {
            gView.translatesAutoresizingMaskIntoConstraints = false
            gatherView.addSubview(gView)
            gView.tag = gatherCount
            gatherView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view" : gView]))
            gatherView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[view(110)]", options: .directionLeadingToTrailing, metrics: ["top" : (gatherCount - 1) * 110], views: ["view" : gView]))
            
            let picker = CityPickerView()
            picker.tag = gatherCount
            picker.cDelegate = self
            gView.locationTextField.inputView = picker
            picker.initData()
        }
        gatherViewHeightLCosntraint.constant = CGFloat(gatherCount * 110)
    }
    
    
    @IBAction func uploadPicture(_ sender: Any) {
        let cropping = CroppingParameters()
        let cameraViewController = CameraViewController(croppingParameters: cropping, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: false){ [weak self] image, asset in
            // Do something with your image here.
            if image != nil {
                JHUD.show(at: self!.view)
                self?.service.uploadHeaderIcon(imageData: UIImageJPEGRepresentation(image!, 0.5)!){
                    (result, url) in
                    DispatchQueue.main.async {
                        [weak self] in
                        JHUD.hide(for: self!.view)
                        if result {
                            self?.pictureButton.setImage(image, for: .normal)
                            if let jsonStr = url, jsonStr.count > 0 {
                                if let data = jsonStr.data(using: .utf8) {
                                    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {
                                        self?.imageUrl = json?["data"] as? String
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @objc private func textFieldValueChanged(_ sender: Any) {
        if let title = actionTitleLabel.text {
            if title.count > 10 {
                let index = title.index(title.startIndex, offsetBy: 10)
                actionTitleLabel.text = String(title[..<index])
            }
        }
    }
}

extension JPublishCircleViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension JPublishCircleViewController: CityPickerViewDelegate {
    func callback(_ pickerView: CityPickerView, province: String, city: String, area: String) {
        if pickerView.tag == 0 {
            locationTextField.text = "\(province) \(city) \(area)"
            self.province = province
            self.city = city
            self.area = area
        } else {
            if let gView = gatherView.viewWithTag(pickerView.tag) as? JGatherView {
                gView.locationTextField.text = "\(province) \(city) \(area)"
            }
        }
    }
}

extension JPublishCircleViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let text = textView.text
        if text == "请填写活动简介" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text == "" {
            textView.text = "请填写活动简介"
        }
    }
}

