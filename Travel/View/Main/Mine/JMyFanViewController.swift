//
//  JMyFanViewController.swift
//  Travel
//
//  Created by 张晓飞 on 2018/9/20.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import Toaster

class JMyFanViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let service = JFocusModelService()
    private var array: [Fan] = []
    private var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if flag == 0 {
            service.getFocus(page: 0, keyboard: "", criteria: "", orderby: "") {[weak self] (array, message) in
                if array != nil {
                    self?.array = array!
                    self?.tableView.reloadData()
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        } else {
            service.getFan(page: 0, keyboard: "", criteria: "", orderby: "") {[weak self] (array, message) in
                if array != nil {
                    self?.array = array!
                    self?.tableView.reloadData()
                }
                if message != nil {
                    Toast(text: message!).show()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func intent(flag: Int) {
        self.flag = flag
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

extension JMyFanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JMyFanTableViewCell
        cell.lineImageView.isHidden = indexPath.row == 1
        let fan = array[indexPath.row]
        if let url = fan.user?.icon, url.count > 0 {
            cell.iconImageView.sd_setImage(with: URL(string: url)!)
        } else {
            cell.iconImageView.image = nil
        }
        cell.nameLabel.text = fan.user?.userName
        cell.signLabel.text = fan.user?.introduce
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let fan = array[indexPath.row]
        if let chatId = fan.user?.chatId, chatId.count > 0 {
            let controller = EaseMessageViewController(conversationChatter: chatId, conversationType: EMConversationTypeChat)
            controller?.title = fan.user?.userName
            controller?.serverId = fan.userId
            self.navigationController?.pushViewController(controller!, animated: true)
        }
        
    }
}
