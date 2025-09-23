//
//  DetailsViewController.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/10/25.
//

import UIKit

protocol ArticleDetailsDelegate: AnyObject {
    func receiveUpdatedArticle(_ article: ArticleDetails?)
}

class DetailsViewController: UIViewController {
    
    //MARK: Properties
    
    var article: ArticleDetails?
    var articleDelegate: ArticleDetailsDelegate?
//    var closure: ((ArticleDetails?) -> Void?)? = nil
    var prefetchedImage: UIImage?
    
    var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .systemBlue
        titleLabel.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 35)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 17)
        descriptionLabel.textColor = .black
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    var commentsTextField: UITextField = {
        let commentsTextField = UITextField()
        commentsTextField.placeholder = "Add a comment..."
        commentsTextField.borderStyle = .roundedRect
        commentsTextField.textColor = .black
        commentsTextField.translatesAutoresizingMaskIntoConstraints = false
        commentsTextField.font = .systemFont(ofSize: 17)
        return commentsTextField
    }()
    
    var articleImageView = {
        let articleImageView = UIImageView()
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
        articleImageView.setContentHuggingPriority(.required, for: .horizontal)
        articleImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return articleImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
    }
}

//MARK: Helper functions

extension DetailsViewController {
    
    func setupUI() {
        title = "Details"
        view.backgroundColor = .systemBackground
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel,articleImageView,  descriptionLabel, commentsTextField])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 12
        vStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStack)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backToPreviousScreen))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveComment))
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.widthAnchor.constraint(equalToConstant: 500),
            commentsTextField.heightAnchor.constraint(equalToConstant: 80),
            commentsTextField.widthAnchor.constraint(equalToConstant: 500),
            articleImageView.heightAnchor.constraint(equalToConstant: 300),
            articleImageView.widthAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    func configureData() {
        titleLabel.text = article?.author ?? "Unknown Author"
        descriptionLabel.text = article?.description ?? "No description available"
        if let image = prefetchedImage {
            articleImageView.image = image
        } else {
            articleImageView.image = UIImage(systemName: "photo.trianglebadge.exclamationmark.fill")
        }
        if article?.comments != nil {
            commentsTextField.text = article?.comments
        }
    }
    
    @objc func backToPreviousScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveComment() {
        article?.comments = commentsTextField.text
        articleDelegate?.receiveUpdatedArticle(article)
        self.navigationController?.popViewController(animated: true)
    }
}
