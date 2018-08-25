//
//  JMainCollectionViewCell.swift
//  EufyLife
//
//  Created by ANKER on 2018/8/9.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JMainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    weak var delegate: JMainCollectionViewCellDelegate?
    
    var array: [Device] = []
    
    public func refreshScaleData(weight: String) {
        if let cell = tableView.visibleCells.first as? JMainTableViewCell {
            cell.refreshScaleData(weight: weight)
        }
    }
    
    public func refreshConnectState(state: String) {
        if let cell = tableView.visibleCells.first as? JMainTableViewCell {
            cell.refreshData(connectStatus: state)
        }
    }
}

// MARK: - UITableViewDelegate UITableViewDataSource

extension JMainCollectionViewCell : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCell, for: indexPath) as! JMainTableViewCell
        cell.refreshData(device: array[indexPath.row])
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight - 86
    }
}

extension JMainCollectionViewCell: JMainTableViewCellDelegate {
    func tapMore(tag: Int) {
        delegate?.tapMore(column: self.tag, row: tag)
    }
    
    
}

protocol JMainCollectionViewCellDelegate: NSObjectProtocol {
    func tapMore(column: Int, row: Int)
}
