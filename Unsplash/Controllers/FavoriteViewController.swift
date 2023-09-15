//
//  FavoriteViewController.swift
//  Unsplash
//
//  Created by Дмитрий Рыбаков on 05.09.2023.
//

import UIKit

class FavoriteViewController: UIViewController {
    
//    var collectionView: UICollectionView!
    let authLabel = UILabel()
    let authButton = UIButton(type: .system)
    
    private let user: User?
    
    init(with user: User?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if let user = user {
            authLabel.isHidden = true
            authButton.isHidden = true
        } else {
            authLabel.isHidden = false
            authButton.isHidden = false
            setupAuthUI()
        }
//        setupCollectionView()
       
    }
    
    private func setupAuthUI() {
        authLabel.text = "Sorry, \nCan't get user favorites \nwithout authentication."
        authLabel.textAlignment = .center
        authLabel.numberOfLines = 0
        authLabel.textColor = .gray
        authLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authLabel)
        
        authButton.setTitle("Log in", for: .normal)
        authButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        authButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        authButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authButton)
        
        NSLayoutConstraint.activate([
            authLabel.heightAnchor.constraint(equalToConstant: 61),
            authLabel.widthAnchor.constraint(equalToConstant: 182),
            authLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            authButton.topAnchor.constraint(equalTo: authLabel.bottomAnchor, constant: 8),
            authButton.centerXAnchor.constraint(equalTo: authLabel.centerXAnchor)
        ])
    }
    
    @objc private func authButtonTapped() {
//        let authVC = AuthViewController()
//        self.present(authVC, animated: true)
        print(UnsplashApi.clientID)
    }
    
//    private func setupCollectionView() {}

}
