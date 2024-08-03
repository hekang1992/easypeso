//
//  SPCodeIDViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/2.
//  身份证

import UIKit
import OpenCombine

class SPCodeIDViewController: SPBaseViewController {
    var fatherVc: UIViewController?
    /// 产品id
    var liberal: String?
    private var cardModel: SPCodeFaceIDModel?
    /// 0: 当前选择卡片类型   1：卡片类型完成   2：身份证完成   3：活体完成
    @OpenCombine.Published private var nowStep: Int = 0
    
    /// 卡类型数据源
    private var arrCardType: [SPCodeCardTypeModel.SPCodeCardModel]?
    private var selectCardTypeIndex: Int?
    private var selectCardTypeCode: String {
        guard let arrCardType = arrCardType, 
                let selectCardTypeIndex = selectCardTypeIndex, 
                arrCardType.count > selectCardTypeIndex else { return "" }
        return arrCardType[selectCardTypeIndex].housewives ?? ""
    }
    private var cancelSet = Set<AnyCancellable>()
    
    private var contentView = UIView()
    /// 切换类型的按钮  上传完图片之后这个按钮要消失
    private let btnSwitch = UIButton(type: .custom)
    /// 图片  类型 和 身份证都是这个
    private let imgBoxPlaceView = UIImageView(image: UIImage(named: "sp_code_boxPlace"))
    private var frontImg: UIImage?
    /// 中间的那个相机图标，选择卡片类型之后才显示
    private let imgCameraView = UIImageView(image: UIImage(named: "sp_code_id_camera"))
    /// 底部按钮
    private lazy var btnTijiao = SPTijiaoButton(frame: .zero)
    
    lazy var faceView = {
        let v = SPCodeFaceView(frame: UIScreen.main.bounds)
        v.completeThis = {
            self.fatherVc = nil
        }
        
        return v
    }()
    
    lazy var pickerVc = {
        let vc = UIImagePickerController()
        vc.delegate = self
        
        return vc
    }()
    
    private var timeBegin: Int = 0
    private var loadTime: Int = 0
    /// 按钮是否可以点击
    @OpenCombine.Published private var enablePub: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(str: "#103059")
        _initView()
        
        _bindData()
        _fetchData()
        
        loadTime = Int(Date().timeIntervalSince1970 * 1000)
    }
    
    // MARK: - 网络请求
    private func _fetchData() {
        guard let liberal = liberal else { return }
        SPNetRequest
            .spRequestHandyData(showHud: view, SPCodeFaceIDModel.self, url: "/scene_around", method: .get, para: ["liberal": liberal, "staircase": String.suijiStr])
            .subscribe(onNext: { bigModel in
                self.cardModel = bigModel?.confession
                /// 身份证是否完成
                let cowardice = self.cardModel?.seehim?.cowardice ?? 0
                /// 人脸是否完成
                let offices = self.cardModel?.offices ?? 0
                if cowardice == 0 {
                    self.nowStep = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        self.switchAction()
                    }
                }else if cowardice == 1 {
                    self.imgBoxPlaceView.kf.setImage(with: URL(string: self.cardModel?.seehim?.honored ?? ""), placeholder: UIImage(named: "sp_code_boxPlace"))
                    if offices == 0 {
                        self.nowStep = 2
                    }else if offices == 1 {
                        self.nowStep = 3
                    }
                }
            }).disposed(by: rx.disposeBag)
    }
    /// 获取卡片类型
    private func _getCardTypeData()-> OpenCombine.PassthroughSubject<Bool, Never> {
        let sub = OpenCombine.PassthroughSubject<Bool, Never>()
        
        guard let liberal = liberal else {
            sub.send(false)
            return sub
        }
        SPNetRequest
            .spRequestHandyData(SPCodeCardTypeModel.self,
                                        url: "/uiwGiid",
                                        para: ["liberal": liberal, "staircase": String.suijiStr()])
            .subscribe(onNext: { bigModel in
                self.arrCardType = bigModel?.confession?.peosloejis
                sub.send(true)
            })
            .disposed(by: rx.disposeBag)
        return sub
    }
    /// 上传照片
    private func shangchuanImage(_ dict: [String: Any]) {
        let hud = view.hudAnimation()
        hud.hide(animated: true, afterDelay: 15)
        
        SPNetRequest
            .spUpImage(showHud: view, SPCodeCardUpImageModel.self, url: "/painting_books", dict: dict)
            .subscribe(onNext: { bigModel in
                hud.hide(animated: true)
                if bigModel?.ofdiffident == 0 {
                    if self.nowStep == 1 {
                        let model = bigModel?.confession
                        self.showFrontView(data: model)
                    }else {
                        self.nowStep = 3
                        self.faceView.imgFaceView.image = dict["applying"] as? UIImage
                        self.faceView.btnVeri.setTitle("Submit and Next", for: .normal)
                        
                        let timeEnd = Int(Date().timeIntervalSince1970 * 1000)
                        SPNetRequest.spUpTrack(molested: self.liberal ?? "", barriers: "4", swife: self.faceView.timeBegin, admired: timeEnd)
                    }
                }else {
                    self.view.errorMsg(str: bigModel?.exhaustion)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func _bindData() {
        $enablePub.assign(to: \.touchEnable, on: btnTijiao).store(in: &cancelSet)
        $nowStep.sink { [weak self] now in
            if now == 0 {
                self?.enablePub = false
                self?.btnSwitch.isHidden = false
                self?.imgCameraView.isHidden = true
            }else if now == 1 {
                self?.enablePub = false
                self?.btnSwitch.isHidden = false
                self?.imgCameraView.isHidden = false
            }else if now == 2 {
                self?.enablePub = true
                self?.btnSwitch.isHidden = true
                self?.imgCameraView.isHidden = false
            }else if now == 3 {
                self?.enablePub = true
                self?.btnSwitch.isHidden = true
                self?.imgCameraView.isHidden = false
            }
        }.store(in: &cancelSet)
    }
    
    // MARK: - UI
    private func _initView() {
        let backImgView = UIImageView(image: UIImage(named: "sp_code_idBack"))
        view.addSubview(backImgView)
        backImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPKit.topAreaHeight + 64, left: 0, bottom: 0, right: 0))
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPKit.topAreaHeight + 64, left: 0, bottom: bottomStepHeight, right: 0))
        }
        
        let shineImgView = UIImageView(image: UIImage(named: "sp_code_idTop_shine"))
        shineImgView.addOpacityAnimation(duration: 2)
        view.addSubview(shineImgView)
        shineImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(SPKit.topAreaHeight + 44)
        }
        
        btnSwitch.isHidden = true
        btnSwitch.addTarget(self, action: #selector(switchAction), for: .touchUpInside)
        contentView.addSubview(btnSwitch)
        btnSwitch.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
        }
        
        let lblSwitch = UILabel().then { lbl in
            lbl.text = "TYPE"
            lbl.font = UIFont.puFont(size: 14)
            lbl.textColor = UIColor(str: "#B8CCE9")
        }
        btnSwitch.addSubview(lblSwitch)
        lblSwitch.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        let imgSwitchView = UIImageView(image: UIImage(named: "sp_code_switch"))
        btnSwitch.addSubview(imgSwitchView)
        imgSwitchView.snp.makeConstraints { make in
            make.leading.equalTo(lblSwitch.snp.trailing).offset(6)
            make.centerY.equalTo(lblSwitch)
            make.trailing.equalToSuperview()
        }
        
        let imgBoxView = UIImageView(image: UIImage(named: "sp_code_idBox"))
        imgBoxView.setContentHuggingPriority(.required, for: .horizontal)
        imgBoxView.setContentHuggingPriority(.required, for: .vertical)
        imgBoxView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imgBoxView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        imgBoxView.isUserInteractionEnabled = true
        contentView.addSubview(imgBoxView)
        imgBoxView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btnSwitch.snp.bottom).offset(2)
            make.trailing.equalTo(btnSwitch)
        }
        
        imgBoxView.addSubview(imgBoxPlaceView)
        imgBoxPlaceView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
        
        let btnBox = UIButton(type: .custom)
        imgBoxView.addSubview(btnBox)
        btnBox.addTarget(self, action: #selector(cardAction), for: .touchUpInside)
        btnBox.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imgCameraView.isHidden = true
        imgBoxView.addSubview(imgCameraView)
        imgCameraView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // !!!: 底部提交按钮
        btnTijiao.tijiaoCallback = { [weak self] in
            self?.tijiaoAction()
        }
        contentView.addSubview(btnTijiao)
        btnTijiao.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(64)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        let imgPeopleView = UIImageView(image: UIImage(named: "sp_code_people"))
        contentView.insertSubview(imgPeopleView, belowSubview: btnTijiao)
        imgPeopleView.snp.makeConstraints { make in
            make.bottom.equalTo(btnTijiao.snp.top).offset(20)
            make.leading.equalTo(btnTijiao).offset(5)
        }
        
        let imgMsgView = UIImageView(image: UIImage(named: "sp_code_msg"))
        contentView.insertSubview(imgMsgView, belowSubview: btnTijiao)
        imgMsgView.snp.makeConstraints { make in
            make.leading.equalTo(imgPeopleView.snp.trailing)
            make.bottom.equalTo(btnTijiao.snp.top).offset(-36)
        }
    }
    
    private func showFrontView(data: SPCodeCardUpImageModel?) {
        guard let data = data else { return }
        let idView = SPCodeFrontInfoView(frame: UIScreen.main.bounds, model: data, preStr: selectCardTypeCode)
        SPKit.window?.addSubview(idView)
        
        idView.successCallback = {
            self.nowStep = 2
            self.imgBoxPlaceView.image = self.frontImg
            
            let timeEnd = Int(Date().timeIntervalSince1970 * 1000)
            SPNetRequest.spUpTrack(molested: self.liberal ?? "", barriers: "3", swife: self.loadTime, admired: timeEnd)
        }
    }
    
    // MARK: - 点击事件
    /// 切换类型
    @objc func switchAction() {
        timeBegin = Int(Date().timeIntervalSince1970 * 1000)
        if arrCardType == nil {
            _getCardTypeData()
                .sink { [weak self] finish in
                    if finish {
                        let listView = SPCodeIDCardListView(frame: UIScreen.main.bounds, self?.arrCardType, selectIndex: self?.selectCardTypeIndex)
                        SPKit.window?.addSubview(listView)
                        
                        listView.confirmCallback = { index, seleModel  in
                            self?.selectCardTypeIndex = index
                            self?.imgBoxPlaceView.kf.setImage(with: URL(string: seleModel.skillfulpoliticians ?? ""), placeholder: UIImage(named: "sp_code_boxPlace"))
                            self?.cardModel?.seehim?.scholarshipstudent = seleModel.housewives
                            
                            self?.nowStep = 1
                            
                            let timeEnd = Int(Date().timeIntervalSince1970 * 1000)
                            SPNetRequest.spUpTrack(molested: self?.liberal ?? "", barriers: "2", swife: self?.timeBegin ?? 0, admired: timeEnd)
                        }
                    }
                }.store(in: &cancelSet)
        }else {
            let listView = SPCodeIDCardListView(frame: UIScreen.main.bounds, arrCardType, selectIndex: selectCardTypeIndex)
            SPKit.window?.addSubview(listView)
            
            listView.confirmCallback = { index, seleModel  in
                self.selectCardTypeIndex = index
                self.imgBoxPlaceView.kf.setImage(with: URL(string: seleModel.skillfulpoliticians ?? ""), placeholder: UIImage(named: "sp_code_boxPlace"))
                self.cardModel?.seehim?.scholarshipstudent = seleModel.housewives
                
                self.nowStep = 1
                
                let timeEnd = Int(Date().timeIntervalSince1970 * 1000)
                SPNetRequest.spUpTrack(molested: self.liberal ?? "", barriers: "2", swife: self.timeBegin, admired: timeEnd)
            }
        }
    }
    
    /// 身份证正面照
    @objc func cardAction() {
        if nowStep == 0 {
            switchAction()
        }else if nowStep == 1 {
            SPCodeSelectPicView.show()
                .typePub
                .subscribe(onNext: { index in
                    if index == 0 { /// 相机
                        self._paizhaoAction()
                    }else { /// 相册
                        self._xiangceAction()
                    }
                })
                .disposed(by: rx.disposeBag)
        }
    }
    
    /// 弹出人脸识别页面
    @objc func tijiaoAction() {
        fatherVc?.view.addSubview(faceView)
        faceView.liberal = liberal
        faceView.imgUrl = cardModel?.honored
        faceView.paizhaoBack = { [weak self] in
            self?._paizhaoAction()
        }
        
        faceView.successBack = { [weak self] img, leId in
            let dict = [
                "filing": "1",
                "liberal": self?.liberal ?? "",
                "housewives": "10",
                "applying": img,
                "ofstudying": leId,
                "civilized": String.suijiStr(),
                "fluke": self?.faceView.advModel?.fluke ?? "",
                "scholarshipstudent": self?.selectCardTypeCode ?? ""
            ]
            self?.shangchuanImage(dict)
        }
    }
    
    private func _paizhaoAction() {
        self.pickerVc.sourceType = .camera
        self.pickerVc.cameraDevice = nowStep == 1 ? .rear : .front
        self.pickerVc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(self.pickerVc, animated: true)
    }
    
    private func _xiangceAction() {
        self.pickerVc.sourceType = .photoLibrary
        self.pickerVc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(self.pickerVc, animated: true)
    }
}

extension SPCodeIDViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let img = info[.originalImage] as? UIImage, let liberal = liberal else {
            return
        }
        picker.dismiss(animated: false)
        if nowStep == 1 {
            let dict: [String: Any] = [
                "filing": "1",
                "liberal": liberal,
                "housewives": "11",
                "applying": img,
                "ofstudying": "",
                "civilized": String.suijiStr(),
                "fluke": "",
                "scholarshipstudent": selectCardTypeCode
            ]
            frontImg = img
            shangchuanImage(dict)
        }else if nowStep == 2 {
            let dict: [String: Any] = [
                "filing": "1",
                "liberal": liberal,
                "housewives": "10",
                "applying": img,
                "ofstudying": "",
                "civilized": String.suijiStr(),
                "fluke": faceView.advModel?.fluke ?? "",
                "scholarshipstudent": selectCardTypeCode
            ]
            shangchuanImage(dict)
        }
    }
}
