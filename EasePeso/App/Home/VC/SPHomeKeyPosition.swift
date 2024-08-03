//
//  SPHomeKeyPosition.swift
//  EasePeso
//
//  Created by apple on 2024/4/1.
//

import UIKit

struct SPKeyPosition {
    let position: CGPoint
    let style: ItemStyle
}

enum ItemStyle: Equatable {
    case start
    /// step 是当前是第几步
    /// ifNow： 是不是当前，如果是当前的话用小头像，不是的话用完成按钮
    case step(step: Int = 1, ifNow: Bool = false)
    case complete
}


