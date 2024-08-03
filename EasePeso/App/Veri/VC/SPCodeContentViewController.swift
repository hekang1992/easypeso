//
//  SPCodeContentViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/2.
//  认证容器控制器

import UIKit

/// 底部的进度的高度
//let bottomStepHeight: CGFloat = 75 + SPKit.bottomAreaHeight
let bottomStepHeight: CGFloat = 75

extension Notification.Name {
    /// 这个步骤完成之后，发送通知，获取下一步认证项
    static let spCodeNext = Notification.Name("spCodeNext")
}

class SPCodeContentViewController: UIPageViewController {
    /// 产品id
    var liberal: String?
    var homeModel: SPCodeDetailModel?
    
    let lblTitle = UILabel()
    var bottomView = SPCodeBottomView(frame: .zero)
    
    deinit {
        SPPrint("销毁了\(self)")
    }
    
    private lazy var wanliuView = { createWanliuView() }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.spTheme
        
        _initView()
        if let model = homeModel {
            judgeStep(model, contentVc: self)
        }else {
            huoquData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(huoquData), name: .spCodeNext, object: nil)
    }
    
    private func _initView() {
        let imgHeight: CGFloat = 64
        let titleView = UIImageView(image: UIImage(named: "sp_navi"))
        titleView.isUserInteractionEnabled = true
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(SPKit.topAreaHeight + imgHeight)
        }
        
        lblTitle.font = UIFont.puFont(size: 20)
        lblTitle.textColor = .white
        titleView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(SPKit.topAreaHeight)
            make.height.equalTo(44)
        }
        
        let btnBack = UIButton(type: .custom)
        btnBack.addTarget(self, action: #selector(_wanliuAction), for: .touchUpInside)
        btnBack.setImage(UIImage(named: "sp_home_naviBack"), for: .normal)
        titleView.addSubview(btnBack)
        btnBack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(lblTitle)
            make.width.height.equalTo(44)
        }
        
        bottomView.backgroundColor = .cyan.withAlphaComponent(0.6)
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(bottomStepHeight)
        }
    }
    @objc func _wanliuAction() {
        view.addSubview(wanliuView)
        wanliuView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createWanliuView()-> UIView {
        let secView = UIView()
        secView.backgroundColor = .black.withAlphaComponent(0.6)
        view.addSubview(secView)
        
        let centerView = UIView()
        secView.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let topView = UIImageView(image: UIImage(named: "sp_code_wanliu"))
        centerView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        let btnCancel = UIButton()
        btnCancel.setBackgroundImage(UIImage(named: "sp_code_wanliu_fangqi"), for: .normal)
        btnCancel.setTitle("Give Up", for: .normal)
        btnCancel.titleLabel?.font = UIFont.puFont(size: 20)
        btnCancel.setTitleColor(.black, for: .normal)
        centerView.addSubview(btnCancel)
        btnCancel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(43)
            make.top.equalTo(topView.snp.bottom).offset(47)
            make.bottom.equalToSuperview()
        }
        
        let btnQueren = UIButton()
        btnQueren.setBackgroundImage(UIImage(named: "sp_code_wanliu_queding"), for: .normal)
        btnQueren.setTitle("Continue", for: .normal)
        btnQueren.titleLabel?.font = UIFont.puFont(size: 20)
        btnQueren.setTitleColor(.black, for: .normal)
        centerView.addSubview(btnQueren)
        btnQueren.snp.makeConstraints { make in
            make.leading.equalTo(btnCancel.snp.trailing).offset(17)
            make.top.bottom.equalTo(btnCancel)
        }
        
        btnCancel.rx.tap.asSignal().emit(onNext: { _ in
            secView.removeFromSuperview()
        }).disposed(by: rx.disposeBag)
        
        btnQueren.rx.tap.asSignal().emit(onNext: { [weak self] _ in
            if let self = self {
                NotificationCenter.default.removeObserver(self, name: .spCodeNext, object: nil)                
            }
            secView.removeFromSuperview()
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        return secView
    }
    
    @objc func huoquData() {
        guard let liberal = liberal else { return }
        SPPrint("huoquData huoquData huoquData")
        SPNetRequest
            .spRequestHandyData(showHud: view, SPCodeDetailModel.self, url: "/nobody_still", para: ["liberal": liberal, "price": String.suijiStr(), "economic": String.suijiStr()])
            .subscribe(onNext: { bigModel in
                let model = bigModel?.confession
                self.bottomView.detailModel = model
                self.lblTitle.text = model?.sheacknowledged?.witty
//                let strNext = model?.sheacknowledged?.throwing
                
                judgeStep(model, contentVc: self)
                
//                if strNext == .idCard {
//                    let vc = SPCodeIDViewController()
//                    vc.fatherVc = self
//                    vc.liberal = self.liberal
//                    self.setViewControllers([vc], direction: .forward, animated: true) { finish in
//                        print("finish == \(finish)")
//                    }
//                }else if strNext == .gerenxinxi {
//                    let vc = SPCodePersonalViewController()
//                    vc.type = 0
//                    vc.liberal = self.liberal
//                    self.setViewControllers([vc], direction: .forward, animated: true) { finish in
//                        print("finish == \(finish)")
//                    }
//                }else if strNext == .gongzuo {
//                    let vc = SPCodePersonalViewController()
//                    vc.type = 1
//                    vc.liberal = self.liberal
//                    self.setViewControllers([vc], direction: .forward, animated: true) { finish in
//                        print("finish == \(finish)")
//                    }
//                }else if strNext == .lianxiren {
//                    let vc = SPCodeFriendViewController()
//                    vc.liberal = self.liberal
//                    self.setViewControllers([vc], direction: .forward, animated: true) { finish in
//                        print("finish == \(finish)")
//                    }
//                }else if strNext == .yinhang {
//                    let vc = SPCodeBankViewController()
//                    vc.liberal = self.liberal
//                    self.setViewControllers([vc], direction: .forward, animated: true) { finish in
//                        print("finish == \(finish)")
//                    }
//                }else if strNext == nil {
//                    let timeBegin = Int(Date().timeIntervalSince1970 * 1000)
//                    SPNetRequest
//                        .spRequestHandyData(
//                            showHud: self.view,
//                            SPZhunruModel.self,
//                            url: "/being_identicalseemingskins",
//                            para: [
//                                "savagely": model?.otherplan?.comradely ?? "",
//                                "soonas": String.suijiStr(),
//                                "wheedling": String.suijiStr(),
//                                "unnatural": String.suijiStr(),
//                                "sounded": String.suijiStr()])
//                        .subscribe(onNext: { accBigModel in
//                            if accBigModel?.ofdiffident == 0 {
//                                let timeEnd = Int(Date().timeIntervalSince1970 * 1000)
//                                SPNetRequest.spUpTrack(molested: self.liberal ?? "", barriers: "9", swife: timeBegin, admired: timeEnd)
//                            }
//                            if let strUrl = accBigModel?.confession?.honored {
//                                let webVc = SPNetViewController(strUrl, ifFull: false)
//                                self.navigationController?.pushViewController(webVc, animated: true)
//                                
//                                DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(300)) {
//                                    var vcs = self.navigationController?.viewControllers
//                                    vcs?.removeAll(where: { $0 == self })
//                                    self.navigationController?.viewControllers = vcs ?? []
//                                }
//                            }
//                        })
//                        .disposed(by: self.rx.disposeBag)
//                }
            }).disposed(by: rx.disposeBag)
    }
}
