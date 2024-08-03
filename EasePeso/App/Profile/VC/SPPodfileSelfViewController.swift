//
//  SPPodfileSelfViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/3.
//  个人中心

import UIKit

class SPPodfileSelfViewController: SPBaseViewController {

    lazy var lblPhone = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.puFont(size: 18)
        if let call = SPSelfInfo.share.call {
            let start = call.index(call.startIndex, offsetBy: 3)
            let end = call.index(start, offsetBy: 3)
            let callXing = call.replacingCharacters(in: start...end, with: "****")
            lbl.text = callXing
        }
        
        return lbl
    }()
    
    /// 近两日订单的按钮  背景图会切换
    lazy var btn2Days = UIButton()
    private var twoDaysOrder = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.4)
        navigationController?.isNavigationBarHidden = true
        
        _initView()
        _getData()
    }
    
    private func _getData() {
        SPNetRequest.spRequestHandyData(showHud: view, SPProfileOrderModels.self, url: "/about_could", para: ["marryyou": "9"])
            .subscribe(onNext: { bigModel in
                if let arrModel = bigModel?.confession?.indulgent, !arrModel.isEmpty {
                    self.btn2Days.setImage(UIImage(named: "sp_podfile_2Days"), for: .normal)
                    self.twoDaysOrder = true
                }else {
                    self.btn2Days.setImage(UIImage(named: "sp_podfile_No2Days"), for: .normal)
                    self.twoDaysOrder = false
                }
            }).disposed(by: rx.disposeBag)
    }
    
    private func _initView() {
        let scBackView = UIScrollView()
        scBackView.showsVerticalScrollIndicator = false
        view.addSubview(scBackView)
        scBackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        
        let colorImg = UIImage(named: "sp_podfileMyBack")
        let colSize = colorImg?.size ?? .init(width: 1, height: 1)
        let colorCapImg = colorImg?.resizableImage(withCapInsets: UIEdgeInsets(top: colSize.height / 2.0, left: colSize.width / 2.0, bottom: colSize.height / 2.0, right: colSize.width / 2.0), resizingMode: .stretch)
        let backImgView = UIImageView(image: colorCapImg)
        backImgView.isUserInteractionEnabled = true
        scBackView.addSubview(backImgView)
        backImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPKit.topAreaHeight + 23, left: 0, bottom: 0, right: 0))
            make.width.equalTo(SPKit.width - 20)
        }
        
        let titleView = UIImageView(image: UIImage(named: "sp_podfile_centerTitle"))
        backImgView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(-23)
            make.height.equalTo(65)
        }
        
        let btnClose = UIButton()
        btnClose.setImage(UIImage(named: "sp_signinClose"), for: .normal)
        btnClose.addTarget(self, action: #selector(xiaoshi), for: .touchUpInside)
        scBackView.addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.trailing.equalTo(backImgView)
            make.top.equalTo(backImgView).offset(-7)
        }
        
        let imgPeopleView = UIImageView(image: UIImage(named: "sp_podfile_person"))
        imgPeopleView.isUserInteractionEnabled = true
        backImgView.addSubview(imgPeopleView)
        imgPeopleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom)
        }
        
        imgPeopleView.addSubview(lblPhone)
        lblPhone.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalTo(imgPeopleView.snp.centerX).offset(-20)
        }
        
        let btnUp = UIButton()
        btnUp.addTarget(self, action: #selector(unpaidAction), for: .touchUpInside)
        btnUp.setImage(UIImage(named: "sp_podfile_unpaid"), for: .normal)
        imgPeopleView.addSubview(btnUp)
        btnUp.snp.makeConstraints { make in
            make.top.equalTo(lblPhone.snp.bottom).offset(10)
            make.leading.equalTo(lblPhone).offset(-3)
        }
        
        let btnAll = UIButton()
        btnAll.addTarget(self, action: #selector(allOrderAction), for: .touchUpInside)
        btnAll.setImage(UIImage(named: "sp_podfile_allOrder"), for: .normal)
        imgPeopleView.addSubview(btnAll)
        btnAll.snp.makeConstraints { make in
            make.top.equalTo(btnUp.snp.bottom).offset(10)
            make.leading.equalTo(lblPhone).offset(-3)
        }
        
        let stView = UIStackView()
        stView.spacing = 15
        stView.axis = .vertical
        stView.distribution = .fill
        backImgView.addSubview(stView)
        stView.snp.makeConstraints { make in
            make.top.equalTo(imgPeopleView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        btn2Days.addTarget(self, action: #selector(daysOrderAction), for: .touchUpInside)
        btn2Days.setImage(UIImage(named: "sp_podfile_2Days"), for: .normal)
        stView.addArrangedSubview(btn2Days)
        let imgLineView = UIImageView(image: UIImage(named: "sp_podfile_sepLine"))
        stView.addArrangedSubview(imgLineView)
        
        let arr = [
            ["title": "Bank card", "detail": "", "tag": 10],
            ["title": "Help Center", "detail": "", "tag": 0],
            ["title": "About Us", "detail": "", "tag": 1],
            ["title": "Version Update", "detail": "V\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")", "tag": 2],
            ["title": "FAQ", "detail": "", "tag": 4],
            ["title": "Settings", "detail": "", "tag": 3]
        ]
        
        arr.forEach {
            stView.addArrangedSubview(_createItemView(dict: $0))
        }
    }
    
    @objc func xiaoshi() {
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: .spOutNoti, object: nil)
    }
    
    /// 代付款订单
    @objc func unpaidAction() {
        let vc = SPProfileOrderListViewController()
        vc.marryyou = "6"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 所有订单
    @objc func allOrderAction() {
        let vc = SPProfileOrderListViewController()
        vc.marryyou = "4"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 近两日待还订单有的时候 跳转近两日   没有的话跳转全部订单
    @objc func daysOrderAction(_ btn: UIButton) {
        if twoDaysOrder {
            unpaidAction()
        }else {
            allOrderAction()
        }
    }
    
    @objc func itemAction(_ btn: UIButton) {
        if btn.tag == 0 { /// help
            let web = SPNetViewController(SPDomainManager.share.spKefu)
            navigationController?.pushViewController(web, animated: true)
        }else if btn.tag == 1 { /// about us
            let usVc = SPProfileAboutUsViewController()
            navigationController?.pushViewController(usVc, animated: true)
        }else if btn.tag == 2 { /// update
            let hud = view.hudAnimation()
            let netVer = UserDefaults.standard.value(forKey: "spEfforts") as? String
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(1000)) {
                hud.hide(animated: true)
            }
            
            if netVer != version {
                let alterVc = UIAlertController(title: "New version found", message: "Go to update", preferredStyle: .alert)
                alterVc.addAction(UIAlertAction(title: "Update", style: .destructive, handler: { _ in
                    self.gotoUpdate()
                }))
                alterVc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    
                }))
                
                navigationController?.present(alterVc, animated: true)
            }else {
                view.errorMsg(str: "Already the latest version")
            }
        }else if btn.tag == 3 { /// setting
            let usVc = SPProfileSettingViewController()
            navigationController?.pushViewController(usVc, animated: true)
        }else if btn.tag == 4 { /// FAQ
            let usVc = SPFAQViewController()
            navigationController?.pushViewController(usVc, animated: true)
        }else if btn.tag == 10 { /// 银行卡
            let net = SPNetViewController(SPDomainManager.share.spKaHuan, ifFull: false)
            navigationController?.pushViewController(net, animated: true)
        }
    }
    
    func gotoUpdate() {
        if let upUrl = URL(string: "https://apps.apple.com/app/\(SPDomainManager.share.spAppId)") {
            UIApplication.shared.open(upUrl, options: [:], completionHandler: nil)
        }
    }
    
    private func _createItemView(dict: [String: Any])-> UIView {
        let secView = UIView()
        
        let btn = UIButton()
        btn.tag = dict["tag"] as? Int ?? 0
        btn.setBackgroundImage(UIImage(named: "sp_podfile_itemContent"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "sp_podfile_itemContent"), for: .highlighted)
        btn.addTarget(self, action: #selector(itemAction), for: .touchUpInside)
        secView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(9)
            make.bottom.equalToSuperview()
        }
        
        let lblLeft = UILabel()
        lblLeft.text = dict["title"] as? String
        lblLeft.textColor = UIColor(str: "#2B3139")
        lblLeft.font = UIFont.puFont(size: 18)
        btn.addSubview(lblLeft)
        lblLeft.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        let imgRightView = UIImageView(image: UIImage(named: "sp_base_rightJian"))
        btn.addSubview(imgRightView)
        imgRightView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        let lblDetail = UILabel()
        lblDetail.text = dict["detail"] as? String
        lblDetail.textColor = UIColor(str: "#6C6C6C")
        lblDetail.font = UIFont.puFont(size: 14)
        btn.addSubview(lblDetail)
        lblDetail.snp.makeConstraints { make in
            make.trailing.equalTo(imgRightView.snp.leading).offset(-2)
            make.centerY.equalToSuperview()
        }
        
        return secView
    }
}
