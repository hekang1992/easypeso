//
//  SPCodeFrontInfoView.swift
//  EasePeso
//
//  Created by apple on 2024/4/3.
//  选择身份照片之后展示的信息

import UIKit

import OpenCombine
import RxSwift
import Kingfisher
import BRPickerView

class SPCodeFrontInfoView: UIView {
    var successCallback: (()-> Void)?
    private let datePub = PublishSubject<String?>()
    private var model: SPCodeCardUpImageModel
    /// 前缀
    private var preStr: String
    
    private var setCancel = Set<AnyCancellable>()
    
    private var txfName: UITextField!
    private var txfKahao: UITextField!
    private var txfBirthday: UITextField!
    init(frame: CGRect, model: SPCodeCardUpImageModel, preStr: String) {
        self.model = model
        self.preStr = preStr
        super.init(frame: frame)
        
        backgroundColor = .black.withAlphaComponent(0.8)
        _initView()
    }
    
    private func _initView() {
        let backView = UIView()
        addSubview(backView)
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        let btnClose = UIButton(type: .custom)
        btnClose.setImage(UIImage(named: "sp_code_close_rect"), for: .normal)
        btnClose.addTarget(self, action: #selector(xiaoshiAction), for: .touchUpInside)
        backView.addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().offset(-22)
            make.width.height.equalTo(44)
        }
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor(str: "#19427B")
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        backView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(btnClose.snp.bottom)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview()
        }
        
        let nameItemView = SPCodeItemView()
        let numberItemView = SPCodeItemView()
        let birthItemView = SPCodeItemView()
        txfName = nameItemView.txfFillin
        txfKahao = numberItemView.txfFillin
        txfBirthday = birthItemView.txfFillin
        txfName.font = UIFont.puFont(size: 14)
        txfKahao.font = UIFont.puFont(size: 14)
        txfBirthday.font = UIFont.puFont(size: 14)
        birthItemView.selectCallback = {
            self._selectDatePicker()
        }
        
        datePub.subscribe(onNext: { [weak self] str in
            birthItemView.txfFillin.text = str
            self?.model.foot = str
        }).disposed(by: rx.disposeBag)
        
        nameItemView.rightView.isHidden = true
        nameItemView.btnCover.isHidden = true
        nameItemView.lblTitle.text = preStr + " Name"
        nameItemView.txfFillin.attributedPlaceholder = NSAttributedString(string:"Please enter", attributes: [.foregroundColor: UIColor.SPB_1])
        txfName.text = model.ilove
        
        numberItemView.rightView.isHidden = true
        numberItemView.btnCover.isHidden = true
        numberItemView.lblTitle.text = preStr + " Number"
        numberItemView.txfFillin.attributedPlaceholder = NSAttributedString(string:"Please enter", attributes: [.foregroundColor: UIColor.SPB_1])
        txfKahao.text = model.department
        
        birthItemView.lblTitle.text = preStr + " Date"
        birthItemView.txfFillin.attributedPlaceholder = NSAttributedString(string:"Please Select", attributes: [.foregroundColor: UIColor.SPB_1])
        if let foot = model.foot {
            let format = DateFormatter()
            format.dateFormat = "yyyy/MM/dd"
            let date = format.date(from: foot) ?? Date()
            format.dateFormat = "dd/MM/yyyy"
            let str = format.string(from: date)
            txfBirthday.text = format.string(from: date)
        }
        
        contentView.addSubview(nameItemView)
        contentView.addSubview(numberItemView)
        contentView.addSubview(birthItemView)
        nameItemView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        numberItemView.snp.makeConstraints { make in
            make.top.equalTo(nameItemView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(nameItemView)
        }
        birthItemView.snp.makeConstraints { make in
            make.top.equalTo(numberItemView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(nameItemView)
        }
        
        let boView = UIView()
        boView.backgroundColor = UIColor(str: "#103059")
        contentView.addSubview(boView)
        boView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(birthItemView.snp.bottom).offset(32)
            make.height.equalTo(115)
            make.bottom.equalToSuperview()
        }
        
        let btnSure = UIButton()
        btnSure.setBackgroundImage(UIImage(named: "sp_code_id_commit_enable"), for: .normal)
        btnSure.setTitle("Confirm", for: .normal)
        btnSure.titleLabel?.font = UIFont.puFont(size: 20)
        btnSure.setTitleColor(.black, for: .normal)
        btnSure.addTarget(self, action: #selector(tijiaoAction), for: .touchUpInside)
        boView.addSubview(btnSure)
        btnSure.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.top.equalToSuperview().offset(26)
            make.height.equalTo(64)
        }
    }
    
    private func _selectDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.date(from: txfBirthday.text ?? "")
        
        let picker = BRDatePickerView(pickerMode: .YMD)
        picker.selectDate = date
        picker.title = "Select birthday"
        picker.show()
        
        picker.resultBlock = { date, str in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            self.txfBirthday.text = formatter.string(from: date ?? Date())
        }
    }
    
    @objc func xiaoshiAction() {
        self.removeFromSuperview()
    }
    
    @objc func tijiaoAction() {
        guard let strMz = txfName.text, !strMz.isEmpty,
              let strKahao = txfKahao.text, !strKahao.isEmpty,
        let strDay = txfBirthday.text, !strDay.isEmpty else {
            self.errorMsg(str: "Please provide additional details")
            return
        }
        let hud = self.hudAnimation()
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        let date = format.date(from: strDay) ?? Date()
        format.dateFormat = "yyyy/MM/dd"
        let strNet = format.string(from: date)
        
        let dict = [
            "foot": strNet,
            "reluctant": "",
            "department": strKahao,
            "ilove": strMz,
            "housewives": "11",
            "telldr": String.suijiStr()
        ]
        SPNetRequest
            .spRequestHandyData(showHud: self, SPZeroModel.self, url: "/people_added", method: .post, para: dict)
            .subscribe(onNext: { bigModel in
                hud.hide(animated: true)
                if bigModel?.ofdiffident == 0 {
                    self.xiaoshiAction()
                    self.successCallback?()
                }else {
                    self.errorMsg(str: bigModel?.exhaustion)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        model = SPCodeCardUpImageModel()
        preStr = ""
        super.init(coder: coder)
    }
}
