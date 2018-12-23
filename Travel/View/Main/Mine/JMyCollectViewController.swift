//
//  JMyCollectViewController.swift
//  Travel
//
//  Created by 张晓飞 on 2018/9/20.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster
import SDWebImage

class JMyCollectViewController: UIViewController {

    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBttuon: UIButton!
    @IBOutlet weak var tableViewBottomLConstraint: NSLayoutConstraint!
    
    private let service = JMyCollectionModelService()
    private var id = ""
    private var arrayData : [Activity] = []
    private var array: [ActivityB] = []
    private var deleteArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteBttuon.isHidden = true
        deleteBttuon.layer.borderColor = ZColorManager.sharedInstance.colorWithHexString(hex: "108EE9").cgColor
        deleteBttuon.layer.borderWidth = 1
        
        reloadData()
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
    
    public func intent(id: String) {
        self.id = id
    }

    private func reloadData() {
        if id.count > 0 {
            title = "活动"
            JHUD.show(at: self.view)
            service.getActivity(id: id) {[weak self] (result, message) in
                if self != nil {
                    JHUD.hide(for: self!.view)
                }
                if result != nil {
                    self?.arrayData.removeAll()
                    self?.arrayData = result!
                    self?.tableView.reloadData()
                }
                if message != nil {
                    Toast(text: message!).show()
                }
                
            }
        } else {
            JHUD.show(at: self.view)
            service.getFavorite(page: 0, keyboard: nil, criteria: nil, orderby: nil) {[weak self] (result, message) in
                if self != nil {
                    JHUD.hide(for: self!.view)
                }
                if result != nil {
                    self?.array.removeAll()
                    self?.array = result!
                    self?.tableView.reloadData()
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        }
    }
    
    @IBAction func editCollection(_ sender: Any) {
        if editBarButtonItem.title == "编辑" {
            editBarButtonItem.title = "完成"
            deleteBttuon.isHidden = false
            tableViewBottomLConstraint.constant = -50
        } else {
            editBarButtonItem.title = "编辑"
            deleteBttuon.isHidden = true
            tableViewBottomLConstraint.constant = 0
        }
        
        tableView.reloadData()
    }
    
    @IBAction func deleteCollection(_ sender: Any) {
        if deleteArray.count > 0 {
            JHUD.show(at: view)
            var orderId : [String] = []
            for i in 0..<deleteArray.count {
                orderId.append(array[deleteArray[i]].id ?? "")
            }
            service.deleteFavorite(orderId: orderId) {[weak self] (result, message) in
                if self != nil {
                    JHUD.hide(for: self!.view)
                }
                if result {
                    self?.deleteArray.removeAll()
                    self?.editCollection(self!.deleteBttuon)
                    self?.reloadData()
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        }
    }
}

extension JMyCollectViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if id.count > 0 {
            return arrayData.count
        } else {
            return array.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JMyCollectTableViewCell
        cell.showLeftView(value: editBarButtonItem.title == "完成")
        var activity : Activity?
        if id.count > 0 {
            activity = arrayData[indexPath.row]
        } else {
            activity = array[indexPath.row].activity
        }
        if let url = activity?.imageUrl, url.hasPrefix("http") {
            cell.iconImageView.sd_setImage(with: URL(string: url))
        } else {
            cell.iconImageView.image = nil
        }
        cell.titleLabel.text = "【周四】\(activity?.city ?? "").\(activity?.district ?? "").\(activity?.title ?? "")"
        cell.addressLabel.text = "\(activity?.city ?? "") \(activity?.district ?? "")"
        cell.priceLabel.text = "¥\(activity?.fee ?? 0)"
        cell.timeLabel.text = activity?.startTime
        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "JActionDetailViewController") as? JActionDetailViewController {
            var activity : Activity?
            if id.count > 0 {
                activity = arrayData[indexPath.row]
            } else {
                activity = array[indexPath.row].activity
            }
            viewController.intent(value: activity?.id ?? "")
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension JMyCollectViewController: JMyCollectTableViewCellDelegate {
    func select(tag: Int, value: Bool) {
        if value {
            deleteArray.append(tag)
        } else {
            for (index, item) in deleteArray.enumerated() {
                if item == tag {
                    deleteArray.remove(at: index)
                    break
                }
            }
        }
    }
}
