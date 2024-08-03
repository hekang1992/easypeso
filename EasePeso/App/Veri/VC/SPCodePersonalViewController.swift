//
//  SPCodePersonalViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/12.
//  个人信息

import UIKit

import RxSwift

class SPCodePersonalViewController: SPCodeBaseViewController {
    var liberal: String?
    var arrModels: [SPCodeInfoModel]?
    
    /// 0:  用户信息  1：工作信息
    var type: Int = 0
    var timeBegin = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        timeBegin = Int(Date().timeIntervalSince1970 * 1000)
    }
    
    override func tijiaoData() {
        super.tijiaoData()
        if let arrModels = arrModels {
            var dict: [String: Any] = ["valuable": String.suijiStr(), "liberal": liberal ?? ""]
            for model in arrModels {
                dict[model.ofdiffident ?? ""] = model.housewives
            }
            
            var path = "/shell_public"
            if type == 1 {
                path = "/nopulling_between"
            }
            
            SPNetRequest
                .spRequestHandyData(showHud: view, SPCodeInfoModuleModel.self, url: path, para: dict)
                .subscribe(onNext: { bigModel in
                    if bigModel?.ofdiffident == 0 {
                        let timeEnd = Int(Date().timeIntervalSince1970 * 1000)
                        if self.type == 0 {
                            SPNetRequest.spUpTrack(molested: self.liberal ?? "", barriers: "5", swife: self.timeBegin, admired: timeEnd)
                        }else {
                            SPNetRequest.spUpTrack(molested: self.liberal ?? "", barriers: "6", swife: self.timeBegin, admired: timeEnd)
                        }
                        NotificationCenter.default.post(name: .spCodeNext, object: nil)
                    }else {
                        self.view.errorMsg(str: bigModel?.exhaustion)
                    }
                })
                .disposed(by: rx.disposeBag)
        }
    }
    
    func fetchData() {
        var path = "/though_recommended"
        if type == 1 {
            path = "/is_full"
        }
        SPNetRequest
            .spRequestHandyData(showHud: view, SPCodeInfoModuleModel.self, url: path, para: ["liberal": liberal ?? ""])
            .subscribe(onNext: { bigModel in
                self.arrModels = bigModel?.confession?.wantto?.compactMap { $0 }
                var arr = [BehaviorSubject<Bool>]()
                self.arrModels?.forEach {
                    let itemView = SPCodeItemView(frame: .zero)
                    itemView.infoModel = $0
                    self.stView.addArrangedSubview(itemView)
                    itemView.bottomCancelFirst = {
                        self.view.endEditing(true)
                    }
                    
                    arr.append($0.obsFillIn)
                }
                
                Observable.combineLatest(arr)
                    .subscribe(onNext: { arr in
                        let disable = arr.first { able in
                            able == false
                        }
                        
                        if disable != nil {
                            self.btnTijiao.touchEnable = false
                        }else {
                            self.btnTijiao.touchEnable = true
                        }
                    })
                    .disposed(by: self.rx.disposeBag)
            })
            .disposed(by: rx.disposeBag)
    }
}
