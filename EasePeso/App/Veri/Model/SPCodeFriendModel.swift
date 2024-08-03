//
//  SPCodeFriendModel.swift
//  EasePeso
//
//  Created by apple on 2024/4/7.
//  联系人

import UIKit
import HandyJSON
import RxSwift

struct SPCodeFriend: HandyJSON {
    var weeping: SPCodeFriendData?
    
    struct SPCodeFriendData: HandyJSON {
        var indulgent: [SPCodeFriendModel]?
    }
}

class SPCodeFriendModel: HandyJSON {
    required init() { }
    /// 关系
    var babbled: String?
    /// 关系名字
    var relation_name: String?
    /// 名字
    var ilove: String?
    /// 电话
    var msorry: String?
    /// 提交key
    var clerk: String?
    /// 标题
    var periodically: String?
    /// 底部弹窗数据
    var influence: [SPCodeItemSelectModel]?
    
    func didFinishMapping() {
        guard let babbled = babbled, !babbled.isEmpty,
              let ilove = ilove, !ilove.isEmpty,
              let msorry = msorry, !msorry.isEmpty else {
            obsFillIn.onNext(false)
            return
        }
        obsFillIn.onNext(true)
    }
    
    lazy var obsFillIn = BehaviorSubject(value: false)
}

