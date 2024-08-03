//
//  SPHomeStepItemView.swift
//  EasePeso
//
//  Created by apple on 2024/3/28.
//

import UIKit

class SPHomeStepItemView: UIView {
    
    private let imgTopView = UIImageView()
    init(frame: CGRect, _ style: ItemStyle) {
        super.init(frame: frame)
        
        let diskView = initDiskImgView()
        self.addSubview(diskView)
        diskView.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
        }
        diskView.addOpacityAnimation(duration: 2)
        
        switch style {
            case .start:
                diskView.isHidden = true
                imgTopView.image = UIImage(named: "sp_home_step_now")
            case .step(_, ifNow: true):
                imgTopView.image = UIImage(named: "sp_home_step_now")
            case .step(step: let index, ifNow: false):
                imgTopView.image = UIImage(named: "sp_home_step_suo")
            
                let imgCenterView = UIImageView(image: UIImage(named: "sp_home_suo\(index)"))
                imgTopView.addSubview(imgCenterView)
                imgCenterView.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(6)
                }
            case .complete:
                imgTopView.image = UIImage(named: "sp_home_step_complete")
        }
        
        imgTopView.contentMode = .scaleAspectFit
        self.insertSubview(imgTopView, belowSubview: diskView)
        imgTopView.snp.makeConstraints { make in
            make.centerX.top.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
            make.width.equalTo(64)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgTopView.addPositionAnimation(duration: 0.6)
    }
    
    fileprivate func initDiskImgView()-> UIView {
        let diskImgView = UIImageView(image: UIImage(named: "sp_home_step_sunshine"))
        return diskImgView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
