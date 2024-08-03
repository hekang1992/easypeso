//
//  SPNetRequest.swift
//  EasePeso
//
//  Created by apple on 2024/3/29.
//

import UIKit

import Alamofire
import RxSwift
import RxCocoa
import OpenCombine

import HandyJSON
import DeviceKit
import MBProgressHUD

class SPNetRequest {
    static var lunxunIndex = 0
    static var arrUrls: [String]?
    static let bag = DisposeBag()
    
    static func spRequestHandyData<T: HandyJSON>(showHud: UIView? = nil,
                                                 _ modelType: T.Type,
                                                 url: String,
                                                 method: HTTPMethod = .post,
                                                 para: Parameters? = nil,
                                                 endcoding: ParameterEncoding = URLEncoding.default)-> Observable<SPBaseGenericModel<T>?> {
        var hud: MBProgressHUD?
        if let showHud = showHud {
            hud = showHud.hudAnimation()
            hud?.hide(animated: true, afterDelay: 15)
        }
        return Observable.create { a in
            self._requestData(url: url, method: method, para: para, endcoding: endcoding).responseString { res in
                if let strRes = res.value {
                    let model = SPBaseGenericModel<T>.deserialize(from: strRes)
                    if model?.ofdiffident == -2 {
                        self._spLoginError(showHud)
                    }else {
                        a.onNext(model)
                    }
                }
                if let hud = hud {
                    hud.hide(animated: true)
                }
            }
            return Disposables.create()
        }
    }
    
    static func spRequestBaseData(showHud: UIView? = nil,
                                  url: String,
                                  method: HTTPMethod = .post,
                                  para: Parameters? = nil,
                                  endcoding: ParameterEncoding = URLEncoding.default)-> Observable<Data> {
        var hud: MBProgressHUD?
        if let showHud = showHud {
            hud = showHud.hudAnimation()
            hud?.hide(animated: true, afterDelay: 15)
        }
        
        return Observable.create { a in
            self._requestData(url: url, method: method, para: para, endcoding: endcoding).responseData { res in
                if let strRes = res.value {
                    a.onNext(strRes)
                }
                if let hud = hud {
                    hud.hide(animated: true)
                }
            }
            return Disposables.create()
        }
    }
    
    /// 上传图片
    static func spUpImage<T: HandyJSON>(showHud: UIView? = nil,
                                        _ modelType: T.Type,
                                        url: String,
                                        dict: [String: Any])-> Observable<SPBaseGenericModel<T>?> {
        var hud: MBProgressHUD?
        if let showHud = showHud {
            hud = showHud.hudAnimation()
            hud?.hide(animated: true, afterDelay: 15)
        }
        return Observable.create { a in
            let muData = MultipartFormData()
            
            for (first, val) in dict {
                if val is UIImage {
                    if let data = (val as! UIImage).cutDownImage(to: 9 * 100000) {
                        muData.append(data, withName: first, fileName: "spname.jpg", mimeType: "image/jpg")
                    }
                } else if val is String {
                    if let data = (val as! String).data(using: .utf8) {
                        muData.append(data, withName: first)
                    }
                }
            }
            
            let appendUrl = SPDomainManager.share.spUrl + addPara(to: url)
            AF.upload(multipartFormData: muData, to: appendUrl).responseString { res in
                if let strRes = res.value {
                    let model = SPBaseGenericModel<T>.deserialize(from: strRes)
                    if model?.ofdiffident == -2 {
                        self._spLoginError(showHud)
                    }else {
                        a.onNext(model)
                    }
                }
                if let hud = hud {
                    hud.hide(animated: true)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /// 上报埋点
    /// - Parameters:
    ///   - molested: 产品ID
    ///   - barriers: 上报场景类型：1、注册 2、认证选择 3、证件信息（按照进入页面开始） 4、人脸照片（按照点击活体认证按钮开始） 5、个人信息 6、工作信息 7、紧急联系人 8、银行卡信息9、开始申贷 10、结束申贷
    ///   - swife: 开始时间
    ///   - admired: 结束时间
    static func spUpTrack(molested: String, barriers: String, swife: Int, admired: Int) {
        let dict: [String: Any] = [
            "molested": molested,
            "barriers": barriers,
            "comradely": "",
            "paths": SPSelfInfo.share.selfIdfv,
            "foryou": SPSelfInfo.share.selfIdfa,
            "herselfinto": SPLocation.share.lng ?? "",
            "fianc": SPLocation.share.lat ?? "",
            "swife": swife,
            "admired": admired,
            "nastily": String.suijiStr()
        ]
        spRequestHandyData(SPZeroModel.self, url: "/there_sternly", method: .post, para: dict)
            .subscribe(onNext: { _ in
//                SPPrint("maidian == \(bigModel?.exhaustion)")
            }).disposed(by: bag)
    }
    
    // MARK: - 给url添加公参
    static func addPara(to url: String)-> String {
        let dict = [
            "gaiety": "ios",
            "efforts": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "cringed": Device.current.description,
            "ancestors": SPSelfInfo.share.selfIdfv,
            "stonemason": Device.current.systemVersion ?? "",
            "scotch": String.suijiStr(),
            "quiterecently": SPSelfInfo.share.callId ?? "",
            "scotsmen": SPSelfInfo.share.selfIdfv,
            "change": String.suijiStr()
        ]
        
        var strUrl = url
        if var components = URLComponents(string: strUrl) {
            let encodedQuery = (components.percentEncodedQuery.map { $0 + "&" } ?? "") + queString(dict)
            components.percentEncodedQuery = encodedQuery
            
            strUrl = components.string ?? ""
        }
        
        return strUrl
        
        /*
        var arr = [String]()
        for (key, value) in dict {
            let esKey = key.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? key
            let esValue = value.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? value
            arr.append("\(esKey)=\(esValue)")
        }
        
        if url.contains("?") {
            let appendUrl = url.appending("/").appending(arr.joined(separator: "&"))
            
            return appendUrl
        }else {
            let appendUrl = url.appending("?").appending(arr.joined(separator: "&"))
            
            return appendUrl
        }
         */
    }
    
    static func queString(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        let encod = URLEncoding.queryString
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += encod.queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private static func _spLoginError(_ view: UIView?) {
        let vc = view?.vc
        if let nav = vc as? UINavigationController {
            let signVc = SPSigninViewController()
            let signNaviVc = SPBaseNaviViewController(rootViewController: signVc)
            signNaviVc.modalPresentationStyle = .fullScreen
            nav.present(signNaviVc, animated: true)
        }else if let vc = vc {
            let signVc = SPSigninViewController()
            let signNaviVc = SPBaseNaviViewController(rootViewController: signVc)
            signNaviVc.modalPresentationStyle = .fullScreen
            vc.present(signNaviVc, animated: true)
        }
    }
    
    /// 创建请求
    private static func _requestData(url: String,
                      method: HTTPMethod,
                      para: Parameters?,
                      endcoding: ParameterEncoding)-> DataRequest {
        
        let appendUrl = SPDomainManager.share.spUrl + addPara(to: url)
//        SPPrint("appendUrl == \(appendUrl)")
        
        return AF.request(appendUrl, method: method, parameters: para, encoding: endcoding) { $0.timeoutInterval = 15 }
    }
}

extension SPNetRequest {
    static func checkUrl(complete: @escaping (()-> Void)) {
        _requestData(url: "/janykils", method: .get, para: ["ofdisability": String.suijiStr(), "rescues": String.suijiStr()], endcoding: URLEncoding.default)
            .responseData { res in
                guard let data = res.data else {
                    urlOperation(complete: complete)
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    if let ofdiffident = json?["ofdiffident"] as? String {
                        if ofdiffident == "0" || ofdiffident == "00" {
                            complete()
                        }else {
                            urlOperation(complete: complete)
                        }
                    }else if let ofdiffident = json?["ofdiffident"] as? Int {
                        if ofdiffident == 0 {
                            complete()
                        }else {
                            urlOperation(complete: complete)
                        }
                    }else {
                        urlOperation(complete: complete)
                    }
                } catch {
                    SPPrint("catch error \(error)")
                    urlOperation(complete: complete)
                }
            }
    }
    
    static func urlOperation(complete: @escaping (()-> Void)) {
        if let arrUrls = arrUrls, !arrUrls.isEmpty { /// 有数据
            if lunxunIndex < arrUrls.count {
                SPDomainManager.share.spHost = arrUrls[lunxunIndex]
                lunxunIndex += 1
                checkUrl(complete: complete)
            }else {
                SPPrint("都不可用")
                return
            }
        }else { /// 没数据，去请求数据
            fetchUrls {
                if let arrUrls = arrUrls, !arrUrls.isEmpty {
                    lunxunIndex = 0
                    SPDomainManager.share.spHost = arrUrls[lunxunIndex]
                    lunxunIndex += 1
                    checkUrl(complete: complete)
                }else {
                    SPPrint("都不可用")
                    return
                }
            }
        }
    }
    
    static func fetchUrls(complete: @escaping (()-> Void)) {
        let hud = SPKit.window?.hudAnimation()
        hud?.hide(animated: true, afterDelay: 15)
        AF.request(SPDomainManager.share.spBeiyong.utf8Str ?? "", method: .get)
            .responseString(completionHandler: { res in
                guard let str64 = res.value,
                      let str8 = str64.utf8Str,
                      let data8 = str8.data(using: .utf8) else {
                    hud?.hide(animated: true)
                    return
                }
                
                arrUrls = try? JSONSerialization.jsonObject(with: data8) as? [String]
                complete()
            })
    }
}

