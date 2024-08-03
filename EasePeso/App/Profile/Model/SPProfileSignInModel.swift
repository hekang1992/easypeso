//
//  SPProfileSignInModel.swift
//  EasePeso
//
//  Created by apple on 2024/4/8.
//

import Foundation
import HandyJSON

/// 登录成功
struct SPSignInModel: HandyJSON {
    var quiterecently: String = ""
}

struct SPProfileOrderModels: HandyJSON {
    var indulgent: [SPProfileOrderListModel]?
}

struct SPProfileOrderListModel: HandyJSON {
    /// 逾期天数
    var daffodils: Int?
    /// logo
    var yetpossible: String?
    /// 名字
    var trust: String?
    /// 订单状态  逾期180    待还款：174   还款成功200
    var andhid: String?
    /// 金额
    var maroon: String?
    /// 金额前面的文案
    var jikiwl: String?
    /// Loan Date
    var tousled: String?
    /// "23-04-2024"
    var bloom: String?
    /// detail的文案
    var pairof: String?
    
    /// url
    var sleepily: String?
}


struct SPProfileFAQModel: HandyJSON {
    var affront: [SPProfileFAQItemModel]?
    
    class SPProfileFAQItemModel: HandyJSON {
        required init() {}
        
        var witty: String?
        var vanished: String?
        var select = false
    }
}
