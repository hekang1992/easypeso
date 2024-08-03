//
//  SPPremissionView.swift
//  EasePeso
//
//  Created by apple on 2024/4/17.
//

import UIKit

class SPPremissionView: UIView {
    enum PremissionType {
        case location
        case camera
        case library
    }
    
    @discardableResult class func showPremission(_ type: PremissionType)-> Self {
        let preView = SPPremissionView(frame: UIScreen.main.bounds)
        preView.backgroundColor = .black.withAlphaComponent(0.8)
        SPKit.window?.addSubview(preView)
        
        let centerView = UIView()
        centerView.backgroundColor = UIColor(str: "#19427B")
        centerView.layer.cornerRadius = 16
        preView.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.center.equalToSuperview()
        }
        
        let imgTopView = UIImageView(image: UIImage(named: "sp_premission_topKey"))
        centerView.addSubview(imgTopView)
        imgTopView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(28)
        }
        
        let lblTitle = UILabel()
        lblTitle.textAlignment = .center
        lblTitle.textColor = .white
        lblTitle.font = UIFont.puFont(size: 16)
        centerView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.top.equalTo(imgTopView.snp.bottom).offset(13)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        let lblDesc = UILabel()
        lblDesc.numberOfLines = 0
        lblDesc.textColor = UIColor(str: "#B1B1B1")
        lblDesc.font = UIFont.puFont(size: 16)
        centerView.addSubview(lblDesc)
        lblDesc.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom).offset(10)
            make.leading.trailing.equalTo(lblTitle)
        }
        
        let imgContentView = UIImageView(image: UIImage(named: "sp_veri_dataItem"))
        centerView.addSubview(imgContentView)
        imgContentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(lblTitle)
            make.top.equalTo(lblDesc.snp.bottom).offset(13)
        }
        
        let imgLeftView = UIImageView()
        imgContentView.addSubview(imgLeftView)
        imgLeftView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        let lblContentDetail = UILabel()
        lblContentDetail.textColor = UIColor(str: "#B1B1B1")
        lblContentDetail.font = .systemFont(ofSize: 14, weight: .semibold)
        imgContentView.addSubview(lblContentDetail)
        lblContentDetail.snp.makeConstraints { make in
            make.leading.equalTo(imgLeftView.snp.trailing).offset(11)
            make.centerY.equalToSuperview()
        }
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor(str: "#103059")
        bottomView.layer.cornerRadius = 16
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        centerView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
            make.top.equalTo(imgContentView.snp.bottom).offset(30)
            make.bottom.equalToSuperview().offset(-2)
        }
        
        let btnIgnore = UIButton()
        btnIgnore.setBackgroundImage(UIImage(named: "sp_code_blueBack"), for: .normal)
        btnIgnore.titleLabel?.font = UIFont.puFont(size: 20)
        btnIgnore.setTitle("Ignore", for: .normal)
        btnIgnore.setTitleColor(.black, for: .normal)
        bottomView.addSubview(btnIgnore)
        btnIgnore.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.top.equalToSuperview().offset(18)
        }
        
        let btnSetting = UIButton()
        btnSetting.setBackgroundImage(UIImage(named: "sp_code_id_commit_enable"), for: .normal)
        btnSetting.titleLabel?.font = UIFont.puFont(size: 20)
        btnSetting.setTitle("Go to settings", for: .normal)
        btnSetting.setTitleColor(.black, for: .normal)
        bottomView.addSubview(btnSetting)
        btnSetting.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(btnIgnore)
            make.top.equalTo(btnIgnore.snp.bottom).offset(14)
            make.bottom.equalToSuperview().offset(-21)
        }
        
        btnIgnore.rx.tap
            .asSignal()
            .emit(onNext: { [weak preView] _ in
                preView?.removeFromSuperview()
            }).disposed(by: preView.rx.disposeBag)
        
        btnSetting.rx.tap
            .asSignal()
            .emit(onNext: { [weak preView] _ in
                preView?.removeFromSuperview()
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }).disposed(by: preView.rx.disposeBag)
        
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 8
        para.alignment = .center
        switch type {
        case .location:
            lblTitle.text = "Request location permission"
            lblDesc.attributedText = NSAttributedString(string: "If location permission is not granted, your loan application will not be approved.", attributes: [.paragraphStyle: para])
            lblContentDetail.text = "Location authorization required"
            imgLeftView.image = UIImage(named: "sp_premiss_locationLeft")
        case .camera:
            lblTitle.text = "Request camera permission"
            lblDesc.attributedText = NSAttributedString(string: "So that you can take photos and record videos", attributes: [.paragraphStyle: para])
            lblContentDetail.text = "Camera authorization required"
            imgLeftView.image = UIImage(named: "sp_premiss_cameraLeft")
        case .library:
            lblTitle.text = "Request gallery access"
            lblDesc.attributedText = NSAttributedString(string: "This way, you can upload local images", attributes: [.paragraphStyle: para])
            lblContentDetail.text = "Gallery access required"
            imgLeftView.image = UIImage(named: "sp_premiss_libraryLeft")
        }
        
        return preView as! Self
    }
}
