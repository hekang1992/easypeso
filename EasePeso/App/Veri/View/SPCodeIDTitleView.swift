//
//  SPCodeIDTopView.swift
//  EasePeso
//
//  Created by apple on 2024/4/2.
//

import UIKit

class SPCodeIDTitleView: UIView {
    var closeCallback: (()-> Void)?
    var btnClose: UIButton!
    
    init(title: String?) {
        super.init(frame: .zero)
        
        let imgTitle = UIImage(named: "sp_code_bottomTitle")
        let titleSize = imgTitle?.size ?? .init(width: 1, height: 1)
        let titleCapImg = imgTitle?.resizableImage(withCapInsets: UIEdgeInsets(top: titleSize.height / 2.0, left: titleSize.width / 2.0, bottom: titleSize.height / 2.0, right: titleSize.width / 2.0), resizingMode: .stretch)
        let titleImgView = UIImageView(image: titleCapImg)
        addSubview(titleImgView)
        titleImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let lblTitle = UILabel().then {
            $0.font = UIFont.puFont(size: 18)
            $0.textColor = .white
            $0.text = title
        }
        titleImgView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(54)
            make.top.equalToSuperview().offset(15)
        }
        
        let imgTopActionView = UIImageView(image: UIImage(named: "sp_code_bottomShowTop"))
        imgTopActionView.isUserInteractionEnabled = true
        insertSubview(imgTopActionView, belowSubview: titleImgView)
        imgTopActionView.snp.makeConstraints { make in
            make.top.equalTo(titleImgView).offset(14)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(68)
            make.bottom.equalToSuperview().offset(24)
        }
        
        btnClose = UIButton(type: .custom).then {
            $0.setImage(UIImage(named: "sp_code_close_rect"), for: .normal)
        }
        btnClose.addTarget(self, action: #selector(xiaoshiAction), for: .touchUpInside)
        addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.top).offset(45)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
    
    @objc func xiaoshiAction() {
        closeCallback?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
