//
//  mobileTableCell.swift
//  ExitekTestProject
//
//  Created by Oleksandr Smakhtin on 23.09.2022.
//

import UIKit
import CoreData

//MARK: - TABLE CELL
class MobileTableCell: UITableViewCell {

    //MARK: - UI ELEMENTS
    let modelLbl = UILabel()
    let imeiLbl = UILabel()
    
    //MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // disable selection
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        configureView()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - CONFIGURE CELL
    func configureCell(mobile: Mobile) {
        modelLbl.text = "Model: \(mobile.model!)"
        imeiLbl.text = "IMEI: \(mobile.imei!)"
    }

    //MARK: - CONFIGURE VIEW
    func configureView() {
        // content view
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.06)
        // model label
        contentView.addSubview(modelLbl)
        modelLbl.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        modelLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // imei label
        contentView.addSubview(imeiLbl)
        imeiLbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        imeiLbl.textColor = #colorLiteral(red: 0.178378731, green: 0.178378731, blue: 0.178378731, alpha: 1)
        
    }
    
    //MARK: - CONSTRAINTS
    // set constarints
    override func layoutSubviews() {
        super.layoutSubviews()
        // for content view
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0))
        // for model label
        modelLbl.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(12)
            make.left.equalTo(contentView).offset(22)
        }
        // for imei label
        imeiLbl.snp.makeConstraints { make in
            make.top.equalTo(modelLbl.snp_bottomMargin).offset(8)
            make.left.equalTo(contentView).offset(22)
        }
    }
    
    
}
