//
//  SPPhone.swift
//  EasePeso
//
//  Created by apple on 2024/3/29.
//  上传设备

import Foundation
import CoreTelephony
import SystemConfiguration.CaptiveNetwork

import RxCocoa
import RxSwift
import NSObject_Rx
import Alamofire
import DeviceKit

// MARK: - 设备
class SPPhone: NSObject {
    static let sharePhone = SPPhone()
    let publishPhone = PublishSubject<Any>()
    
    private override init() {
        super.init()
        
        publishPhone
            .catchAndReturn("error phone data")
            .debounce(.seconds(2), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.upIphoneData()
                NotificationCenter.default.post(name: NSNotification.Name("sp_maidian_first"), object: nil)
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func upIphoneData() {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict)
            let str = data.base64EncodedString(options: .lineLength64Characters)
            SPNetRequest
                .spRequestHandyData(SPZeroModel.self, url: "/lovely_anything", para: ["confession": str])
                .subscribe { _ in
                    
                }.disposed(by: rx.disposeBag)
        } catch {
            
        }
    }
    
    lazy var dict: [String: Any] = [
        "provided": "ios",
        "tostart": Device.current.systemVersion ?? "",
        "littlemercenary": littlemercenary,
        "ofturning": ofturning,
        "incapable": [
            "fatherat": fatherat,
            "bounty": bounty
        ],
        "historian": [
            "skittishly": skittishly,
            "blushing": blushing,
            "announced": announced,
            "moreproud": moreproud,
            "mansion": mansion,
            "timbered": timbered,
            "ocean": ocean,
            "is_simulator": is_simulator,
            "mountains": mountains,
            "sviews": sviews,
            "oppose": oppose,
            "layer": layer,
            "loyalty": loyalty
        ],
        "momentshe": [
            "glimpses": "",
            "parties": "iPhone",
            "orintimidate": "",
            "amuse": "\(Int(SPKit.height))",
            "comfortable": UIDevice.current.name,
            "sheherself": "\(Int(SPKit.width))",
            "coward": Device.current.description,
            "educated": "\(Device.current.diagonal)",
            "thehomes": Device.current.systemVersion ?? ""
        ],
        "genteel": [
            "provide": provide,
            "meanto": [
                "ilove": ilove,
                "gladto": gladto,
                "announced": announcedWifi,
                "disconcert": disconcert
            ],
            "acceptable": _wifiListCount()
        ],
        "horrify": [
            "nottrying": nottrying,
            "credentials": credentials,
            "beforeshe": "\(beforeshe)",
            "tractor": tractor
        ]
    ]
    
    /// 上次登录时间，毫秒数
    var littlemercenary: String { _openTime() }
    /// 包名
    var ofturning: String { Bundle.main.bundleIdentifier ?? "" }
    
    var skittishly: String { SPSelfInfo.share.selfIdfv }
    var blushing: String { SPSelfInfo.share.selfIdfa }
    /// 设备mac
    lazy var announced = ""
    /// 系统当前时间，单位毫秒
    var moreproud:String { "\(Int((Date().timeIntervalSince1970 * 1000)))" }
    /// 是否使用代理(yes:1,no:0)
    var mansion: String { _openPro() }
    /// 是否使用vpn(yes:1,no:0)
    var timbered: String { _openVpn() }
    /// 是否越狱(yes: 1, no: 0)
    var ocean: String { _broken() }
    /// 是否是模拟器(yes: 1, no: 0)
    var is_simulator: String { Device.current.isSimulator ? "1" : "0" }
    /// 设备语言
    var mountains: String { Locale.current.languageCode ?? "en" }
    /// 运营商名称
    var sviews: String { "" }
    /// 网络类型
    var oppose: String {
        if let sta = NetworkReachabilityManager.default?.status {
            switch sta {
            case .unknown:
                return "OTHER"
            case .notReachable:
                return "OTHER"
            case .reachable(let connectionType):
                if connectionType == .ethernetOrWiFi {
                    return "WIFI"
                }else {
                    return _spGetNet()
                }
            }
        }
        
        return "OTHER"
    }
    /// 时区
    var layer: String { TimeZone.current.abbreviation() ?? "GMT" }
    /// 设备启动毫秒数
    var loyalty: String { _openTime() }
    
    /// 电池百分比
    var fatherat: String { "\(Device.current.batteryLevel ?? 0)" }
    /// 是否在充电
    var bounty: String { 
        let stat = Device.current.batteryState!
        if case .unplugged = stat {
            return "0"
        }else {
            return "1"
        }
    }
    /// 内网ip
    var provide: String { SPMemory.innerIPAdress() }
    /// 当前wifi
    var ilove: String { disconcert }
    ///当前的 wifi BSSID
    var gladto: String {
        let info = _getCurrentWiFiInfo()
        let bssid = info?[kCNNetworkInfoKeyBSSID as String] as? String
        
        return bssid ?? ""
    }
    ///当前的 wifi MAC
    var announcedWifi: String { gladto }
    ///当前的 wifi SSID
    var disconcert: String {
        let info = _getCurrentWiFiInfo()
        let ssid = info?[kCNNetworkInfoKeySSID as String] as? String
        
        return ssid ?? ""
    }
    
    /// 未使用存储大小
    let nottrying: String = "\(DeviceKit.Device.volumeAvailableCapacity ?? 1)"
    /// 总存储大小
    let credentials: String = "\(DeviceKit.Device.volumeTotalCapacity ?? 1)"
    /// 总内存大小
    let beforeshe: UInt64 = ProcessInfo.processInfo.physicalMemory
    /// 未使用内存大小
//    lazy var tractor: String = "\(beforeshe - SPMemory.memoryUsage())"
    lazy var tractor: String = "\(Int(SPMemory.getAvailableMemorySize()))"
    
    private func _spGetNet() -> String {
        let networkInfo = CTTelephonyNetworkInfo()
        guard let currentRadioAccessTechnology = networkInfo.currentRadioAccessTechnology else { return "OTHER" }
        if #available(iOS 14.1, *) {
            switch currentRadioAccessTechnology {
            case CTRadioAccessTechnologyWCDMA,
                CTRadioAccessTechnologyHSUPA,
                 CTRadioAccessTechnologyHSDPA,
                 CTRadioAccessTechnologyCDMAEVDORev0,
                 CTRadioAccessTechnologyCDMAEVDORevA,
                CTRadioAccessTechnologyCDMA1x,
                 CTRadioAccessTechnologyCDMAEVDORevB,
                 CTRadioAccessTechnologyeHRPD:
                return "3G"
                
            case CTRadioAccessTechnologyLTE:
                return "4G"
                
            case CTRadioAccessTechnologyGPRS,
                 CTRadioAccessTechnologyEdge:
                return "2G"
                
            case CTRadioAccessTechnologyNR:
                return "5G"
                
            default:
                return "OTHER"
            }
        } else {
            switch currentRadioAccessTechnology {
                
            case CTRadioAccessTechnologyWCDMA,
                CTRadioAccessTechnologyHSDPA,
                CTRadioAccessTechnologyCDMAEVDORev0,
                 CTRadioAccessTechnologyHSUPA,
                 CTRadioAccessTechnologyCDMAEVDORevA,
                CTRadioAccessTechnologyCDMA1x,
                 CTRadioAccessTechnologyCDMAEVDORevB,
                 CTRadioAccessTechnologyeHRPD:
                return "3G"
                
            case CTRadioAccessTechnologyGPRS,
                 CTRadioAccessTechnologyEdge:
                return "2G"
                
            case CTRadioAccessTechnologyLTE:
                return "4G"
                
            default:
                return "OTHER"
            }
        }
    }
    
    private func _openTime()-> String {
        let time: TimeInterval = ProcessInfo.processInfo.systemUptime
        let timeDate = Date(timeIntervalSinceNow: -time)
        let timeSp = String(format: "%ld", Int(timeDate.timeIntervalSince1970))
        
        return timeSp
    }
    
    /// 是否开了vpn
    private func _openVpn()-> String {
        guard let dictVpn = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as? [String: Any] else {
            return "0"
        }
        let open = dictVpn.keys.contains { key in
            key == "tap" || key == "tun" || key == "ppp"
        }
        return open ? "1" : "0"
    }
    
    /// 是否开了代理
    private func _openPro() -> String {
        if let proxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as? [String: Any] {
            if let httpProxy = proxySettings[kCFNetworkProxiesHTTPProxy as String] as? String,
               !httpProxy.isEmpty {
                return "1"
            }
        }

        return "0"
    }
    
    private func _broken()-> String {
        // 检查越狱常见文件和路径
        let wshPaths = ["/Applications/Cydia.app", "/private/var/lib/cydia", "/private/var/lib/apt/", "/private/var/stash"]
        
        for path in wshPaths {
            if FileManager.default.fileExists(atPath: path) {
                return "1"
            }
        }
        
        // 检查是否能够打开系统应用，通常越狱后可以访问系统应用
        if FileManager.default.fileExists(atPath: "/Applications/Preferences.app") {
            return "1"
        }
        
        // 检查是否能够写入系统路径，正常情况下应该受到限制
        let testWritePath = "/private/jailbreaktest"
        do {
            try "Jailbreak test".write(toFile: testWritePath, atomically: true, encoding: String.Encoding.utf8)
            try FileManager.default.removeItem(atPath: testWritePath)
            return "1"
        } catch {
            return "0"
        }
    }
    
    /// 保存的wifi信息
    private func _wifiListCount()-> String {
        var list = 0
        
        guard let ss = CNCopySupportedInterfaces() else { return "0" }
        let aa = ss as NSArray
        
        for item in aa {
            if let mm = _transformToCFString(value: item) {
                if let info = CNCopyCurrentNetworkInfo(mm) {
                    let mmInfo = info as NSDictionary
                    if let _ = mmInfo[kCNNetworkInfoKeySSID as String] as? String {
                        list += 1
                    }
                }
            }
        }
        
        return "\(list)"
        
        func _transformToCFString(value: Any) -> CFString? {
            if let stringValue = value as? String {
                return stringValue as CFString
            } else {
                return nil
            }
        }
    }

    private func _getCurrentWiFiInfo() -> [String: Any]? {
        var wifiInfo: [String: Any]?
        
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    wifiInfo = interfaceInfo as? [String: Any]
                    break
                }
            }
        }
        
        return wifiInfo
    }
}

