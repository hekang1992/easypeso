//
//  SPProfileBottomShowView.swift
//  EasePeso
//
//  Created by apple on 2024/4/17.
//

import UIKit
import RxSwift

class SPProfileBottomShowView: UIView {
    /// 0: 上面  1：下面
    let typePub = PublishSubject<Int>()
    
    @discardableResult
    static func show(
        topImage: UIImage? = UIImage(named: "sp_code_blueBack"),
        topTitle: String?,
        bottomImage: UIImage? = UIImage(named: "sp_code_id_commit_enable"),
        bottomTitle: String?)-> SPProfileBottomShowView {
            
        let selfView = SPProfileBottomShowView(frame: UIScreen.main.bounds)
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
        
        let btnTop = selfView._createBtn(backImg: topImage, left: nil, title: topTitle)
        let btnBottom = selfView._createBtn(backImg: bottomImage, left: nil, title: bottomTitle)
        btnTop.addTarget(selfView, action: #selector(topAction), for: .touchUpInside)
        btnBottom.addTarget(selfView, action: #selector(bottomAction), for: .touchUpInside)
        contentView.addSubview(btnTop)
        contentView.addSubview(btnBottom)
        btnTop.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(76)
        }
        
        btnBottom.snp.makeConstraints { make in
            make.top.equalTo(btnTop.snp.bottom).offset(19)
            make.leading.trailing.height.equalTo(btnTop)
        }
        
        UIView.animate(withDuration: 0.25) {
            selfView.backgroundColor = .black.withAlphaComponent(0.8)
            backView.frame = CGRect(x: 0, y: SPKit.height - (260 + SPKit.bottomAreaHeight), width: SPKit.width, height: 260 + SPKit.bottomAreaHeight)
        } completion: { finish in
            
        }
        
        return selfView
    }
    
    @objc func topAction() {
        typePub.onNext(0)
        self.closeAction()
    }
    
    @objc func bottomAction() {
        typePub.onNext(1)
        self.closeAction()
    }
    
    @objc func closeAction() {
        self.removeFromSuperview()
    }
    
    private func _createBtn(backImg: UIImage?, left image: UIImage?, title: String?)-> UIButton {
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
}
