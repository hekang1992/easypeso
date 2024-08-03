//
//  SPRuleView.swift
//  EasePeso
//
//  Created by apple on 2024/4/1.
//

import UIKit

class SPRuleView: UIView {
    class func showRule(to view: UIView) {
        let contentView = SPRuleView(frame: view.bounds)
        view.addSubview(contentView)
        let imgView = UIImageView(image: UIImage(named: "sp_home_ruleWindow"))
        imgView.frame = CGRect(x: 16, y: SPKit.height - 376, width: SPKit.width - 32, height: 300)
        imgView.contentMode = .scaleAspectFit
        contentView.addSubview(imgView)
        
        let btnClose = UIButton(type: .custom)
        btnClose.addTarget(contentView, action: #selector(closeAction), for: .touchUpInside)
        btnClose.setImage(UIImage(named: "sp_signinClose"), for: .normal)
        contentView.addSubview(btnClose)
        btnClose.frame = CGRect(x: SPKit.width - 60, y: SPKit.height - 230, width: 44, height: 44)
        
        contentView.backgroundColor = .black.withAlphaComponent(0.8)
    }
    
    @objc private func closeAction() {
        self.removeFromSuperview()
    }
}
