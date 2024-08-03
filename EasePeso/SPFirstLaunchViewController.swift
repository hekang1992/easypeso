//
//  SPFirstLaunchViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/18.
//

import UIKit
import Alamofire

class SPFirstLaunchViewController: UIViewController {
    deinit {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let imgView = UIImageView(image: UIImage(named: "sp_launch"))
        imgView.contentMode = .scaleAspectFill
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        guard let hadAgree = UserDefaults.standard.value(forKey: "sp_had_agree") as? Bool, hadAgree else {
            _agree()
            return
        }
        _netMonter()
    }
    
    private func _agree() {
        let agreeView = SPAgreeView(frame: view.bounds)
        view.addSubview(agreeView)
        agreeView.agreeCallback = {
            self._netMonter()
        }
    }
    
    private func _netMonter() {
        SPPrint("_netMonter _netMonter _netMonter")
        let monter = NetworkReachabilityManager()
        monter?.startListening(onUpdatePerforming: { netReach in
            switch netReach {
            case .reachable(_):
                monter?.stopListening()
                self.checkUrl()
            default:
                SPPrint("net disable")
            }
        })
    }
    
    private func checkUrl() {
        SPNetRequest.checkUrl {
            self._requestHomeData()
            SPIDManager.fetchIdfaAndUp()
            
            if SPSelfInfo.share.selfIn {
                SPLocation.share.uploadLocation()
            }
        }
    }
    
    private func _requestHomeData() {
        SPNetRequest
            .spRequestHandyData(SPHomeModel.self, url: "/light_rough", para: ["ofdisability": "ppos", "rescues": "mklps"])
            .subscribe(onNext: { bigModel in
                let homeModel = bigModel?.confession
                if homeModel?.wasgo == nil {
                    let homeVc = SPHomeSecondViewController()
                    homeVc.ifFirst = true
                    homeVc.homeModel = homeModel
                    
                    SPKit.window?.rootViewController = SPBaseNaviViewController(rootViewController: homeVc)
                }else {
                    let homeVc = SPHomeViewController()
                    homeVc.ifFirst = true
                    homeVc.homeModel = homeModel
                    
                    SPKit.window?.rootViewController = SPBaseNaviViewController(rootViewController: homeVc)
                }
            })
            .disposed(by: rx.disposeBag)
    }
}

class SPAgreeView: UIView {
    var agreeCallback: (()-> Void)?
    let contentView = UIView(frame: CGRect(x: 0, y: SPKit.height, width: SPKit.width, height: 0.8 * SPKit.height))
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        
        UIView.animate(withDuration: 0.25) {
            self.contentView.frame = CGRect(x: 0, y: 0.2 * SPKit.height, width: SPKit.width, height: 0.8 * SPKit.height)
            self.backgroundColor = .black.withAlphaComponent(0.3)
        }
        
        let topView = SPCodeIDTitleView(title: "Loan agreement")
        topView.btnClose.isHidden = true
        contentView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        let scView = UIScrollView()
        scView.backgroundColor = UIColor(str: "#19427B")
        scView.showsVerticalScrollIndicator = false
        contentView.insertSubview(scView, belowSubview: topView)
        scView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
        }
        
        let str = """
                Loan Agreement

                Welcome to Our APP (hereinafter referred to as "we"). As a premium product under UPK LENDING CORP, we are committed to providing users with efficient and convenient loan services, to alleviate your urgent needs and ensure your peace of mind.

                Loan Provider Information
                Company Info: UPK LENDING CORP
                Address: 26 Bldg.  B, Great Mall of Luzon, Xevera Subd., Mabalacat, Philippines, 2010
                Email:support@upklending.com
                SEC.NO.CS201800385
                CA.NO.2642

                Overview of Loan Information
                Loan Amount Range: Starting from a minimum of 3000 Philippine pesos(PHP) to a maximum of 70,000 Philippine pesos(PHP).
                Annual Percentage Rate (APR): Ranges from a minimum of 19% to a maximum of 31%, equivalent to a daily interest rate of only 0.05% to 0.08%, allowing you to easily grasp the borrowing cost.
                Loan Term: Flexibly selectable, ranging from a minimum of 91 days to a maximum of 365 days.

                Application Conditions
                We welcome Filipino citizens aged between 18 and 60 with good credit records to apply. You can choose to receive loans through bank transfers or e-wallets, and we will ensure that the funds reach your designated account safely and quickly. During the application process, we may need to collect your personal information, such as name, age, etc., as well as location and device information. However, please rest assured that we will strictly protect the security of this information, store it using advanced data encryption technology, and prevent any unauthorized access.

                Application Process
                Just a few simple steps to easily apply for a loan: Install the our app, complete registration, and fill in the necessary authentication information. After successful authentication, we will review your application information. Once approved, the loan amount will be quickly disbursed to your designated account.

                Overdue Handling Plan
                We understand that unexpected circumstances may lead to delays in repayment. Therefore, we will remind you one day before the repayment date. If you do encounter difficulties that prevent you from repaying on time, we will actively communicate with you to negotiate and formulate a repayment plan that suits your actual situation. However, please note that overdue repayment may have a negative impact on your credit record and may affect your future loan amount.

                Dispute Resolution Mechanism
                If you encounter any problems or disputes during use, we provide the following resolution methods:
                1. Friendly negotiation: We encourage both parties to resolve disputes through friendly negotiation, based on integrity and respect, fully communicate, and reach consensus. We have an excellent customer service team available to assist you at any time.
                2. Mediation: If friendly negotiation fails to resolve the dispute, both parties may choose to submit the dispute to a mutually agreed third-party mediation organization for mediation. During mediation, both parties should abide by the rules and procedures of the mediation organization and respect the mediation results.
                3. Arbitration: If mediation fails or both parties do not choose mediation, either party has the right to submit the dispute to the agreed arbitration institution for arbitration. The arbitration award is legally binding, and both parties should comply with it.
                4. Litigation: Subject to compliance with laws and regulations, if arbitration fails to resolve the dispute, either party may file a lawsuit with a competent court. During litigation, both parties should abide by the rules and procedures of the court and accept the court's judgment or ruling.

                Contact Us
                If you have any questions, suggestions, or need assistance, please feel free to contact us via the following methods:
                Email:support@upklending.com
                Address: 26 Bldg.  B, Great Mall of Luzon, Xevera Subd., Mabalacat, Philippines, 2010
                We promise to respond to your email as soon as possible and resolve any issues for you. Thank you for choosing us, and we are committed to serving you wholeheartedly!
                """
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 8
        let attr = NSAttributedString(string: str, attributes: [
            .paragraphStyle: para,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.white
        ])
        let lblDetail = UILabel()
        lblDetail.numberOfLines = 0
        lblDetail.attributedText = attr
        scView.addSubview(lblDetail)
        lblDetail.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 30, left: 24, bottom: 150, right: 24))
            make.width.equalTo(SPKit.width - 48)
        }
        
        let btnAgree = UIButton()
        btnAgree.setTitle("Agree", for: .normal)
        btnAgree.titleLabel?.font = UIFont.puFont(size: 20)
        btnAgree.setTitleColor(.black, for: .normal)
        btnAgree.setBackgroundImage(UIImage(named: "sp_code_blueBack"), for: .normal)
        contentView.addSubview(btnAgree)
        btnAgree.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(64)
        }
        
        let btnDisAgree = UIButton()
        btnDisAgree.setTitle("Disagree", for: .normal)
        btnDisAgree.titleLabel?.font = UIFont.puFont(size: 20)
        btnDisAgree.setTitleColor(.black, for: .normal)
        btnDisAgree.setBackgroundImage(UIImage(named: "sp_code_id_commit_enable"), for: .normal)
        contentView.addSubview(btnDisAgree)
        btnDisAgree.snp.makeConstraints { make in
            make.leading.equalTo(btnAgree.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.width.height.equalTo(btnAgree)
        }
        
        btnAgree.rx.tap
            .asSignal()
            .emit(onNext: { [weak self] _ in
                UserDefaults.standard.setValue(true, forKey: "sp_had_agree")
                self?.closeSelf()
                self?.agreeCallback?()
            }).disposed(by: rx.disposeBag)
        
        btnDisAgree.rx.tap
            .asSignal()
            .emit(onNext: { _ in
            exit(0)
        }).disposed(by: rx.disposeBag)
    }
    
    @objc func closeSelf() {
        UIView.animate(withDuration: 0.25) {
            self.contentView.frame = CGRect(x: 0, y: SPKit.height, width: SPKit.width, height: 0.8 * SPKit.height)
            self.backgroundColor = .black.withAlphaComponent(0)
        } completion: { finish in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
