//
//  ArticleTableCell.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/8/25.
//

import UIKit

class ArticleTableCell: UITableViewCell {
    
    //MARK: Properties
    
    static let reuseIdentifier = "ArticleTableCell"
    let titleLabel = UILabel()
    let postDetailsLabel = UILabel()
    let uploadImageView = UIImageView(image: UIImage(systemName: "square.and.arrow.up"))
    let dateLabel = UILabel()
    let articleImageView = UIImageView()
        
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

extension ArticleTableCell {
    func setupUI() {
        backgroundColor = .white
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .systemBlue
        titleLabel.numberOfLines = 0
        
        postDetailsLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        postDetailsLabel.textColor = .secondaryLabel
        postDetailsLabel.numberOfLines = 0
        
        uploadImageView.tintColor = .systemBlue
        uploadImageView.contentMode = .scaleAspectFit
        uploadImageView.setContentHuggingPriority(.required, for: .horizontal)
        
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .tertiaryLabel
        
        let dateRow = UIStackView(arrangedSubviews: [uploadImageView, dateLabel, UIView()])
        dateRow.axis = .horizontal
        dateRow.alignment = .center
        dateRow.spacing = 6
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, postDetailsLabel, dateRow])
        textStack.axis = .vertical
        textStack.spacing = 8
        
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
        articleImageView.setContentHuggingPriority(.required, for: .horizontal)
        articleImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let imageStackView = UIStackView(arrangedSubviews: [UIView(),articleImageView,UIView()])
        imageStackView.axis = .vertical
        imageStackView.spacing = 8

        // Root horizontal stack
        let hStack = UIStackView(arrangedSubviews: [textStack, imageStackView])
        hStack.axis = .horizontal
        hStack.alignment = .top
        hStack.spacing = 12
        hStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            articleImageView.widthAnchor.constraint(equalToConstant: 80),
            articleImageView.heightAnchor.constraint(equalToConstant: 80),
            uploadImageView.widthAnchor.constraint(equalToConstant: 16),
            uploadImageView.heightAnchor.constraint(equalToConstant: 16)
            ])
    }
    
    func loadCellData(article: ArticleDetails) {
        
        titleLabel.text = article.author ?? ""
        postDetailsLabel.text = article.description ?? ""
        
        if let publishedAt = article.publishedAt, publishedAt.count >= 10 {
            dateLabel.text = String(publishedAt.prefix(10))
        } else {
            dateLabel.text = ""
        }
    
        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self else { return }
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        self.articleImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            articleImageView.image = nil
        }
    }
}
