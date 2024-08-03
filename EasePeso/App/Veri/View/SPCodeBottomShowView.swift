//
//  SPCodeBottomShowView.swift
//  EasePeso
//
//  Created by apple on 2024/4/2.
//  底部弹出的选择窗口

import UIKit
import HandyJSON

import Kingfisher

class SPCodeBottomShowView: UIView {
    var callback: ((SPCodeItemSelectModel)-> Void)?
    private let arrModels: [SPCodeItemSelectModel]?
    private let selectType: String?
    
    private var contentHeight: CGFloat = 0
    private let backView = UIView()
    
    init(frame: CGRect, _ title: String?, model: [SPCodeItemSelectModel]?, select type: String?) {
        self.arrModels = model
        selectType = type
        super.init(frame: frame)
        
        _initView(title)
    }
    
    private func _initView(_ title: String?) {
        let count = arrModels?.count ?? 0
        let maxHeight = 0.7 * SPKit.height
        
        addSubview(backView)
        
        let topView = SPCodeIDTitleView(title: title)
        backView.addSubview(topView)
        topView.closeCallback = {
            self.xiaoshiAction()
        }
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        let scView = UIScrollView()
        scView.backgroundColor = UIColor(str: "#19427B")
        scView.showsVerticalScrollIndicator = false
        backView.insertSubview(scView, belowSubview: topView)
        let scHeight = min(CGFloat(66 * count) + SPKit.bottomAreaHeight + 10, maxHeight)
        scView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(scHeight)
        }
        
        let stAxView = UIStackView()
        stAxView.axis = .vertical
        stAxView.distribution = .fill
        scView.addSubview(stAxView)
        stAxView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
            make.width.equalTo(self)
        }
        
        self.arrModels?.forEach { item in
            let itemView = createItemView(pModel: item)
            stAxView.addArrangedSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.height.equalTo(66)
            }
        }
        
        contentHeight = scHeight + 58
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(contentHeight)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25) {
            self.backView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            
            self.backgroundColor = .black.withAlphaComponent(0.8)
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    func createItemView(pModel: SPCodeItemSelectModel)-> UIView {
        let secView = UIView()
        
        let itemView = UIView()
        itemView.backgroundColor = UIColor(str: "#103059")
        if pModel.housewives == self.selectType {
            itemView.backgroundColor = UIColor(str: "#1FCDF2")
        }
        itemView.layer.cornerRadius = 4
        secView.addSubview(itemView)
        itemView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 14, left: 32, bottom: 0, right: 32))
        }
        
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 12
        imgView.layer.masksToBounds = true
        itemView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        var imgHidden = false
        if let imgUrl = pModel.youdon, !imgUrl.isEmpty {
            imgView.isHidden = false
            imgView.kf.setImage(with: URL(string: imgUrl))
            imgHidden = false
        }else {
            imgView.isHidden = true
            imgHidden = true
        }
        
        let lbl = UILabel().then {
            $0.font = UIFont.puFont(size: 18)
            $0.textColor = .white
            $0.textAlignment = imgHidden ? .center : .left
            $0.text = pModel.ilove
        }
        itemView.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            if imgHidden {
                make.leading.equalToSuperview().offset(24)
            }else {
                make.leading.equalTo(imgView.snp.trailing).offset(2)
            }
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        
        let btn = UIButton(type: .custom)
        itemView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        btn.rx.tap.asSignal().emit(onNext: { [weak self] in
            self?.callback?(pModel)
            self?.xiaoshiAction()
        }).disposed(by: rx.disposeBag)
        
        return secView
    }
    
    @objc func xiaoshiAction() {
        UIView.animate(withDuration: 0.25) {
            self.backView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(self.contentHeight)
            }
            self.backgroundColor = .black.withAlphaComponent(0)
            self.setNeedsLayout()
            self.layoutIfNeeded()
        } completion: { finish in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
