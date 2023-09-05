//
//  FavoriteViewController.swift
//  Unsplash
//
//  Created by Дмитрий Рыбаков on 05.09.2023.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    let button = UIButton(type: .system)
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(button)
        button.frame.size = CGSize(width: 200, height: 80)
        button.center = view.center
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        button.setTitle("Download", for: .normal)
    }
    
    @objc func tap() {
//        apiTasker.getRandomPhotos(pageNumber: 2) { result in
//            switch result {
//            case .success(let posts):
//                print(posts.count)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        
//        apiTasker.getSearchedPhotos(pageNumber: 3, target: "cat") { result in
//            switch result {
//            case .success(let posts):
//                print(posts.count)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
}
