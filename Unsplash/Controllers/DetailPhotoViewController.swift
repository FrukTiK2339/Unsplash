//
//  DetailPhotoViewController.swift
//  Unsplash
//
//  Created by Дмитрий Рыбаков on 06.09.2023.
//

import UIKit

class DetailsPhotoViewController: UIViewController {
    
    //data
    private var post: Post
    
    private var postImageView = WebImageView()
    private var postDiscriptionLabel = UILabel()
    private var postDateLabel = UILabel()
    
    private var likeButton = UIButton()
    
    private var userStackView = UIStackView()
    private var userContainerView = UIView()
    private var userCircleImageView = WebImageView()
    private var userNameLabel = UILabel()
    private var userLocationLabel = UILabel()
    private var supportLabel = UILabel()
    
    private var dateFormatterGet: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }
    private var dateFormatterPrint: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, d"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }
    
    init(post: Post, image: UIImage? = nil) {
        self.postImageView.image = image
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.0862745098, blue: 0.09803921569, alpha: 1)
        
        view.addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.set(imageURL: post.urls["regular"])
        postImageView.contentMode = .scaleAspectFill
        
        
        
        view.addSubview(userStackView)
        userStackView.translatesAutoresizingMaskIntoConstraints = false
        userStackView.layer.cornerRadius = 20
        userStackView.clipsToBounds = true
        userStackView.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.0862745098, blue: 0.09803921569, alpha: 1)
        userStackView.axis = .vertical
        userStackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        userStackView.isLayoutMarginsRelativeArrangement = true
        userStackView.spacing = 4
        
        var userStackViewHeight: CGFloat = 109
        
        
        
        userStackView.addArrangedSubview(userContainerView)
        userContainerView.translatesAutoresizingMaskIntoConstraints = false
        userContainerView.addSubview(userCircleImageView)
        userContainerView.addSubview(userNameLabel)
        userContainerView.addSubview(userLocationLabel)
        
        userCircleImageView.translatesAutoresizingMaskIntoConstraints = false
        userCircleImageView.set(imageURL: post.user.profileImage["small"])
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        userNameLabel.textColor = .lightText
        userNameLabel.text = post.user.name
        
        userLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        userLocationLabel.font = .systemFont(ofSize: 14, weight: .regular)
        userLocationLabel.textColor = .lightGray
        if let location = post.user.location {
            userLocationLabel.text = location
        } else {
            userStackViewHeight -= 16
        }
        
        userContainerView.addSubview(postDateLabel)
        postDateLabel.translatesAutoresizingMaskIntoConstraints = false
        postDateLabel.text = getDate(from: post)
        postDateLabel.textColor = .darkGray
        postDateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        postDateLabel.textAlignment = .right
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .lightGray
        userStackView.addArrangedSubview(separator)
        
        if let description = post.description {
            userStackView.addArrangedSubview(postDiscriptionLabel)
            
            postDiscriptionLabel.font = .systemFont(ofSize: 16, weight: .light)
            postDiscriptionLabel.textColor = .lightText
            postDiscriptionLabel.text = description
            postDiscriptionLabel.numberOfLines = 0
            supportLabel = postDiscriptionLabel
            supportLabel.frame.size.width = view.frame.width - 32
            supportLabel.sizeToFit()
            postDiscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            postDiscriptionLabel.heightAnchor.constraint(equalToConstant: supportLabel.frame.height).isActive = true
            userStackViewHeight += supportLabel.frame.height
        }
        
        
     
       
        userContainerView.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setTitle("", for: .normal)
        likeButton.setImage(UIImage(named: "unliked"), for: .normal)
        likeButton.setImage(UIImage(named: "liked"), for: .selected)
        likeButton.contentVerticalAlignment = .fill
        likeButton.contentHorizontalAlignment = .fill
        
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            userStackView.heightAnchor.constraint(equalToConstant: userStackViewHeight), //100 + postHeight
            userStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            userStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            userCircleImageView.heightAnchor.constraint(equalToConstant: 50),
            userCircleImageView.widthAnchor.constraint(equalToConstant: 50),
            userCircleImageView.leadingAnchor.constraint(equalTo: userContainerView.leadingAnchor),
            userCircleImageView.topAnchor.constraint(equalTo: userContainerView.topAnchor, constant: 16),
            
            userNameLabel.topAnchor.constraint(equalTo: userCircleImageView.topAnchor, constant: 3),
            userNameLabel.leadingAnchor.constraint(equalTo: userCircleImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: userContainerView.trailingAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 24),
            
            userLocationLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            userLocationLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userLocationLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            userLocationLabel.heightAnchor.constraint(equalToConstant: 16),
            
            postImageView.topAnchor.constraint(equalTo: view.topAnchor),
            postImageView.bottomAnchor.constraint(equalTo: userStackView.topAnchor, constant: 18),
            postImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            postDateLabel.bottomAnchor.constraint(equalTo: userContainerView.bottomAnchor, constant: -4),
            postDateLabel.heightAnchor.constraint(equalToConstant: 16),
            postDateLabel.leadingAnchor.constraint(equalTo: userCircleImageView.leadingAnchor),
            postDateLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: -8),
            
            likeButton.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: -16),
            likeButton.topAnchor.constraint(equalTo: userStackView.topAnchor, constant: 16),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func getDate(from post: Post) -> String {
        guard let date = dateFormatterGet.date(from: post.createdAt) else {
            return ""
        }
        return dateFormatterPrint.string(from: date).capitalized
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userCircleImageView.layer.cornerRadius = 25
        userCircleImageView.layer.masksToBounds = true
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
//        UIView.animate(withDuration: 0.15) {
//            sender.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//        } completion: { _ in
//            UIView.animate(withDuration: 0.1) {
//                sender.transform = .identity
//            } completion: { _ in
//                
//            }
//        }
    }
    
}
