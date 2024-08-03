//
//  SPBaseGenericModel.swift
//  EasePeso
//
//  Created by apple on 2024/4/1.
//

import Foundation
import HandyJSON

import BRPickerView

struct SPBaseGenericModel<T: HandyJSON>: HandyJSON {
    
    /// Code
    let ofdiffident: Int = 0
    /// 文案
    let exhaustion: String = ""
    /// --
    let confession: T? = nil
}

/// 空数据,占位用
struct SPZeroModel: HandyJSON { }
