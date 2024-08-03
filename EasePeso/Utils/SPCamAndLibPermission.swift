//
//  SPCamAndLibPermission.swift
//  EasePeso
//
//  Created by apple on 2024/4/3.
//

import UIKit
import AVFoundation
import Photos

import RxSwift

final class SPCamAndLibPermission: NSObject {
    /// 相机权限
    class func camAction()-> Observable<Bool> {
        let camStatus = AVCaptureDevice.authorizationStatus(for: .video)
        return Observable.create { obs in
            
            switch camStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { finish in
                    doInMain { 
                        obs.onNext(finish)
                        if !finish {
                            SPPremissionView.showPremission(.camera)
                        }
                    }
                }
            case .authorized:
                doInMain { obs.onNext(true) }
            default:
                doInMain { 
                    obs.onNext(false)
                    SPPremissionView.showPremission(.camera)
                }
            }
            
            return Disposables.create { SPPrint("销毁相机权限") }
        }
    }
    
    /// 相册权限
    class func libAction()-> Observable<Bool> {
        let libStatus = PHPhotoLibrary.authorizationStatus()
        return Observable.create { obs in
            
            switch libStatus {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { st in
                    let au = st == .authorized
                    doInMain {
                        obs.onNext(au)
                        if !au {
                            SPPremissionView.showPremission(.library)
                        }
                    }
                }
            case .authorized:
                doInMain { obs.onNext(true) }
            default:
                doInMain { 
                    obs.onNext(false)
                    SPPremissionView.showPremission(.library)
                }
            }
            
            return Disposables.create { SPPrint("销毁相册权限") }
        }
    }
}
