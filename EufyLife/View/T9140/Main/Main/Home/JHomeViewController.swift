//
//  JHomeViewController.swift
//  Jouz
//
//  Created by ANKER on 2018/5/30.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JHomeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewWidthLConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    private var arrViewController : [UIViewController] = []
    private var presenter: JHomeDelegate!
    private var rView: UIView!
    private var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        presenter = JHomePresenter()
        setSubViewPropertyValue()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(notification:)), name: kJHomeViewController, object: nil)
        sendScreenView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        log.info("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    // MARK: - Public
    
    // MARK: - Private
    
    private func setSubViewPropertyValue() {
        title = ""
        createTitleLabel()
        contentViewWidthLConstraint.constant = 2 * screenWidth
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "JSideMenuViewController") as! JSideMenuViewController
        let main = self.storyboard?.instantiateViewController(withIdentifier: "JMainViewController") as! JMainViewController
        arrViewController.append(menu)
        arrViewController.append(main)
        
        contentViewHeightConstraint.constant = screenHeight
        for (index, viewController) in arrViewController.enumerated() {
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(viewController.view)
            self.addChildViewController(viewController)
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|\(index != 0 ? "-(leading)-" : "")[view(width)]\(index == arrViewController.count - 1 ? "|" : "")", options: .directionLeadingToTrailing, metrics: index == 0 ? ["width" : screenWidth] : ["width" : screenWidth, "leading" : (CGFloat(index) * screenWidth)], views: ["view" : viewController.view]))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view(height)]", options: .directionLeadingToTrailing, metrics:["height" : screenHeight], views: ["view" : viewController.view]))
        }
        scrollView.contentSize = CGSize(width: CGFloat(arrViewController.count) * screenWidth, height: screenHeight)
        scrollView.contentOffset.x = screenWidth
    }
    
    private func createLeftBarButtonItem() -> UIBarButtonItem {
        let imageName = presenter.getMemberCount() > 0 ? "homepage_icon_menu_white" : "homepage_icon_menu"
        return UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: self, action: #selector(pushToMenu))
    }
    
    private func createRightBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "common_icon_back2"), style: .plain, target: self, action: #selector(scrollToBack))
    }
    
    private func createTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textColor = c8
        titleLabel.font = t2
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        navigationItem.titleView = titleLabel
    }
    
    // MARK: - Action

    @objc func pushToMenu() {
        scrollView.contentOffset.x = 0
    }
    
    @objc func scrollToBack() {
        scrollView.contentOffset.x = screenWidth
    }
    
    @objc private func handleNotification(notification: Notification) {
       
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

//MARK: - scrollView delegate

extension JHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x + screenWidth / 2) / screenWidth)
        let nullBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = page == 1 ? createLeftBarButtonItem() : nullBarButtonItem
        navigationItem.rightBarButtonItem = page == 0 ? createRightBarButtonItem() : nullBarButtonItem
        titleLabel.text = page == 1 ? "Charles" : "Settings"
        titleLabel.textColor = page == 1 ? c8 : c2
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
}
