//
//  SPFAQViewController.swift
//  EasePeso
//
//  Created by apple on 2024/4/16.
//  http://8.212.181.119:8093/smtp/anything_reached

import UIKit

class SPFAQViewController: SPBaseViewController, UITableViewDataSource, UITableViewDelegate {

    private lazy var tabView: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.backgroundColor = UIColor(str: "#3F7774")
        tab.separatorStyle = .none
        tab.dataSource = self
        tab.delegate = self
        tab.contentInset = UIEdgeInsets(top: 11, left: 0, bottom: 0, right: 0)
        tab.contentOffset = .init(x: 0, y: -11)
        tab.register(SPFAQTableCell.self, forCellReuseIdentifier: "SPFAQTableCell")
        
        return tab
    }()
    
    var arrData: [SPProfileFAQModel.SPProfileFAQItemModel]?
    var lastSelect: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(str: "#3F7774")
        
        _createNaviView()
        
        view.addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPKit.topAreaHeight + 44, left: 0, bottom: 0, right: 0))
        }
        
        getData()
    }
    
    func getData() {
        SPNetRequest
            .spRequestHandyData(showHud: view, SPProfileFAQModel.self, url: "/anything_reached")
            .subscribe(onNext: { bigModel in
                self.arrData = bigModel?.confession?.affront
                self.tabView.reloadData()
            })
            .disposed(by: rx.disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SPFAQTableCell", for: indexPath) as! SPFAQTableCell
        
        let model = self.arrData?[indexPath.row]
        
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 8
//        model?.witty = "sfbjksakfldms asnklsdam cnkslamls;a sahfewndjks sanksamlkdsa sankdlsa"
//        model?.vanished = "sfbjksakfldms asnklsdam cnkslamls;a sahfewndjks sanksamlkdsa sankdlsa"
        let attrTitle = NSAttributedString(string: model?.witty ?? "''", attributes: [
            .paragraphStyle: para
        ])
        let attrDetail = NSAttributedString(string: model?.vanished ?? "''", attributes: [
            .paragraphStyle: para
        ])
        cell.lblTitle.attributedText = attrTitle
        cell.lblDetail.attributedText = attrDetail
        
        if model?.select == true {
            cell.detailView.isHidden = false
        }else {
            cell.detailView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var arrIndexPaths = [IndexPath]()
        if lastSelect != indexPath.row {
            if let lastSelect = lastSelect {
                arrIndexPaths.append(IndexPath(row: lastSelect, section: 0))
                
                let modelLast = arrData?[lastSelect]
                modelLast?.select = false
            }
            
            arrIndexPaths.append(indexPath)
            let modelLast = arrData?[indexPath.row]
            modelLast?.select = true
            
            tableView.reloadRows(at: arrIndexPaths, with: .automatic)
        }
        lastSelect = indexPath.row
    }
    
    private func _createNaviView() {
        let imgHeight: CGFloat = 44
        let titleView = UIImageView(image: UIImage(named: "sp_profile_list_top"))
        titleView.isUserInteractionEnabled = true
        view.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(SPKit.topAreaHeight + imgHeight)
        }
        
        let centerView = UIView()
        titleView.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(SPKit.topAreaHeight)
            make.height.equalTo(imgHeight)
        }
        
        let lblTitle = UILabel()
        lblTitle.text = "FAQ"
        lblTitle.font = UIFont.puFont(size: 20)
        lblTitle.textColor = .white
        centerView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(44)
        }
        
        let btnBack = UIButton(type: .custom)
        btnBack.rx.tap.asSignal().emit(onNext: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        btnBack.setImage(UIImage(named: "sp_home_naviBack"), for: .normal)
        titleView.addSubview(btnBack)
        btnBack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(lblTitle)
            make.width.height.equalTo(44)
        }
    }
}

class SPFAQTableCell: UITableViewCell {
    let lblTitle = UILabel()
    let detailView = UIView()
    let lblDetail = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = UIColor(str: "#3F7774")
        
        let backImg = UIImage(named: "sp_podfile_itemContent")
        let backSize = backImg?.size ?? .init(width: 1, height: 1)
        let backImgCap = backImg?.resizableImage(withCapInsets: UIEdgeInsets(top: backSize.height / 4.0 * 3, left: backSize.width / 2.0, bottom: backSize.height / 4.0, right: backSize.width / 2.0), resizingMode: .stretch)
        
        let imgBackView = UIImageView(image: backImgCap)
        contentView.addSubview(imgBackView)
        imgBackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 12, right: 16))
        }
        
        let stView = UIStackView()
        stView.axis = .vertical
        stView.distribution = .fill
        imgBackView.addSubview(stView)
        stView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 6, right: 14))
        }
        
        let titleView = UIView()
        stView.addArrangedSubview(titleView)
        
        let imgDetailView = UIImageView(image: UIImage(named: "sp_faq_xiajian"))
        titleView.addSubview(imgDetailView)
        
        lblTitle.font = UIFont.puFont(size: 18)
        lblTitle.textColor = .black
        lblTitle.numberOfLines = 0
        titleView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.trailing.equalTo(imgDetailView.snp.leading).offset(-8)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        imgDetailView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(lblTitle)
            make.width.height.equalTo(16)
        }
        
        detailView.isHidden = true
        stView.addArrangedSubview(detailView)
        
        lblDetail.font = UIFont.puFont(size: 14)
        lblDetail.textColor = UIColor(str: "#6C6C6C")
        lblDetail.numberOfLines = 0
        detailView.addSubview(lblDetail)
        lblDetail.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
