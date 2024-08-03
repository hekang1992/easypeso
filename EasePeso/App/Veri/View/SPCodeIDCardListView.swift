//
//  SPCodeIDCardListView.swift
//  EasePeso
//
//  Created by apple on 2024/4/2.
//  卡类型View

import UIKit
import Kingfisher

class SPCodeIDCardListView: UIView {
    var confirmCallback:((Int, SPCodeCardTypeModel.SPCodeCardModel)-> Void)?
    
    private var selectIndex: Int?
    private let arrData: [SPCodeCardTypeModel.SPCodeCardModel]?
    private var collView: UICollectionView!
    
    init(frame: CGRect, _ arrData: [SPCodeCardTypeModel.SPCodeCardModel]?, selectIndex: Int?) {
        self.arrData = arrData
        self.selectIndex = selectIndex
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.8)
        
        _initView()
        
        if let selectIndex = selectIndex {
            let indexPath = IndexPath(row: selectIndex, section: 0)
            collView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        }
    }
    
    @objc func xiaoshiAction() {
        self.removeFromSuperview()
    }
    
    private func _initView() {
        let maxHeight = 0.7 * SPKit.height
        let minHeight = 0.5 * SPKit.height
        
        let topView = SPCodeIDTitleView(title: "Select ID Card Type")
        addSubview(topView)
        topView.closeCallback = {
            self.xiaoshiAction()
        }
        topView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        layout.sectionFootersPinToVisibleBounds = true
        layout.sectionInset = UIEdgeInsets(top: 25, left: 15, bottom: 0, right: 15)
        let itemWidth = (SPKit.width - 30 - 7) / 2.0
        let itemHeight = 146 / 170 * itemWidth
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.footerReferenceSize = CGSize(width: SPKit.width, height: 20 + 64 + 13)
        
        collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.dataSource = self
        collView.delegate = self
        collView.backgroundColor = UIColor(str: "#19427B")
        collView.showsVerticalScrollIndicator = false
        insertSubview(collView, belowSubview: topView)
        let calcuteHeight = 80 + CGFloat(itemHeight * CGFloat(ceil(Double(arrData?.count ?? 0) / 2.0))) + SPKit.bottomAreaHeight
        let scHeight = min(max(minHeight, calcuteHeight), maxHeight)
        collView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(scHeight)
        }
        collView.register(SPCodeIDListCell.self, forCellWithReuseIdentifier: "SPCodeIDListCell")
        collView.register(SPCodeIDListFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SPCodeIDListFooter")
    }
    
    required init?(coder: NSCoder) {
        arrData = nil
        super.init(coder: coder)
    }
}

extension SPCodeIDCardListView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPCodeIDListCell", for: indexPath) as! SPCodeIDListCell
        
        let model = arrData?[indexPath.item]
        cell.imgIDView.kf.setImage(with: URL(string: model?.skillfulpoliticians ?? ""), placeholder: UIImage(named: "sp_code_boxPlace"))
        cell.lblName.text = model?.housewives
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SPCodeIDListFooter", for: indexPath) as! SPCodeIDListFooter
        
        footer.xuanzeCallback = { [weak self] in
            
            guard let self = self else { return }
            guard let selectIndex = selectIndex,
                    let model = arrData?[selectIndex] else {
                errorMsg(str: "Please select your identity type")
                return
            }
            xiaoshiAction()
            confirmCallback?(selectIndex, model)
        }
        
        return footer
    }
}

class SPCodeIDListCell: UICollectionViewCell {
    let imgIDView = UIImageView(image: UIImage(named: "sp_code_boxPlace"))
    let lblName = UILabel()
    private let coverView = UIView()
    private let imgCoverView = UIImageView(image: UIImage(named: "sp_code_idCard_select"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(str: "#19427B")
        
        let imgContentView = UIImageView(image: UIImage(named: "sp_code_cardContent"))
        contentView.addSubview(imgContentView)
        imgContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lblName.textColor = UIColor(str: "#B8CCE9")
        lblName.font = UIFont.puFont(size: 14)
        lblName.textAlignment = .center
        imgContentView.addSubview(lblName)
        lblName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
        }
        
        imgContentView.addSubview(imgIDView)
        imgIDView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.leading.equalToSuperview().offset(7)
            make.trailing.equalToSuperview().offset(-7)
            make.height.equalTo(93)
        }
        
        coverView.layer.cornerRadius = 8
        coverView.backgroundColor = .black.withAlphaComponent(0.3)
        contentView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        coverView.addSubview(imgCoverView)
        imgCoverView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.trailing.equalToSuperview().offset(-6)
        }
        
        coverView.isHidden = !self.isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            coverView.isHidden = !isSelected
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class SPCodeIDListFooter: UICollectionReusableView {
    var xuanzeCallback: (()-> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        let btnXuanze = UIButton(type: .custom).then { btn in
            btn.setTitle("Confirm Selection", for: .normal)
            btn.titleLabel?.font = UIFont.puFont(size: 20)
            btn.setTitleColor(.black, for: .normal)
            btn.setBackgroundImage(UIImage(named: "sp_code_id_commit_enable"), for: .normal)
            btn.addTarget(self, action: #selector(xuanzeAction), for: .touchUpInside)
        }
        self.addSubview(btnXuanze)
        btnXuanze.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
    }
    
    @objc func xuanzeAction() {
        xuanzeCallback?()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
