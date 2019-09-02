//
//  FavoritesViewController.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

class FavoritesViewController: ViewController {

    struct Layout {
        struct CollectionView {
            static let backgroundColor: UIColor         = .clear
            static let itemSize: CGSize                 = CGSize(width: 165, height: 124)
            static let minimumLineSpacing: CGFloat      = 10
            static let minimumInteritemSpacing: CGFloat = 5.0
            static let sectionInset: UIEdgeInsets       = .init(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            static let itemIdentifier                   = CardCollectionCell.className
        }
        
        struct SearchBar {
            static let searchBarFont: UIFont       = .systemFont(ofSize: 16.0)
            static let searchBarTextColor: UIColor = .white
            static let searchBarTintColor: UIColor = .clear
        }
    }

    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout                     = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize                = Layout.CollectionView.itemSize
        collectionViewLayout.minimumLineSpacing      = Layout.CollectionView.minimumLineSpacing
        collectionViewLayout.minimumInteritemSpacing = Layout.CollectionView.minimumInteritemSpacing
        collectionViewLayout.scrollDirection         = .vertical
        collectionViewLayout.sectionInset            = Layout.CollectionView.sectionInset
        return collectionViewLayout
    }()

    var collectionView: UICollectionView
    var backgroundNoFavaorites: NoContentView
    var searchBarController: CustomSearchController!
    var presenter: FavoritesPresenter?
    
    init() {
        collectionView = .init(frame: .zero, collectionViewLayout: .init())
        backgroundNoFavaorites = .init()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCollectionViewData()
    }
    
    private func hideBackTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    private func setupSearchBar() {
        let searchBarFrame: CGRect = CGRect(x: 0, y: 0, width: view.frame.width, height: 50.0)
        searchBarController = CustomSearchController(searchResultsController: self,
                                                     searchBarFrame: searchBarFrame,
                                                     searchBarFont: Layout.SearchBar.searchBarFont,
                                                     searchBarTextColor: Layout.SearchBar.searchBarTextColor,
                                                     searchBarTintColor: Layout.SearchBar.searchBarTintColor)
        searchBarController.customSearchBar?.placeholder = "Search your favorite movies..."
        searchBarController.customDelegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBarController.customSearchBar!)
    }

    override func addViewHierarchy() {
        view.addSubview(collectionView)
        collectionView.register(CardCollectionCell.self, forCellWithReuseIdentifier: Layout.CollectionView.itemIdentifier)
    }

    override func setupConstraints() {
        view.layoutIfNeeded()
        activate(collectionView.anchor.top.bottom.left.right.equal.to(view.anchor))
    }

    override func configureViews() {
        view.backgroundColor = .darkGrayThemeColor
        hideBackTitle()
        setupCollectionView()
        setupSearchBar()
    }

    private func setupCollectionView() {
        let delegate = presenter?.getDelegate(vc: self)
        collectionView.dataSource = presenter?.getDataSource(vc: self)
        collectionView.delegate   = delegate
        collectionView.dragDelegate = delegate
        collectionView.dropDelegate = delegate
        collectionView.dragInteractionEnabled = true
        collectionView.reorderingCadence = .fast
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = Layout.CollectionView.backgroundColor
        collectionView.collectionViewLayout = collectionViewFlowLayout
    }
    
    private func reloadCollectionViewData() {
        presenter?.reloadData()
        collectionView.reloadData()
        setBackgroundNoFavoritesIfNeeds()
    }
    
    func setBackgroundNoFavoritesIfNeeds() {
        if collectionView.numberOfItems(inSection: 0) == 0 {
            if collectionView.backgroundView == nil {
                backgroundNoFavaorites.alpha = 0.0
                collectionView.backgroundView = backgroundNoFavaorites

                UIView.animate(withDuration: 0.6, delay: 0, options: .transitionCrossDissolve, animations: { [weak self] in
                    guard let self = self else { return }
                    self.backgroundNoFavaorites.alpha = 1.0
                }, completion: nil)
            }
        } else {
            UIView.animate(withDuration: 0.6, delay: 0, options: .transitionCrossDissolve, animations: { [weak self] in
                guard let self = self else { return }
                self.backgroundNoFavaorites.alpha = 0.0
            }, completion: { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.backgroundView = nil
            })
        }
    }
}

// MARK: HandlerProtocol
extension FavoritesViewController: CardInteractionDelegate {
    func didRemoveFromFavorites(_ item: Movie, index: IndexPath) {
        collectionView.performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            self.presenter?.removeFromFavorite(item)
            self.collectionView.deleteItems(at: [index])
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.setBackgroundNoFavoritesIfNeeds()
        })
    }

    func didAddToFavorites(_ items: [Movie]) {
        presenter?.addToFavorites(items)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.setBackgroundNoFavoritesIfNeeds()
        }
    }

    func didSelectItem(_ item: Movie) {
        presenter?.didSelectItem(item)
    }
}

// MARK: SearchBarDelegates
extension FavoritesViewController: CustomSearchControllerDelegate {
    func didStartSearching() {}
    
    func didTapOnSearchButton() {}
    
    func didTapOnCancelButton() {
        presenter?.searchWasCanceled()
        reloadCollectionViewData()
    }
    
    func didChangeSearchText(searchText: String) {
        presenter?.filterDataBy(searchText)
        reloadCollectionViewData()
    }
}
