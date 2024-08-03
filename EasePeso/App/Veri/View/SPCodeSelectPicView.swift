//
//  SPCodeSelectPicView.swift
//  EasePeso
//
//  Created by apple on 2024/4/3.
//  选择照片底部弹窗

import UIKit
import RxSwift

class SPCodeSelectPicView: UIView {
    /// 0: 相机  1：相册
    let typePub = PublishSubject<Int>()
    
    @discardableResult
    static func show()-> SPCodeSelectPicView {
        let selfView = SPCodeSelectPicView(frame: UIScreen.main.bounds)
        SPKit.window?.addSubview(selfView)
        
        let backView = UIView(frame: CGRect(x: 0, y: SPKit.height, width: SPKit.width, height: 260 + SPKit.bottomAreaHeight))
        selfView.addSubview(backView)
        
        let btnClose = UIButton()
        btnClose.addTarget(selfView, action: #selector(closeAction), for: .touchUpInside)
        btnClose.setImage(UIImage(named: "sp_code_close_rect"), for: .normal)
        backView.addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        let contentView = UIView()
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = UIColor(str: "#19427B")
        backView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(btnClose.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        let btnCam = selfView._createBtn(backImg: UIImage(named: "sp_code_blueBack"), left: UIImage(named: "sp_code_id_camera"), title: "Take a photo")
        let btnPhoto = selfView._createBtn(backImg: UIImage(named: "sp_code_id_commit_enable"), left: UIImage(named: "sp_code_photoLib"), title: "From Local Album")
        btnCam.addTarget(selfView, action: #selector(camAction), for: .touchUpInside)
        btnPhoto.addTarget(selfView, action: #selector(libAction), for: .touchUpInside)
        contentView.addSubview(btnCam)
        contentView.addSubview(btnPhoto)
        btnCam.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(76)
        }
        
        btnPhoto.snp.makeConstraints { make in
            make.top.equalTo(btnCam.snp.bottom).offset(19)
            make.leading.trailing.height.equalTo(btnCam)
        }
        
        UIView.animate(withDuration: 0.25) {
            selfView.backgroundColor = .black.withAlphaComponent(0.8)
            backView.frame = CGRect(x: 0, y: SPKit.height - (260 + SPKit.bottomAreaHeight), width: SPKit.width, height: 260 + SPKit.bottomAreaHeight)
        } completion: { finish in
            
        }
        
        return selfView
    }
    
    @objc func closeAction() {
        self.removeFromSuperview()
    }
    
    @objc func camAction() {
        closeAction()
        SPCamAndLibPermission.camAction()
            .subscribe(onNext: { finish in
                if finish {
                    self.typePub.onNext(0)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    @objc func libAction() {
        closeAction()
        SPCamAndLibPermission.libAction()
            .subscribe(onNext: { finish in
                if finish {
                    self.typePub.onNext(1)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    private func _createBtn(backImg: UIImage?, left image: UIImage?, title: String)-> UIButton {
        let btnBack = UIButton()
        btnBack.setBackgroundImage(backImg, for: .normal)
        
        let centerView = UIView()
        centerView.isUserInteractionEnabled = false
        btnBack.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let imgLeftView = UIImageView(image: image)
        centerView.addSubview(imgLeftView)
        imgLeftView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let lbl = UILabel()
        lbl.text = title
        lbl.textColor = .black
        lbl.font = UIFont.puFont(size: 20)
        centerView.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.leading.equalTo(imgLeftView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        return btnBack
    }
    
    deinit {
        SPPrint("\(self) 销毁")
    }
}
