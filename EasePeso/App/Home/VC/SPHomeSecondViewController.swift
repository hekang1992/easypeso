//
//  SPHomeSecondViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/17.
//  首页2

import UIKit
import TYCyclePagerView
import MJRefresh

class SPHomeSecondViewController: SPBaseViewController {
    var homeModel: SPHomeModel?
    var ifFirst = true
    private let scrollView = UIScrollView()
    private lazy var stView = {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .fill
        v.spacing = 15
        
        return v
    }()
    
    /// 轮播
    private lazy var pageView = {
        let page = TYCyclePagerView(frame: CGRect(x: 0, y: 0, width: SPKit.width - 30, height: 152))
        page.delegate = self
        page.dataSource = self
        page.register(SPHomeBannerCycleCell.self, forCellWithReuseIdentifier: "SPHomeBannerCycleCell")
        
        return page
    }()
    
    /// 复贷
    private lazy var reLoanView = {
        let v = UIView()
        v.addSubview(btnReloan)
        btnReloan.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 14, left: 0, bottom: 0, right: 0))
            make.height.equalTo(50)
        }
        
        return v
    }()
    private lazy var btnReloan: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(reloanAction), for: .touchUpInside)
        return btn
    }()
    
    /// 空白页面
    private lazy var emptyView = {
        let lbl = UILabel()
        lbl.text = "No Data"
        lbl.textColor = .white
        lbl.font = UIFont.puFont(size: 18)
        lbl.textAlignment = .center
        
        return lbl
    }
    
    /// 保存产品view
    private var arrItems = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(str: "#3F7774")

        _initView()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .spOutNoti, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ifFirst && homeModel != nil {
            self._reloadUI()
            ifFirst = false
        }else {
            getData()
        }
    }
    
    @objc private func getData() {
        SPNetRequest
            .spRequestHandyData(showHud: view, SPHomeModel.self, url: "/light_rough", para: ["ofdisability": "ppos", "rescues": "mklps"])
            .subscribe(onNext: { homeModel in
                self.scrollView.mj_header?.endRefreshing()
                
                self.homeModel = homeModel?.confession
                if self.homeModel?.wasgo != nil {
                    NotificationCenter.default.removeObserver(self, name: .spOutNoti, object: nil)
                    let homeVc = SPHomeViewController()
                    homeVc.ifFirst = true
                    homeVc.homeModel = self.homeModel
                    
                    SPKit.window?.rootViewController = SPBaseNaviViewController(rootViewController: homeVc)
                }else {
                    self._reloadUI()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    @objc func reloanAction() {
        let reVc = SPHomeReGoodsViewController()
        navigationController?.pushViewController(reVc, animated: true)
    }
    
    private func _reloadUI() {
        /// banner
        if let bannerData = homeModel?.witnessednatural, let arrBanner = bannerData.humanitarians, !arrBanner.isEmpty {
            self.pageView.isHidden = false
            self.pageView.reloadData()
            if arrBanner.count > 1 {
                self.pageView.autoScrollInterval = 3
            }else {
                self.pageView.autoScrollInterval = 0
            }
        }else {
            self.pageView.isHidden = true
        }
        
        /// 复贷
        if let calculated = homeModel?.calculated, let arrData = calculated.humanitarians, !arrData.isEmpty {
            self.reLoanView.isHidden = false
            let model = arrData.first
            self.btnReloan.kf.setImage(with: URL(string: model?.skillfulpoliticians ?? ""), for: .normal, placeholder: UIImage(named: "sp_home_reloan"))
        }else {
            self.reLoanView.isHidden = true
        }
        
        /// 小卡位
        if let indulgent = homeModel?.indulgent, let arrItems = indulgent.humanitarians, !arrItems.isEmpty {
            createGoodsView(arrItems)
        }else {
            arrItems.forEach { $0.removeFromSuperview() }
            arrItems.removeAll()
        }
    }
    
    func createGoodsView(_ arrItemModels: [SPHomeSectionItemModel]) {
        arrItems.forEach { $0.removeFromSuperview() }
        arrItems.removeAll()
        
        arrItemModels.forEach { arrItems.append(_createGoodItemView(itemModel: $0)) }
        arrItems.forEach { stView.addArrangedSubview($0) }
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
        backImgView.addSubview(btnApply)
        btnApply.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.trailing.equalToSuperview().offset(-9)
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
        
        if let skinniness = itemModel.skinniness, !skinniness.isEmpty { /// 逾期
            btnApply.setImage(UIImage(named: "sp_home_good_repay"), for: .normal)
        }else if let authoritarianism = itemModel.authoritarianism, !authoritarianism.isEmpty { /// 复贷
            btnApply.setImage(UIImage(named: "sp_home_good_canApply"), for: .normal)
            
            let imgReView = UIImageView(image: UIImage(named: "sp_home_good_retake"))
            itemView.insertSubview(imgReView, belowSubview: backImgView)
            imgReView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(backImgView.snp.bottom).offset(-13)
                make.bottom.equalToSuperview()
            }
        }else {
            if itemModel.modish == "1" {
                btnApply.setImage(UIImage(named: "sp_home_good_canApply"), for: .normal)
            }else if itemModel.modish == "2" {
                btnApply.setImage(UIImage(named: "sp_home_good_repay"), for: .normal)
            }else if itemModel.modish == "3" {
                btnApply.setImage(UIImage(named: "sp_home_good_notApply"), for: .normal)
            }
        }
        
        return itemView
    }
    
    private func _configTopView() {
        let imgHeight: CGFloat = 80
        let titleView = UIImageView(image: UIImage(named: "sp_profile_list_top"))
        titleView.isUserInteractionEnabled = true
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(SPKit.topAreaHeight + imgHeight)
        }
        
        let topView = UIStackView()
        topView.axis = .horizontal
        topView.distribution = .fillProportionally
        topView.spacing = 10
        topView.alignment = .center
        print("SPKit.topAreaHeight == \(SPKit.topAreaHeight)")
        titleView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(SPKit.topAreaHeight)
            make.height.equalTo(imgHeight)
        }
        
        let maxImgView = UIImageView(image: UIImage(named: "sp_home_topMoney"))
        topView.addArrangedSubview(maxImgView)
        
        let btnQues = UIButton(type: .custom)
        btnQues.addTarget(self, action: #selector(questionAction), for: .touchUpInside)
        btnQues.setImage(UIImage(named: "sp_home_second_order"), for: .normal)
        topView.addArrangedSubview(btnQues)
        
        let btnProfile = UIButton(type: .custom)
        btnProfile.addTarget(self, action: #selector(profileAction), for: .touchUpInside)
        btnProfile.setImage(UIImage(named: "sp_home_center"), for: .normal)
        topView.addArrangedSubview(btnProfile)
    }
    
    private func _initView() {
        _configTopView()
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPKit.topAreaHeight + 80, left: 0, bottom: 0, right: 0))
        }
        
        scrollView.mj_header = MJRefreshGifHeader(refreshingBlock: { [weak self] in
            self?.getData()
        })
        
        scrollView.addSubview(stView)
        stView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 28, left: 0, bottom: 0, right: 0))
            make.width.equalTo(SPKit.width - 30)
        }
        stView.addArrangedSubview(pageView)
        pageView.snp.makeConstraints { make in
            make.height.equalTo(152)
        }
        
        stView.addArrangedSubview(reLoanView)
        
        pageView.isHidden = true
        reLoanView.isHidden = true
    }
    
    @objc func questionAction() {
//        let faqVc = SPFAQViewController()
//        navigationController?.pushViewController(faqVc, animated: true)
        
        let orderListVc = SPProfileOrderListViewController()
        navigationController?.pushViewController(orderListVc, animated: true)
    }
    
    @objc func profileAction() {
        let podfileVc = SPPodfileSelfViewController()
        let podNaviVc = SPBaseNaviViewController(rootViewController: podfileVc)
        podNaviVc.modalPresentationStyle = .custom
        navigationController?.present(podNaviVc, animated: true)
    }
    
    /// 请求准入的接口
    /// - Parameter proId: 产品id
    func getAccessDa(_ proId: String) {
        if homeModel?.thepolice != "1" {
            if SPLocation.share.auth == .denied || SPLocation.share.auth == .restricted {
                SPPremissionView.showPremission(.location)
                return
            }
        }
        SPNetRequest
            .spRequestHandyData(showHud: view, SPZhunruModel.self, url: "/required_running", para: ["liberal": proId, "reaction": String.suijiStr(), "triggers": String.suijiStr()])
            .subscribe(onNext: { homeModel in
                judge(homeModel?.confession?.honored, from: self)
            })
            .disposed(by: rx.disposeBag)
    }
}

extension SPHomeSecondViewController: TYCyclePagerViewDataSource, TYCyclePagerViewDelegate {
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        homeModel?.witnessednatural?.humanitarians?.count ?? 0
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "SPHomeBannerCycleCell", for: index) as! SPHomeBannerCycleCell
        
        let model = homeModel?.witnessednatural?.humanitarians?[index]
        cell.imgView.kf.setImage(with: URL(string: model?.skillfulpoliticians ?? ""), placeholder: UIImage(named: "sp_home_banner_place"))
        
        return cell
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: SPKit.width - 30, height: 152)
        layout.itemHorizontalCenter = true
        
        return layout
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at index: Int) {
        let model = homeModel?.witnessednatural?.humanitarians?[index]
        judge(model?.honored, from: self)
    }
}

class SPHomeBannerCycleCell: UICollectionViewCell {
    let imgView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
