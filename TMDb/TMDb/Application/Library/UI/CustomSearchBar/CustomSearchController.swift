//
//  CustomSearchController.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

protocol CustomSearchControllerDelegate {
    func didStartSearching()
    func didTapOnSearchButton()
    func didTapOnCancelButton()
    func didChangeSearchText(searchText: String)
}

class CustomSearchController: UISearchController {
    var customSearchBar: CustomSearchBar?
    var customDelegate: CustomSearchControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(searchResultsController: UIViewController?, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        configureCustomSearchBar(searchBarFrame: searchBarFrame, searchBarFont: searchBarFont, searchBarTextColor: searchBarTextColor, searchBarTintColor: searchBarTintColor)
    }
    
    private func configureCustomSearchBar(searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        customSearchBar = CustomSearchBar(frame: searchBarFrame, customFont: searchBarFont, customTextColor: searchBarTextColor)
        customSearchBar?.barTintColor = searchBarTintColor
        customSearchBar?.tintColor = searchBarTextColor
        customSearchBar?.showsBookmarkButton = false
        customSearchBar?.delegate = self
        hideCancelButton()
    }
    
    private func showCancelButton() {
        customSearchBar?.showsCancelButton = true
        UIView.animate(withDuration: 0.1) {
            self.customSearchBar?.layoutIfNeeded()
        }
    }

    private func hideCancelButton() {
        customSearchBar?.showsCancelButton = false
        UIView.animate(withDuration: 0.1) {
            self.customSearchBar?.layoutIfNeeded()
        }
    }

    func setInitialState() {
        customSearchBar?.text = nil
        customSearchBar?.resignFirstResponder()
        hideCancelButton()
    }
}

// MARK: UISearchBarDelegate functions
extension CustomSearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showCancelButton()
        customDelegate?.didStartSearching()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideCancelButton()
        customSearchBar?.resignFirstResponder()
        customDelegate?.didTapOnSearchButton()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideCancelButton()
        customSearchBar?.resignFirstResponder()
        customDelegate?.didTapOnCancelButton()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        customDelegate?.didChangeSearchText(searchText: searchText)
    }
}
