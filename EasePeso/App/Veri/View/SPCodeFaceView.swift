//
//  SPCodeFaceView.swift
//  EasePeso
//
//  Created by apple on 2024/4/3.
//  人脸数据

import UIKit
import OpenCombine

import AAILivenessSDK
import AAILiveness

class SPCodeFaceView: UIView {
    var paizhaoBack: (()-> Void)?
    var completeThis: (()-> Void)?
    var successBack: ((UIImage, String)-> Void)?
    var timeBegin: Int = 0
    
    /// 产品id
    var liberal: String?
    var imgUrl: String? {
        didSet {
            guard let imgUrl = imgUrl, !imgUrl.isEmpty else {
                return
            }
            imgFaceView.kf.setImage(with: URL(string: imgUrl), placeholder: UIImage(named: "sp_code_face_place"))
            btnVeri.setTitle("Submit and Next", for: .normal)
        }
    }
    let imgFaceView = UIImageView(image: UIImage(named: "sp_code_face_place"))
    lazy var btnVeri = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "sp_code_id_commit_enable"), for: .normal)
        btn.setTitle("Go to Verification", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.puFont(size: 20)
        btn.addTarget(self, action: #selector(veriAction), for: .touchUpInside)
        
        return btn
    }()
    
    /// adv数据
    var advModel: SPCodeADVCheckModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black.withAlphaComponent(0.8)
        _initView()
    }
    
    private func _initView() {
        let backImgView = UIImageView(image: UIImage(named: "sp_code_face"))
        backImgView.isUserInteractionEnabled = true
        addSubview(backImgView)
        backImgView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        let imgBoxView = UIImageView(image: UIImage(named: "sp_code_faceBox"))
        backImgView.addSubview(imgBoxView)
        imgBoxView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(109)
        }
        
        backImgView.addSubview(imgFaceView)
        imgFaceView.snp.makeConstraints { make in
            make.center.equalTo(imgBoxView)
            make.size.equalTo(CGSize.init(width: 145, height: 145))
        }
        
        let btnClose = UIButton()
        btnClose.addTarget(self, action: #selector(xiaoshi), for: .touchUpInside)
        backImgView.addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(44)
        }
        
        backImgView.addSubview(btnVeri)
        btnVeri.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.height.equalTo(64)
            make.bottom.equalToSuperview().offset(-13 - SPKit.bottomAreaHeight)
        }
    }
    
    /// 检查Advance调用次数
    func _advCheck(complete: @escaping (()-> Void)) {
        SPNetRequest
            .spRequestHandyData(showHud: self, SPCodeADVCheckModel.self, url: "/shape_fluke")
            .subscribe(onNext: { bigModel in
                self.advModel = bigModel?.confession
                complete()
            })
            .disposed(by: rx.disposeBag)
    }
    
    @objc func veriAction() {
        if btnVeri.currentTitle == "Submit and Next" {
            SPNetRequest
                .spRequestHandyData(SPZeroModel.self, url: "/right_people", para: ["liberal": liberal ?? ""])
                .subscribe(onNext: { [weak self] _ in
                    NotificationCenter.default.post(name: .spCodeNext, object: nil)
                    self?.xiaoshi()
                    self?.completeThis?()
                })
                .disposed(by: rx.disposeBag)
        }else {
            if self.advModel != nil {
                SPCamAndLibPermission.camAction()
                    .subscribe(onNext: { ok in
                        if ok {
                            if self.advModel?.fluke == "1" {
                                self.paizhaoBack?()
                            }else {
                                self._huoti()
                            }
                        }
                    })
                    .disposed(by: self.rx.disposeBag)
            }else {
                _advCheck {
                    SPCamAndLibPermission.camAction()
                        .subscribe(onNext: { ok in
                            if ok {
                                if self.advModel?.fluke == "1" {
                                    self.paizhaoBack?()
                                }else {
                                    self._huoti()
                                }
                            }
                        })
                        .disposed(by: self.rx.disposeBag)
                }
            }
        }
    }
    
    private func _huoti() {
        timeBegin = Int(Date().timeIntervalSince1970 * 1000)
        AAILivenessSDK.initWith(.philippines)
        let aaiResult = AAILivenessSDK.configLicenseAndCheck(advModel?.otherand ?? "")
        if aaiResult == "SUCCESS" {
            let aaiVc = AAILivenessViewController()
            self.vc?.navigationController?.pushViewController(aaiVc, animated: true)
            
            aaiVc.detectionSuccessBlk = { vc, resu in
                self.imgFaceView.image = resu.fullFaceImg
                self.btnVeri.setTitle("Submit and Next", for: .normal)
                aaiVc.navigationController?.popViewController(animated: true)
                self.successBack?(resu.fullFaceImg, resu.livenessId)
            }
        }else {
            print("aaiResult == \(aaiResult)")
        }
    }
    
    @objc func xiaoshi() {
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
