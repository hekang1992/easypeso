//
//  SPHomeModel.swift
//  EasePeso
//
//  Created by apple on 2024/4/8.
//

import Foundation
import HandyJSON

struct SPHomeModel: HandyJSON {
    /// 认证项总数
    var jokeil: Int = 5
    /// 当前认证项
    var gollel: Int = 1
    /// 版本号
    var efforts: String?
    /// 1： 假产品  0:真产品
    var thepolice: String?
    
    /// banner
    var witnessednatural: SPHomeSectionModel<[SPHomeSectionItemModel]>?
    /// 大卡位
    var wasgo: SPHomeSectionModel<SPHomeSectionItemModel>?
    /// 小卡位
    var indulgent: SPHomeSectionModel<[SPHomeSectionItemModel]>?
    /// 复贷数据，如果为nil就没有复贷
    var calculated: SPHomeSectionModel<[SPHomeSectionItemModel]>?
    
    func didFinishMapping() {
        UserDefaults.standard.setValue(efforts, forKey: "spEfforts")
        UserDefaults.standard.setValue(thepolice, forKey: "spThepolice")
    }
}

/// 复贷列表数据
struct SPRecommandModel: HandyJSON {
    var indulgent: [SPHomeSectionItemModel]?
}

struct SPHomeSectionModel<T: HandyJSON>: HandyJSON {
    /// 类型
    var housewives: String?
    var humanitarians: T?
}

struct SPHomeSectionItemModel: HandyJSON {
    /// 产品id
    var hateful: String?
    /// 产品名字
    var trust: String?
    /// 产品logo
    var yetpossible: String?
    /// 额度
    var magical: String?
    /// 额度下面的文案
    var andshe: String?
    /// 按钮类型 1表示申请状态，2表示未还款状态，3表示准入拒绝状态（一般是灰色）
    var modish: String?
    /// 逾期文案
    var skinniness: String?
    /// 是否是复贷  不为空是复贷
    var authoritarianism: String?
    
    /// imgUrl
    var skillfulpoliticians: String?
    
    /// url
    var honored: String?
}

/// 准入数据模型
struct SPZhunruModel: HandyJSON {
    var honored: String?
}


extension Array: HandyJSON {}
