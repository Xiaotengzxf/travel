//
//  SCWelcomeViewController.swift
//  SoundCore
//
//  Created by ANKER on 2018/5/15.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import TYAttributedLabel

class SCWelcomeViewController: SCBaseViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var descLabel: TYAttributedLabel!
    @IBOutlet weak var descLabelHeightLConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViewPropertyValue()
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
    
    // MARK: - Private
    
    private func setSubViewPropertyValue() {
        contentView.backgroundColor = c7
        setLinkLabelText()
        let size = CGSize(width: screenWidth - 40, height: 48)
        agreeButton.setBackground(size: size, cornerRadius: 14, addShadow: true)
        agreeButton.setTitle("l_s_sign_up_agree".localized(), for: .normal)
    }
    
    private func setLinkLabelText() {
        descLabel.delegate = self
        let text = NSString(string: "l_s_sign_up_policy".localized())
        let term = "p_terms_of_service".localized()
        let rangeTerm = text.range(of: term)
        let policy = "p_privacy_policy".localized()
        let rangePolicy = text.range(of: policy)
        //let dataPolicy = "p_data_policy".localized()
        //let rangeData = text.range(of: dataPolicy)
        let frontLocation = rangeTerm.location
        let frontLength = rangeTerm.length
        let midLocation = rangePolicy.location
        let midLength = rangePolicy.length
        //let lastLocation = rangeData.location
        //let lastLength = rangeData.length
        
        let prefix = NSMutableAttributedString(string: text.substring(with: NSMakeRange(0, frontLocation)))
        prefix.addAttributeTextColor(c3)
        prefix.addAttributeFont(t3)
        descLabel.appendTextAttributedString(prefix)
        
        descLabel.appendLink(withText: term, linkFont: t3, linkColor: c1, linkData: "1")
        
        let middle = NSMutableAttributedString(string: text.substring(with: NSMakeRange(frontLocation + frontLength, midLocation - frontLocation - frontLength)))
        middle.addAttributeTextColor(c3)
        middle.addAttributeFont(t3)
        descLabel.appendTextAttributedString(middle)
        
        descLabel.appendLink(withText: policy, linkFont: t3, linkColor: c1, linkData: "2")
        
        let supfix = NSMutableAttributedString(string: text.substring(with: NSMakeRange(midLocation + midLength, text.length - midLocation - midLength)))
        supfix.addAttributeTextColor(c3)
        supfix.addAttributeFont(t3)
        descLabel.appendTextAttributedString(supfix)
        
//        descLabel.appendLink(withText: dataPolicy, linkFont: t3, linkColor: c1, linkData: "3")
//
//        let last = NSMutableAttributedString(string: text.substring(with: NSMakeRange(lastLocation + lastLength, text.length - lastLocation - lastLength)))
//        last.addAttributeTextColor(c3)
//        last.addAttributeFont(t3)
//        descLabel.appendTextAttributedString(last)
        
        descLabel.backgroundColor = c7
        
    }
    
    // MARK: - Action
    
    @IBAction func agreeAndContinue(_ sender: Any) {
        if let rootController = self.storyboard?.instantiateViewController(withIdentifier: "JRootViewController") as? JRootViewController {
            UserDefaults.standard.set(true, forKey: kWelcomeKey)
            let policy = UserDefaults.standard.integer(forKey: kPolicyKey)
            if policy == 0 {
                UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: kPolicyKey)
            }
            self.navigationController?.setViewControllers([rootController], animated: false)
        }
    }
    

}

extension SCWelcomeViewController: TYAttributedLabelDelegate {
    func attributedLabel(_ attributedLabel: TYAttributedLabel!, textStorageClicked textStorage: TYTextStorageProtocol!, at point: CGPoint) {
        if let storage = textStorage as? TYLinkTextStorage {
            if let link = storage.linkData as? String {
                var country = ""
                let currentLanguage = SCLanguageManager.sharedInstance.currentLanguage() as NSString
                if currentLanguage.contains("ja") {
                    country = "jp"
                } else {
                    country = "us"
                }
                let policyVC = JTermsViewController()
                policyVC.url = link == "1" ? "https://www.jouz.com/jouz_app_terms?country=\(country)" : "https://www.jouz.com/jouz_app_policy?country=\(country)"
                let navigationController = UINavigationController(rootViewController: policyVC)
                self.present(navigationController, animated: true) {
                    
                }
            }
        }
    }
}
