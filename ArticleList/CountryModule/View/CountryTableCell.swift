//
//  CountryTableCell.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/18/25.
//

import UIKit

class CountryTableCell: UITableViewCell {
    
    //MARK: Properties
    
    static let reuseIdentifier = "CountryTableCell"
    
    let titleLabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    let codeLabel = {
        let codeLabel = UILabel()
        codeLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        codeLabel.textColor = .systemBlue
        codeLabel.numberOfLines = 0
        return codeLabel
    }()
    
    let capitalLabel = {
        let capitalLabel = UILabel()
        capitalLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        capitalLabel.textColor = .secondaryLabel
        capitalLabel.numberOfLines = 0
        return capitalLabel
    }()
    
    //MARK: Initializers for UITableViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Helper functions

extension CountryTableCell {
    func setupUI() {
        
        backgroundColor = .white
        
        let primaryRow = UIStackView(arrangedSubviews: [titleLabel, UIView(), codeLabel])
        primaryRow.axis = .horizontal
        primaryRow.alignment = .center
        primaryRow.spacing = 6
        
        let verticalStack = UIStackView(arrangedSubviews: [primaryRow, capitalLabel])
        verticalStack.axis = .vertical
        verticalStack.spacing = 10
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(verticalStack)

        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])
    }
    
    func loadCellData(country: Country) {
        titleLabel.text = country.name + ", " + country.code
        codeLabel.text = country.code
        capitalLabel.text = country.capital
    }
}
