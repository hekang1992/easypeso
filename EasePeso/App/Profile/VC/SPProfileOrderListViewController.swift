//
//  SPProfileOrderListViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/7.
//  订单列表

import UIKit
import OpenCombine

class SPProfileOrderListViewController: SPBaseViewController {
    
    /// 状态 4全部 5已结清 6待还款 7进行中 8放款失败 9两天内逾期的订单
    var marryyou: String = "4"
    
    private var setCancel = Set<AnyCancellable>()
    /// 数据源
    private var arrOrders: [SPProfileOrderListModel]? {
        didSet {
            guard let arrOrders = arrOrders, !arrOrders.isEmpty else {
                emptyPlace.isHidden = false
                return
            }
            emptyPlace.isHidden = true
        }
    }
    
    private lazy var lblTitle = {
        let lbl = UILabel()
        lbl.font = UIFont.puFont(size: 20)
        lbl.textColor = .white
        
        return lbl
    }()
    
    lazy var tabView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.separatorStyle = .none
        tab.dataSource = self
        tab.delegate = self
        tab.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tab.contentOffset = .init(x: 0, y: -10)
        tab.register(SPOrderListTableViewCell.self, forCellReuseIdentifier: "SPOrderListTableViewCell")
        
        return tab
    }()
    /// 空白页面
    private lazy var emptyPlace = {
        let lbl = UILabel()
        lbl.text = "No Orders at the Moment"
        lbl.textColor = .white
        lbl.font = UIFont.puFont(size: 18)
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    /// 底部选择
    lazy var selectView = SPOrderListBottomSelectView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(str: "#3F7774")
        
        _initView()
        lblTitle.text = _mapTapToTitle(from: marryyou)
        
        selectView.callback = { [weak self] str in
            self?.marryyou = str
            self?.getData()
            self?.lblTitle.text = self?._mapTapToTitle(from: str)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    @objc func selectAction() {
        view.addSubview(selectView)
        selectView.show()
    }
    
    private func _initView() {
        _createNaviView()
        
        tabView.backgroundColor = UIColor(str: "#3F7774")
        view.addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPKit.topAreaHeight + 44, left: 0, bottom: 0, right: 0))
        }
        
        emptyPlace.backgroundColor = UIColor(str: "#3F7774")
        emptyPlace.isHidden = true
        view.addSubview(emptyPlace)
        emptyPlace.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPKit.topAreaHeight + 44, left: 0, bottom: 0, right: 0))
        }
    }
    
    private func getData() {
        SPNetRequest.spRequestHandyData(showHud: view, SPProfileOrderModels.self, url: "/about_could", para: ["marryyou": marryyou])
            .subscribe(onNext: { bigModel in
                self.arrOrders = bigModel?.confession?.indulgent
                self.tabView.reloadData()
            }).disposed(by: rx.disposeBag)
    }
    
    private func _mapTapToTitle(from str: String)-> String {
        if str == "4" {
            return "All Orders"
        }else if str == "5" {
            return "Settled"
        }else if str == "6" {
            return "Outstanding Orders"
        }else if str == "7" {
            return "Application in Progress"
        }else if str == "9" {
            return "Outstanding Orders"
        }
        return "All Orders"
    }
}

extension SPProfileOrderListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrOrders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SPOrderListTableViewCell", for: indexPath) as! SPOrderListTableViewCell
        let model = arrOrders?[indexPath.row]
        
        if let daffodils = model?.daffodils, daffodils > 0 {
            cell.lblOverTime.isHidden = false
            if daffodils > 1 {
                cell.lblOverTime.text = "OVERDUE FOR \(daffodils) DAYS"
            }else {
                cell.lblOverTime.text = "OVERDUE FOR \(daffodils) DAY"
            }
        }else {
            cell.lblOverTime.isHidden = true
        }
        
        cell.imgLogoView.kf.setImage(with: URL(string: model?.yetpossible ?? ""), placeholder: UIImage(named: "sp_orderList_logo_place"))
        let arr = [model?.tousled, model?.bloom].compactMap { $0 }
        if arr.count > 1 {
            cell.lblTime.text = arr.joined(separator: ": ")
        }else {
            cell.lblTime.text = arr.joined()
        }
        
        let arrMoney = [model?.jikiwl, model?.maroon].compactMap { $0 }
        if arrMoney.count > 1 {
            cell.lblMoney.text = arrMoney.joined(separator: ": ")
        }else {
            cell.lblMoney.text = arrMoney.joined()
        }
        cell.lblName.text = model?.trust
        
        if let pairof = model?.pairof, !pairof.isEmpty {
            cell.imgBackView.image = UIImage(named: "sp_order_more")
            cell.imgDetailView.isHidden = false
            cell.lblDetail.text = pairof
            if model?.andhid == "200" {
                cell.lblDetail.textColor = UIColor(str: "#385459")
            }else {
                cell.lblDetail.textColor = UIColor(str: "#E49E46")
            }
        }else {
            /// 订单状态  逾期180    待还款：174   还款成功200
            if model?.andhid == "174" {
                cell.imgBackView.image = UIImage(named: "sp_code_orderList_toPay")
                cell.imgDetailView.isHidden = true
            }else if model?.andhid == "180" {
                cell.imgBackView.image = UIImage(named: "sp_code_orderListOutDay")
                cell.imgDetailView.isHidden = true
            }else {
                cell.imgBackView.image = UIImage(named: "sp_code_orderList_doing")
                cell.imgDetailView.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = arrOrders?[indexPath.row]
        judge(model?.sleepily, from: self)
    }
}

extension SPProfileOrderListViewController {
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
        
        centerView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(44)
        }
        
        let imgViewXia = UIImageView(image: UIImage(named: "sp_code_orderListxiajian"))
        centerView.addSubview(imgViewXia)
        imgViewXia.snp.makeConstraints { make in
            make.leading.equalTo(lblTitle.snp.trailing).offset(4)
            make.centerY.equalTo(lblTitle)
            make.trailing.equalToSuperview()
        }
        let btnSelect = UIButton()
        btnSelect.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        centerView.addSubview(btnSelect)
        btnSelect.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
