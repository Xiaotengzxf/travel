//
//  JPayActionViewController.swift
//  Travel
//
//  Created by ANKER on 2018/12/19.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit
import Toaster

class JPayActionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var wxImageView: UIImageView!
    @IBOutlet weak var alipayImageView: UIImageView!
    public var order: Order?
    private let service = JPayActionModelService()
    private var alipayUtils: AliPayUtils?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alipayImageView.isHidden = true
        feeLabel.text = "¥\(order?.totalFee ?? 0)"
        orderNo.text = "单号：\(order?.number ?? "")"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func wxpay(_ sender: Any) {
        wxImageView.isHidden = false
        alipayImageView.isHidden = true
    }
    
    @IBAction func alipay(_ sender: Any) {
        wxImageView.isHidden = true
        alipayImageView.isHidden = false
    }
    
    @IBAction func pay(_ sender: Any) {
        let isWX = wxImageView.isHidden == false ? true : false
        JHUD.show(at: view)
        if isWX {
            service.payWX(tradeNo: order?.number ?? "") {[weak self] (result, message) in
                if self != nil {
                    JHUD.hide(for: self!.view)
                }
                if WXApi.isWXAppInstalled() {
                    if result != nil {
                        let request = PayReq()
                        request.partnerId = result!.partnerId
                        request.prepayId =  result!.prepayId
                        request.package = result!.packageValue
                        request.nonceStr = result!.nonceStr
                        request.timeStamp = UInt32(result?.timeStamp ?? "0") ?? 0
                        request.sign = result!.sign
                        WXApi.send(request)
                    }
                } else {
                    Toast(text: "请先安装微信APP").show()
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        } else {
            service.payAli(tradeNo: order?.number ?? "") {[weak self] (result, message) in
                if self != nil {
                    JHUD.hide(for: self!.view)
                }
                if result != nil {
                    self?.alipayUtils = AliPayUtils(context: self!)
                    self?.alipayUtils?.pay(sign: result!)
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        }
    }
}
