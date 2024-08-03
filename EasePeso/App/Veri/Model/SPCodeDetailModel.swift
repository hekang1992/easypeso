//
//  SPCodeItemsModel.swift
//  EasePeso
//
//  Created by apple on 2024/4/7.
//  产品详情

import Foundation
import HandyJSON

class SPCodeDetailModel: HandyJSON {
    required init() {}
    
    var otherplan: SPCodeDetailOrderModel?
    
    struct SPCodeDetailOrderModel: HandyJSON {
        /// 产品id
        var hateful: String?
        /// 订单号
        var comradely: String?
        /// 订单id
        var whilethey: String?
    }
    
    /// 所有认证项
    var forgiving: [SPCodeItemModel] = []
    
    /// 下一步认证项
    var sheacknowledged: NextStepModel?
    
    class SPCodeItemModel: HandyJSON {
        required init() {}
        
        /// 认证项
        var throwing: DetailStep?
        /// 是否已经完成
        var cowardice: Int = 0
    }
    
    /// 下一步
    class NextStepModel: HandyJSON {
        required init() {}
        
        /// 下一步认证项
        var throwing: DetailStep?
        /// 标题
        var witty: String?
    }
}

enum DetailStep: String, HandyJSONEnum {
//    case uy1 = "public"
//    case uy2 = "personal"
//    case uy3 = "work"
//    case uy4 = "ext"
//    case uy5 = "bank"
    
    case idCard = "uy1"
    case gerenxinxi = "uy2"
    case gongzuo = "uy3"
    case lianxiren = "uy4"
    case yinhang = "uy5"
}
