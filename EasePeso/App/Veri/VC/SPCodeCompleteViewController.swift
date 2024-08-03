//
//  SPCodeCompleteViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/25.
//

import UIKit

class SPCodeCompleteViewController: SPBaseViewController {
    var strUrl: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func homeAction(_ sender: Any) {
        if let vcs = navigationController?.viewControllers {
            for vc in vcs where vc.isKind(of: SPCodeContentViewController.self) {
                NotificationCenter.default.removeObserver(vc, name: .spCodeNext, object: nil)
            }
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func loanAction(_ sender: Any) {
        let webVc = SPNetViewController(strUrl, ifFull: false)
        navigationController?.pushViewController(webVc, animated: true)
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(300)) {
            var arrVcs: [UIViewController] = []
            if let vcs = webVc.navigationController?.viewControllers {
                for vc in vcs {
                    if vc.isKind(of: SPCodeContentViewController.self) {
                        NotificationCenter.default.removeObserver(vc, name: .spCodeNext, object: nil)
                    }else if vc == self {
                        
                    }else {
                        arrVcs.append(vc)
                    }
                }
            }
            webVc.navigationController?.viewControllers = arrVcs
            
//            var vcs = webVc.navigationController?.viewControllers
//            vcs?.removeAll(where: { $0 == self || $0.isKind(of: SPCodeContentViewController.self) })
////            NotificationCenter.default.removeObserver(contentVc, name: .spCodeNext, object: nil)
//            webVc.navigationController?.viewControllers = vcs ?? []
        }
    }
}
