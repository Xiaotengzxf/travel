//
//  AreaPickerView.swift
//  GeneralBear
//
//  Created by YAMYEE on 2018/6/4.
//  Copyright © 2018年 YAMYEE. All rights reserved.
//

import UIKit

protocol AreaPickerViewDelegate: NSObjectProtocol {
    func areaPickerView(pickerView:UIPickerView, didSelected row: [Int])
    func areaPickerView(pickerView:UIPickerView, next: Bool)
    func areaPickerView()
}

class AreaPickerView: UIView {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var prefixButton: UIButton!
    @IBOutlet weak var supfixButton: UIButton!
    @IBOutlet weak var sureButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isAreaShow = true
    var isSaveHistory = true
    var delegate:AreaPickerViewDelegate?
    var oldRows: [Int] = []
    var pickerData : [[String]] = []
    
    //MARK:setup
    private func setup() {
        let view = Bundle.main.loadNibNamed("AreaPicker", owner: self, options: nil)?.first as! UIView
        view.frame = self.frame
        addSubview(view)

        sureButton.setTitle("Done", for: .normal)
        sureButton.setTitleColor(c1, for: .normal)
        sureButton.titleLabel?.font = t3
        
        titleLabel.textColor = c2
        titleLabel.font = t3
    }
    
    private func eventBinding() {
        backView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onCancleButtonClick))
        backView.addGestureRecognizer(tap)
    }
    //MARK:data
    private func initData(rows: [Int]) {
        for (index, row) in rows.enumerated() {
            pickerView.selectRow(row, inComponent: index, animated: false)
        }
        pickerView.tag = tag
    }
    

    //MARK:event respond
    
    @objc private func onCancleButtonClick() {
        delegate?.areaPickerView(pickerView: pickerView, didSelected: oldRows)
        delegate?.areaPickerView()
        dismiss()
    }

    @IBAction func onPrefixButtonClick(_ sender: Any){
        if let button = sender as? UIButton {
            delegate?.areaPickerView(pickerView: pickerView, next: button == supfixButton)
        }
    }
    
    @IBAction func onSureButtonClick(_ sender: Any){
        delegate?.areaPickerView()
        dismiss()
    }

    private func showAnimate(){
        if let view = UIApplication.shared.keyWindow{
            view.addSubview(self)
            self.boxView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 220)
            self.backView.alpha = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.boxView.frame = CGRect(x: 0, y: screenHeight-220, width: screenWidth, height: 220)
                self.backView.alpha = 0.4
            })
        }
    }
    func  dismiss(){
        UIView.animate(withDuration: 0.3, animations: {
            
            self.boxView.frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 220)
            self.backView.alpha = 0
        }) { (_) in
            
            self.removeFromSuperview()
        }
    }
    
    //MARK:public
    func show(title: String, rows: [Int], data: [[String]], refresh: Bool = false) {
        titleLabel.text = title
        oldRows = rows
        pickerData = data
        if refresh {
            pickerView.reloadAllComponents()
        } else {
            showAnimate()
        }
        initData(rows: rows)
    }

    init() {
        super.init(frame: UIScreen.main.bounds)
        setup()
        eventBinding()
    }
    override private init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        eventBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension AreaPickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = t2
            pickerLabel?.textAlignment = .center
            pickerLabel?.textColor = c2
        }
        pickerLabel?.text = pickerData[component][row]
        return pickerLabel!
    }
}

extension AreaPickerView: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return screenWidth / CGFloat(max(pickerData.count, 1))
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        oldRows[component] = row
        delegate?.areaPickerView(pickerView: pickerView, didSelected: oldRows)
    }
}

