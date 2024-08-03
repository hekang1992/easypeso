//
//  SPCodeFriendTableViewCell.swift
//  EasePeso
//
//  Created by apple on 2024/4/7.
//

import UIKit
import ContactsUI

class SPCodeFriendTableViewCell: UITableViewCell, CNContactPickerDelegate {
    var model: SPCodeFriendModel? {
        didSet {
            lblTitle.text = model?.periodically
            itemReleasionView.txfFillin.text = model?.relation_name
            txfName.text = model?.ilove
            txfPhone.text = model?.msorry
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.spTheme
        
        selectionStyle = .none
        _initView()
    }
    
    private func _initView() {
        contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(20)
        }
        
        let infoView = UIView()
        infoView.layer.cornerRadius = 10
        infoView.backgroundColor = .white.withAlphaComponent(0.16)
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(lblTitle.snp.bottom).offset(14)
            make.bottom.equalToSuperview()
        }
        
        infoView.addSubview(itemReleasionView)
        itemReleasionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(14)
        }
        
        let imgDetail = UIImage(named: "sp_veri_dataItem")
        let imgDetailSize = imgDetail?.size ?? .init(width: 1, height: 1)
        let imgDetailCap = imgDetail?.resizableImage(withCapInsets: UIEdgeInsets(top: imgDetailSize.height / 2.0, left: imgDetailSize.width / 2.0, bottom: imgDetailSize.height / 2.0, right: imgDetailSize.width / 2.0), resizingMode: .stretch)
        let detailView = UIImageView(image: imgDetailCap)
        detailView.isUserInteractionEnabled = true
        infoView.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(itemReleasionView)
            make.top.equalTo(itemReleasionView.snp.bottom).offset(13)
            make.height.equalTo(89)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        
        detailView.addSubview(txfPhone)
        txfPhone.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(21)
        }
        
        detailView.addSubview(txfName)
        txfName.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(txfPhone.snp.bottom).offset(16)
        }
        
        let imgRightView = UIImageView(image: UIImage(named: "sp_code_friend_book"))
        detailView.addSubview(imgRightView)
        imgRightView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
        }
        
        let btnCover = UIButton(type: .custom)
        btnCover.backgroundColor = .clear
        btnCover.addTarget(self, action: #selector(coverAction), for: .touchUpInside)
        detailView.addSubview(btnCover)
        btnCover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        itemReleasionView.selectCallback = { [weak self] in
            let bottomView = SPCodeBottomShowView(frame: UIScreen.main.bounds, self?.model?.babbled, model: self?.model?.influence, select: self?.model?.babbled)
            SPKit.window?.addSubview(bottomView)
            
            bottomView.callback = { selectModel in
                self?.model?.babbled = selectModel.housewives
                self?.model?.relation_name = selectModel.ilove
                self?.itemReleasionView.txfFillin.text = self?.model?.relation_name
            }
        }
    }
    
    @objc func coverAction() {
        guard let strFill = itemReleasionView.txfFillin.text, !strFill.isEmpty else {
            vc?.view.errorMsg(str: "Please select the relationship first")
            return
        }
        let contactVc = CNContactPickerViewController()
        contactVc.delegate = self
        vc?.navigationController?.present(contactVc, animated: true)
    }
    
    lazy var lblTitle = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.puFont(size: 16)
        
        return lbl
    }()
    
    lazy var itemReleasionView: SPCodeItemView = {
        let itemView = SPCodeItemView()
        itemView.txfFillin.attributedPlaceholder = NSAttributedString(string: "Please select", attributes: [.foregroundColor: UIColor.spPlace])
        itemView.lblTitle.text = "Relationship"
        
        return itemView
    }()
    
    lazy var txfPhone = {
        let txf = UITextField()
        txf.font = UIFont.puFont(size: 16)
        txf.textColor = .white
        txf.attributedPlaceholder = NSAttributedString(string: "Contact Information", attributes: [.foregroundColor: UIColor.spPlace])
        
        return txf
    }()
    
    lazy var txfName = {
        let txf = UITextField()
        txf.font = UIFont.puFont(size: 16)
        txf.textColor = .white
        txf.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [.foregroundColor: UIColor.spPlace])
        
        return txf
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        var arrPhone = [String]()
        
        contact.phoneNumbers.forEach { numValue in
            let phone = numValue.value.stringValue
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .replacingOccurrences(of: "+", with: "")
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: " ", with: "")
            
            arrPhone.append(phone)
        }
        
        let arrNames = [contact.familyName, contact.middleName, contact.givenName].compactMap { $0 }
        model?.ilove = arrNames.joined(separator: " ")
        model?.msorry = arrPhone.joined(separator: ",")
        
        txfName.text = model?.ilove
        txfPhone.text = model?.msorry
        
        model?.obsFillIn.onNext(true)
        
        picker.dismiss(animated: true)
    }
}

import OpenCombine
class SPCodeFriendFooterView: UIView {
    var callback: (()-> Void)?
    @OpenCombine.Published var btnEnable = false
    
    var setCancel = Set<AnyCancellable>()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let btnTijiao = SPTijiaoButton(frame: .zero)
        addSubview(btnTijiao)
        btnTijiao.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 28, bottom: 20, right: 28))
            make.height.equalTo(64)
        }
        
        $btnEnable.assign(to: \.touchEnable, on: btnTijiao)
            .store(in: &setCancel)
        
        btnTijiao.tijiaoCallback = { [weak self] in
            self?.callback?()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
