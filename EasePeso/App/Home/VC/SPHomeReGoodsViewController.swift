//
//  SPHomeReGoodsViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/18.
//  复贷列表

import UIKit

class SPHomeReGoodsViewController: SPBaseViewController {

    lazy var stView = {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .fill
        v.spacing = 15
        
        return v
    }()
    
    private var arrData: [SPHomeSectionItemModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(str: "#3F7774")
        _initView()
        _getData()
    }
    
    private func _getData() {
        SPNetRequest
            .spRequestHandyData(showHud: view, SPRecommandModel.self, url: "/drugged_mother", method: .get, para: ["ofdisability": "ppos", "rescues": "mklps"])
            .subscribe(onNext: { homeModel in
                self.arrData = homeModel?.confession?.indulgent
                self.createGoodsView(self.arrData)
            })
            .disposed(by: rx.disposeBag)
    }
    
    func createGoodsView(_ arrItemModels: [SPHomeSectionItemModel]?) {
        stView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if let arrItemModels = arrItemModels {
            arrItemModels.forEach { stView.addArrangedSubview(_createGoodItemView(itemModel: $0)) }
        }
    }
    
    private func _initView() {
        _createNaviView()
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPKit.topAreaHeight + 44, left: 0, bottom: 0, right: 0))
        }
        
        scrollView.addSubview(stView)
        stView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 28, left: 0, bottom: 0, right: 0))
            make.width.equalTo(SPKit.width - 30)
        }
    }
    
    private func _createGoodItemView(itemModel: SPHomeSectionItemModel)-> UIView {
        let itemView = UIView()
        
        let imgLogoBackView = UIImageView(image: UIImage(named: "sp_code_orderList_LogoBack"))
        itemView.addSubview(imgLogoBackView)
        
        let imgLogoView = UIImageView()
        imgLogoView.kf.setImage(with: URL(string: itemModel.yetpossible ?? ""), placeholder: UIImage(named: "sp_orderList_logo_place"))
        imgLogoBackView.addSubview(imgLogoView)
        
        imgLogoBackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        imgLogoView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.width.height.equalTo(56)
        }
        
        let backImgView = UIImageView(image: UIImage(named: "sp_home_goodsContent"))
        backImgView.isUserInteractionEnabled = true
        itemView.insertSubview(backImgView, belowSubview: imgLogoBackView)
        backImgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(21)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
        }
        let lblName = UILabel()
        lblName.font = UIFont.puFont(size: 14)
        lblName.textColor = UIColor(str: "#76FB4C")
        lblName.text = itemModel.trust
        itemView.addSubview(lblName)
        lblName.snp.makeConstraints { make in
            make.leading.equalTo(imgLogoBackView.snp.trailing).offset(4)
            make.top.equalToSuperview().offset(2)
        }
        
        let lblDays = UILabel()
        lblDays.isHidden = true
        lblDays.font = UIFont.puFont(size: 14)
        lblDays.textColor = UIColor(str: "#7F3C2D")
        backImgView.addSubview(lblDays)
        lblDays.snp.makeConstraints { make in
            make.leading.equalTo(lblName)
            make.top.equalToSuperview().offset(11)
        }
        if let skinniness = itemModel.skinniness, !skinniness.isEmpty {
            lblDays.isHidden = false
            lblDays.text = skinniness
        }
        
        let lblMoney = UILabel()
        lblMoney.text = itemModel.magical
        lblMoney.font = UIFont.puFont(size: 24)
        lblMoney.textColor = .white
        backImgView.addSubview(lblMoney)
        lblMoney.snp.makeConstraints { make in
            make.leading.equalTo(lblName)
            if lblDays.isHidden {
                make.top.equalToSuperview().offset(11)
            }else {
                make.top.equalTo(lblDays.snp.bottom).offset(3)
            }
        }
        
        let lblMoneyDesc = UILabel()
        lblMoneyDesc.text = itemModel.andshe
        lblMoneyDesc.font = UIFont.puFont(size: 14)
        lblMoneyDesc.textColor = UIColor(str: "#385459")
        backImgView.addSubview(lblMoneyDesc)
        lblMoneyDesc.snp.makeConstraints { make in
            make.leading.equalTo(lblName)
            make.top.equalTo(lblMoney.snp.bottom).offset(5)
        }
        
        let btnApply = UIButton()
        btnApply.setImage(UIImage(named: "sp_home_good_canApply"), for: .normal)
        backImgView.addSubview(btnApply)
        btnApply.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.trailing.equalToSuperview().offset(-9)
        }
        
        let imgReView = UIImageView(image: UIImage(named: "sp_home_good_retake"))
        itemView.insertSubview(imgReView, belowSubview: backImgView)
        imgReView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(backImgView.snp.bottom).offset(-13)
            make.bottom.equalToSuperview()
        }
        
        let btnCover = UIButton()
        btnCover.backgroundColor = .clear
        itemView.addSubview(btnCover)
        btnCover.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        btnCover.rx.tap
            .asSignal()
            .emit(onNext: { [weak self] _ in
                if SPLocation.share.auth == .denied || SPLocation.share.auth == .restricted {
                    SPPremissionView.showPremission(.location)
                    return
                }
                if let proId = itemModel.hateful {
                    self?.getAccessDa(proId)
                }
            })
            .disposed(by: rx.disposeBag)
        
        return itemView
    }
    
    func getAccessDa(_ proId: String) {
        SPNetRequest
            .spRequestHandyData(showHud: view, SPZhunruModel.self, url: "/required_running", para: ["liberal": proId, "reaction": String.suijiStr(), "triggers": String.suijiStr()])
            .subscribe(onNext: { homeModel in
                judge(homeModel?.confession?.honored, from: self)
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func _createNaviView() {
        let imgHeight: CGFloat = 44
        let titleView = UIImageView(image: UIImage(named: "sp_profile_list_top"))
        titleView.isUserInteractionEnabled = true
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(SPKit.topAreaHeight + imgHeight)
        }
        
        let centerView = UIView()
        titleView.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(SPKit.topAreaHeight)
            make.height.equalTo(imgHeight)
        }
        
        let lblTitle = UILabel()
        lblTitle.text = "Recommended"
        lblTitle.font = UIFont.puFont(size: 20)
        lblTitle.textColor = .white
        centerView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(44)
        }
        
        let btnBack = UIButton(type: .custom)
        btnBack.rx.tap.asSignal().emit(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        btnBack.setImage(UIImage(named: "sp_home_naviBack"), for: .normal)
        titleView.addSubview(btnBack)
        btnBack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(lblTitle)
            make.width.height.equalTo(44)
        }
    }
}
