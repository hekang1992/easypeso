//
//  SPCodeFriendViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/7.
//

import UIKit
import OpenCombine
import RxSwift

class SPCodeFriendViewController: SPBaseViewController {
    var liberal: String?
    private var arrData: [SPCodeFriendModel]?
    
    @OpenCombine.Published private var tijiaoEnable = false
    private var setCancel = Set<AnyCancellable>()
    
    private lazy var tabView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.backgroundColor = UIColor.clear
        tab.dataSource = self
        tab.delegate = self
        tab.separatorStyle = .none
        tab.register(SPCodeFriendTableViewCell.self, forCellReuseIdentifier: "SPCodeFriendTableViewCell")
        
        return tab
    }()
    
    var timeBegin = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.spTheme
        
        view.addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPKit.topAreaHeight + 64, left: 0, bottom: bottomStepHeight, right: 0))
        }
        
        _getData()
        
        timeBegin = Int(Date().timeIntervalSince1970 * 1000)
    }
    
    private func _getData() {
        SPNetRequest
            .spRequestHandyData(showHud: view, SPCodeFriend.self, url: "/narrow_would", para: ["liberal": liberal ?? "", "wakethem": String.suijiStr()])
            .subscribe(onNext: { bigModel in
                self.arrData = bigModel?.confession?.weeping?.indulgent
                self.tabView.reloadData()
                
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(200)) {
                    if let arr = self.arrData?.compactMap({ $0.obsFillIn }) {
                        Observable.combineLatest(arr)
                            .subscribe(onNext: { arrBools in
                                let disAble = arrBools.first { dis in
                                    dis == false
                                }
                                if disAble != nil {
                                    self.tijiaoEnable = false
                                }else {
                                    self.tijiaoEnable = true
                                }
                            })
                            .disposed(by: self.rx.disposeBag)
                    }
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func _tijiaoData() {
        guard let arrData = arrData else { return }
        
        var arr = [Any]()
        for model in arrData {
            let dictTemp = [
                "msorry": model.msorry ?? "",
                "ilove": model.ilove ?? "",
                "babbled": model.babbled ?? "",
                "clerk": model.clerk ?? ""
            ]
            
            arr.append(dictTemp)
        }
        var dict: [String: Any] = [:]
        if let data = try? JSONSerialization.data(withJSONObject: arr) {
            let str = String(data: data, encoding: .utf8)
            dict["confession"] = str
        }
        dict["liberal"] = liberal ?? ""
        
        SPNetRequest
            .spRequestHandyData(showHud: view, SPZeroModel.self, url: "/heavenly_valleys", method: .post, para: dict)
            .subscribe(onNext: { bigModel in
                if bigModel?.ofdiffident == 0 {
                    let timeEnd = Int(Date().timeIntervalSince1970 * 1000)
                    SPNetRequest.spUpTrack(molested: self.liberal ?? "", barriers: "7", swife: self.timeBegin, admired: timeEnd)
                    
                    NotificationCenter.default.post(name: .spCodeNext, object: nil)
                }else {
                    self.view.errorMsg(str: bigModel?.exhaustion)
                }
            })
            .disposed(by: rx.disposeBag)
    }
}

extension SPCodeFriendViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SPCodeFriendTableViewCell", for: indexPath) as! SPCodeFriendTableViewCell
        let model = arrData?[indexPath.row]
        cell.model = model
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = SPCodeFriendFooterView(frame: .zero)
        
        $tijiaoEnable
            .assign(to: \.btnEnable, on: footerView)
            .store(in: &setCancel)
        
        footerView.callback = { [weak self] in
            self?._tijiaoData()
        }
        
        return footerView
    }
    
//    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
//        view.backgroundColor = .clear
//    }
}
