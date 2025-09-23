//
//  SceneDelegate.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/8/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var appCoordinator: ArticleListCoordinator?

       func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
                  options connectionOptions: UIScene.ConnectionOptions) {
           guard let windowScene = (scene as? UIWindowScene) else { return }
           let window = UIWindow(windowScene: windowScene)
           let articleViewModel: ArticleViewModelProtocol = ArticleViewModel()
           let articleViewController = ArticleViewController(viewModel: articleViewModel)
           let navigationController = UINavigationController(rootViewController: articleViewController)
           navigationController.tabBarItem = UITabBarItem(
            title: "Home", image: UIImage(systemName: "house.fill"), tag: 1)
           let countryViewModel: CountryViewModelProtocol = CountryViewModel()
           let searchCountryViewController = SearchCountryViewController(viewModel: countryViewModel)
           searchCountryViewController.tabBarItem = UITabBarItem(
            title: "Search Country", image: UIImage(systemName: "magnifyingglass"), tag: 2)
           
           let notificationsViewController = NotificationsViewController()
           notificationsViewController.tabBarItem = UITabBarItem(
            title: "Notifications", image: UIImage(systemName: "bell.fill"), tag: 3)
           
           let profileViewController = ProfileViewController()
           profileViewController.tabBarItem = UITabBarItem(
            title: "Profile", image: UIImage(systemName: "person.circle.fill"), tag: 4)
           
           let tabBarController = UITabBarController()
           tabBarController.viewControllers = [navigationController, searchCountryViewController, notificationsViewController, profileViewController]
           
           tabBarController.tabBar.tintColor = .systemBlue
           tabBarController.tabBar.unselectedItemTintColor = .secondaryLabel
           
           let coordinator = ArticleListCoordinator(navigationController: navigationController)
           articleViewController.coordinatorFlowDelegate = coordinator
           self.appCoordinator = coordinator
           window.rootViewController = tabBarController
           self.window = window
           window.makeKeyAndVisible()
       }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // removed comments from here
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

