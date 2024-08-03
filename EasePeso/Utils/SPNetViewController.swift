//
//  SPNetViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/1.
//

import UIKit
import WebKit
import StoreKit

import RxSwift
import MBProgressHUD

class SPNetViewController: SPBaseViewController {
    let topHeight: CGFloat = SPKit.topAreaHeight + 56
    private lazy var netView = {
        let config = WKWebViewConfiguration()
        self.addMethod(to: config)
        var top = topHeight
        if ifFull {
            top = 0
        }
        let net = WKWebView(frame: CGRect(x: 0, y: top, width: SPKit.width, height: SPKit.height - top), configuration: config)
        net.scrollView.contentInsetAdjustmentBehavior = .never
        net.navigationDelegate = self
        
        return net
    }()
    
    lazy var style1Image = {
        let img = UIImage(named: "sp_net_top1")
        let imgSize = img?.size ?? .init(width: 1, height: 1)
        let imgCap = img?.resizableImage(withCapInsets: UIEdgeInsets(top: 2, left: imgSize.width / 2.0, bottom: imgSize.height - 2, right: imgSize.width / 2.0), resizingMode: .stretch)
        
        return img
    }()
    
    lazy var style2Image = {
        let img = UIImage(named: "sp_net_top2")
        let imgSize = img?.size ?? .init(width: 1, height: 1)
        let imgCap = img?.resizableImage(withCapInsets: UIEdgeInsets(top: 2, left: imgSize.width / 2.0, bottom: imgSize.height - 2, right: imgSize.width / 2.0), resizingMode: .stretch)
        
        return img
    }()
    
    private lazy var naviView = {
        let v = UIImageView()
        v.image = style1Image
//        v.image = UIImage(named: "sp_net_top2")
        v.isUserInteractionEnabled = true
        
        return v
    }()
    
    private lazy var btnBack = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "sp_home_naviBack"), for: .normal)
        
        return btn
    }()
    
    private lazy var lblTitle = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.puFont(size: 16)
        
        return lbl
    }()
    
    var hud: MBProgressHUD!
    private var timeBegin: Int = 0
    private let requestUrl: String
    private let ifFull: Bool
    required init(_ requestUrl: String, ifFull: Bool = true) {
        self.requestUrl = requestUrl
        self.ifFull = ifFull
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(str: "#3F7774")
        
        timeBegin = Int(Date().timeIntervalSince1970 * 1000)
        view.addSubview(netView)
        
        let addUrl = SPNetRequest.addPara(to: requestUrl)
        guard let checkUrl = addUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        if let url = URL(string: checkUrl) {
            netView.load(URLRequest(url: url))
        }
        
        addObs()
        
        if ifFull {
            view.addSubview(lblTitle)
            lblTitle.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(SPKit.topAreaHeight)
                make.centerX.equalToSuperview()
                make.height.equalTo(44)
            }
            
            btnBack.addTarget(self, action: #selector(popAction), for: .touchUpInside)
            view.addSubview(btnBack)
            btnBack.snp.makeConstraints { make in
                make.leading.equalToSuperview()
//                make.top.equalToSuperview().offset(SPKit.topAreaHeight)
                make.centerY.equalTo(lblTitle)
                make.width.height.equalTo(44)
            }
        }else {
            view.addSubview(naviView)
            naviView.snp.makeConstraints { make in
                make.leading.trailing.top.equalToSuperview()
                make.height.equalTo(topHeight)
            }
            
            naviView.addSubview(lblTitle)
            lblTitle.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(SPKit.topAreaHeight)
                make.centerX.equalToSuperview()
                if SPKit.topAreaHeight > 20 {
                    make.height.equalTo(44)
                }else {
                    make.height.equalTo(56)
                }
            }
            
            btnBack.addTarget(self, action: #selector(popAction), for: .touchUpInside)
            naviView.addSubview(btnBack)
            btnBack.snp.makeConstraints { make in
                make.leading.equalToSuperview()
//                make.top.equalToSuperview().offset(SPKit.topAreaHeight)
                make.centerY.equalTo(lblTitle)
                make.width.height.equalTo(44)
            }
        }
    }
    
    // MARK: - 事件
    @objc func popAction() {
        if self.netView.canGoBack {
            self.netView.goBack()
        }else {
            guard let _ = self.navigationController?.popViewController(animated: true) else {
                self.dismiss(animated: true)
                return
            }
        }
    }
    
    private func addMethod(to config: WKWebViewConfiguration) {
        config.userContentController.add(self, name: "beforeLaugh")
        config.userContentController.add(self, name: "tyingFather")
        config.userContentController.add(self, name: "friendTaller")
        config.userContentController.add(self, name: "fuzzyWalked")
        config.userContentController.add(self, name: "longerAllowedto")
        config.userContentController.add(self, name: "criedSuspicions")
        config.userContentController.add(self, name: "happenedIroning")
        config.userContentController.add(self, name: "faultCould")
        // setNavType([type]) type: 1借款那种头部 type2另一种头部
        config.userContentController.add(self, name: "setNavType")
        /// jumpToEmail([title, order_id])   jumpToEmail([email,title, order_id])
        config.userContentController.add(self, name: "jumpToEmail")
    }
    
    func addObs() {
        netView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        netView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }

    required init?(coder: NSCoder) {
        requestUrl = ""
        self.ifFull = true
        super.init(coder: coder)
    }
}

extension SPNetViewController: WKScriptMessageHandler, WKNavigationDelegate{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let js = message.name
        if js == "beforeLaugh" { //风控埋点
            guard let arrData = message.body as? [Any], 
                    let idNum = arrData.first as? String else {
                return
            }
            let timeEnd = Int(Date().timeIntervalSince1970 * 1000)
            SPNetRequest.spUpTrack(molested: idNum, barriers: "10", swife: timeBegin, admired: timeEnd)
        }else if js == "tyingFather" { // 跳转
            guard let arrData = message.body as? [Any],
                    let strUrl = arrData.first as? String else {
                return
            }
            judge(strUrl, from: self)
        }else if js == "friendTaller" { // 关闭
            self.popAction()
        }else if js == "fuzzyWalked" { // 首页
            navigationController?.popToRootViewController(animated: true)
        }else if js == "longerAllowedto" { // 拨打电话
            guard let arrData = message.body as? [Any], let phone = arrData.first as? String else {
                return
            }
            if let urlPhone = URL(string: "tel://\(phone)") {
                if UIApplication.shared.canOpenURL(urlPhone) {
                    UIApplication.shared.open(urlPhone)
                }
            }
        }else if js == "criedSuspicions" { // 是否隐藏头部导航栏  isScree1是 0否
            guard let arrData = message.body as? [Any] else {
                return
            }
            if let isScree = arrData.first as? Int {
                if isScree == 1 {
                    naviView.isHidden = true
                }else {
                    naviView.isHidden = false
                }
            }else if let isScree = arrData.first as? String {
                if isScree == "1" {
                    naviView.isHidden = true
                }else {
                    naviView.isHidden = false
                }
            }
        }else if js == "happenedIroning" { // 头部导航栏颜色和字体 txtColor字体颜色  navColor导航栏颜色 如果参数是空走默认
            guard let arrData = message.body as? [Any] else {
                return
            }
            if arrData.count >= 2 {
                if let backColor = arrData[1] as? String {
                    naviView.backgroundColor = UIColor(str: backColor)
                }
                if let backColor = arrData[0] as? String {
                    lblTitle.textColor = UIColor(str: backColor)
                }
            }else if arrData.count == 1 {
                if let backColor = arrData[0] as? String {
                    lblTitle.textColor = UIColor(str: backColor)
                }
            }
        }else if js == "faultCould" { // 调用 App 应用评分
            SKStoreReviewController.requestReview()
        }else if js == "setNavType" { // setNavType([type]) type: 1借款那种头部 type: 2另一种头部
            guard let arrData = message.body as? [Any] else {
                return
            }
            if let naviType = arrData.first as? Int {
                if naviType == 1 {
                    naviView.image = style1Image
                }else if naviType == 2 {
                    naviView.image = style2Image
                }
            }else if let naviType = arrData.first as? String {
                if naviType == "1" {
                    naviView.image = style1Image
                }else if naviType == "2" {
                    naviView.image = style2Image
                }
            }
        }else if js == "jumpToEmail" {
            guard let arrData = message.body as? [Any] else {
                return
            }
            let email = arrData.first as? String ?? SPDomainManager.share.spEmail
            let subject = arrData[1] as? String ?? ""
            let orderId = arrData.last as? String ?? ""
            
            let strSubject = "?subject=\(subject)"
            var strBody = "&body=EasePeso Account: \(SPSelfInfo.share.call ?? "")"
            if !orderId.isEmpty {
                strBody += ", orderId: \(orderId)"
            }
            
            let mailUrl = "mailto:\(email)" + strSubject + strBody
            guard let checkMailUrl = mailUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            
            if let url = URL(string: checkMailUrl) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let requestUrl = navigationAction.request.url {
            if requestUrl.scheme == "whatsapp" {
                if UIApplication.shared.canOpenURL(requestUrl) {
                    UIApplication.shared.open(requestUrl)
                }
                decisionHandler(.cancel)
                return
            }else if requestUrl.scheme == "mailto" {
                let mailUrl = requestUrl.absoluteString + "?subject=Contact Us" + "&body=EasePeso Account: \(SPSelfInfo.share.call ?? "")"
                guard let checkMailUrl = mailUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
                
                if let url = URL(string: checkMailUrl) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
                
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
        
//        if let requestUrl = navigationAction.request.url {
//            if requestUrl.scheme == "whatsapp" || requestUrl.scheme == "mailto" {
//                if UIApplication.shared.canOpenURL(requestUrl) {
//                    UIApplication.shared.open(requestUrl)
//                }
//                
//                decisionHandler(.cancel)
//                return
//            }
//        }
//        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        hud = view.hudAnimation()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        view.dismissHud()
        hud.hide(animated: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
//        view.dismissHud()
        hud.hide(animated: true)
    }
}

extension SPNetViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            let value = change?[NSKeyValueChangeKey.newKey] as? String
            lblTitle.text = value
        }else if keyPath == "estimatedProgress" {
            let gress = change?[NSKeyValueChangeKey.newKey] as? Float ?? 0.1
//            lineView.setProgress(gress, animated: true)
            if gress == 1 {
//                hud.hide(animated: true)
            }
        }
    }
}
