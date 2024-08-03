//
//  SPProfileSettingViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/17.
//

import UIKit
import Kingfisher

extension NSNotification.Name {
    static let spOutNoti = NSNotification.Name("spOutNoti")
}

class SPProfileSettingViewController: SPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnBack = UIButton(type: .custom)
        btnBack.rx.tap.asSignal().emit(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        btnBack.setImage(UIImage(named: "sp_home_naviBack"), for: .normal)
        view.addSubview(btnBack)
        btnBack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(SPKit.topAreaHeight)
            make.width.height.equalTo(44)
        }
        
        let lblTitle = UILabel()
        lblTitle.text = "Settings"
        lblTitle.font = UIFont.puFont(size: 20)
        lblTitle.textColor = .white
        view.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(btnBack)
        }
        
        _initView()
    }

    let lblMem = UILabel()
    func _initView() {
        let stView = UIStackView()
        stView.axis = .vertical
        stView.distribution = .fillEqually
        stView.spacing = 16
        view.addSubview(stView)
        stView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(SPKit.topAreaHeight + 44 + 20)
        }
        
        let btnMem = createItemView(backImg: UIImage(named: "sp_profile_settingNormalBack"), title: "Cache", mem: true, index: 0)
        let btnUse = createItemView(backImg: UIImage(named: "sp_profile_settingNormalBack"), title: "User agreement", mem: false, index: 1)
        let btnLoan = createItemView(backImg: UIImage(named: "sp_profile_settingNormalBack"), title: "Loan agreement", mem: false, index: 2)
        let btnDelete = createItemView(backImg: UIImage(named: "sp_profile_deleteAccount"), title: "Delete account", mem: false, index: 3)
        stView.addArrangedSubview(btnMem)
        stView.addArrangedSubview(btnUse)
        stView.addArrangedSubview(btnLoan)
        stView.addArrangedSubview(btnDelete)
        
        let btnOut = UIButton()
        btnOut.tag = 100 + 4
        btnOut.addTarget(self, action: #selector(itemAction), for: .touchUpInside)
        btnOut.setBackgroundImage(UIImage(named: "sp_profile_normalBig"), for: .normal)
        btnOut.setTitle("Sign out", for: .normal)
        btnOut.setTitleColor(UIColor(str: "#B1B1B1"), for: .normal)
        btnOut.titleLabel?.font = UIFont.puFont(size: 18)
        view.addSubview(btnOut)
        btnOut.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-SPKit.bottomAreaHeight - 38)
        }
    }
    
    @objc func itemAction(_ btn: UIButton) {
        let index = btn.tag - 100
        if index == 0 { /// cache
            let hud = view.hudAnimation()
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(1)) {
                hud.hide(animated: true)
                ImageCache.default.clearDiskCache {
                    self.lblMem.text = "0M"
                }
            }
        }else if index == 1 { ///  隐私
            let web = SPNetViewController(SPDomainManager.share.spUserPri, ifFull: false)
            navigationController?.pushViewController(web, animated: true)
        }else if index == 2 { /// 贷款
            let web = SPNetViewController(SPDomainManager.share.spBigPri, ifFull: false)
            navigationController?.pushViewController(web, animated: true)
        }else if index == 3 { /// 删除
            let deleteVc = SPProfileDeleteViewController()
            navigationController?.pushViewController(deleteVc, animated: true)
        }else if index == 4 { /// 退出
            SPProfileBottomShowView
                .show(topTitle: "Think it over", bottomTitle: "Confirm exit")
                .typePub
                .subscribe(onNext: { index in
                    if index == 1 {
                        self.outAccount()
                    }
                })
                .disposed(by: rx.disposeBag)
        }
    }
    
    func outAccount() {
        SPNetRequest
            .spRequestHandyData(showHud: view, SPZeroModel.self, url: "/world_stained", method: .get, para: ["theywouldn": String.suijiStr(), "sabotage": String.suijiStr()])
            .subscribe(onNext: { bigModel in
                SPSelfInfo.share.call = nil
                SPSelfInfo.share.callId = nil
                self.navigationController?.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .spOutNoti, object: nil)
            })
            .disposed(by: rx.disposeBag)
    }
    
    func createItemView(backImg: UIImage?, title: String?, mem: Bool = false, index: Int)-> UIButton {
        let btnBack = UIButton()
        btnBack.tag = 100 + index
        btnBack.setBackgroundImage(backImg, for: .normal)
        btnBack.addTarget(self, action: #selector(itemAction), for: .touchUpInside)
        
        let lblTitle = UILabel()
        lblTitle.text = title
        lblTitle.font = UIFont.puFont(size: 18)
        lblTitle.textColor = UIColor(str: "#B1B1B1")
        btnBack.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(btnBack)
        }
        
        let imgRightView = UIImageView(image: UIImage(named: "sp_base_rightJian"))
        btnBack.addSubview(imgRightView)
        imgRightView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        if mem {
            lblMem.font = UIFont.puFont(size: 14)
            lblMem.text = "0M"
            lblMem.textColor = UIColor(str: "#6C6C6C")
            btnBack.addSubview(lblMem)
            lblMem.snp.makeConstraints { make in
                make.trailing.equalTo(imgRightView.snp.leading)
                make.centerY.equalTo(btnBack)
            }
            
            ImageCache.default.calculateDiskStorageSize { resp in
                if case .success(let success) = resp {
                    let siz = floor(Double(success) / (1024.0 * 1024.0))
                    self.lblMem.text = "\(siz)M"
                }
            }
        }
        
        return btnBack
    }
}
