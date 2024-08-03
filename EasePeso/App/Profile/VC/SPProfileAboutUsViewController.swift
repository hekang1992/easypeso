//
//  SPProfileAboutUsViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/17.
//

import UIKit
import StoreKit

class SPProfileAboutUsViewController: SPBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(str: "#0C1228")
        
        let imgBackView = UIImageView(image: UIImage(named: "sp_profie_aboutUs"))
        view.addSubview(imgBackView)
        imgBackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        let imgbottomView = UIImageView(image: UIImage(named: "sp_profile_aboutUs_item"))
        imgbottomView.isUserInteractionEnabled = true
        view.addSubview(imgbottomView)
        imgbottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imgBackView.snp.bottom).offset(20)
        }
        
        let btnRate = UIButton()
        btnRate.backgroundColor = .clear
        imgbottomView.addSubview(btnRate)
        
        let btnEmail = UIButton()
        btnEmail.backgroundColor = .clear
        imgbottomView.addSubview(btnEmail)
        btnRate.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        btnEmail.snp.makeConstraints { make in
            make.top.equalTo(btnRate.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(btnRate)
        }
        
        btnRate.rx.tap
            .asSignal()
            .emit(onNext: { _ in
                SKStoreReviewController.requestReview()
            })
            .disposed(by: rx.disposeBag)
        
        btnEmail.rx.tap
            .asSignal()
            .emit(onNext: { _ in
                if let mailUrl = URL(string: "mailto:\(SPDomainManager.share.spEmail)") {
                    if UIApplication.shared.canOpenURL(mailUrl) {
                        UIApplication.shared.open(mailUrl, options: [:]) { finish in
                            SPPrint("mail finish == \(finish)")
                        }
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        let lblVersion = UILabel()
        lblVersion.font = UIFont.puFont(size: 12)
        lblVersion.textColor = UIColor(str: "#868686")
        lblVersion.text = "v \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
        view.addSubview(lblVersion)
        lblVersion.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40 - SPKit.bottomAreaHeight)
        }
        
        
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
    }
}
