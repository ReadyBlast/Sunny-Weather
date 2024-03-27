//
//  TableViewCell.swift
//  Sunny Weather
//
//  Created by XE on 24.03.2024.
//

import Foundation
import UIKit

final class TableViewCell: UITableViewCell {
    
    static var identifier: String {"\(Self.self)"}
    
    private var cityNameLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cityNameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(with text: String) {
        cityNameLabel.text = text
    }
}
