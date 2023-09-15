//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Дмитрий Рыбаков on 05.09.2023.
//

import UIKit

enum LoadingMode {
    case random
    case search(String)
}

class SearchViewController: UIViewController {
    
    private let dataFetcher = NetworkDataFetcher()
    
    private var currentPosts = [Post]()
    private var currentPageCounter = 1
    private var currentMode: LoadingMode = .random
    
    private var previousPosts = [Post]()
    private var previousPageCounter = 1
    private var previousMode: LoadingMode = .random
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchBar()
        collectionView.reloadData()
        loadRandomPhotosData()
    }
    
    private func loadRandomPhotosData() {
        dataFetcher.getRandomPhotos(pageNumber: currentPageCounter) { result in
            switch result {
            case .success(let loadedPosts):
                self.currentPosts = loadedPosts
                self.currentPageCounter += 1
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func appendRandomPhotosData() {
        dataFetcher.getRandomPhotos(pageNumber: currentPageCounter) { result in
            switch result {
            case .success(let loadedPosts):
                self.currentPosts.append(contentsOf: loadedPosts)
                self.currentPageCounter += 1
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadSearchedPhotosData(target: String) {
        dataFetcher.getSearchedPhotos(pageNumber: currentPageCounter, target: target) { result in
            switch result {
            case .success(let loadedPosts):
                self.currentPosts = loadedPosts
                self.currentPageCounter += 1
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func appendSearchedPhotosData(target: String) {
        dataFetcher.getSearchedPhotos(pageNumber: currentPageCounter, target: target) { result in
            switch result {
            case .success(let loadedPosts):
                self.currentPosts.append(contentsOf: loadedPosts)
                self.currentPageCounter += 1
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCollectionCell.self, forCellWithReuseIdentifier: SearchResultCollectionCell.identifier)
        view.addSubview(collectionView)
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.setValue("Cancel", forKey: "cancelButtonText")
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            return self.createPhotoSection()
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func createPhotoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 15, bottom: 0, trailing: 15)
       
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == currentPosts.count - 2 {
            switch currentMode {
            case .random:
                appendRandomPhotosData()
            case .search(let target):
                appendSearchedPhotosData(target: target)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SearchResultCollectionCell else { return }
        let detailVC = DetailsPhotoViewController(post: currentPosts[indexPath.row], image: cell.imageView.image)
        UIView.animate(withDuration: 0.15) {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.05) {
                cell.transform = .identity
                self.present(detailVC, animated: true)
            }
        }
        
        
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionCell.identifier, for: indexPath) as? SearchResultCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: currentPosts[indexPath.row])
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text != "" else { return }
        previousMode = currentMode
        previousPageCounter = currentPageCounter
        currentPageCounter = 1
        previousPosts = currentPosts
        currentMode = .search(text)
        loadSearchedPhotosData(target: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentMode = previousMode
        currentPageCounter = previousPageCounter
        if !previousPosts.isEmpty {
            self.currentPosts = previousPosts
        } else {
            loadRandomPhotosData()
        }
        
        collectionView.reloadData()
    }
}

