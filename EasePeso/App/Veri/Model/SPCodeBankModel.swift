//
//  SPCodeBankModel.swift
//  EasePeso
//
//  Created by apple on 2024/4/15.
//  银行卡数据源

import Foundation
import HandyJSON
import RxSwift

struct SPCodeBankModel: HandyJSON {
    var wantto: [SPCodeBankItemModel]?
}

class SPCodeBankItemModel: HandyJSON {
    required init() { }
    
    var witty: String = ""
    var housewives: Int?
    var wantto: [SPCodeInfoModel]?
    
//    class SPCodeBankItemDataModel: HandyJSON {
//        required init() {}
//        
//        /// title标题
//        var witty: String?
//        /// placeholder
//        var crying: String?
//        /// code保存时的key键
//        var ofdiffident: String?
//        /// 看文档里值映射-认证项组件
//        var regretful: String?
//        /// 是否为选填 1是
//        var unhappiness: String?
//        /// 下拉的显示值，如果不是下拉就在填的值  前端显示
//        var cliff: String?
//        /// 下拉的type值，如果不是下拉就是填的值   传递给后端
//        var housewives: String?
//        /// 下拉框数据源
//        var rising: [SPCodeItemSelectModel]?
//        
//        private var obsAble = BehaviorSubject(value: false)
//        
//        
//        func didFinishMapping() {
//            if unhappiness == "1" {
//                obsAble.onNext(true)
//            }else {
//                if let _ = housewives {
//                    obsAble.onNext(true)
//                }else {
//                    obsAble.onNext(false)
//                }
//            }
//        }
//    }
}
