//
//  UIKit+Extension.swift
//  EasePeso
//
//  Created by apple on 2024/3/26.
//

import UIKit

import MBProgressHUD

// MARK: - SPKit
struct SPKit {
    static let window: UIWindow? = _window()
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    
    static let topAreaHeight = _topAreaHeight()
    static let bottomAreaHeight = _bottomAreaHeight()
    
    static let scaleX = width / 375.0
    static let scaleY = height / 812.0
    
    fileprivate static func _topAreaHeight()-> CGFloat {
        if let inset = _fetchInset() {
            return inset.top
        }
        return 0
    }
    
    fileprivate static func _bottomAreaHeight()-> CGFloat {
        if let inset = _fetchInset() {
            return inset.bottom
        }
        return 0
    }
    
    fileprivate static func _fetchInset()-> UIEdgeInsets? {
        if #available(iOS 13, *) {
            let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene
            return screen?.windows.first?.safeAreaInsets
        }else {
            return UIApplication.shared.windows.first?.safeAreaInsets
        }
    }
    
    fileprivate static func _window()-> UIWindow? {
        if #available(iOS 13, *) {
            let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene
            return screen?.windows.first
        }else {
            return UIApplication.shared.windows.first
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

// MARK: - UIFont
extension UIFont {
    class func puFont(size: CGFloat)-> UIFont {
        guard let font = UIFont(name: "Plumpfull", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
}

// MARK: - UIColor
extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init?(str: String, _ alpha: Float = 1) {
        var strHex = str
        
        if strHex.hasPrefix("#") {
            strHex = String(strHex[strHex.index(after: strHex.startIndex)...])
        }

        guard let hexVal = Int64(strHex, radix: 16) else {
            self.init()
            return
        }

        switch strHex.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha)
        case 4:
            self.init(hex4: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
        case 8:
            self.init(hex8: hexVal, alpha: alpha)
        default:
            self.init()
        }
    }
    
    static func random()-> UIColor {
        let redRandom = arc4random_uniform(255)
        let greenRandom = arc4random_uniform(255)
        let blueRandom = arc4random_uniform(255)
        
        return UIColor.init(r: Int(redRandom), g: Int(greenRandom), b: Int(blueRandom))
    }
    
    private convenience init?(hex3: Int64, alpha: Float) {
        self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init?(hex4: Int64, alpha: Float?) {
        self.init(red:   CGFloat( ((hex4 & 0xF000) >> 12).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex4 & 0x0F00) >> 8).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex4 & 0x00F0) >> 4).duplicate4bits() ) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat( ((hex4 & 0x000F) >> 0).duplicate4bits() ) / 255.0)
    }

    private convenience init?(hex6: Int64, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }

    private convenience init?(hex8: Int64, alpha: Float?) {
        self.init(red:   CGFloat( (hex8 & 0xFF000000) >> 24 ) / 255.0,
                  green: CGFloat( (hex8 & 0x00FF0000) >> 16 ) / 255.0,
                  blue:  CGFloat( (hex8 & 0x0000FF00) >> 8 ) / 255.0,
                  alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat( (hex8 & 0x000000FF) >> 0 ) / 255.0)
    }
}

// MARK: - UIView
extension UIView {
    func errorMsg(str: String?) {
        MBProgressHUD.hide(for: self, animated: true)
        
        var style = ToastStyle()
        style.horizontalPadding = 18
//        style.verticalPadding = topPadding
        style.messageFont = UIFont.puFont(size: 16)
        style.backgroundColor = UIColor(red: 78 / 255.0, green: 99 / 255.0, blue: 118 / 255.0, alpha: 0.6)
        style.shadowColor = UIColor(red: 78 / 255.0, green: 99 / 255.0, blue: 118 / 255.0, alpha: 0.6)
        style.displayShadow = true
//        makeToast(str, duration: 2.0, position: .top, style: style)
        SPKit.window?.makeToast(str, duration: 2.0, position: .top, style: style)
    }
    
    func hudAnimation()-> MBProgressHUD {
        MBProgressHUD.hide(for: self, animated: true)
        let mb = MBProgressHUD.showAdded(to: self, animated: true).then { hud in
            hud.mode = .customView
            hud.bezelView.style = .solidColor
        }
        
        let arrImages = (0...24).compactMap { UIImage(named: "sp_load\($0)") }
        
        mb.customView = SPLoadingView(frame: .init(x: 0, y: 0, width: 170, height: 52)).then {
            $0.animationDuration = 1
            $0.contentMode = .scaleAspectFit
            $0.animationRepeatCount = 0
            $0.animationImages = arrImages
            
            $0.startAnimating()
        }
        
        mb.hide(animated: true, afterDelay: 13)
        
        return mb
    }
    
    func dismissHud() {
        MBProgressHUD.hide(for: self, animated: true)
    }
    
    class SPLoadingView: UIImageView {
        override var intrinsicContentSize: CGSize {
            .init(width: 170, height: 52)
        }
    }
}

extension UIView {
    var vc: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIImage {
    func cutDownImage(to bytes: Int)-> Data? {
        var compression: CGFloat = 1.0
        var imageData = self.jpegData(compressionQuality: compression)
        
        while let data = imageData, data.count > bytes, compression > 0.1 {
            compression -= 0.1
            imageData = self.jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
}
