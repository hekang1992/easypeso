//
//  Foundation+Extension.swift
//  EasePeso
//
//  Created by apple on 2024/4/1.
//

import Foundation

extension String {
    func toNsRange(with range: Range<Self.Index>?)-> NSRange? {
        guard let range = range,
            let low = range.lowerBound.samePosition(in: utf16),
                let up = range.upperBound.samePosition(in: utf16) else {
            return nil
        }
        
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: low), length: utf16.distance(from: low, to: up))
    }
    
    static func suijiStr(_ count: Int = 6)-> Self {
        let str = "qrNOEFGHIJabcVWXYZstuedPQRfghijklmSTUvwxyzABCDnopKLM"
        let aa = (0..<count).compactMap { _ in str.randomElement() }
        
        return String(aa)
    }
    
    var utf8Str: Self? {
        guard let data64 = Data(base64Encoded: self, options: .ignoreUnknownCharacters),
              let str8 = String(data: data64, encoding: .utf8) else {
            return nil
        }
        
        return str8
    }
}

// MARK: - Int64
extension Int64 {
    func duplicate4bits() -> Int64 {
        return (self << 4) + self
    }
}

// MARK: - 主线程执行
func doInMain(_ doThing: @escaping ()-> Void) {
    DispatchQueue.main.async {
        doThing()
    }
}

// MARK: - 打印
func SPPrint(_ thing: Any...) {
    #if DEBUG
    print(thing.description)
    #endif
}
