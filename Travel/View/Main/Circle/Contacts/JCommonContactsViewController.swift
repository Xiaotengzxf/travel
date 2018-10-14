//
//  JCommonContactsViewController.swift
//  Travel
//
//  Created by ANKER on 2018/12/16.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit
import Toaster

class JCommonContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var tableData: [JCommonContactModel] = []
    private let service = JCommonContactModelService()
    private var type: String?
    weak var delegate: JCommonContactsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "常用联系人"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "新增", style: .plain, target: self, action: #selector(addCommonContact(_:)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: Notification.Name("JCommonContacts"), object: nil)
        
        loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadData() {
        JHUD.show(at: view)
        service.getContactList(type: type) {[weak self] (value, message) in
            if self != nil {
                JHUD.hide(for: self!.view)
            }
            if value != nil {
                self?.tableData.removeAll()
                self?.tableData = value!
                self?.tableView.reloadData()
            }
            if message != nil {
                Toast(text: message!).show()
            }
        }
    }
    
    public func intentData(type: String?) {
        self.type = type
    }
    
    @objc private func addCommonContact(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "JAddCommonContactViewController") as? JAddCommonContactViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    @objc private func handleNotification(notification: Notification) {
        loadData()
    }
}

extension JCommonContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JCommonContactTableViewCell
        cell.refreshUI(model: tableData[indexPath.row])
        cell.actionPeopleView.delegate = self
        cell.actionPeopleView.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
}

extension JCommonContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension JCommonContactsViewController: JApplyActionPeopleViewDelegate {
    func choosePeople(_ view: JApplyActionPeopleView, type: String?) {
        let row = view.tag
        delegate?.choose(type: type, model: tableData[row])
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

protocol JCommonContactsViewControllerDelegate: NSObjectProtocol {
    func choose(type: String?, model: JCommonContactModel)
}
