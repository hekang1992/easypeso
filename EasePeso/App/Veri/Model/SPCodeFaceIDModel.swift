//
//  SPCodeIDModel.swift
//  EasePeso
//
//  Created by apple on 2024/4/3.
//  身份证

import UIKit
import HandyJSON

struct SPCodeFaceIDModel: HandyJSON {
    // MARK: - 正面
    var seehim: SPCodeFrontIDModel?
    // MARK: - 人脸
    /// 人脸是否完成 0、1
    var offices: Int?
    /// 人脸图片地址
    var honored: String?
    /// 图片选择类型：1，相机+相册；2，相机
    var housewives: Int = 1
    
    /// 正面Model
    struct SPCodeFrontIDModel: HandyJSON {
        /// 证件是否完成 0、1
        var cowardice: Int?
        /// 选择卡片类型
        var scholarshipstudent: String?
        /// 证件照地址
        var honored: String?
        
        /// 正面数据
        var studying: FrontIDData?
        
        struct FrontIDData: HandyJSON {
            /// 名字
            var ilove: String?
            /// 卡号
            var department: String?
            /// 生日
            var foot: String?
        }
    }
}

/// 卡类型Model
struct SPCodeCardTypeModel: HandyJSON {
    var peosloejis: [SPCodeCardModel]?
    
    struct SPCodeCardModel: HandyJSON {
        var housewives: String?
        var skillfulpoliticians: String?
    }
}

// MARK: - 上传图片之后返回的model
struct SPCodeCardUpImageModel: HandyJSON {
    /// 名字
    var ilove: String?
    /// 身份证号码
    var department: String?
    /// 生日
    var foot: String?
    /// 性别
    var nowcongratulated: String?
}

// MARK: - 检查Advance调用次数
struct SPCodeADVCheckModel: HandyJSON {
    /// 类型      1.自拍 2.望为 3.adv
    var fluke: String?
    /// licence
    var otherand: String?
    /// 人脸难易程度
    var housewives: String?
}
