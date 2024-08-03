//
//  SPCodeInfoModel.swift
//  EasePeso
//
//  Created by apple on 2024/4/2.
//  工作信息 和 个人信息

import UIKit
import HandyJSON

import RxSwift

struct SPCodeInfoModuleModel: HandyJSON {
    var wantto: [SPCodeInfoModel]?
}

class SPCodeInfoModel: HandyJSON {
    required init() {}
    
    var hateful: String?
    //title标题
    var witty: String?
    //input提示
    var crying: String?
    //code保存时的key键
    var ofdiffident: String?
    //看文档里值映射-认证项组件
    var regretful: String?
    //是否是数字键盘 1是
    var anormal: String?
    /// 是否是选填  1是
    var unhappiness: String?
    //下拉的显示值，如果不是下拉就在填的值  前端显示
    var cliff: String?
    /// 下拉的type值，如果不是下拉就在填的值   传递给后端
    var housewives: String?
    /// 下拉选择的model
    var rising: [SPCodeItemSelectModel]?
    
    var obsFillIn = BehaviorSubject(value: false)
    
    /// 是否是两个按钮的标志
    var needTwoBtns: Bool {
        rising?.count == 2
    }
    
    func didFinishMapping() {
        if unhappiness == "1" {
            obsFillIn.onNext(true)
        }else {
            guard let housewives = housewives, !housewives.isEmpty else {
                obsFillIn.onNext(false)
                return
            }
            obsFillIn.onNext(true)
        }
    }
}

/// 下拉选择的model
struct SPCodeItemSelectModel: HandyJSON {
    var ilove: String?
    var housewives: String?
    var youdon: String?
    var rising: [SPCodeItemSelectModel]?
}
