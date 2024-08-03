//
//  SPLocation.swift
//  EasePeso
//
//  Created by apple on 2024/3/29.
//

import Foundation
import CoreLocation

import RxCocoa
import RxSwift
import NSObject_Rx

// MARK: - 位置
class SPLocation: NSObject {
    static let share = SPLocation()
    var lat: Double?
    var lng: Double?
    
    /// 上传位置
    private var publishLocation = PublishSubject<PublishLocationStatus>()
    
    /// 位置权限
    var auth: CLAuthorizationStatus {
        _auth()
    }
    
    /// 上传位置
    func uploadLocation() {
        if auth == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }else if auth == .authorizedAlways || auth == .authorizedWhenInUse {
            locationManager.requestLocation()
        }else {
            SPPhone.sharePhone.publishPhone.onNext("")
        }
    }
    
    private lazy var locationManager = {
        let m = CLLocationManager()
        m.desiredAccuracy = kCLLocationAccuracyHundredMeters
        m.delegate = self
        
        return m
    }()
    
    private func _auth()-> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    private override init() {
        super.init()
        
        publishLocation
            .catchAndReturn(.error("location publish error"))
            .debounce(.seconds(2), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] loStatus in
                if case let .success(dict) = loStatus {
                    self?._upLocation(dict)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    /// 上报位置
    private func _upLocation(_ dict: [String: Any]) {
        SPNetRequest.spRequestHandyData(SPZeroModel.self, url: "/theyprobably_andsee", para: dict)
            .subscribe(onNext: { bigModel in
                SPPrint("bigModel == \(bigModel?.exhaustion)")
            })
            .disposed(by: rx.disposeBag)
    }
    
    private enum PublishLocationStatus {
        case success([String: String])
        case error(String)
    }
}

extension SPLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("auth change == \(status)")
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            SPPrint("restricted || denied")
            SPPhone.sharePhone.publishPhone.onNext("")
        case .authorizedAlways, .authorizedWhenInUse:
            SPPrint("authorizedWhenInUse authorizedWhenInUse authorizedWhenInUse")
            manager.requestLocation()
        @unknown default:
            SPPrint("default default default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        SPPrint("locations locations == \(locations.first?.coordinate)")
        
        SPPhone.sharePhone.publishPhone.onNext("")
        guard let location = locations.first else {
            publishLocation.onNext(.error("locations is empty"))
            return
        }
        self.lat = location.coordinate.latitude
        self.lng = location.coordinate.longitude
        
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(location) { places, err in
            guard let firstPlace = places?.first else {
                self.publishLocation.onNext(.error("places first is empty"))
                return
            }
            
            /// 省
            let neverwinter = firstPlace.administrativeArea ?? ""
            let beautiful = firstPlace.isoCountryCode ?? ""
            let magic = firstPlace.country ?? ""
            let britishcolumbia = firstPlace.thoroughfare ?? ""
            var fianc = ""
            if let lat = self.lat {
                fianc = "\(lat)"
            }
            var herselfinto = ""
            if let lng = self.lng {
                herselfinto = "\(lng)"
            }
            let sparkled = firstPlace.locality ?? ""
            
            let dictLocation = [
                "neverwinter": neverwinter,
                "beautiful": beautiful,
                "magic": magic,
                "britishcolumbia": britishcolumbia,
                "fianc": fianc,
                "herselfinto": herselfinto,
                "sparkled": sparkled,
                "dimpled": String.suijiStr(),
                "beshe": String.suijiStr()
            ]
            
            self.publishLocation.onNext(.success(dictLocation))
        }
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        SPPrint("didFailWithError == \(error)")
    }
}
