//
//  SPDomainManager.swift
//  EasePeso
//
//  Created by apple on 2024/4/22.
//

import UIKit

class SPDomainManager {
    static let share = SPDomainManager()
    
    let spBeiyong = "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2R0c2Rhcmsvc210c3cvbWFpbi9hZWU="
    /// 域名
    var spHost = "https://upklending.com"
    /// 接口
    var spUrl: String {
        spHost + "/smtp"
    }
    /// H5
    var spHUrl: String { spHost }
    /// 隐私协议
    var spUserPri: String { spHUrl + "/thethickThings" }
    /// 贷款协议
    var spBigPri: String { spHUrl + "/stumpsCracked" }
    /// 客服首页
    var spKefu: String { spHUrl + "/overcomeFirst" }
    /// 换卡
    var spKaHuan: String { spHUrl + "/backedAfford" }
    
    /// 邮箱
    let spEmail = "support@upklending.com"
    /// 用于更新
    let spAppId = ""
    
    private init() {
        
    }
}
