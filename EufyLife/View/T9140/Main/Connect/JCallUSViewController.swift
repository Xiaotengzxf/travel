//
//  JCallUSViewController.swift
//  Jouz
//
//  Created by ANKER on 2018/6/3.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JCallUSViewController: SCBaseViewController {

    private var arrayPhone : [String] = []
    private var arrayCountry : [String]  = []
    private var arrayNameAndTime : [String]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let arrayUS = "cnn_service_number_us".localized().components(separatedBy: "^^")
        let arrayJP = "cnn_service_number_jp".localized().components(separatedBy: "^^")
        if arrayUS.count == 3 && arrayJP.count == 3 {
            arrayPhone.append(arrayUS[0])
            arrayPhone.append(arrayJP[0])
            arrayCountry.append(arrayUS[1])
            arrayCountry.append(arrayJP[1])
            arrayNameAndTime.append(arrayUS[2])
            arrayNameAndTime.append(arrayJP[2])
        }
        title = "cnn_searching_call_us".localized()
        sendScreenView()
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

}

extension JCallUSViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPhone.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! JCallUSTableViewCell
        let attrString = NSMutableAttributedString(string: arrayPhone[indexPath.row], attributes: [.font: t3, .foregroundColor: c1])
        attrString.append(NSAttributedString(string: arrayCountry[indexPath.row], attributes: [.font: t3, .foregroundColor: c2]))
        cell.phoneLabel.attributedText = attrString
        cell.nameAndTimeLabel.text = arrayNameAndTime[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let phone = arrayPhone[indexPath.row]
        let regix = try? NSRegularExpression(pattern: "[^0-9]", options: .allowCommentsAndWhitespace)
        if let phoneNum = regix?.stringByReplacingMatches(in: phone, options: [], range: NSMakeRange(0, phone.count), withTemplate: "") {
            if let url = URL(string: "tel://\(phoneNum)") {
                if UIApplication.shared.canOpenURL(url) {
                    let options = [UIApplicationOpenURLOptionUniversalLinksOnly :false]
                    UIApplication.shared.open(url, options: options, completionHandler: nil)
                }
            }
            
        }
        
    }
}
