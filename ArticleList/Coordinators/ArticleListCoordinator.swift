//
//  Untitled.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/15/25.
//
import UIKit

protocol ArticleListCoordinatorProtocol {
    func showDetailScreen(article: ArticleDetails,
                          prefetchedImage: UIImage?,
                          onSave: @escaping ((ArticleDetails?) -> Void?))
}

final class ArticleListCoordinator: ArticleListCoordinatorProtocol {
    private let networkClient: NetworkManagerProtocol
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController,
         networkClient: NetworkManagerProtocol = NetworkManager.shared) {
        self.navigationController = navigationController
        self.networkClient = networkClient
    }

    func showDetailScreen(article: ArticleDetails,
                          prefetchedImage: UIImage?,
                          onSave: @escaping ((ArticleDetails?) -> Void?)) {
        let detailsVC = DetailsViewController()
        detailsVC.article = article
        detailsVC.prefetchedImage = prefetchedImage
        detailsVC.closure = onSave
        navigationController.pushViewController(detailsVC, animated: true)
    }
}
