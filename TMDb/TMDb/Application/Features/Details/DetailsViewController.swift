//
//  DetailsViewController.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//
import UIKit
import Anchors

class DetailsViewController: ViewController {
    
    enum FlipOrientation {
        case leftToRight
        case rightToLeft
    }
    
    lazy var favoriteButton: UIButton = {
        let bt: UIButton = UIButton(type: .custom)
        bt.setImage(#imageLiteral(resourceName: "icon_favorite_no_selected"), for: .normal)
        bt.setImage(#imageLiteral(resourceName: "icon_favorite_selected"), for: .selected)
        bt.addTarget(self, action: #selector(DetailsViewController.favoriteButtonPressed(_:)), for: .touchUpInside)
        return bt
    }()
    
    var frontCardView: FrontCardView!
    var backCardView: BackCardView!
    var presenter: DetailsPresenter?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func prepareViews() {
        frontCardView = .init(presenter?.getData())
        backCardView  = .init(presenter?.getData(), delegate: self)
    }

    override func addViewHierarchy() {
        view.addSubviews([frontCardView, backCardView])
    }

    override func setupConstraints() {
        activate(
            frontCardView.anchor.size.equal.to(view.anchor).multiplier(0.8),
            frontCardView.anchor.center.equal.to(view.anchor),
            backCardView.anchor.size.equal.to(view.anchor).multiplier(0.8),
            backCardView.anchor.center.equal.to(view.anchor)
        )
    }

    override func configureViews() {
        navigationItem.rightBarButtonItem = .init(customView: favoriteButton)
        view.backgroundColor              = .darkGrayThemeColor

        let frontCardTapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(frontCardTapped))
        frontCardTapGesture.numberOfTapsRequired = 1
        frontCardView.infoButton.addGestureRecognizer(frontCardTapGesture)

        let backCardTapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(backCardTapped))
        backCardTapGesture.numberOfTapsRequired = 1
        backCardView.backButton.addGestureRecognizer(backCardTapGesture)
        backCardView.alpha = 0.0
    }

    private func updateUI() {
        let isFavorited = presenter?.getData()?.isFavorite
        favoriteButton.isSelected = isFavorited.or(false)
    }

    private func flipView(from: UIView, to: UIView, transition: FlipOrientation) {
        var transitionOptions: UIView.AnimationOptions = []
        to.alpha = 0.0

        switch transition {
        case .leftToRight:
            transitionOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
        case .rightToLeft:
            transitionOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        }

        UIView.transition(with: from, duration: 1.0, options: transitionOptions, animations: {
            from.alpha = 0.0
        })

        UIView.transition(with: to, duration: 1.0, options: transitionOptions, animations: {
            to.alpha = 1.0
        })
    }

    @objc private func frontCardTapped() {
        backCardView.updateUI()
        flipView(from: frontCardView, to: backCardView, transition: .rightToLeft)
    }

    @objc private func backCardTapped() {
        flipView(from: backCardView, to: frontCardView, transition: .leftToRight)
    }

    @objc private func favoriteButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            presenter?.setAsFavorite()
        } else {
            presenter?.setAsUnFavorite()
        }
    }
}

extension DetailsViewController: ResourceItemInteractionDelegate {
    func didSelect(item: Genre) {
        showSimpleAlert(title: nil, text: item.name, cancelButtonTitle: "Close")
    }
}

