//
//  JScaleSettingViewController.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/24.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JScaleSettingViewController: SCBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scaleNameView: UIView!
    @IBOutlet weak var blueToothLabel: UILabel!
    @IBOutlet weak var snLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var unitView: UIView!
    @IBOutlet weak var unitTipLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var howToUseView: UIView!
    @IBOutlet weak var howToUseLabel: UILabel!
    @IBOutlet var lineImageView: [UIImageView]!
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonBottomLConstraint: NSLayoutConstraint!
    
    private var presenter: JScaleSettingDelegate!
    private var device: Device!
    private var keyboardHeight: CGFloat = 0
    private var duration: Double = 0
    private var index = 0
    private var picker: AreaPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = JScaleSettingPresenter()
        setSubViewPropertyValue()
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
    
    // MARK: - Public
    
    public func setDevice(index: Int) {
        self.index = index
    }
    
    // MARK: - Private
    
    private func setSubViewPropertyValue() {
        title = ""
        titleLabel.textColor = c2
        titleLabel.font = t1
        
        textField.textColor = c2
        textField.font = t2
        
        blueToothLabel.textColor = c4
        blueToothLabel.font = t3
        snLabel.textColor = c4
        snLabel.font = t3
        
        unitView.backgroundColor = c7
        unitTipLabel.textColor = c2
        unitTipLabel.font = t3
        unitLabel.textColor = c2
        unitLabel.font = t3
        
        howToUseView.backgroundColor = c7
        howToUseLabel.textColor = c2
        howToUseLabel.font = t3
        lineImageView.forEach{$0.backgroundColor = c6}
        
        helpView.backgroundColor = c7
        helpLabel.textColor = c2
        helpLabel.font = t3
        
        deleteButton.setTitleColor(c8, for: .normal)
        deleteButton.titleLabel?.font = t3
        deleteButton.setTitle("Remove Device", for: .normal)
        deleteButton.layer.cornerRadius = 27
        deleteButton.backgroundColor = c9
        
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        saveButton.setBackground(size: CGSize(width: screenWidth, height: 50), cornerRadius: 0, addShadow: false)
        saveButton.setTitleColor(c8, for: .normal)
        saveButton.titleLabel?.font = t3
        saveButton.setTitle("Save", for: .normal)
    }
    
    private func refreshData() {
        device = presenter.getDevice(index: index)
        titleLabel.text = "Device Settings"
        textField.text = device.name
        blueToothLabel.text = "Bluetooth \(device.bluetooth?.ble_mac ?? "")"
        snLabel.text = "SN \(device.sn ?? "")"
        unitTipLabel.text = "Unit"
        unitLabel.text = "kg"
        howToUseLabel.text = "How to use"
        helpLabel.text = "Help"
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userinfo = notification.userInfo! as NSDictionary
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let keyboardRec = nsValue.cgRectValue
        let height = keyboardRec.size.height
        keyboardHeight = height
        saveButtonBottomLConstraint.constant = keyboardHeight
        UIView.animate(withDuration: duration) {
            [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func UIKeyboardWillHide(notification: Notification) {
        let userinfo = notification.userInfo! as NSDictionary
        duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        keyboardHeight = 0
        saveButtonBottomLConstraint.constant = keyboardHeight
        UIView.animate(withDuration: duration) {
            [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    // MARK: - Action
    
    @IBAction func pushToUnit(_ sender: Any) {
        picker = AreaPickerView()
        picker?.delegate = self
        let value = unitLabel.text ?? ""
        picker?.show(title: "Weight", rows: [(value == "lb") ? 0 : 1], data: [["lb", "kg"]])
    }
    
    @IBAction func pushToHowToUse(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "JHowToUseViewController") as? JHowToUseViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func pushToHelp(_ sender: Any) {
        let faq = JFAQViewController()
        self.navigationController?.pushViewController(faq, animated: true)
    }
    
    @IBAction func deleteScale(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to remove the device? The device will be removed from the Account and the weight will be deleted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true) {
            
        }
    }
    
    @objc func closeShadow() {
        textField.resignFirstResponder()
    }
    
    @IBAction func saveScaleName(_ sender: Any) {
        
    }
}

extension JScaleSettingViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        shadowView.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_icon_cancel"), style: .plain, target: self, action: #selector(closeShadow))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        shadowView.isHidden = true
        navigationItem.leftBarButtonItem = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension JScaleSettingViewController: AreaPickerViewDelegate {
    func areaPickerView(pickerView: UIPickerView, next: Bool) {
    }
    
    func areaPickerView(pickerView: UIPickerView, didSelected row: [Int]) {
        unitLabel.text = row[0] == 0 ? "lb" : "kg"
    }
    
    func areaPickerView() {
        picker?.delegate = nil
        picker = nil
    }
    
}
