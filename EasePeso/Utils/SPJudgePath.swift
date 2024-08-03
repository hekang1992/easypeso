//
//  SPJudgePath.swift
//  EasePeso
//
//  Created by apple on 2024/4/9.
//

import UIKit

func judge(_ str: String?, from vc: UIViewController) {
    guard let str = str,
          let url = URL(string: str),
          let sch = url.scheme else { return }
    
    if sch.hasPrefix("http") {
        let netVc = SPNetViewController(str, ifFull: false)
        if let vc = vc as? UINavigationController {
            vc.pushViewController(netVc, animated: true)
        }else {
            vc.navigationController?.pushViewController(netVc, animated: true)
        }
    }else if sch.hasPrefix("qq") {
        let path = url.path
        if path.contains("/girlsAbout") { // 设置
            let setVc = SPProfileSettingViewController()
            if let vc = vc as? UINavigationController {
                vc.pushViewController(setVc, animated: true)
            }else {
                vc.navigationController?.pushViewController(setVc, animated: true)
            }
        }else if path.contains("/asfloPeoples") { // 首页
            if let showVc = UIApplication.topViewController() {
                let arrVcs = [SPPodfileSelfViewController.self, SPProfileOrderListViewController.self, SPProfileAboutUsViewController.self, SPProfileSettingViewController.self, SPProfileDeleteViewController.self, SPSigninViewController.self]
                for vc in arrVcs {
                    if showVc.isKind(of: vc) {
                        showVc.navigationController?.dismiss(animated: true)
                        return
                    }
                }
            }
            
            if let vc = vc as? UINavigationController {
                vc.popToRootViewController(animated: true)
            }else {
                vc.navigationController?.popToRootViewController(animated: true)
            }
        }else if path.contains("/paperBefore") { // 登录页
            let signVc = SPSigninViewController()
            let signNaviVc = SPBaseNaviViewController(rootViewController: signVc)
            signNaviVc.modalPresentationStyle = .fullScreen
            vc.navigationController?.present(signNaviVc, animated: true)
            if let vc = vc as? UINavigationController {
                vc.present(signNaviVc, animated: true)
            }else {
                vc.navigationController?.present(signNaviVc, animated: true)
            }
        }else if path.contains("/roadsThere") { // 订单列表
            let arr = url.query?.components(separatedBy: "=")
            let liberal = arr?.last
            
            let listVc = SPProfileOrderListViewController()
            listVc.marryyou = liberal ?? "4"
            if let vc = vc as? UINavigationController {
                vc.pushViewController(listVc, animated: true)
            }else {
                vc.navigationController?.pushViewController(listVc, animated: true)
            }
        }else if path.contains("/fightSkirt") { // 产品详情
            if let query = url.query {
                let arr = query.components(separatedBy: "=")
                let liberal = arr.last
                pubFetchDetailData(liberal: liberal ?? "", vc: vc) { model in
                    let strNext = model?.sheacknowledged?.throwing
                    if strNext == nil {
                        let timeBegin = Int(Date().timeIntervalSince1970 * 1000)
                        SPNetRequest
                            .spRequestHandyData(showHud: vc.view, SPZhunruModel.self, url: "/being_identicalseemingskins", para: ["savagely": model?.otherplan?.comradely ?? "", "soonas": String.suijiStr(), "wheedling": String.suijiStr(), "unnatural": String.suijiStr(), "sounded": String.suijiStr()])
                            .subscribe(onNext: { accBigModel in
                                if accBigModel?.ofdiffident == 0 {
                                    let timeEnd = Int(Date().timeIntervalSince1970 * 1000)
                                    SPNetRequest.spUpTrack(molested: liberal ?? "", barriers: "9", swife: timeBegin, admired: timeEnd)
                                }
                                if let strUrl = accBigModel?.confession?.honored {
                                    let webVc = SPNetViewController(strUrl, ifFull: false)
                                    vc.navigationController?.pushViewController(webVc, animated: true)
                                }
                            })
                            .disposed(by: vc.rx.disposeBag)
                    }else {
                        let contentVc = SPCodeContentViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                        contentVc.liberal = liberal
                        contentVc.homeModel = model
                        
                        if let vc = vc as? UINavigationController {
                            vc.pushViewController(contentVc, animated: true)
                        }else {
                            vc.navigationController?.pushViewController(contentVc, animated: true)
                        }
                    }
                }
            }
        }else if path.contains("/placesPacks") { // 客服首页
            let netVc = SPNetViewController(SPDomainManager.share.spKefu)
            if let vc = vc as? UINavigationController {
                vc.pushViewController(netVc, animated: true)
            }else {
                vc.navigationController?.pushViewController(netVc, animated: true)
            }
        }else if path.contains("/itselfNoticed") { // 复贷列表
            if let vc = vc as? UINavigationController {
                vc.pushViewController(SPHomeReGoodsViewController(), animated: true)
            }else {
                vc.navigationController?.pushViewController(SPHomeReGoodsViewController(), animated: true)
            }
        }
    }
}

/// 产品详情
func pubFetchDetailData(liberal: String, vc: UIViewController, complete: @escaping ((SPCodeDetailModel?)-> Void)) {
    SPNetRequest
        .spRequestHandyData(showHud: vc.view, SPCodeDetailModel.self, url: "/nobody_still", para: ["liberal": liberal, "price": String.suijiStr(), "economic": String.suijiStr()])
        .subscribe(onNext: { bigModel in
            complete(bigModel?.confession)
        }).disposed(by: vc.rx.disposeBag)
}

func judgeStep(_ model: SPCodeDetailModel?, contentVc: SPCodeContentViewController) {
    contentVc.bottomView.detailModel = model
    contentVc.lblTitle.text = model?.sheacknowledged?.witty
    let strNext = model?.sheacknowledged?.throwing
    if strNext == .idCard {
        let vc = SPCodeIDViewController()
        vc.fatherVc = contentVc
        vc.liberal = contentVc.liberal
        contentVc.setViewControllers([vc], direction: .forward, animated: true) { finish in
            print("finish == \(finish)")
        }
    }else if strNext == .gerenxinxi {
        let vc = SPCodePersonalViewController()
        vc.type = 0
        vc.liberal = contentVc.liberal
        contentVc.setViewControllers([vc], direction: .forward, animated: true) { finish in
            print("finish == \(finish)")
        }
    }else if strNext == .gongzuo {
        let vc = SPCodePersonalViewController()
        vc.type = 1
        vc.liberal = contentVc.liberal
        contentVc.setViewControllers([vc], direction: .forward, animated: true) { finish in
            print("finish == \(finish)")
        }
    }else if strNext == .lianxiren {
        let vc = SPCodeFriendViewController()
        vc.liberal = contentVc.liberal
        contentVc.setViewControllers([vc], direction: .forward, animated: true) { finish in
            print("finish == \(finish)")
        }
    }else if strNext == .yinhang {
        let vc = SPCodeBankViewController()
        vc.liberal = contentVc.liberal
        contentVc.setViewControllers([vc], direction: .forward, animated: true) { finish in
            print("finish == \(finish)")
        }
    }else if strNext == nil {
        let timeBegin = Int(Date().timeIntervalSince1970 * 1000)
        SPNetRequest
            .spRequestHandyData(
                showHud: contentVc.view,
                SPZhunruModel.self,
                url: "/being_identicalseemingskins",
                para: [
                    "savagely": model?.otherplan?.comradely ?? "",
                    "soonas": String.suijiStr(),
                    "wheedling": String.suijiStr(),
                    "unnatural": String.suijiStr(),
                    "sounded": String.suijiStr()])
            .subscribe(onNext: { accBigModel in
                if accBigModel?.ofdiffident == 0 {
                    let timeEnd = Int(Date().timeIntervalSince1970 * 1000)
                    SPNetRequest.spUpTrack(molested: model?.otherplan?.hateful ?? "", barriers: "9", swife: timeBegin, admired: timeEnd)
                }
                if let strUrl = accBigModel?.confession?.honored {
                    // 假产品
                    let ifShen = UserDefaults.standard.value(forKey: "spThepolice") as? String == "1"
                    if ifShen {
                        let comVc = SPCodeCompleteViewController()
                        comVc.strUrl = strUrl
                        contentVc.navigationController?.pushViewController(comVc, animated: true)
                    }else {
                        let webVc = SPNetViewController(strUrl, ifFull: false)
                        contentVc.navigationController?.pushViewController(webVc, animated: true)

                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(300)) {
                            var vcs = webVc.navigationController?.viewControllers
                            vcs?.removeAll(where: { $0 == contentVc })
                            webVc.navigationController?.viewControllers = vcs ?? []
                            
                            NotificationCenter.default.removeObserver(contentVc, name: .spCodeNext, object: nil)
                        }
                    }
                }
            })
            .disposed(by: contentVc.rx.disposeBag)
    }
}
