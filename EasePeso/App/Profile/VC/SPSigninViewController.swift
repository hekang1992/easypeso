//
//  SPSigninViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/1.
//  登录

import UIKit
import Then
import RxSwift
import RxCocoa
import CoreLocation

extension Notification.Name {
    /// 登录成功
    static let dengluSuccess = Notification.Name("sp_loginSuccess")
}

class SPSigninViewController: SPBaseViewController {
    let minPhoneCount = 9
    let codeCount = 6
    let phoneTextfield = UITextField().then { fi in
        fi.font = UIFont.puFont(size: 14)
        fi.keyboardType = .numberPad
        fi.textColor = .white
        fi.attributedPlaceholder = NSAttributedString(string: "Mobile number",
                                                      attributes: [.font: UIFont.puFont(size: 14), .foregroundColor: UIColor.spPlace])
    }
    
    let veriTextfield = UITextField().then { fi in
        fi.font = UIFont.puFont(size: 14)
        fi.keyboardType = .numberPad
        fi.textColor = .white
        fi.attributedPlaceholder = NSAttributedString(string: "Verification code",
                                                      attributes: [.font: UIFont.puFont(size: 14), .foregroundColor: UIColor.spPlace])
    }
    
    let btnVeri = UIButton(type: .custom).then { veri in
        veri.titleLabel?.font = UIFont.puFont(size: 14)
        veri.setTitle("Get Code", for: .normal)
        veri.setTitleColor(UIColor(str: "#6BE747"), for: .normal)
    }
    
    private var veriTimerAttr = BehaviorRelay<NSAttributedString>(value: NSAttributedString(string: "Get Code", attributes: [
                                                                                                                 .font: UIFont.puFont(size: 14),
                                                                                                                 .foregroundColor: UIColor(str: "#6BE747") ?? UIColor.spPlace]))
    
    /// 用于强引用self
    var callback: (()-> Void)?
    
    private var timeBegin: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        spInitView()
        
        callback = { self }
        
        veriTimerAttr.bind(to: btnVeri.rx.attributedTitle(for: .normal))
            .disposed(by: rx.disposeBag)
        
        timeBegin = Int(Date().timeIntervalSince1970 * 1000)
        
        NotificationCenter.default.addObserver(self, selector: #selector(maidianFirst), name: NSNotification.Name("sp_maidian_first"), object: nil)
    }
    
    private func spInitView() {
        let titleView = UIImageView(image: UIImage(named: "sp_signinTop"))
        titleView.isUserInteractionEnabled = true
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(SPKit.topAreaHeight + 44)
        }
        
        let lblTitle = UILabel().then { lbl in
            lbl.font = UIFont.puFont(size: 20)
            lbl.textColor = .white
            lbl.text = "Sign in"
        }
        titleView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(SPKit.topAreaHeight)
            make.height.equalTo(44)
        }
        
        let btnClose = UIButton(type: .custom)
        btnClose.rx.tap.subscribe { [weak self] _ in
            self?.navigationController?.dismiss(animated: true)
            self?.callback = nil
        }.disposed(by: rx.disposeBag)
        btnClose.setImage(UIImage(named: "sp_signinClose"), for: .normal)
        titleView.addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.height.equalTo(44)
            make.centerY.equalTo(lblTitle)
        }
        
        let lblDesc = UILabel().then { lbl in
            lbl.numberOfLines = 0
            
            let para = NSMutableParagraphStyle()
            para.lineSpacing = 8
            let strTotle = "Automatic login and verification for unregistered phone numbers"
            let attr = NSMutableAttributedString(string: strTotle, attributes: [
                .font: UIFont.puFont(size: 14),
                .foregroundColor: UIColor(str: "#6EEAFC") ?? .white,
                .paragraphStyle: para
            ])
            lbl.attributedText = attr
        }
        view.addSubview(lblDesc)
        lblDesc.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(56)
        }
        
        // !!!: phone
        let itemPhoneImgView = UIImageView(image: UIImage(named: "sp_signinItem"))
        itemPhoneImgView.isUserInteractionEnabled = true
        view.addSubview(itemPhoneImgView)
        itemPhoneImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.top.equalTo(lblDesc.snp.bottom).offset(13)
            make.height.equalTo(58)
        }
        
        let itemPhoneLeftImgView = UIImageView(image: UIImage(named: "sp_signinPhone"))
        itemPhoneLeftImgView.setContentCompressionResistancePriority(.required, for: .horizontal)
        itemPhoneLeftImgView.setContentHuggingPriority(.required, for: .horizontal)
        itemPhoneImgView.addSubview(itemPhoneLeftImgView)
        itemPhoneLeftImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        let lblCountryCode = UILabel().then { lbl in
            lbl.text = "+63"
            lbl.textColor = UIColor.spPlace
            lbl.font = UIFont.puFont(size: 14)
        }
        lblCountryCode.setContentCompressionResistancePriority(.required, for: .horizontal)
        lblCountryCode.setContentHuggingPriority(.required, for: .horizontal)
        itemPhoneImgView.addSubview(lblCountryCode)
        lblCountryCode.snp.makeConstraints { make in
            make.leading.equalTo(itemPhoneLeftImgView.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
        }
        
        itemPhoneImgView.addSubview(phoneTextfield)
        phoneTextfield.snp.makeConstraints { make in
            make.leading.equalTo(lblCountryCode.snp.trailing).offset(6)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        // !!!: code
        let itemVeriImgView = UIImageView(image: UIImage(named: "sp_signinItem"))
        itemVeriImgView.isUserInteractionEnabled = true
        self.view.addSubview(itemVeriImgView)
        itemVeriImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.top.equalTo(itemPhoneImgView.snp.bottom).offset(13)
            make.height.equalTo(58)
        }
        
        itemVeriImgView.addSubview(self.veriTextfield)
        self.veriTextfield.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.top.bottom.equalToSuperview()
        }
        
        self.btnVeri.addTarget(self, action: #selector(self.getVeriCode), for: .touchUpInside)
        itemVeriImgView.addSubview(self.btnVeri)
        self.btnVeri.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-28)
            make.top.bottom.equalToSuperview()
        }
        
        let veriSepView = UIView()
        veriSepView.layer.cornerRadius = 1.5
        veriSepView.backgroundColor = UIColor(str: "#3D4F65")
        itemVeriImgView.addSubview(veriSepView)
        veriSepView.snp.makeConstraints { make in
            make.trailing.equalTo(self.btnVeri.snp.leading).offset(-28)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(3)
        }
        
        let lblPravicy = UILabel().then { lbl in
            lbl.font = UIFont.puFont(size: 14)
            lbl.numberOfLines = 0
            let para = NSMutableParagraphStyle()
            para.lineSpacing = 8
            let strPravicy = "Privacy Policy"
            let strTotle = "By clicking login you agree to the terms of the Privacy Policy"
            let attr = NSMutableAttributedString(string: strTotle, attributes: [
                .font: UIFont.puFont(size: 14),
                .foregroundColor: UIColor.white,
                .paragraphStyle: para
            ])
            let range = strTotle.range(of: strPravicy)
            if let nsrange = strTotle.toNsRange(with: range) {
                attr.addAttributes([.foregroundColor: UIColor(str: "#6EEAFC") ?? .white], range: nsrange)
            }
            lbl.attributedText = attr
        }
        view.addSubview(lblPravicy)
        lblPravicy.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.top.equalTo(itemVeriImgView.snp.bottom).offset(13)
        }
        
        let btnPravicy = UIButton(type: .custom).then { btn in
            btn.backgroundColor = .clear
        }
        btnPravicy.addTarget(self, action: #selector(pravicyAction), for: .touchUpInside)
        view.addSubview(btnPravicy)
        btnPravicy.snp.makeConstraints { make in
            make.edges.equalTo(lblPravicy)
        }
        
        let btnSignin = UIButton(type: .custom).then { btn in
            btn.setBackgroundImage(UIImage(named: "sp_signinBtnlogin"), for: .normal)
            btn.titleLabel?.font = UIFont.puFont(size: 20)
            btn.setTitle("Log in", for: .normal)
            btn.setTitleColor(.black, for: .normal)
        }
        view.addSubview(btnSignin)
        btnSignin.addTarget(self, action: #selector(signinAction), for: .touchUpInside)
        btnSignin.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.top.equalTo(btnPravicy.snp.bottom).offset(72)
            make.height.equalTo(72)
        }
    }
    
    @objc func maidianFirst() {
        let timeJieshu = Int(Date().timeIntervalSince1970 * 1000)
        SPNetRequest.spUpTrack(molested: "", barriers: "1", swife: self.timeBegin, admired: timeJieshu)
        callback = nil
        
        SPPrint("埋点一")
    }
    
    @objc func getVeriCode(_ btn: UIButton) {
        guard let strPhone = phoneTextfield.text, strPhone.count >= minPhoneCount else {
            view.errorMsg(str: "Please enter the correct phone number")
            return
        }
        
        SPNetRequest
            .spRequestHandyData(showHud: view, SPZeroModel.self, url: "/behaved_theres", para: ["overtures": strPhone, "civilized": "klpsas"])
            .subscribe(onNext: { [weak self] bigModel in
                self?.view.errorMsg(str: bigModel?.exhaustion)
                if bigModel?.ofdiffident == 0 {
                    self?._countDown()
                }
            }).disposed(by: rx.disposeBag)
    }
    
    /// 倒计时
    private func _countDown() {
        let time = 60
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .take(time)
            .subscribe(onNext: { [weak self] a in
                let attr = NSAttributedString(string: "\(time - a)s",attributes: [ .font: UIFont.puFont(size: 14), .foregroundColor: UIColor.spPlace])
                self?.veriTimerAttr.accept(attr)
                self?.btnVeri.isUserInteractionEnabled = false
            }, onCompleted: { [weak self] in
                let attr = NSAttributedString(string: "Resend",attributes: [ .font: UIFont.puFont(size: 14), .foregroundColor: UIColor(str: "#6BE747") ?? UIColor.spPlace])
                self?.veriTimerAttr.accept(attr)
                self?.btnVeri.isUserInteractionEnabled = true
            })
            .disposed(by: rx.disposeBag)
    }
    
    @objc func pravicyAction() {
        let web = SPNetViewController(SPDomainManager.share.spUserPri, ifFull: false)
        navigationController?.pushViewController(web, animated: true)
    }
    
    @objc func signinAction() {
        guard let strPhone = phoneTextfield.text, strPhone.count >= minPhoneCount,
              let code = veriTextfield.text, code.count == codeCount else {
            view.errorMsg(str: "Please enter the correct phone number and verification code")
            return
        }
        
        view.endEditing(true)
        let hud = view.hudAnimation()
        SPNetRequest.spRequestHandyData(SPSignInModel.self,
                                        url: "/which_hands",
                                        para: ["enemy": strPhone, "hallucinatoryappearance": code, "sudden": "kpas"])
            .subscribe(onNext: { [weak self] bigModel in
                if bigModel?.ofdiffident != 0 {
                    self?.view.errorMsg(str: bigModel?.exhaustion)
                }else {
                    hud.hide(animated: true)
                    SPSelfInfo.share.call = strPhone
                    SPSelfInfo.share.callId = bigModel?.confession?.quiterecently
                    NotificationCenter.default.post(name: .dengluSuccess, object: nil)
                    SPLocation.share.uploadLocation()
                    
                    self?.navigationController?.dismiss(animated: true)
                }
            }).disposed(by: rx.disposeBag)
    }
}
