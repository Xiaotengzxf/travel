//
//  SCMutliSelectViewController.swift
//  Jouz
//
//  Created by ANKER on 2017/12/26.
//  Copyright © 2017年 team. All rights reserved.
//

import UIKit

class SCMultiSelectViewController: SCBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rescanButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    private var presenter: JMultiSelectDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SCMultiSelectPresenter()
        setSubViewPropertyValue()
        sendScreenView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        log.info("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Public
    
    func refreshData() {
        
    }
    
    // MARK: - Private
    
    private func setSubViewPropertyValue() {
        titleLabel.font = t1
        titleLabel.textColor = c2
        
        addButton.setBackground(size: CGSize(width: screenWidth - 80, height: 54), cornerRadius: 27)
    }
    
    private func setText() {
        titleLabel.text = "cnn_select_text".localized()
        addButton.setTitle("cnn_select_connect".localized(), for: .normal)
    }
    
    @objc private func resumeConnectButton() {
        addButton.setTitle("cnn_select_connect".localized(), for: .normal)
        addButton.setImage(nil, for: .normal)
    }
    
    @IBAction func connectPeri(_ sender: Any) {
        if addButton.titleLabel?.text != "cnn_select_connect".localized() {
            return
        }
        addButton.setTitle("cnn_select_connecting".localized(), for: .normal)

       
    }
    
    @IBAction func rescanDevice(_ sender: Any) {
        
    }
}

// MARK: - UICollectionViewDataSource UICollectionViewDelegate

extension SCMultiSelectViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getDeviceListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JMultiSelectTableViewCell
        cell.refreshUI(name: presenter.getDeviceName()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SCMultiSelectViewController: SCMultiSelectViewDelegate {
    func callbackForRefreshTableView() {
        
    }
    
    func callbackForRefreshTableData(needBack: Bool) {
        if needBack {
            self.navigationController?.popViewController(animated: true)
        } else {
            refreshData()
        }
    }
    
    func callbackForRefreshButton(result: Bool?) {
        
    }
    
    func callbackForConnected() {
        self.parent?.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
}
