//
//  SPTijiaoButton.swift
//  EasePeso
//
//  Created by apple on 2024/4/7.
//  认证项 提交按钮

import UIKit
import OpenCombine

class SPTijiaoButton: UIView {
    private lazy var btnTijiao = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "sp_code_id_commit_disable"), for: .disabled)
        btn.setImage(UIImage(named: "sp_code_id_commit_enable"), for: .normal)
        btn.addTarget(self, action: #selector(tijiaoAction), for: .touchUpInside)
        
        return btn
    }()
    
    /// 底部按钮文字
    private lazy var lblTijiao = {
        let lbl = UILabel()
        lbl.font = UIFont.puFont(size: 20)
        lbl.textColor = UIColor(str: "#BFBFBF")
        lbl.text = "Submit and Next"
        
        return lbl
    }()
    
    private var cancellables = Set<AnyCancellable>()
    /// 底部按钮是否可用
    @OpenCombine.Published var touchEnable: Bool = false
    /// 提交
    var tijiaoCallback: (()-> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(btnTijiao)
        btnTijiao.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        let tijiaoView = UIView()
        btnTijiao.addSubview(tijiaoView)
        tijiaoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        let imgTijiaoView = UIImageView(image: UIImage(named: "sp_code_id_dunpai"))
        tijiaoView.addSubview(imgTijiaoView)
        imgTijiaoView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        tijiaoView.addSubview(lblTijiao)
        lblTijiao.snp.makeConstraints { make in
            make.leading.equalTo(imgTijiaoView.snp.trailing).offset(1)
            make.centerY.trailing.equalToSuperview()
        }
        
        $touchEnable
            .sink { [weak self] able in
                self?.btnTijiao.isEnabled = able
                self?.lblTijiao.textColor = able ? .black : UIColor(str: "#BFBFBF")
            }.store(in: &cancellables)
    }
    
    @objc func tijiaoAction() {
        tijiaoCallback?()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
