//
//  JMyPhotoViewController.swift
//  Travel
//
//  Created by 张晓飞 on 2018/9/19.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMyPhotoViewController: UIViewController {

    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let service = JMyPhotoModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        uploadButton.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "108EE9").cgColor
        uploadButton.layer.borderWidth = 0.5
        service.getMyPhoto(page: 0, keyboard: nil, criteria: nil, orderby: nil) { (result, message) in
            
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

}

extension JMyPhotoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCell, for: indexPath)
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.backgroundColor = ZColorManager.sharedInstance.colorWithHexString(hex: "F5F5F5")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
        headerView.label.text = "7月25"
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 44)
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
