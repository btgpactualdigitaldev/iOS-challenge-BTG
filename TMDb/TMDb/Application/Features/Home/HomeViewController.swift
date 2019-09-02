//
//  HomeViewController.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Reachability
import Anchors

class HomeViewController: ViewController {

    struct Layout {
        struct CollectionView {
            static let backgroundColor: UIColor         = .clear
            static let itemSize: CGSize                 = CGSize(width: 165, height: 124)
            static let minimumLineSpacing: CGFloat      = 10
            static let minimumInteritemSpacing: CGFloat = 5.0
            static let sectionInset: UIEdgeInsets       = .init(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            static let bannerReuseIdentifier            = BannerCollectionCell.className
            static let itemIdentifier                   = CardCollectionCell.className
            static let headerIdentifier                 = SectionHeaderReusableView.className
            static let footerIdentifier                 = UICollectionReusableView.className
        }
    }

    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout: UICollectionViewFlowLayout = .init()
        collectionViewLayout.itemSize                        = Layout.CollectionView.itemSize
        collectionViewLayout.minimumLineSpacing              = Layout.CollectionView.minimumLineSpacing
        collectionViewLayout.minimumInteritemSpacing         = Layout.CollectionView.minimumInteritemSpacing
        collectionViewLayout.scrollDirection                 = .vertical
        collectionViewLayout.sectionInset                    = Layout.CollectionView.sectionInset
        return collectionViewLayout
    }()
    
    private var collectionView: UICollectionView
    var searchBarController: CustomSearchController?
    var presenter: HomePresenter?
    private var interaction: UIDropInteraction!
    private let tabIndexAllowedDropInteraction: Int = 1
    private var delayControlTime: TimeInterval = 1
    private var delayItem: DispatchWorkItem?

    init() {
        collectionView = .init(frame: .zero, collectionViewLayout: .init())
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.delegate = self
        presenter?.fetchData(for: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDropInteractionInTabBar()
        reloadCollectionViewData()
        ReachabilityManager.shared.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeDropInteractionFromTabBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ReachabilityManager.shared.removeListener(listener: self)
    }
    
    override func execute(deepLink: DeeplinkType) {
        presenter?.route(deepLink: deepLink)
    }

    override func addViewHierarchy() {
        view.addSubview(collectionView)
        collectionView.register(BannerCollectionCell.self, forCellWithReuseIdentifier: Layout.CollectionView.bannerReuseIdentifier)
        collectionView.register(CardCollectionCell.self, forCellWithReuseIdentifier: Layout.CollectionView.itemIdentifier)
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Layout.CollectionView.headerIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Layout.CollectionView.footerIdentifier)
    }

    override func setupConstraints() {
        activate(
            collectionView.anchor.top.bottom.left.right.equal.to(view.anchor)
        )
    }

    override func configureViews() {
        view.backgroundColor = .darkGrayThemeColor
        hideBackTitle()
        setupCollectionView()
        setupSearchBar()
    }

    private func hideBackTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    private func setupDropInteractionInTabBar() {
        interaction = UIDropInteraction(delegate: self)
        tabBarController?.tabBar.addInteraction(interaction)
    }
    
    private func removeDropInteractionFromTabBar() {
        tabBarController?.tabBar.removeInteraction(interaction)
    }
    
    private func setupSearchBar() {
        let searchBarFrame: CGRect = CGRect(x: 0, y: 0, width: view.frame.width, height: 50.0)
        let searchBarFont: UIFont = UIFont.systemFont(ofSize: 16.0)
        let searchBarTextColor: UIColor = UIColor.white
        let searchBarTintColor: UIColor = UIColor.clear
        
        searchBarController = CustomSearchController(searchResultsController: self,
                                                     searchBarFrame: searchBarFrame,
                                                     searchBarFont: searchBarFont,
                                                     searchBarTextColor: searchBarTextColor,
                                                     searchBarTintColor: searchBarTintColor)
        searchBarController?.customSearchBar?.placeholder = "Search for movies..."
        searchBarController?.customDelegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBarController!.customSearchBar!)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = Layout.CollectionView.backgroundColor
        collectionView.isScrollEnabled = true

        let catalogDelegate = presenter?.getDelegate(vc: self)
        collectionView.dataSource = presenter?.getDataSource(vc: self)
        collectionView.delegate   = catalogDelegate
        
        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.dragDelegate = catalogDelegate
        collectionView.dragInteractionEnabled = true
        collectionView.reorderingCadence = .fast

        collectionView.refreshControlHandler { [weak self] (refreshControl) in
            self?.searchBarController?.setInitialState()
            refreshControl.beginRefreshing()
            self?.presenter?.fetchData(for: 1, isPullRefresh: true, completionHandler: {
                refreshControl.endRefreshing()
            })
        }
    }
    
    private func autoSwitchTabBarSection() {
        if delayItem?.isCancelled == true {
            delayItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.tabBarController?.selectedIndex = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delayControlTime,
                                          execute: delayItem!)
        }
    }
    
    private func abortAutoSwitchTabBarSection() {
        delayItem?.cancel()
    }
    
    private func reloadCollectionViewData() {
        presenter?.reloadData()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

// MARK: NetworkStatusListener
extension HomeViewController: NetworkStatusListener {
    func networkStatusDidChange(status: Reachability.Connection) {
        switch status {
        case .none:
            break
        case .wifi, .cellular:
            if collectionView.numberOfItems(inSection: 1) == 0 {
                presenter?.fetchData(for: 0)
            } else {
                reloadCollectionViewData()
            }
            break
        }
    }
}

// MARK: CardInteractionDelegate
extension HomeViewController: CardInteractionDelegate {
    func didRemoveFromFavorites(_ item: Movie, index: IndexPath) {
        presenter?.removeFromFavorites(item)
    }

    func didAddToFavorites(_ item: Movie) {
        presenter?.addToFavorites(item)
    }
    
    func didSelectItem(_ item: Movie) {
        presenter?.didSelectItem(item)
    }
}

// MARK: DataPaginationDelegate
extension HomeViewController: PaginationDelegate {
    func paginate(to nextPage: Int) {
        if searchBarController?.searchBar.text == nil || searchBarController?.searchBar.text?.isEmpty == true {
            presenter?.fetchData(for: nextPage)
        }
    }
}

// MARK: PresenterDelegate
extension HomeViewController: HomePresenterDelegate {
    func hidePaginationIndicator() {
        reloadCollectionViewData()
    }

    func presentFeedbackLoading(isLoading: Bool) {
        if isLoading {
            Loading.shared.showLoading()
        }else{
            Loading.shared.hideLoading()
        }
    }

    func onError(title: String?, message: String?) {
        showSimpleAlert(title: title, text: message, cancelButtonTitle: "Ok")
    }

    func dataSourceDidUpdate(result: PaginationResultType) {
        switch result {
        case .insertPageData(let newDataCount, let updateDataHandler):
            let section: Int  = collectionView.numberOfSections - 1
            let row: Int      = collectionView.numberOfItems(inSection: section)
            let lastIndexPath = IndexPath(row: row, section: section)

            collectionView.performBatchUpdates({
                var indexs: [IndexPath] = []
                updateDataHandler()
                for idx in 0...newDataCount {
                    let newIndex: IndexPath = IndexPath(item: lastIndexPath.row + idx, section: lastIndexPath.section)
                    indexs.append(newIndex)
                }
                collectionView.insertItems(at: indexs)
            }, completion: nil)
        case .newData:
            reloadCollectionViewData()
        case .noData:
            break
        }
    }
}

// MARK: SearchBarDelegates
extension HomeViewController: CustomSearchControllerDelegate {
    func didStartSearching() {}
    func didTapOnSearchButton() {
        guard let searchText = searchBarController?.customSearchBar?.text, !searchText.isEmpty else {
            return
        }
        presenter?.filterDataBy(searchText)
    }

    func didTapOnCancelButton() {
        presenter?.searchWasCanceled()
    }
    
    func didChangeSearchText(searchText: String) {
        presenter?.filterDataBy(searchText)
    }
}


// MARK: UIDropInteractionDelegate for TabBar
extension HomeViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let operation: UIDropOperation
        let dropLocation = session.location(in: view)
        
        if session.localDragSession != nil {
            if let viewAllowed = tabBarController?.orderedTabBarItemViews[tabIndexAllowedDropInteraction] {
                
                let relativeFrame = viewAllowed.convert(viewAllowed.bounds, to: view)
                
                if relativeFrame.contains(dropLocation) {
                    operation = .copy
                    autoSwitchTabBarSection()
                } else {
                    operation = .forbidden
                    abortAutoSwitchTabBarSection()
                }
            } else {
                operation = .cancel
                abortAutoSwitchTabBarSection()
            }
        } else {
            operation = .cancel
            abortAutoSwitchTabBarSection()
        }
        return UIDropProposal(operation: operation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        abortAutoSwitchTabBarSection()
        session.loadObjects(ofClass: Movie.self) { [weak self] (items) in
            guard let self = self else { return }
            if let items = items as? [Movie] {
                self.presenter?.addToFavorites(items)
            }
        }
    }
}
