//
//  JMyPhotoViewController.swift
//  Travel
//
//  Created by 张晓飞 on 2018/9/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster

class JMyPhotoViewController: UIViewController {

    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let service = JMyPhotoModelService()
    private var keys : [String] = []
    private var list: [[MyPhotoModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        uploadButton.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "108EE9").cgColor
        uploadButton.layer.borderWidth = 0.5
        NotificationCenter.default.addObserver(self, selector: #selector(handle(notification:)), name: Notification.Name("Photo"), object: nil)
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func refreshData() {
        JHUD.show(at: view)
        service.getMyPhoto() {[weak self] (result, message) in
            if self != nil {
                JHUD.hide(for: self!.view)
            }
            if message != nil {
                Toast(text: message!).show()
            }
            if result != nil {
                self?.keys = result!.0
                self?.list = result!.1
                self?.collectionView.reloadData()
            }
        }
    }

    @IBAction func uploadPhotos(_ sender: Any) {
        let picker = TZImagePickerController(maxImagesCount: 3, delegate: self)
        picker?.allowPickingVideo = false
        self.present(picker!, animated: true) {
            
        }
    }
    
    @objc private func handle(notification: Notification) {
        refreshData()
    }
}

extension JMyPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCell, for: indexPath)
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.backgroundColor = ZColorManager.sharedInstance.colorWithHexString(hex: "F5F5F5")
            let item = list[indexPath.section]
            let value = item[indexPath.row]
            if let url = value.imageUrl, url.hasPrefix("http") {
                imageView.kf.setImage(with: URL(string: url))
            } else {
                imageView.image = nil
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "JMyPhotoDetailViewController") as? JMyPhotoDetailViewController {
            viewController.model = list[indexPath.section][indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 55) / 3, height: (screenWidth - 55) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 11, bottom: 0, right: 11)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! HeaderView
        if list.count > indexPath.section {
            headerView.label.text = keys[indexPath.section]
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 44)
    }
}

extension JMyPhotoViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        if photos.count > 0 {
            let count = photos.count
            var tem = 0
            for photo in photos {
                if let data = UIImageJPEGRepresentation(photo, 0.2) {
                    service.uploadHeaderIcon(imageData: data) {[weak self] (result, message) in
                        if message != nil {
                            self?.service.uploadMyPhoto(url: "http://120.79.28.173:8080/travel" + message!, callback: { (result, message) in
                                tem += 1
                                if count == tem {
                                    DispatchQueue.main.async {
                                        [weak self] in
                                        self?.refreshData()
                                    }
                                }
                            })
                        } else {
                            tem += 1
                        }
                    }
                }
            }
        }
    }
}

class HeaderView: UICollectionReusableView {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: CGRect(x: 11, y: 0, width: screenWidth - 22, height: 44))
        label.textColor = ZColorManager.sharedInstance.colorWithHexString(hex: "666666")
        label.font = UIFont.systemFont(ofSize: 15)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
