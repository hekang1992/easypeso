//
//  SPBaseViewController.swift
//  EasePeso
//
//  Created by apple on 2024/3/27.
//

import UIKit

class SPBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.spTheme
    }
    
    deinit {
        print("\(self) 销毁")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
