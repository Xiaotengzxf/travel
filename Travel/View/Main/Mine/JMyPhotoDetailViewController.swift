//
//  JMyPhotoDetailViewController.swift
//  Travel
//
//  Created by ANKER on 2018/12/23.
//  Copyright © 2018 team. All rights reserved.
//

import UIKit
import Toaster

class JMyPhotoDetailViewController: UIViewController ,UIScrollViewDelegate {
    
    var scrollView:UIScrollView?
    var lastImageView:UIImageView?
    var originalFrame:CGRect!
    var isDoubleTap:ObjCBool!
    var model : MyPhotoModel!
    //使用sb拖控件显示图片
    @IBOutlet weak var myImageView: UIImageView!
    private let service = JMyPhotoDetailModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showZoomImageView(tap:)))
        self.myImageView.addGestureRecognizer(tap)
        myImageView.kf.setImage(with: URL(string: model.imageUrl ?? ""))
    }
    
    @objc func showZoomImageView( tap : UITapGestureRecognizer) {
        let bgView = UIScrollView(frame: UIScreen.main.bounds)
        bgView.backgroundColor = UIColor.black
        let tapBg = UITapGestureRecognizer(target: self, action: #selector(tapBgView(tapBgRecognizer:)))
        bgView.addGestureRecognizer(tapBg)
        let picView = tap.view as! UIImageView//view 强制转换uiimageView
        let imageView = UIImageView.init()
        imageView.image = picView.image;
        imageView.frame = bgView.convert(picView.frame, from: self.view)
        bgView.addSubview(imageView)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        self.lastImageView = imageView
        self.originalFrame = imageView.frame
        self.scrollView = bgView
        self.scrollView?.maximumZoomScale = 1.5
        self.scrollView?.delegate = self
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: UIViewAnimationOptions.beginFromCurrentState,
            animations: {
                var frame = imageView.frame
                frame.size.width = bgView.frame.size.width
                frame.size.height = frame.size.width * ((imageView.image?.size.height)! / (imageView.image?.size.width)!)
                frame.origin.x = 0
                frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5
                imageView.frame = frame
        }, completion: nil
        )
        
    }
    
    @objc func tapBgView(tapBgRecognizer: UITapGestureRecognizer)
    {
        self.scrollView?.contentOffset = CGPoint.zero
        UIView.animate(withDuration: 0.5, animations: {
            self.lastImageView?.frame = self.originalFrame
            tapBgRecognizer.view?.backgroundColor = UIColor.clear
        }) { (finished:Bool) in
            tapBgRecognizer.view?.removeFromSuperview()
            self.scrollView = nil
            self.lastImageView = nil
        }
    }
    
    //正确代理回调方法
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.lastImageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deletePhoto(_ sender: Any) {
        JHUD.show(at: view)
        service.deleteMyPhoto(photoId: model.id ?? "") {[weak self] (result, message) in
            if self != nil {
                JHUD.hide(for: self!.view)
            }
            if message != nil {
                Toast(text: message!).show()
            }
            if result {
                NotificationCenter.default.post(name: Notification.Name("Photo"), object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
