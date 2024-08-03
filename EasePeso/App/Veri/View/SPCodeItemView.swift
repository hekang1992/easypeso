//
//  SPCodeItemView.swift
//  EasePeso
//
//  Created by apple on 2024/4/2.
//  身份信息的

import UIKit
import RxSwift
import BRPickerView

class SPCodeItemView: UIView {
    /// 个人信息或者工作信息
    var infoModel: SPCodeInfoModel? {
        didSet {
            lblTitle.text = infoModel?.witty
            txfFillin.attributedPlaceholder = NSAttributedString(string: infoModel?.crying ?? "", attributes: [.foregroundColor: UIColor.SPB_1])
            txfFillin.text = infoModel?.cliff
            
            if infoModel?.anormal == "1" {
                txfFillin.keyboardType = .numberPad
            }else {
                txfFillin.keyboardType = .default
            }
            
            if infoModel?.needTwoBtns == true {
                self.btnCover.isHidden = false
                self.rightView.isHidden = false
            }else {
                if infoModel?.regretful == "jo2" {
                    self.btnCover.isHidden = true
                    self.rightView.isHidden = true
                }else {
                    self.btnCover.isHidden = false
                    self.rightView.isHidden = false
                }
            }
        }
    }
    
    var selectCallback: (()-> Void)?
    /// 取消第一响应
    var bottomCancelFirst: (()-> Void)?
    
    let lblTitle = UILabel()
    let txfFillin = UITextField()
    let btnCover = UIButton(type: .custom)
    let rightView = UIView()
    
    /// 用于持有生命周期
    private lazy var address = SPCodeAddress()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let fillInImgView = UIImageView(image: UIImage(named: "sp_veri_dataItem"))
        fillInImgView.isUserInteractionEnabled = true
        addSubview(fillInImgView)
        fillInImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerX.bottom.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
        }
        
        let stView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 5
        }
        fillInImgView.addSubview(stView)
        stView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
        }
        
        txfFillin.font = UIFont.puFont(size: 14)
        txfFillin.textColor = .white
        stView.addArrangedSubview(txfFillin)
        
        stView.addArrangedSubview(rightView)
        let imgRightView = UIImageView(image: UIImage(named: "sp_code_xiajian"))
        rightView.addSubview(imgRightView)
        imgRightView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(24)
            make.leading.equalToSuperview()
        }
        
        btnCover.backgroundColor = .clear
        btnCover.addTarget(self, action: #selector(coverAction), for: .touchUpInside)
        fillInImgView.addSubview(btnCover)
        btnCover.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
        }
        
        let imgTitle = UIImage(named: "sp_veri_title")
        let titleSize = imgTitle?.size ?? .init(width: 1, height: 1)
        let imgTitleCap = imgTitle?.resizableImage(withCapInsets: UIEdgeInsets(top: titleSize.height / 2.0, left: titleSize.width / 2.0, bottom: titleSize.height / 2.0, right: titleSize.width / 2.0), resizingMode: .stretch)
        let titleImgView = UIImageView(image: imgTitleCap)
        addSubview(titleImgView)
        titleImgView.snp.makeConstraints { make in
            make.leading.equalTo(fillInImgView).offset(8)
            make.centerY.equalTo(fillInImgView.snp.top)
            make.top.equalToSuperview()
        }
        
        lblTitle.font = UIFont.puFont(size: 14)
        lblTitle.textColor = .white
        titleImgView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14))
        }
        
        txfFillin.rx.text
            .subscribe(onNext: { str in
                self.infoModel?.cliff = str
                self.infoModel?.housewives = str
                
                if self.infoModel?.unhappiness == "0" {
                    if let str = str, !str.isEmpty {
                        self.infoModel?.obsFillIn.onNext(true)
                    }else {
                        self.infoModel?.obsFillIn.onNext(false)
                    }
                }
            }).disposed(by: rx.disposeBag)
    }
    
    @objc func coverAction(_ btn: UIButton) {
        if self.selectCallback != nil {
            self.selectCallback?()
        }else {
            bottomCancelFirst?()
            if infoModel?.regretful == "jo3" {
                address.fetchAddress(view: self.vc?.view) { [weak self] arrModel in
                    let addressPicker = BRAddressPickerView(pickerMode: .area)
                    addressPicker.title = self?.infoModel?.witty
                    addressPicker.dataSourceArr = arrModel
                    addressPicker.show()
                    
                    addressPicker.resultBlock = { pro, city, area in
                        let arrAddress = [pro?.name, city?.name, area?.name].compactMap { $0 }
                        self?.txfFillin.text = arrAddress.joined(separator: "-")
                        self?.infoModel?.housewives = arrAddress.joined(separator: "-")
                        self?.infoModel?.obsFillIn.onNext(true)
                    }
                }
            }else if infoModel?.regretful == "jo1" {
                if let arrModels = infoModel?.rising {
                    let aa = arrModels.first { ($0.rising?.count ?? 0) > 0 }
                    if aa != nil {
                        twoConSelectView()
                    }else {
                        oneConSelectView()
                    }
                }else {
                    oneConSelectView()
                }
            }
        }
    }
    
    /// 两列联动
    private func twoConSelectView() {
        guard let arrModels = infoModel?.rising else { return }
        let pickerView = BRStringPickerView(pickerMode: .componentLinkage)
        pickerView.title = infoModel?.witty
        pickerView.numberOfComponents = 2
        pickerView.dataSourceArr = transform(fromData: arrModels)
        
        pickerView.show()
        pickerView.resultModelArrayBlock = { arrValues in
            if let arrSelect = arrValues?.compactMap({ $0.key }), 
                let arrShow = arrValues?.compactMap({ $0.value }) {
                self.txfFillin.text = arrShow.joined(separator: "-")
                self.infoModel?.housewives = arrSelect.joined(separator: "|")
                self.infoModel?.obsFillIn.onNext(true)
            }
        }
    }
    
    /// 单列
    private func oneConSelectView() {
        let v = SPCodeBottomShowView(frame: UIScreen.main.bounds, self.infoModel?.witty, model: self.infoModel?.rising, select: self.infoModel?.housewives)
        SPKit.window?.addSubview(v)
        
        v.callback = { selectModel in
            self.infoModel?.housewives = selectModel.housewives
            self.infoModel?.cliff = selectModel.ilove
            self.txfFillin.text = self.infoModel?.cliff
            self.infoModel?.obsFillIn.onNext(true)
        }
    }
    
    private func transform(fromData: [SPCodeItemSelectModel])-> [BRResultModel] {
        var arrBrModels: [BRResultModel] = []
        
        for model in fromData {
            let brModel = BRResultModel()
            brModel.parentKey = "-1"
            brModel.parentValue = ""
            brModel.key = model.housewives
            brModel.value = model.ilove
            
            arrBrModels.append(brModel)
            
            if let arrInModels = model.rising {
                for inModel in arrInModels {
                    let inBrModel = BRResultModel()
                    inBrModel.parentKey = brModel.key
                    inBrModel.parentValue = brModel.value
                    inBrModel.key = inModel.housewives
                    inBrModel.value = inModel.ilove
                    
                    arrBrModels.append(inBrModel)
                }
            }
        }
        
        return arrBrModels
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
