//
//  JCircleDetailViewController.swift
//  Travel
//
//  Created by ANKER on 2018/11/19.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit
import Toaster
import SDWebImage

class JCircleDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var circleNameLabel: UILabel!
    @IBOutlet weak var circleIDLabel: UILabel!
    @IBOutlet weak var circleDescLabel: UILabel!
    @IBOutlet weak var allPeopleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightLConstraint: NSLayoutConstraint!
    
    private let service = JCircleDetailModelService()
    private var id = ""
    private var circle: Circle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headImageView.backgroundColor = UIColor.lightGray
        JHUD.show(at: self.view)
        service.getCircleDetail(id: id) {[weak self] (result, message) in
            if self != nil {
                JHUD.hide(for: self!.view)
            }
            if result != nil {
                self?.circle = result
                self?.refreshUI()
            }
            if message != nil {
                Toast(text: message!).show()
            }
            let count = self?.circle?.circleUserList?.count ?? 0
            let line = count % 5 > 0 ? (count / 5 + 1) : (count / 5)
            self?.collectionViewHeightLConstraint.constant = CGFloat(line) * CGFloat((screenWidth - 60) / 5  + 40)
            self?.collectionView.reloadData()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "管理", style: .plain, target: self, action: #selector(manageCircle))
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func intent(id: String) {
        self.id = id
    }
    
    private func refreshUI() {
        if let url = circle?.imageUrl, url.hasPrefix("http") {
            headImageView.sd_setImage(with: URL(string: url))
        }
        circleNameLabel.text = circle?.name
        circleDescLabel.text = circle?.description
        circleIDLabel.text = "ID\(circle?.id ?? "")"
        allPeopleLabel.text = "全部成员(\(circle?.circleUserList?.count ?? 0))"
        title = circle?.name
    }
    
    @objc private func manageCircle() {
        
    }

    @IBAction func pushToAllPeople(_ sender: Any) {
        
    }
    
    @IBAction func updateCircleNick(_ sender: Any) {
        
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        
    }
    
    @IBAction func deleteAndExit(_ sender: Any) {
        
    }
    
}

extension JCircleDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return circle?.circleUserList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCell, for: indexPath) as! JPeopleCollectionViewCell
        if let user = circle?.circleUserList?[indexPath.row] {
            if let url = user.user?.icon, url.hasPrefix("http") {
                cell.headImageView.sd_setImage(with: URL(string: url))
            }
            cell.nameLabel.text = user.userName
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth - 60) / 5, height: (screenWidth - 60) / 5  + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
