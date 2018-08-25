//
//  SCBluetoothOFFViewController.swift
//  Jouz
//
//  Created by ANKER on 2017/12/21.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit
import Localize_Swift

class JBluetoothSettingViewController: SCBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var connectLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var bottomWaterWaveView: UIView!
    @IBOutlet weak var bottomWaveView: UIView!
    @IBOutlet weak var bottomWaterWaveViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomWaveViewWidthConstraint: NSLayoutConstraint!
    
    var waterRippleView1: UIView!
    var waterRippleView2: UIView!
    var waterRippleView3: UIView!
    var moveView: UIView?
    
    private let waterWaveWidth : CGFloat = 180 * scale
    private let wavePreWidth : CGFloat = 105 * scale
    private let waterRippleView1PreWidth : CGFloat = 180 * scale
    private let waterRippleView2PreWidth : CGFloat = 263 * scale
    private let waterRippleView3PreWidth : CGFloat = 391 * scale
    private let waveWidth : CGFloat = 260 * scale
    private var waterRippleView1Width : CGFloat = 456 * scale
    private var waterRippleView2Width : CGFloat = 672 * scale
    private var waterRippleView3Width : CGFloat = 874 * scale
    private let waveSufWidth : CGFloat = 292 * scale
    private let waterRippleView1SufWidth : CGFloat = 512 * scale
    private let waterRippleView2SufWidth : CGFloat = 767 * scale
    private let waterRippleView3SufWidth : CGFloat = 924 * scale
    var waterWaveTimer: Timer?
    
    //var searchView: SCSearchView?
    var presenter : JBluetoothSettingPresenterDelegate?
    private var retrySearchViewController: JRetrySearchViewController?
    var temScanCount = 0 // 记录扫描次数
    private var bViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViewPropertyValue()
        presenter = JBluetoothSettingPresenter(delegate: self)
        
        sendScreenView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bViewShowing = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        descLabel.text = "cnn_searching_press_turn_on".localized()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bViewShowing = false
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        log.info("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // MARK: - Public
    
    // MARK: - Private
    
    // 设置子视图相关属性值
    private func setSubViewPropertyValue() {
        titleLabel.textColor = c2
        titleLabel.font = t1
        titleLabel.text = "Descover your scale"
        
        descLabel.textColor = c2
        descLabel.font = t3
        
        addWaterRipple()
        bottomWaveWaterViewAnimation()
        bottomWaterWaveViewWidthConstraint.constant = waterWaveWidth
        bottomWaveViewWidthConstraint.constant = waterWaveWidth
        
        bottomWaterWaveView.backgroundColor = UIColor.clear
        bottomWaveView.backgroundColor = UIColor.clear
        bottomWaveView.insertGradientLayer(size: CGSize(width: waterWaveWidth, height: waterWaveWidth), isHaveShadow: false, cornerRadius: waterWaveWidth / 2)
        
        connectLabel.text = "Searching..."
        connectLabel.textColor = c8
        connectLabel.font = t3
    }
    
    // 调整至重试界面
    private func pushToRetrySearchViewController(bRetry: Bool, bShowCall: Bool = true) {
        if let retrySearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "JRetrySearchViewController") as? JRetrySearchViewController {
            retrySearchViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(retrySearchViewController.view)
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": retrySearchViewController.view]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": retrySearchViewController.view]))
            self.addChildViewController(retrySearchViewController)
            self.retrySearchViewController = retrySearchViewController
            self.retrySearchViewController?.delegate = self
        }
    }
    
    private func addWaterRipple() {
        
        waterRippleView1Width = 232 * scale
        waterRippleView2Width = 310 * scale
        waterRippleView3Width = 410 * scale
        
        waterRippleView1 = UIView(frame: CGRect(x: -(waterRippleView1Width - waterWaveWidth) / 2, y: -(waterRippleView1Width - waterWaveWidth) / 2, width: waterRippleView1Width, height: waterRippleView1Width))
        waterRippleView1?.layer.cornerRadius = CGFloat(waterRippleView1Width / 2)
        waterRippleView1?.insertGradientLayer(size: (waterRippleView1?.bounds.size)!, isHaveShadow: false, cornerRadius: waterRippleView1!.bounds.size.height / 2)
        
        waterRippleView2 = UIView(frame: CGRect(x: -(waterRippleView2Width - waterWaveWidth) / 2, y: -(waterRippleView2Width - waterWaveWidth) / 2, width: waterRippleView2Width, height: waterRippleView2Width))
        waterRippleView2?.layer.cornerRadius = CGFloat(waterRippleView2Width / 2)
        waterRippleView2?.insertGradientLayer(size: (waterRippleView2?.bounds.size)!, isHaveShadow: false, cornerRadius: waterRippleView2!.bounds.size.height / 2)
        
        waterRippleView3 = UIView(frame: CGRect(x: -(waterRippleView3Width - waterWaveWidth) / 2, y: -(waterRippleView3Width - waterWaveWidth) / 2, width: waterRippleView3Width, height: waterRippleView3Width))
        waterRippleView3?.layer.cornerRadius = CGFloat(waterRippleView3Width / 2)
        waterRippleView3?.insertGradientLayer(size: (waterRippleView3?.bounds.size)!, isHaveShadow: false, cornerRadius: waterRippleView3!.bounds.size.height / 2)
        
        bottomWaterWaveView.insertSubview(waterRippleView1!, belowSubview: bottomWaveView)
        bottomWaterWaveView.insertSubview(waterRippleView2!, belowSubview: waterRippleView1!)
        bottomWaterWaveView.insertSubview(waterRippleView3!, belowSubview: waterRippleView2!)
    
        waterRippleView1.alpha = 0
        waterRippleView2.alpha = 0
        waterRippleView3.alpha = 0
    }
    
    @objc private func bottomWaveWaterViewAnimation() {
        bottomWaterWaveView.isHidden = false
        connectLabel.isHidden = false
        bottomWaveView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        waterRippleView1?.transform = CGAffineTransform(scaleX: 1.2, y:  1.2)
        waterRippleView2?.transform = CGAffineTransform(scaleX:  1.2, y:  1.2)
        waterRippleView3?.transform = CGAffineTransform(scaleX:  1.2, y: 1.2)
        UIView.animate(withDuration: 1, animations: {
            [weak self] in
            self?.bottomWaveView.layer.opacity = 0.5
            self?.waterRippleView1.layer.opacity = 0.3
            self?.waterRippleView2.layer.opacity = 0.2
            self?.waterRippleView3.layer.opacity = 0.1
            self?.bottomWaveView?.transform = CGAffineTransform.identity
            self?.waterRippleView1?.transform = CGAffineTransform.identity
            self?.waterRippleView2?.transform = CGAffineTransform.identity
            self?.waterRippleView3?.transform = CGAffineTransform.identity
        }) {[weak self] (finished) in
            self?.bottomWaveWaterViewAnimationOther(isZoom: false)
        }
    }
    
    private func bottomWaveWaterViewAnimationOther(isZoom: Bool) {
        UIView.animate(withDuration: isZoom ? 0.8 : 1.2, animations: {
            [weak self] in
            self?.waterRippleView1?.transform = CGAffineTransform(scaleX: isZoom ? 1 : 1.2, y:  isZoom ? 1 : 1.2)
            self?.waterRippleView2?.transform = CGAffineTransform(scaleX: isZoom ? 1 : 1.2, y:  isZoom ? 1 : 1.2)
            self?.waterRippleView3?.transform = CGAffineTransform(scaleX: isZoom ? 1 : 1.2, y:  isZoom ? 1 : 1.2)
        }) {[weak self] (finished) in
            if self?.bViewShowing ?? false {
                self?.bottomWaveWaterViewAnimationOther(isZoom: !isZoom)
            }
        }
    }
    
    private func pushToHome() {
        if let array = self.navigationController?.viewControllers {
            for viewController in array {
                if viewController is JHomeViewController {
                    self.navigationController?.popToViewController(viewController, animated: true)
                    return
                }
            }
        }
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "JHomeViewController") as? JHomeViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - IBAction
    @IBAction func pushToMenu(_ sender: Any) {
       
    }
    
    @IBAction func pushToBluetoothSetting(_ sender: Any) {
        self.pustToSystemBluetoothSetting()
    }
    
    private func pustToSystemBluetoothSetting() {
        let url = NSURL(string: "App-Prefs:root=Bluetooth") // General&path=Bluetooth
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: { (finished) in
                
            })
        }
    }
    
    // MARK: - Handle Notification
    
    @objc func handleNotification(notification: Notification) {
//        let bluetoothOpen = presenter?.getBluetoothState() ?? false
//        if let top =  UIApplication.topViewController(), top == self {
//            if bluetoothOpen && (presenter?.isBLEScaning() ?? false) && retrySearchViewController == nil {
//                presenter?.startScanDevice()
//            }
//        }
    }
}

extension JBluetoothSettingViewController: JBluetoothSettingViewDelegate {
    
    // 处理蓝牙是否开启
    func showBluetoothPowerOff(isOn: Bool) {
        
    }
    
    // 处理连接结果
    func callbackForConnectFailThreeTime() {
        pushToRetrySearchViewController(bRetry: false)
    }
    
    func handleCanCommand(_ isValue: Bool) {
        if isValue {
            pushToHome()
        } else {
            if presenter?.getBluetoothState() ?? false {
                presenter?.startScanDevice()
            } else if (presenter?.getBluetoothState() ?? false) {
                showBluetoothPowerOff(isOn: true)
            } else {
                showBluetoothPowerOff(isOn: false)
            }
            self.navigationController?.popToViewController(self, animated: true)
        }
    }
    
    /// 回调结束扫描设备
    ///
    /// - Parameter bResult: 是否有扫描到设备
    func callbackFinishedToScanDevice(_ bResult: Bool) {
        if bResult {
            if self.navigationController?.topViewController == self {
                if bViewShowing {
                    return
                }
                bViewShowing = true
                self.performSegue(withIdentifier: "MultiSelectViewController", sender: self)
            }
        }else{
            if self.navigationController?.topViewController == self {
                temScanCount += 1
                if temScanCount >= 3 {
                    pushToRetrySearchViewController(bRetry: true)
                    return
                }
                pushToRetrySearchViewController(bRetry: true, bShowCall: false)
            }
        }
    }
    
    /// 回调蓝牙扫描
    func callbackBlueToothScan(bWait: Bool) {
        DispatchQueue.main.async {
            [weak self] in
            if UIApplication.shared.applicationState != .background  {
                self?.presenter?.startScanDevice()
            }
        }
    }
    
    /// 回调握手
    func callbackForHandShakeFail() {
        if self.navigationController?.topViewController is JBluetoothSettingViewController {
            // TODO: 握手失败
            presenter?.disconnectToConnectedDevice()
        }
    }
    
    func callbackGetDeviceInfo(result: Bool?) {
        if result == true {
            // TODO: -主页面
            pushToHome()
        } else {
            if self.navigationController?.topViewController is JBluetoothSettingViewController {
                // TODO: 获取设备信息失败
                presenter?.disconnectToConnectedDevice()
            }
        }
    }
}

extension JBluetoothSettingViewController: JRetrySearchViewControllerDelegate {
    func callbackForRemoveSelf() {
        retrySearchViewController?.view.removeFromSuperview()
        retrySearchViewController?.removeFromParentViewController()
        retrySearchViewController = nil
    }
    
    
}
