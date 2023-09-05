//
//  SearchResultCollectionCell.swift
//  Unsplash
//
//  Created by Дмитрий Рыбаков on 05.09.2023.
//

import UIKit

class SearchResultCollectionCell: UICollectionViewCell {
    
    static let identifier = "searchResultCollectionCell"
    
    var imageView = WebImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    func configure(with model: Post) {
        if let urlString = model.urls["small"] {
            imageView.set(imageURL: urlString)
        }
    }
    
    
}
