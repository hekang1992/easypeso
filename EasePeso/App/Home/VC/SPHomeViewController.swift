//
//  ViewController.swift
//  EasePeso
//
//  Created by apple on 2024/3/26.
//

import UIKit
import SnapKit

class SPHomeViewController: SPBaseViewController {

    // MARK: Data
    var homeModel: SPHomeModel?
    var ifFirst = true
    /// 一共有多少步骤
    private var totleSteps: Int {
        homeModel?.jokeil ?? 3
    }
    private var currentStep: Int {
        if SPSelfInfo.share.selfIn {
            return homeModel?.gollel ?? 0
        }
        return 0
    }
    private var arrKeyPositions: [SPKeyPosition] = []
    /// 保存进度的动画图片
    private var arrStepView: [UIView] = []
    
    // MARK: Views
    /// 底部的背景图
    private let contImgView = UIImageView()
    
    /// 是不是大屏手机  如果是667的高度，就是小屏
    private var ifBigScreen = true
    override func viewDidLoad() {
        super.viewDidLoad()
        ifBigScreen = SPKit.height > 800 ? true : false
        
        spInitView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .spOutNoti, object: nil)
        
        /// 是否已经弹窗
        let hadInstall = UserDefaults.standard.value(forKey: "sp_had_install") as? Bool
        if let hadInstall = hadInstall, hadInstall {
            
        }else {
            ruleAction()
            UserDefaults.standard.setValue(true, forKey: "sp_had_install")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if ifFirst && homeModel != nil {
            configStepItemView()
            ifFirst = false
        }else {
            getData()
        }
    }
    
    // MARK: - 点击事件
    @objc func ruleAction() {
        SPRuleView.showRule(to: self.view)
    }
    
    @objc func questionAction() {
        let faqVc = SPFAQViewController()
        navigationController?.pushViewController(faqVc, animated: true)
    }
    
    @objc func profileAction() {
        if !SPSelfInfo.share.selfIn {
            let signVc = SPSigninViewController()
            let signNaviVc = SPBaseNaviViewController(rootViewController: signVc)
            signNaviVc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(signNaviVc, animated: true)
        }else {
            let podfileVc = SPPodfileSelfViewController()
            let podNaviVc = SPBaseNaviViewController(rootViewController: podfileVc)
            podNaviVc.modalPresentationStyle = .custom
            self.navigationController?.present(podNaviVc, animated: true)
        }
    }
    
    @objc func kaishiAction() {
        if !SPSelfInfo.share.selfIn {
            let signVc = SPSigninViewController()
            let signNaviVc = SPBaseNaviViewController(rootViewController: signVc)
            signNaviVc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(signNaviVc, animated: true)
        }else {
            if homeModel?.thepolice != "1" {
                if SPLocation.share.auth == .denied || SPLocation.share.auth == .restricted {
                    SPPremissionView.showPremission(.location)
                    return
                }
                if let proId = homeModel?.wasgo?.humanitarians?.hateful {
                    getAccessDa(proId)
                }
            }else {
                if let proId = homeModel?.wasgo?.humanitarians?.hateful {
                    getAccessDa(proId)
                }
            }
        }
    }
    
    // MARK: - 设置UI
    private func spInitView() {
        let imgContent = ifBigScreen ? UIImage(named: "sp_home_cont812") : UIImage(named: "sp_home_cont667")
        contImgView.image = imgContent
        contImgView.contentMode = .scaleAspectFit
        contImgView.isUserInteractionEnabled = true
        view.addSubview(contImgView)
        let imgBackSize = imgContent?.size ?? .init(width: 1, height: 1)
        contImgView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo((imgBackSize.height / imgBackSize.width) * SPKit.width)
        }
        
        configTopView()
        
        let btnRules = UIButton(type: .custom)
        btnRules.addTarget(self, action: #selector(ruleAction), for: .touchUpInside)
        btnRules.setImage(UIImage(named: "sp_home_rules"), for: .normal)
        contImgView.addSubview(btnRules)
        btnRules.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
        
        let imgMountainView = UIImageView(image: UIImage(named: "sp_home_Mountain"))
        view.addSubview(imgMountainView)
        imgMountainView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let btnStart = UIButton(type: .custom)
        btnStart.setImage(UIImage(named: "sp_home_kaishi"), for: .normal)
        btnStart.addTarget(self, action: #selector(kaishiAction), for: .touchUpInside)
        view.addSubview(btnStart)
        btnStart.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-SPKit.bottomAreaHeight - 70)
        }
    }
    
    private func configTopView() {
        let topView = UIStackView()
        topView.axis = .horizontal
        topView.distribution = .fillProportionally
        topView.spacing = 10
        topView.alignment = .center
        print("SPKit.topAreaHeight == \(SPKit.topAreaHeight)")
        contImgView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(SPKit.topAreaHeight)
            make.height.equalTo(100)
        }
        
        let maxImgView = UIImageView(image: UIImage(named: "sp_home_maxMoney"))
        topView.addArrangedSubview(maxImgView)
        
        let btnQues = UIButton(type: .custom)
        btnQues.addTarget(self, action: #selector(questionAction), for: .touchUpInside)
        btnQues.setImage(UIImage(named: "sp_home_question"), for: .normal)
        topView.addArrangedSubview(btnQues)
        
        let btnProfile = UIButton(type: .custom)
        btnProfile.addTarget(self, action: #selector(profileAction), for: .touchUpInside)
        btnProfile.setImage(UIImage(named: "sp_home_center"), for: .normal)
        topView.addArrangedSubview(btnProfile)
    }
    
    private func configStepItemView() {
        arrStepView.forEach { $0.removeFromSuperview() }
        addKeyPosition()

        for (_, po) in arrKeyPositions.enumerated() {
            let stepView = SPHomeStepItemView(frame: .zero, po.style)
            contImgView.addSubview(stepView)
            stepView.snp.makeConstraints { make in
                make.centerX.equalTo(contImgView.snp.leading).offset(po.position.x)
                make.centerY.equalTo(contImgView.snp.top).offset(po.position.y)
            }
            
            arrStepView.append(stepView)
        }
        
        let lastView = UIView()
        if ifBigScreen {
            lastView.frame = CGRect(x: SPKit.width - 25 * SPKit.scaleX - 69 * SPKit.scaleX, y: 280 * SPKit.scaleX, width: 69 * SPKit.scaleX, height: 54 * SPKit.scaleX)
        }else {
            lastView.frame = CGRect(x: SPKit.width - 25 * SPKit.scaleX - 69 * SPKit.scaleX, y: 200 * SPKit.scaleX, width: 69 * SPKit.scaleX, height: 54 * SPKit.scaleX)
        }
        arrStepView.append(lastView)
        contImgView.addSubview(lastView)
        
        let imgShanView = UIImageView(image: UIImage(named: "sp_home_lastShan"))
        imgShanView.bounds = lastView.bounds
        imgShanView.addOpacityAnimation(duration: 2)
        imgShanView.contentMode = .scaleAspectFit
        lastView.addSubview(imgShanView)
        
        let imgShanBox = UIImageView(image: UIImage(named: "sp_home_lastBox"))
        imgShanBox.frame = CGRect(x: 0, y: -25, width: 69 * SPKit.scaleX, height: 48 * SPKit.scaleX)
        imgShanBox.contentMode = .scaleAspectFit
        imgShanBox.addPositionAnimation(duration: 1)
        lastView.addSubview(imgShanBox)
    }
    
    // MARK: - 获取数据
    @objc func getData() {
        SPNetRequest
            .spRequestHandyData(showHud: view, SPHomeModel.self, url: "/light_rough", para: ["ofdisability": "ppos", "rescues": "mklps"])
            .subscribe(onNext: { homeModel in
                self.homeModel = homeModel?.confession
                if self.homeModel?.wasgo == nil {
                    NotificationCenter.default.removeObserver(self, name: .spOutNoti, object: nil)
                    let homeVc = SPHomeSecondViewController()
                    homeVc.ifFirst = true
                    homeVc.homeModel = self.homeModel
                    
                    SPKit.window?.rootViewController = SPBaseNaviViewController(rootViewController: homeVc)
                }else {
                    self.configStepItemView()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    /// 请求准入的接口
    /// - Parameter proId: 产品id
    func getAccessDa(_ proId: String) {
        SPNetRequest
            .spRequestHandyData(showHud: view, SPZhunruModel.self, url: "/required_running", para: ["liberal": proId, "reaction": String.suijiStr(), "triggers": String.suijiStr()])
            .subscribe(onNext: { homeModel in
                judge(homeModel?.confession?.honored, from: self)
            })
            .disposed(by: rx.disposeBag)
    }
}

extension SPHomeViewController {
    private func addKeyPosition() {
        arrKeyPositions.removeAll()
        if currentStep == 0 {
            var center0 = CGPoint(x: 130 * SPKit.scaleX, y: 580 * SPKit.scaleX)
            if !ifBigScreen {
                center0 = CGPoint(x: 132 * SPKit.scaleX, y: 446 * SPKit.scaleX)
            }
            arrKeyPositions.append(SPKeyPosition(position: center0, style: .start))
        }
        if totleSteps == 3 {
            var center31 = CGPoint(x: 175 * SPKit.scaleX, y: 480 * SPKit.scaleX)
            var center32 = CGPoint(x: 195 * SPKit.scaleX, y: 305 * SPKit.scaleX)
            
            if !ifBigScreen {
                center31 = CGPoint(x: 192 * SPKit.scaleX, y: 376 * SPKit.scaleX)
                center32 = CGPoint(x: 172 * SPKit.scaleX, y: 226 * SPKit.scaleX)
            }
            
            for i in 1..<totleSteps {
                var point = center31
                if i == 1 {
                    point = center31
                }else {
                    point = center32
                }
                if i < currentStep {
                    arrKeyPositions.append(SPKeyPosition(position: point, style: .complete))
                }else if i == currentStep {
                    arrKeyPositions.append(SPKeyPosition(position: point, style: .step(ifNow: true)))
                }else {
                    arrKeyPositions.append(SPKeyPosition(position: point, style: .step(step: i)))
                }
            }
        }else if totleSteps == 4 {
            var center41 = CGPoint(x: 175 * SPKit.scaleX, y: 480 * SPKit.scaleX)
            var center42 = CGPoint(x: 220 * SPKit.scaleX, y: 400 * SPKit.scaleX)
            var center43 = CGPoint(x: 195 * SPKit.scaleX, y: 305 * SPKit.scaleX)
            
            if !ifBigScreen {
                center41 = CGPoint(x: 182 * SPKit.scaleX, y: 381 * SPKit.scaleX)
                center42 = CGPoint(x: 157 * SPKit.scaleX, y: 276 * SPKit.scaleX)
                center43 = CGPoint(x: 202 * SPKit.scaleX, y: 206 * SPKit.scaleX)
            }
            
            for i in 1..<totleSteps {
                var point = center41
                if i == 1 {
                    point = center41
                }else if i == 2 {
                    point = center42
                }else {
                    point = center43
                }
                
                if i < currentStep {
                    arrKeyPositions.append(SPKeyPosition(position: point, style: .complete))
                }else if i == currentStep {
                    arrKeyPositions.append(SPKeyPosition(position: point, style: .step(ifNow: true)))
                }else {
                    arrKeyPositions.append(SPKeyPosition(position: point, style: .step(step: i)))
                }
            }
        }else {
            var center51 = CGPoint(x: 175 * SPKit.scaleX, y: 480 * SPKit.scaleX)
            var center52 = CGPoint(x: 250 * SPKit.scaleX, y: 430 * SPKit.scaleX)
            var center53 = CGPoint(x: 150 * SPKit.scaleX, y: 350 * SPKit.scaleX)
            var center54 = CGPoint(x: 230 * SPKit.scaleX, y: 285 * SPKit.scaleX)
            
            if !ifBigScreen {
                center51 = CGPoint(x: 182 * SPKit.scaleX, y: 381 * SPKit.scaleX)
                center52 = CGPoint(x: 217 * SPKit.scaleX, y: 306 * SPKit.scaleX)
                center53 = CGPoint(x: 157 * SPKit.scaleX, y: 276 * SPKit.scaleX)
                center54 = CGPoint(x: 202 * SPKit.scaleX, y: 206 * SPKit.scaleX)
            }
            
            for i in 1..<totleSteps {
                var point = center51
                if i == 1 {
                    point = center51
                }else if i == 2 {
                    point = center52
                }else if i == 3 {
                    point = center53
                }else {
                    point = center54
                }
                
                if i < currentStep {
                    arrKeyPositions.append(SPKeyPosition(position: point, style: .complete))
                }else if i == currentStep {
                    arrKeyPositions.append(SPKeyPosition(position: point, style: .step(ifNow: true)))
                }else {
                    arrKeyPositions.append(SPKeyPosition(position: point, style: .step(step: i)))
                }
            }
        }
    }
}
