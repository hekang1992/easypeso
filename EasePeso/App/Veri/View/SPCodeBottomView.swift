//
//  SPCodeBottomItemView.swift
//  EasePeso
//
//  Created by apple on 2024/4/7.
//  底部的进度条

import UIKit

class SPCodeBottomView: UIView {
    var detailModel: SPCodeDetailModel? {
        didSet {
            _initView()
        }
    }
    
    private lazy var stView = {
        let st = UIStackView()
        st.axis = .horizontal
        st.distribution = .fillEqually
        
        return st
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stView)
        stView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func _initView() {
        stView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        guard let detailModel = detailModel else { return }
        for item in detailModel.forgiving {
            stView.addArrangedSubview(_createItemView(item))
        }
    }
    
    private func _createItemView(_ itemModel: SPCodeDetailModel.SPCodeItemModel)-> UIView {
        let secView = UIView()
        
        let imgBack = UIImage(named: "sp_code_bottomItem_now")
        let imgBackSize = imgBack?.size ?? .init(width: 1, height: 1)
        let imgBackCap = imgBack?.resizableImage(withCapInsets: UIEdgeInsets(top: imgBackSize.height / 2.0, left: imgBackSize.width / 2.0, bottom: imgBackSize.height / 2.0, right: imgBackSize.width / 2.0), resizingMode: .stretch)
        
        let backImgView = UIImageView()
        backImgView.backgroundColor = .cyan.withAlphaComponent(0.5)
        backImgView.image = imgBackCap
        secView.addSubview(backImgView)
        backImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let centerView = UIView()
        secView.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        let imgTopView = UIImageView(image: UIImage(named: "sp_code_suo_now"))
        imgTopView.contentMode = .scaleAspectFit
        centerView.addSubview(imgTopView)
        imgTopView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        let lblName = UILabel()
        lblName.font = UIFont.puFont(size: 12)
        lblName.text = map(from: itemModel.throwing?.rawValue)
        centerView.addSubview(lblName)
        lblName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgTopView.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
        
        /// 当前
        if itemModel.throwing == detailModel?.sheacknowledged?.throwing {
            lblName.textColor = .black
            imgTopView.image = UIImage(named: "sp_code_suo_now")
        }else {
            if itemModel.cowardice == 1 { /// 已完成
                lblName.textColor = .black
                imgTopView.image = UIImage(named: "sp_code_suo_last")
            }else { /// 未完成
                lblName.textColor = UIColor(str: "#ABABAB")
                imgTopView.image = UIImage(named: "sp_code_suo_Future")
                
                let imgBack = UIImage(named: "sp_code_bottomItem_Not")
                let imgBackSize = imgBack?.size ?? .init(width: 1, height: 1)
                let imgBackCap = imgBack?.resizableImage(withCapInsets: UIEdgeInsets(top: imgBackSize.height / 2.0, left: imgBackSize.width / 2.0, bottom: imgBackSize.height / 2.0, right: imgBackSize.width / 2.0), resizingMode: .stretch)
                backImgView.image = imgBackCap
            }
        }
        
        return secView
    }
    
    private func map(from str: String?)-> String {
        if str == "uy1" {
            return "ID Card"
        }else if str == "uy2" {
            return "Profile"
        }else if str == "uy3" {
            return "work"
        }else if str == "uy4" {
            return "Contact"
        }else if str == "uy5" {
            return "Bank"
        }
        return ""
    }
    
    required init?(coder: NSCoder) {
        detailModel = SPCodeDetailModel()
        super.init(coder: coder)
    }
    
}
