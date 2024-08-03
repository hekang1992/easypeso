//
//  SPProfileDeleteViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/17.
//

import UIKit

class SPProfileDeleteViewController: SPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let topView = UIView()
        topView.layer.cornerRadius = 12
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topView.backgroundColor = UIColor(str: "#C74E4C")
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        let btnBack = UIButton(type: .custom)
        btnBack.rx.tap.asSignal().emit(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        btnBack.setImage(UIImage(named: "sp_home_naviBack"), for: .normal)
        topView.addSubview(btnBack)
        btnBack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(SPKit.topAreaHeight)
            make.width.height.equalTo(44)
        }
        
        let lblTitle = UILabel()
        lblTitle.text = "Delete account"
        lblTitle.font = UIFont.puFont(size: 20)
        lblTitle.textColor = .white
        topView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(btnBack)
        }
        
        let lblDesc = UILabel()
        lblDesc.text = "Deletion of account information"
        lblDesc.font = UIFont.puFont(size: 18)
        lblDesc.textColor = UIColor(str: "#222222")
        topView.addSubview(lblDesc)
        lblDesc.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.top.equalTo(lblTitle.snp.bottom).offset(32)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        let imgContentView = UIImageView(image: UIImage(named: "sp_delete_content"))
        imgContentView.contentMode = .scaleAspectFit
        view.addSubview(imgContentView)
        imgContentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(13)
        }
        
        let btnSure = UIButton()
        btnSure.addTarget(self, action: #selector(actionSure), for: .touchUpInside)
        btnSure.setTitle("Go to Verification", for: .normal)
        btnSure.titleLabel?.font = UIFont.puFont(size: 20)
        btnSure.setTitleColor(.black, for: .normal)
        btnSure.setBackgroundImage(UIImage(named: "sp_profile_backRed"), for: .normal)
        view.addSubview(btnSure)
        btnSure.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-SPKit.bottomAreaHeight - 13)
        }
    }
    
    @objc func actionSure(_ btn: UIButton) {
        SPProfileBottomShowView
            .show(topTitle: "Reconsider", bottomImage: UIImage(named: "sp_profile_backRed"), bottomTitle: "Confirm deletion")
            .typePub
            .subscribe(onNext: { index in
                if index == 1 {
                    self.deleteAccount()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    func deleteAccount() {
        SPNetRequest
            .spRequestHandyData(showHud: view, SPZeroModel.self, url: "/island_weather", method: .get, para: ["pensions": String.suijiStr()])
            .subscribe(onNext: { bigModel in
                SPSelfInfo.share.call = nil
                SPSelfInfo.share.callId = nil
                self.navigationController?.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .spOutNoti, object: nil)
            })
            .disposed(by: rx.disposeBag)
    }
}
