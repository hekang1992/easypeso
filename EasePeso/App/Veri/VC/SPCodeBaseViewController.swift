//
//  SPCodeBaseViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/2.
//

import UIKit

class SPCodeBaseViewController: SPBaseViewController {
    let btnTijiao = SPTijiaoButton(frame: .zero)
    let scView = UIScrollView()
    lazy var horseView = {
        let hoView = UIView()
        hoView.backgroundColor = UIColor(str: "#C74E4C")
        
        return hoView
    }()
    
    lazy var stView: UIStackView = {
        let st = UIStackView()
        st.distribution = .fill
        st.axis = .vertical
        st.spacing = 20
        
        return st
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPKit.topAreaHeight + 64, left: 0, bottom: bottomStepHeight, right: 0))
        }
        
        contentView.addSubview(btnTijiao)
        btnTijiao.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(64)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        scView.showsVerticalScrollIndicator = false
        contentView.insertSubview(scView, belowSubview: btnTijiao)
        scView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        scView.addSubview(stView)
        stView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 64 + 20, right: 0))
            make.width.equalTo(SPKit.width - 48)
        }
        
        btnTijiao.tijiaoCallback = { [weak self] in
            self?.tijiaoData()
        }
    }
    
    func tijiaoData() {
        
    }
}
