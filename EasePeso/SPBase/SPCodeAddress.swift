//
//  SPCodeAddress.swift
//  EasePeso
//
//  Created by apple on 2024/4/15.
//

import UIKit
import BRPickerView

/// 保存在本地的地址路径
let addressFile = (NSTemporaryDirectory() as NSString).appendingPathComponent("address.plist")

// MARK: - 地址选择
class SPCodeAddress: NSObject {
    func fetchAddress(view: UIView?, complete: @escaping ([BRProvinceModel])-> Void) {
        let exist = FileManager.default.fileExists(atPath: addressFile)
        if exist {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: addressFile))
                if let arrJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [Any] {
                    let arrData = SPTransFormAddress.fetchProvinceModelArr(arrJson)
                    complete(arrData)
                }
            }catch {
                _getData(view, complete: complete)
            }
        }else {
            _getData(view, complete: complete)
        }
    }
    
    private func _getData(_ view: UIView?, complete: @escaping ([BRProvinceModel])-> Void) {
        SPNetRequest
            .spRequestBaseData(showHud: view, url: "/course_would", method: .get)
            .subscribe(onNext: { bigData in
                do {
                    guard let json = try JSONSerialization.jsonObject(with: bigData, options: .fragmentsAllowed) as? [String: Any],
                            let dict = json["confession"] as? [String: Any],
                          let arrJson = dict["indulgent"] as? [Any] else {
                        return
                    }
                    let arrData = SPTransFormAddress.fetchProvinceModelArr(arrJson)
                    complete(arrData)
                    
                    let data = try JSONSerialization.data(withJSONObject: arrJson, options: .fragmentsAllowed)
                    try data.write(to: URL(fileURLWithPath: addressFile))
                }catch {
                    
                }
            })
            .disposed(by: rx.disposeBag)
    }
}

/*
// MARK: - 地址Model
class SPAddressModel: NSObject, HandyJSON, NSSecureCoding {
    static var supportsSecureCoding: Bool { true }
    
    func encode(with coder: NSCoder) {
        coder.encode(indulgent, forKey: "indulgent")
    }
    
    required init?(coder: NSCoder) {
        indulgent = coder.decodeObject(forKey: "indulgent") as? [SPAddressItemModel]
    }
    
    required override init() {
        
    }
    
    var indulgent: [SPAddressItemModel]? = nil
    
    func didFinishMapping() {
        let url = URL(fileURLWithPath: addressFile)
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            try data.write(to: url)
        }catch {
            SPPrint("error = \(error)")
        }
    }
}

class SPAddressItemModel: NSObject, HandyJSON, NSSecureCoding {
    static var supportsSecureCoding: Bool { true }
    
    func encode(with coder: NSCoder) {
        coder.encode(hateful, forKey: "hateful")
        coder.encode(ilove, forKey: "ilove")
        coder.encode(indulgent, forKey: "indulgent")
    }
    
    required init?(coder: NSCoder) {
        hateful = coder.decodeObject(forKey: "hateful") as? Int
        ilove = coder.decodeObject(forKey: "ilove") as? String
        indulgent = coder.decodeObject(forKey: "indulgent") as? [SPAddressItemModel]
    }
    
    required override init() {
        
    }
    
    var hateful: Int? = nil
    var ilove: String? = nil
    var indulgent: [SPAddressItemModel]? = nil
}
*/

