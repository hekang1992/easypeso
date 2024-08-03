//
//  SPSelfInfo.swift
//  EasePeso
//
//  Created by apple on 2024/3/29.
//

import UIKit
import AdSupport
import AppTrackingTransparency

class SPSelfInfo {
    static let share = SPSelfInfo()
    var selfIdfa: String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    var selfIdfv: String = SPIDManager.fetchIdfv()
    
    private init() {
        
    }
    
    var call: String? {
        set { UserDefaults.standard.setValue(newValue, forKey: "spCall") }
        get { UserDefaults.standard.value(forKey: "spCall") as? String }
    }
    
    var callId: String? {
        set { UserDefaults.standard.setValue(newValue, forKey: "spCallId") }
        get { UserDefaults.standard.value(forKey: "spCallId") as? String }
    }
    
    var selfIn: Bool {
        guard let callId = callId, !callId.isEmpty else { return false }
        return true
    }
}

import KeychainAccess
import RxSwift
import AppsFlyerLib
class SPIDManager {
    private static let dis = DisposeBag()
    
    static func fetchIdfaAndUp() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { aa in
                SPPrint("requestTrackingAuthorization == \(aa)")
                
                if aa == .notDetermined {
                    SPPrint("首次启动")
                }else {
                    SPSelfInfo.share.selfIdfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    SPIDManager.upTrans()
                }
                
                doInMain {
                    NotificationCenter.default.post(name: NSNotification.Name("sp_remoteNoti"), object: nil)
                }
            }
        } else {
            SPSelfInfo.share.selfIdfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            SPIDManager.upTrans()
        }
    }
    
    private static func upTrans() {
        SPNetRequest
            .spRequestHandyData(SPIDUPModel.self, url: "/young_onreflection", para: ["herdiamond": String.suijiStr(), 
                                                                                     "skittishly": SPSelfInfo.share.selfIdfv,
                                                                                     "blushing": SPSelfInfo.share.selfIdfa])
            .subscribe { bigModel in
                if bigModel?.ofdiffident == 0 {
                    let model = bigModel?.confession
                    if model?.theshame == 1 {
                        AppsFlyerLib.shared().appsFlyerDevKey = model?.softening ?? ""
                        AppsFlyerLib.shared().appleAppID = model?.scotch ?? ""
                        AppsFlyerLib.shared().start { dict, err in
                            SPPrint("idfa == \(dict as AnyObject)")
                        }
                    }
                }
            }.disposed(by: dis)
    }
    
    static func fetchIdfv()-> String {
        var idfv = ""
        let strBendiKey = "spIdfvBendi"
        if let saveBendi = UserDefaults.standard.value(forKey: strBendiKey) as? String, !saveBendi.isEmpty {
            idfv = saveBendi
        }else {
            let service = "sp_idfv_service"
            let key = "sp_idfv"
            let chain = Keychain(service: service)
            let chainIdfv = chain[key]
            
            if let chainIdfv = chainIdfv, !chainIdfv.isEmpty {
                idfv = chainIdfv
                UserDefaults.standard.setValue(idfv, forKey: strBendiKey)
            }else {
                idfv = UIDevice.current.identifierForVendor?.uuidString ?? ""
                UserDefaults.standard.setValue(idfv, forKey: strBendiKey)
                chain[key] = idfv
            }
        }
        
        return idfv
    }
}

import HandyJSON
struct SPIDUPModel: HandyJSON {
    
    var theshame: Int?
    /// appid
    var scotch: String?
    // key
    var softening: String?
}
