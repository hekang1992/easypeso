//
//  SPOrderListBottomSelectView.swift
//  EasePeso
//
//  Created by apple on 2024/4/8.
//

import UIKit
import OpenCombine

class SPOrderListBottomSelectView: UIView {
//    @OpenCombine.Published var marryyou: String = "4"
//    let marryyou: PublishedSubject<String, Never>? = PublishedSubject()
//    let marryyou: PassthroughSubject<String, Never>? = PassthroughSubject()
    
    var callback: ((String)-> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _initView()
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func show() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = .black.withAlphaComponent(0.8)
            self.backView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    private let totleHeight: CGFloat = 367
    private let backView = UIView()
    private func _initView() {
        backView.backgroundColor = UIColor(str: "#19427B")
        backView.layer.cornerRadius = 16
        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(backView)
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(totleHeight)
            make.height.equalTo(totleHeight)
        }
        
        let btnClose = UIButton(type: .custom).then {
            $0.setImage(UIImage(named: "sp_code_close_rect"), for: .normal)
        }
        btnClose.addTarget(self, action: #selector(xiaoshiAction), for: .touchUpInside)
        backView.addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        var topView: UIView? = nil
        [("All Orders", "4"), ("Outstanding Orders", "6"), ("Settled", "5"), ("Application in Progress", "7")]
            .forEach { model in
                let secView = _createItemView(model)
                self.backView.addSubview(secView)
                secView.snp.makeConstraints { make in
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.height.equalTo(52)
                    if topView != nil {
                        make.top.equalTo(topView!.snp.bottom).offset(14)
                    }else {
                        make.top.equalToSuperview().offset(64)
                    }
                }
                
                topView = secView
            }
    }
    
    private func _createItemView(_ itemModel: (String, String))-> UIView {
        let secView = UIView()
        
        let itemView = UIView()
        itemView.backgroundColor = UIColor(str: "#103059")
        itemView.layer.cornerRadius = 4
        secView.addSubview(itemView)
        itemView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32))
        }
        
        let lbl = UILabel().then {
            $0.font = UIFont.puFont(size: 18)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.text = itemModel.0
        }
        itemView.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
        
        let btn = UIButton(type: .custom)
        itemView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        btn.rx.tap.asSignal().emit(onNext: { [weak self] in
            self?.xiaoshiAction()
            SPPrint("itemModel.1 ==== \(itemModel.1)")
            self?.callback?(itemModel.1)
//            self?.marryyou?.send(itemModel.1)
//            self?.marryyou = itemModel.1
        }).disposed(by: rx.disposeBag)
        
        return secView
    }
    
    @objc func xiaoshiAction() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = .black.withAlphaComponent(0)
            self.backView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(self.totleHeight)
            }
            
            self.layoutIfNeeded()
        } completion: { finish in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
