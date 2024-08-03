//
//  SPOrderListTableViewCell.swift
//  EasePeso
//
//  Created by apple on 2024/4/8.
//

import UIKit

class SPOrderListTableViewCell: UITableViewCell {
    let lblOverTime = UILabel()
    let imgBackView = UIImageView()
    let imgLogoView = UIImageView(image: UIImage(named: "sp_orderList_logo_place"))
    let lblTime = UILabel()
    let lblMoney = UILabel()
    let lblName = UILabel()
    let imgDetailView = UIImageView()
    let lblDetail = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.backgroundColor = UIColor(str: "#3F7774")
        contentView.addSubview(lblOverTime)
        contentView.addSubview(imgBackView)
        imgBackView.isUserInteractionEnabled = true
        
        let imgLogoBackView = UIImageView(image: UIImage(named: "sp_code_orderList_LogoBack"))
        imgBackView.addSubview(imgLogoBackView)
        imgLogoBackView.addSubview(imgLogoView)
        
        imgBackView.addSubview(lblTime)
        imgBackView.addSubview(lblMoney)
        imgBackView.addSubview(lblName)
        imgBackView.addSubview(imgDetailView)
        let imgRightView = UIImageView(image: UIImage(named: "sp_code_orderListRightin"))
        imgBackView.addSubview(imgRightView)
        
        imgDetailView.addSubview(lblDetail)

        lblOverTime.textColor = UIColor(str: "#D17D5B")
        lblOverTime.font = UIFont.puFont(size: 14)
        lblOverTime.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-17)
            make.top.equalToSuperview().offset(8)
        }
        
        let imgBack = UIImage(named: "sp_code_orderList_doing")
        imgBackView.image = imgBack
        imgBackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 14, left: 17, bottom: 8, right: 17))
        }
        
        imgLogoBackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        imgLogoView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.width.height.equalTo(56)
        }
        
        lblTime.textColor = UIColor(str: "#ABF15A")
        lblTime.font = UIFont.puFont(size: 16)
        lblTime.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(81)
            make.top.equalToSuperview().offset(20)
        }
        
        lblMoney.textColor = .white
        lblMoney.font = UIFont.puFont(size: 16)
        lblMoney.snp.makeConstraints { make in
            make.leading.equalTo(lblTime)
            make.top.equalTo(lblTime.snp.bottom).offset(4)
        }
        
        lblName.textColor = .white
        lblName.font = UIFont.puFont(size: 16)
        lblName.snp.makeConstraints { make in
            make.leading.equalTo(lblTime)
            make.top.equalTo(lblMoney.snp.bottom).offset(4)
        }
        
        imgRightView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }
        
        imgDetailView.isHidden = true
        imgDetailView.image = UIImage(named: "sp_code_orderList_adding")
        imgDetailView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-9)
            make.top.equalTo(lblName.snp.bottom).offset(4)
        }
        
        lblDetail.font = UIFont.puFont(size: 14)
        lblDetail.textColor = UIColor(str: "#385459")
        lblDetail.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
