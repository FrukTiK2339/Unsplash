//
//  MainTabBarController.swift
//  Unsplash
//
//  Created by Дмитрий Рыбаков on 05.09.2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchVC = SearchViewController()
        let favoriteVC = FavoriteViewController()
        
        tabBar.tintColor = .gray
        
        let boldConf = UIImage.SymbolConfiguration(weight: .medium)
        let searchImage = UIImage(systemName: "magnifyingglass", withConfiguration: boldConf)
        let favoriteImage = UIImage(systemName: "heart", withConfiguration: boldConf)
        
        viewControllers = [generateNavigationController(rootViewController: searchVC, title: "Search", image: searchImage),
                           generateNavigationController(rootViewController: favoriteVC, title: "Favorite", image: favoriteImage)]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navVC = UINavigationController(rootViewController: rootViewController)
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = image
        return navVC
    }
}

