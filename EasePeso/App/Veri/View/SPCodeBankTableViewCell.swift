//
//  SPCodeBankTableViewCell.swift
//  EasePeso
//
//  Created by apple on 2024/4/15.
//

import UIKit

class SPCodeBankTableViewCell: UITableViewCell {
    var infomodel: SPCodeInfoModel? {
        didSet {
            itemView.infoModel = infomodel
        }
    }
    
    lazy var itemView = SPCodeItemView(frame: .zero)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor.spTheme
        
        contentView.addSubview(itemView)
        itemView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SPCodeBankTypeCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor.spTheme
        
        contentView.addSubview(btnFrist)
        contentView.addSubview(btnSecond)
        
        btnFrist.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        btnSecond.snp.makeConstraints { make in
            make.leading.equalTo(btnFrist.snp.trailing).offset(11)
            make.top.bottom.width.equalTo(btnFrist)
            make.trailing.equalToSuperview().offset(-24)
        }
        btnFrist.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        btnSecond.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
    }
    
    @objc func btnAction(_ btn: UIButton) {
        let index = btn.tag - 1000
        if index == 0 {
            btnFrist.isSelected = true
            btnSecond.isSelected = false
        }else {
            btnFrist.isSelected = false
            btnSecond.isSelected = true
        }
        callback?(index)
    }
    
    var callback: ((Int)-> Void)?
    lazy var btnFrist = {
        let btn = UIButton()
        btn.tag = 1000
        btn.titleLabel?.font = UIFont.puFont(size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundImage(UIImage(named: "sp_veri_dataItem"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "sp_veri_dataItem_select"), for: .selected)
        
        return btn
    }()
    
    lazy var btnSecond = {
        let btn = UIButton()
        btn.tag = 1001
        btn.titleLabel?.font = UIFont.puFont(size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.setBackgroundImage(UIImage(named: "sp_veri_dataItem"), for: .normal)
        btn.setBackgroundImage(UIImage(named: "sp_veri_dataItem_select"), for: .selected)
        
        return btn
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
