//
//  ArticleTableCell.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/8/25.
//

import UIKit

protocol ArticleTableCellDelegate: AnyObject {
    func didTapOnDeleteButton(_ cell: ArticleTableCell)
}

class ArticleTableCell: UITableViewCell {
    
    //MARK: Properties
    
    static let reuseIdentifier = "ArticleTableCell"
    weak var delegate: ArticleTableCellDelegate?
    
    let titleLabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .systemBlue
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    let postDetailsLabel = {
        let postDetailsLabel = UILabel()
        postDetailsLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        postDetailsLabel.textColor = .secondaryLabel
        postDetailsLabel.numberOfLines = 0
        return postDetailsLabel
    }()
    
    let uploadImageView = {
        let uploadImageView = UIImageView(image: UIImage(systemName: "square.and.arrow.up"))
        uploadImageView.tintColor = .systemBlue
        uploadImageView.contentMode = .scaleAspectFit
        uploadImageView.setContentHuggingPriority(.required, for: .horizontal)
        return uploadImageView
    }()
    
    let dateLabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .tertiaryLabel
        return dateLabel
    }()
    
    let articleImageView = {
        let articleImageView = UIImageView()
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
        articleImageView.setContentHuggingPriority(.required, for: .horizontal)
        articleImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return articleImageView
    }()
    
    private let deleteButton: UIButton = {
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.setContentHuggingPriority(.required, for: .horizontal)
        deleteButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        return deleteButton
    }()
    
    //MARK: Initializers for UITableViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Helper functions

extension ArticleTableCell {
    func setupUI() {
        
        backgroundColor = .white
        
        let dateRow = UIStackView(arrangedSubviews: [uploadImageView, dateLabel, UIView()])
        dateRow.axis = .horizontal
        dateRow.alignment = .center
        dateRow.spacing = 6
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, postDetailsLabel, dateRow])
        textStack.axis = .vertical
        textStack.spacing = 8
        
        let imageStackView = UIStackView(arrangedSubviews: [UIView(),articleImageView,UIView()])
        imageStackView.axis = .vertical
        imageStackView.spacing = 8

        // Root horizontal stack
        let hStack = UIStackView(arrangedSubviews: [textStack, imageStackView, deleteButton])
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
            uploadImageView.heightAnchor.constraint(equalToConstant: 16),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24),
            ])
    }
    
    @MainActor
    func loadCellData(article: ArticleDetails) {
        
        titleLabel.text = article.author ?? ""
        postDetailsLabel.text = article.description ?? ""
        dateLabel.text = article.publishedAt
        
        Task {
            let state = await NetworkManager.shared.getData(from: article.urlToImage)
            switch state {
            case .success(let fetchedData):
                self.articleImageView.image = UIImage(data: fetchedData)
            case .errorFetchingData, .isLoading, .invalidURL, .noDataFromServer:
                self.articleImageView.image = UIImage(systemName: "photo.trianglebadge.exclamationmark.fill")
            }
        }
    }

    @objc func deleteButtonTapped(){
        delegate?.didTapOnDeleteButton(self)
    }
}
