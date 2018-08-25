//
//  JEditUserInfoViewController.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/23.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JEditUserInfoViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var headIconImageView: UIImageView!
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ganderView: UIView!
    @IBOutlet weak var ganderButton: UIButton!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var contentViewBottomLConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightLConstraint: NSLayoutConstraint!
    
    private var arrayAge : [String] = []
    private var arrayHeightFL: [[String]] = []
    private var arrayHeightCM: [[String]] = []
    private let arrayGander = ["Male", "Female"]
    private var uint = 0 // 0: ft 1: cm
    private var picker: AreaPickerView?
    private var presenter: JEditUserInfoDelegate!
    private var keyboardHeight: CGFloat = 0
    private var duration: Double = 0
    private var customer: Customer?
    private var row = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contentView.alpha = 0
        setupSubviewPropertyValue()
        
        arrayAge = JContext.instanceShared.initialAge()
        let arrayHeight = JContext.instanceShared.initailHeight()
        arrayHeightFL = arrayHeight.0
        arrayHeightCM = arrayHeight.1
        presenter = JEditUserInfoPresenter()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentViewBottomLConstraint.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            [weak self] in
            self?.contentView.alpha = 1
            self?.view.layoutIfNeeded()
        }) { (finished) in
            
        }
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
    
    public func intentData(customer: Customer?, row: Int) {
        self.customer = customer
        self.row = row
    }
    
    // MARK: - Private
    
    private func setupSubviewPropertyValue() {
        titleLabel.font = t2
        titleLabel.textColor = c2
        
        headView.backgroundColor = c7
        bottomView.backgroundColor = c7
        
        nameTextField.textColor = c3
        nameTextField.font = t4
        ageButton.setTitleColor(c3, for: .normal)
        heightButton.setTitleColor(c3, for: .normal)
        ganderButton.setTitleColor(c3, for: .normal)
        ageButton.titleLabel?.font = t6
        heightButton.titleLabel?.font = t6
        ganderButton.titleLabel?.font = t6
        ageButton.setTitle("Choose an age", for: .normal)
        heightButton.setTitle("Choose an height", for: .normal)
        ganderButton.setTitle("Gander", for: .normal)
        ageButton.titleLabel?.transform = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(Float(-15 * Double.pi / 180))), d: 1, tx: 0, ty: 0)
        heightButton.titleLabel?.transform = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(Float(-15 * Double.pi / 180))), d: 1, tx: 0, ty: 0)
        ganderButton.titleLabel?.transform = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(Float(-15 * Double.pi / 180))), d: 1, tx: 0, ty: 0)
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [.font: t6, .foregroundColor: c3])
        
        saveButton.setTitleColor(c1, for: .normal)
        saveButton.titleLabel?.font = t3
        saveButton.setTitle("Save", for: .normal)
        
        headLabel.textColor = c8
        headLabel.font = ZFontManager.sharedInstance.getFont(type: .bold, size: 20)
        
        if JDeviceUtil.deviceType() == .IPhone_X {
            contentViewHeightLConstraint.constant = -88
            contentViewBottomLConstraint.constant =  88 - screenHeight
        } else {
            contentViewHeightLConstraint.constant = -64
            contentViewBottomLConstraint.constant = 64 - screenHeight
        }
        
        deleteButton.setTitleColor(c8, for: .normal)
        deleteButton.titleLabel?.font = t3
        deleteButton.setTitle("Delete Member", for: .normal)
        deleteButton.layer.cornerRadius = 27
        deleteButton.backgroundColor = c9
        
    }
    
    private func refreshData() {
        titleLabel.text = customer == nil ? "Add Account" : "Edit Account"
        headImageView.image = UIImage(named: "setting_icon_adavater\(row)")
        if let name = customer?.name, name.count > 0 {
            nameTextField.text = name
            headLabel.text = String(name.first!).uppercased()
            headIconImageView.isHidden = true
        } else {
            headIconImageView.image = UIImage(named: "addaccount_icon_avatar_default")
        }
        if let sex = customer?.sex, sex.count > 0 {
            ganderButton.setTitle(sex, for: .normal)
            ganderButton.titleLabel?.transform = CGAffineTransform.identity
        }
        if let birthday = customer?.birthday {
            let age = JContext.instanceShared.convertBirthdayToAge(birthday: birthday)
            ageButton.setTitle("\(age)", for: .normal)
            ageButton.titleLabel?.transform = CGAffineTransform.identity
        }
        if let height = customer?.height {
            let ft2cm = JContext.instanceShared.convertFTorCM(value: "\(height)")
            heightButton.setTitle(ft2cm, for: .normal)
            heightButton.titleLabel?.transform = CGAffineTransform.identity
        }
        if customer == nil || row == 1 {
            deleteButton.isHidden = true
        }
    }
    
    private func convertFTtoRow(value: String) -> (Int, Int) {
        let array = value.components(separatedBy: "'")
        let FT = Int(array[0]) ?? 0
        let IN = Int(array[1].replacingOccurrences(of: "\"", with: "")) ?? 0
        return (FT - 3, IN - 1)
    }
    
    private func convertCMtoRow(value: String) -> Int {
        let cm = Int(value) ?? 0
        return cm - 100
    }
    
    private func getFTorCM(rows: [Int]) -> String {
        if rows.count > 2 {
            return "\(arrayHeightFL[0][rows[0]])\(arrayHeightFL[1][rows[1]])"
        } else {
            return "\(arrayHeightCM[0][rows[0]])"
        }
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userinfo = notification.userInfo! as NSDictionary
        let nsValue = userinfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        let keyboardRec = nsValue.cgRectValue
        let height = keyboardRec.size.height
        keyboardHeight = height
        transformBottomView(duration: duration, height: height)
    }
    
    @objc private func UIKeyboardWillHide(notification: Notification) {
        let userinfo = notification.userInfo! as NSDictionary
        duration = userinfo[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        keyboardHeight = 0
        transformBottomView(duration: duration)
    }
    
    private func transformBottomView(duration: Double, height: CGFloat) {
        var h: CGFloat = 0
        if JDeviceUtil.deviceType() == .IPhone_X {
            h = 88
        } else {
            h = 64
        }
        h = height - (screenHeight - h - heightView.frame.origin.y - 50 - 50) + 25
        if h > 0 {
            UIView.animate(withDuration: duration) {
                [weak self] in
                self?.bottomView.transform = CGAffineTransform(translationX: 0, y: -h)
            }
        }
    }
    
    private func transformBottomView(duration: Double) {
        UIView.animate(withDuration: duration) {
            [weak self] in
            self?.bottomView.transform = CGAffineTransform.identity
        }
    }
    
    private func back() {
        if JDeviceUtil.deviceType() == .IPhone_X {
            contentViewBottomLConstraint.constant =  88 - screenHeight
        } else {
            contentViewBottomLConstraint.constant = 64 - screenHeight
        }
        UIView.animate(withDuration: 0.2, animations: {
            [weak self] in
            self?.contentView.alpha = 0
            self?.view.layoutIfNeeded()
        }) {[weak self] (finished) in
            self?.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    // MARK: - Action
    
    @IBAction func backToBefore(_ sender: Any) {
        back()
    }
    
    @IBAction func saveUserInfo(_ sender: Any) {
        if let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), name.count > 0 {
            if let sex = ganderButton.titleLabel?.text, sex != "Gander" {
                if let age = Int(ageButton.titleLabel?.text ?? "0"), age > 0 {
                    if let heightString = heightButton.titleLabel?.text, heightString != "Choose an height" {
                        var height = 0
                        if uint == 0 {
                            let ft2cm = JContext.instanceShared.convertFTorCM(value: heightString)
                            height = Int(ft2cm) ?? 0
                        } else {
                            height = Int(heightString) ?? 0
                        }
                        showHUD()
                        let birthday = JContext.instanceShared.convertAgeToBirthday(age: age)
                        if customer != nil {
                            customer?.name = name
                            customer?.birthday = birthday
                            customer?.sex = sex
                            customer?.height = height
                            presenter.editCustomer(customer: customer!) {[weak self] (result, message) in
                                if result {
                                    self?.back()
                                } else {
                                    if message != nil {
                                        ZToast(text: message!).show()
                                    }
                                }
                            }
                        }else {
                            presenter.addCustomer(name: name, sex: sex, age: birthday, height: height) {[weak self] (result, message) in
                                self?.hideHUD()
                                if result {
                                    self?.back()
                                } else {
                                    if message != nil {
                                        ZToast(text: message!).show()
                                    }
                                }
                            }
                        }
                    } else {
                        heightButton.setTitleColor(c9, for: .normal)
                    }
                } else {
                    ageButton.setTitleColor(c9, for: .normal)
                }
            } else {
                ganderButton.setTitleColor(c9, for: .normal)
            }
        } else {
            nameTextField.text = nil
            nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [.font: t6, .foregroundColor: c9])
        }
    }
    
    @IBAction func selectGander(_ sender: Any) {
        nameTextField.resignFirstResponder()
        transformBottomView(duration: 0.3, height: 220)
        let text = ganderButton.titleLabel?.text
        let value = text == "Gander" ? arrayGander[0] : arrayGander[1]
        picker = AreaPickerView()
        picker?.delegate = self
        picker?.tag = 3
        picker?.show(title: "Gander", rows: [value == arrayGander[0] ? 0 : 1], data: [arrayGander])
        ganderButton.setTitleColor(c3, for: .normal)
        ganderButton.titleLabel?.transform = .identity
        if text == "Gander" {
            ganderButton.setTitle(arrayGander[0], for: .normal)
        }
    }
    
    @IBAction func selectAge(_ sender: Any) {
        nameTextField.resignFirstResponder()
        transformBottomView(duration: 0.3, height: 220)
        let text = ageButton.titleLabel?.text
        let value = text == "Choose an age" ? 25 : (Int(text ?? "0") ?? 0)
        picker = AreaPickerView()
        picker?.delegate = self
        picker?.tag = 1
        picker?.show(title: "Age", rows: [value - 13], data: [arrayAge])
        ageButton.setTitleColor(c3, for: .normal)
        ageButton.titleLabel?.transform = .identity
        if text == "Choose an age" {
            ageButton.setTitle("25", for: .normal)
        }
    }
    
    @IBAction func selectHeight(_ sender: Any) {
        nameTextField.resignFirstResponder()
        transformBottomView(duration: 0.3, height: 220)
        let text = heightButton.titleLabel?.text
        var value : [Int] = []
        if text == "Choose an height" {
            value = [2, 5, 0]
        } else {
            if uint == 0 {
                let tuple = convertFTtoRow(value: text ?? "")
                value = [tuple.0, tuple.1, 0]
            } else {
                value = [convertCMtoRow(value: text ?? ""), 1]
            }
        }
        picker = AreaPickerView()
        picker?.delegate = self
        picker?.tag = 2
        picker?.show(title: "Height", rows: value, data: uint == 0 ? arrayHeightFL : arrayHeightCM)
        heightButton.setTitleColor(c3, for: .normal)
        heightButton.titleLabel?.transform = .identity
        if text == "Choose an height" {
            heightButton.setTitle("5'6\"", for: .normal)
        }
    }
    
    @IBAction func deleteMember(_ sender: Any) {
        showHUD()
        presenter.deleteCustomer(customerId: customer?.id ?? "") {[weak self] (result, message) in
            self?.hideHUD()
            if result {
                self?.back()
            } else {
                if message != nil {
                    ZToast(text: message!).show()
                }
            }
        }
    }
}

extension JEditUserInfoViewController: AreaPickerViewDelegate {
    func areaPickerView(pickerView: UIPickerView, next: Bool) {
        
    }
    
    func areaPickerView(pickerView: UIPickerView, didSelected row: [Int]) {
        switch pickerView.tag {
        case 1:
            ageButton.setTitle(arrayAge[row[0]], for: .normal)
        case 2:
            if row.count > 2 {
                if row[2] == 1 {
                    uint = 1
                    let text = heightButton.titleLabel?.text ?? ""
                    let ft2cm = JContext.instanceShared.convertFTorCM(value: text)
                    let cm = convertCMtoRow(value: ft2cm)
                    let rows = [cm, 1]
                    picker?.show(title: "Height", rows: rows, data: arrayHeightCM, refresh: true)
                    heightButton.setTitle(ft2cm, for: .normal)
                } else {
                    uint = 0
                    heightButton.setTitle(getFTorCM(rows: row), for: .normal)
                }
            } else {
                if row[1] == 0 {
                    uint = 0
                    let text = heightButton.titleLabel?.text ?? ""
                    let ft2cm = JContext.instanceShared.convertFTorCM(value: text)
                    let cm = convertFTtoRow(value: text)
                     let rows = [cm.0, cm.1, 0]
                    picker?.show(title: "Height", rows: rows, data: arrayHeightFL, refresh: true)
                    heightButton.setTitle(ft2cm, for: .normal)
                } else {
                    uint = 1
                    heightButton.setTitle(getFTorCM(rows: row), for: .normal)
                }
            }
        case 3:
            ganderButton.setTitle(arrayGander[row[0]], for: .normal)
        default:
            print("illegal data")
        }
    }
    
    func areaPickerView() {
        transformBottomView(duration: 0.3, height: 0)
        picker?.delegate = nil
        picker = nil
    }
    
}

extension JEditUserInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = ((textField.text ?? "") + string).trimmingCharacters(in: .whitespacesAndNewlines)
        if text.count > 0 {
            headLabel.text = String(text.first!).uppercased()
            headIconImageView.isHidden = true
        } else {
            headLabel.text = nil
            headIconImageView.isHidden = false
        }
        return true
    }
}
