//
//  SCBaseWebViewController.swift
//  Jouz
//
//  Created by SeanGao on 2018/1/11.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit
import WebKit

class SCBaseWebViewController: SCLocalizedViewController {

    var webView: WKWebView?
    var progressView: UIProgressView?
    var strUrl: String?
    let estimatedProgressKeyPath = "estimatedProgress"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onLoad()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        onLoad()
    }

    func onLoad() {
        self.webView = WKWebView(frame: CGRect.zero)
        self.progressView = UIProgressView(frame: CGRect.zero)
    }
    deinit {
        webView?.removeObserver(self, forKeyPath: estimatedProgressKeyPath)
        log.info("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWKwebView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == estimatedProgressKeyPath {
            let progress: Float = Float((webView?.estimatedProgress)!)
            progressView?.setProgress(progress * 2, animated: true)
            progressView?.isHidden = (progress > 0.55)
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - private
    // MARK: - Set webview
    
    func setUpWKwebView() {
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(userScript)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        
        view.addSubview(progressView!)
        view.addSubview(webView!)
        
        progressView?.translatesAutoresizingMaskIntoConstraints = false
        let progressHeight = NSLayoutConstraint(item: progressView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2)
        let progressWidth = NSLayoutConstraint(item: progressView!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        view.addConstraints([progressHeight, progressWidth])
        view.addConstraint(NSLayoutConstraint(item: progressView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        if #available(iOS 11.0, *) {
            view.addConstraint(NSLayoutConstraint(item: progressView!, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
        } else {
            view.addConstraint(NSLayoutConstraint(item: progressView!, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        }
        
        progressView?.setProgress(0.15, animated: true) // 进度条预先显示 0.15进度 提示用户正在加载中
        
        webView?.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: webView!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView!, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: webView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        if #available(iOS 11.0, *) {
            view.addConstraint(NSLayoutConstraint(item: webView!, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
        } else {
            view.addConstraint(NSLayoutConstraint(item: webView!, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        }
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.isOpaque = false
        webView?.backgroundColor = UIColor.clear
        webView?.scrollView.backgroundColor = UIColor.clear
        webView?.addObserver(self, forKeyPath: estimatedProgressKeyPath, options: .new, context: nil)
        
    }
    
    func loadUrl(url: String, header: [String: String]? = nil) {
        let myURL = URL(string: url)
        var myRequest = URLRequest(url: myURL!)
        if header?.count ?? 0 > 0 {
            for h in header! {
                myRequest.addValue(h.value, forHTTPHeaderField: h.key)
            }
        }
        webView?.load(myRequest)
    }

}

extension SCBaseWebViewController: WKNavigationDelegate, WKUIDelegate {
    // MARK: - WKUIDelegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let err = error as NSError
        if err.code == kErrorNetworkOffline {
            ZToast(text: "common_check_network".localized()).show()
        }
    }
}
