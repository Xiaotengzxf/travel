//
//  JUseInfoViewController.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/8.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JUseInfoViewController: JLoginBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var heightButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var descLabelTopLConstraint: NSLayoutConstraint!
    @IBOutlet weak var descLabelBottomLConstraint: NSLayoutConstraint!
    
    private var presenter: JUserInfoDelegate!
    private var arrayAge : [String] = []
    private var arrayHeightFL: [[String]] = []
    private var arrayHeightCM: [[String]] = []
    private var uint = 0 // 0: ft 1: cm
    private var picker: AreaPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewPropertyValue()
        presenter = JUserInfoPresenter()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        arrayAge = JContext.instanceShared.initialAge()
        let arrayHeight = JContext.instanceShared.initailHeight()
        arrayHeightFL = arrayHeight.0
        arrayHeightCM = arrayHeight.1
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
    
    // MARK: - Private
    // 设置子视图属性值
    private func setupSubviewPropertyValue() {
        titleLabel.font = t2
        titleLabel.textColor = c2
        titleLabel.text = "Your Account"
        
        sendButton.setBackground(size: CGSize(width: screenWidth - 80, height: 54), cornerRadius: 27, addShadow: false)
        sendButton.setTitleColor(c8, for: .normal)
        sendButton.titleLabel?.font = t3
        sendButton.setTitle("Complete", for: .normal)
        
        maleLabel.textColor = c1
        maleLabel.font = t4
        femaleLabel.textColor = c3
        femaleLabel.font = t4
        maleLabel.text = "Male"
        femaleLabel.text = "Female"
        
        textField.textColor = c3
        textField.font = t4
        ageButton.setTitleColor(c3, for: .normal)
        heightButton.setTitleColor(c3, for: .normal)
        ageButton.titleLabel?.font = t6
        heightButton.titleLabel?.font = t6
        ageButton.setTitle("Choose an age", for: .normal)
        heightButton.setTitle("Choose an height", for: .normal)
        ageButton.titleLabel?.transform = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(Float(-15 * Double.pi / 180))), d: 1, tx: 0, ty: 0)
        heightButton.titleLabel?.transform = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(Float(-15 * Double.pi / 180))), d: 1, tx: 0, ty: 0)
        
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [.font: t6, .foregroundColor: c3])
        
        changeDescLabelLayoutConstraint(normal: true)
    }
    
    private func changeDescLabelLayoutConstraint(normal: Bool) {
        if normal {
            let paragraphType = NSMutableParagraphStyle()
            paragraphType.lineSpacing = 11
            descLabel.attributedText = NSAttributedString(string: "Fill in the correct information befor you can get accurate body fat data", attributes: [.font: t3, .foregroundColor: c4, .paragraphStyle: paragraphType])
            descLabelTopLConstraint.constant = 40
            descLabelBottomLConstraint.constant = 30
        } else {
            descLabel.attributedText = nil
            descLabelTopLConstraint.constant = 0
            descLabelBottomLConstraint.constant = 13
        }
    }
    
    private func convertFTtoRow(value: String) -> (Int, Int) {
        let array = value.components(separatedBy: "'")
        let FT = Int(array[0]) ?? 0
        let IN = Int(array[1].replacingOccurrences(of: "\"", with: "")) ?? 0
        return (FT - 2, IN - 1)
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
    
    // MARK: - Action
    
    @IBAction func chooseSex(_ sender: Any) {
        if let button = sender as? UIButton {
            button.isSelected = true
            if button == maleButton {
                femaleButton.isSelected = false
                femaleLabel.textColor = c3
                maleLabel.textColor = c1
            } else {
                maleButton.isSelected = false
                femaleLabel.textColor = c1
                maleLabel.textColor = c3
            }
        }
    }
    
    @IBAction func chooseAge(_ sender: Any) {
        changeDescLabelLayoutConstraint(normal: false)
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
    
    @IBAction func chooseHeight(_ sender: Any) {
        changeDescLabelLayoutConstraint(normal: false)
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
    
    @IBAction func sendUserInfo(_ sender: Any) {
        if let name = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), name.count > 0 {
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
                    presenter.addCustomer(name: name, sex: maleButton.isSelected ? "Male" : "Female", age: birthday, height: height) {[weak self] (result, message) in
                        self?.hideHUD()
                        if result {
                            let storyboard = UIStoryboard(name: "T9140", bundle: nil)
                            if let viewController = storyboard.instantiateViewController(withIdentifier: "JHomeViewController") as? JHomeViewController {
                                self?.navigationController?.pushViewController(viewController, animated: true)
                            }
                        } else {
                            if message != nil {
                                ZToast(text: message!).show()
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
            textField.text = nil
            textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [.font: t6, .foregroundColor: c9])
        }
    }
}

extension JUseInfoViewController: AreaPickerViewDelegate {
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
        default:
            print("illegal data")
        }
    }
    
    func areaPickerView() {
        changeDescLabelLayoutConstraint(normal: true)
        picker?.delegate = nil
        picker = nil
    }
    
}

extension JUseInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
