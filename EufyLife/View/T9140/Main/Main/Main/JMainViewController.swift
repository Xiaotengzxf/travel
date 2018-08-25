//
//  SCMainViewController.swift
//  Jouz
//
//  Created by ANKER on 2017/12/25.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit
import Localize_Swift
import Kingfisher

class JMainViewController: SCLocalizedViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addDeviceView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addDeviceButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    var presenter: JMainDelegate!
    
    private let color = ZColorManager.sharedInstance.colorWithHexString(hex: "e4e4e4")
    private var batteryLayer: CALayer!
    private var heatStickName = ""
    private var lowBatteryShown = false
    private var arrImage : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = JMainPresenter(viewDelegate: self)
        arrImage = presenter.getBackgroundImages()
        setSubViewPropertyValue()
        sendScreenView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addDeviceView.isHidden = presenter.getDeviceCount() > 0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.parent?.navigationItem.rightBarButtonItem = nil
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
        pageControl.currentPageIndicatorTintColor = c8
        pageControl.pageIndicatorTintColor = c8.withAlphaComponent(0.3)
        pageControl.isHidden = presenter.getMemberCount() <= 1
        pageControl.numberOfPages = presenter.getMemberCount()
        
        welcomeLabel.textColor = c2
        welcomeLabel.font = t1
        nameLabel.textColor = c1
        nameLabel.font = t1
        descLabel.textColor = c2
        descLabel.font = t3
        
        addDeviceButton.setTitleColor(c8, for: .normal)
        addDeviceButton.titleLabel?.font = t3
        addDeviceButton.setTitle("Add Device", for: .normal)
        addDeviceButton.setImage(UIImage(named: "homepage_icon_add"), for: .normal)
        addDeviceButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15)
        addDeviceButton.setBackground(size: CGSize(width: screenWidth - 80, height: 54), cornerRadius: 27, addShadow: false)
        
        addDeviceView.backgroundColor = c7
        
        welcomeLabel.text = "Welcome"
        nameLabel.text = "Bruce"
        descLabel.text = "Live a Smarter and Healthier lifestyle bu connecting a device to keep track of your health status"
    }
    


    // MARK: - IBAction
    @IBAction func addNewDevice(_ sender: Any) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "JBluetoothSettingViewController") as? JBluetoothSettingViewController {
            self.parent?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}

extension JMainViewController: JMainCallbackDelegate {
    func callbackScaleData(weight: String) {
        if let cell = collectionView.visibleCells.first as? JMainCollectionViewCell {
            cell.refreshScaleData(weight: weight)
        }
    }
    
    func callbackConnectState(state: String) {
        if let cell = collectionView.visibleCells.first as? JMainCollectionViewCell {
            cell.refreshConnectState(state: state)
        }
    }
}

extension JMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getMemberCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCell, for: indexPath) as! JMainCollectionViewCell
        cell.backgroundImageView.image = arrImage[indexPath.row]
        cell.array = presenter.getDeviceInfoes()
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int((scrollView.contentOffset.x + screenWidth / 2) / screenWidth)
    }
}

extension JMainViewController: JMainCollectionViewCellDelegate {
    func tapMore(column: Int, row: Int) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "JScaleSettingViewController") as? JScaleSettingViewController {
            viewController.setDevice(index: row)
            self.parent?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}

