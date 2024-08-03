//
//  SPCodeBankViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/7.
//  银行卡

import UIKit
import MarqueeLabel
import RxSwift

class SPCodeBankViewController: SPBaseViewController {
    var liberal: String?
    private let queeView = UIView()
    private lazy var tabView = UITableView(frame: .zero, style: .plain)
    private lazy var bottomView = SPCodeFriendFooterView(frame: .zero)
    /// 数据源
    private var bankModel: SPCodeBankModel?
    private var seletIndex: Int = 0
    
    private var obsFrist: Observable<[Bool]>!
    private var obsSecond: Observable<[Bool]>!
    private var obsAble: BehaviorSubject<Observable<[Bool]>>!
    
    private var timeBegin = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initView()
        _getData()
        
        timeBegin = Int(Date().timeIntervalSince1970 * 1000)
    }
    
    private func _initView() {
        queeView.backgroundColor = UIColor(str: "#C74E4C")
        view.addSubview(queeView)
        queeView.snp.makeConstraints { make in
            make.left.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(SPKit.topAreaHeight + 20)
            make.height.equalTo(67)
        }
        
        let imgQueeView = UIImageView(image: UIImage(named: "sp_horse_noti"))
        queeView.addSubview(imgQueeView)
        imgQueeView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-11)
        }
        
        let lblQuee = MarqueeLabel(frame: .zero, rate: 25, fadeLength: 10)
        lblQuee.text = "If you input the wrong account number, it may result in the failure to receive funds. Please make sure to double-check and ensure accuracy to avoid any payment issues"
        lblQuee.font = UIFont.puFont(size: 14)
        lblQuee.textColor = .white
        queeView.addSubview(lblQuee)
        lblQuee.snp.makeConstraints { make in
            make.leading.equalTo(imgQueeView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(imgQueeView)
        }
        
        tabView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 104, right: 0)
        tabView.sectionHeaderHeight = 0
        tabView.delegate = self
        tabView.dataSource = self
        tabView.separatorStyle = .none
        tabView.backgroundColor = UIColor.clear
        view.addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.top.equalTo(queeView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomStepHeight)
        }
        
        tabView.register(SPCodeBankTypeCell.self, forCellReuseIdentifier: "SPCodeBankTypeCell")
        tabView.register(SPCodeBankTableViewCell.self, forCellReuseIdentifier: "SPCodeBankTableViewCell")
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-bottomStepHeight)
            make.height.equalTo(104)
        }
        
        bottomView.callback = { [weak self] in
            self?._tijiaoData()
        }
    }
    
    private func _bindData() {
        let arrObsFrist = self.bankModel?.wantto?.first?.wantto?.compactMap({ $0.obsFillIn })
        let arrObsSecond = self.bankModel?.wantto?.last?.wantto?.compactMap({ $0.obsFillIn })
        
        obsFrist = Observable.combineLatest(arrObsFrist!)
        obsSecond = Observable.combineLatest(arrObsSecond!)
        obsAble = BehaviorSubject(value: obsFrist)
        
        obsAble
            .flatMapLatest { $0 }
            .subscribe(onNext: { arrAble in
                let dis = arrAble.first { $0 == false }
                if dis == nil {
                    // 可以点击
                    self.bottomView.btnEnable = true
                }else {
                    // 不可点击
                    self.bottomView.btnEnable = false
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func _getData() {
        SPNetRequest
            .spRequestHandyData(showHud: view, SPCodeBankModel.self, url: "/when_all", method: .get, para: ["plead": "0", "staring": String.suijiStr()])
            .subscribe(onNext: { bigModel in
                self.bankModel = bigModel?.confession
                self.tabView.reloadData()
                self.queeView.isHidden = false
                
                self._bindData()
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func _tijiaoData() {
        var dict: [String: Any] = ["liberal": liberal ?? "", "awake": String.suijiStr()]
        if let model = bankModel?.wantto?[seletIndex] {
            dict["scholarshipstudent"] = model.housewives ?? "1"
            if let arrItems = model.wantto {
                for item in arrItems {
                    dict[item.ofdiffident ?? ""] = item.housewives ?? ""
                }
            }
        }
        
        SPNetRequest
            .spRequestHandyData(showHud: view, SPZeroModel.self, url: "/and_dragging", para: dict)
            .subscribe(onNext: { bigModel in
                if bigModel?.ofdiffident == 0 {
                    let timeEnd = Int(Date().timeIntervalSince1970 * 1000)
                    SPNetRequest.spUpTrack(molested: self.liberal ?? "", barriers: "8", swife: self.timeBegin, admired: timeEnd)
                    
                    NotificationCenter.default.post(name: .spCodeNext, object: nil)
                }else {
                    self.view.errorMsg(str: bigModel?.exhaustion)
                }
            })
            .disposed(by: rx.disposeBag)
    }
}

extension SPCodeBankViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (bankModel?.wantto?.first?.wantto?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SPCodeBankTypeCell", for: indexPath) as! SPCodeBankTypeCell
            cell.btnFrist.setTitle(bankModel?.wantto?.first?.witty, for: .normal)
            cell.btnSecond.setTitle(bankModel?.wantto?.last?.witty, for: .normal)
            
            if self.seletIndex == 0 {
                cell.btnFrist.isSelected = true
                cell.btnSecond.isSelected = false
            }else {
                cell.btnFrist.isSelected = false
                cell.btnSecond.isSelected = true
            }
            
            cell.callback = { index in
                self.seletIndex = index
                if index == 0 {
                    self.obsAble.onNext(self.obsFrist)
                }else {
                    self.obsAble.onNext(self.obsSecond)
                }
                tableView.reloadData()
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SPCodeBankTableViewCell", for: indexPath) as! SPCodeBankTableViewCell
            
            if let arrData = bankModel?.wantto?[seletIndex].wantto {
                cell.infomodel = arrData[indexPath.row - 1]
            }
            
            return cell
        }
    }
}
