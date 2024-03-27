//
//  CharacterDetailsErrorView.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 27/03/2024.
//

import Foundation
import UIKit

protocol CharacterDetailsErrorViewDelegate: AnyObject {

    func didPressRetryButton()
}

class CharacterDetailsErrorView: UIView {

    private enum Constants {

        static let stackViewSpacing: CGFloat = 4
    }

    private let stackView = UIStackView()
    
    weak var delegate: CharacterDetailsErrorViewDelegate?

    init() {

        super.init(frame: CGRect.zero)

        self.configureView()
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Configuration

private extension CharacterDetailsErrorView {

    func configureView() {

        self.addViews()
        self.defineSubviews()
        self.addSubviewConstraints()
    }

    func addViews() { 

        self.addSubview(self.stackView)

        let errorLabel = UILabel()
        errorLabel.useAutoLayout()
        errorLabel.text = "There was an error"
        errorLabel.numberOfLines = 1
        
        let retryButton = UIButton(type: .system)
        retryButton.useAutoLayout()
        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)

        self.stackView.addArrangedSubviews([errorLabel, retryButton])
    }

    func defineSubviews() {

        self.stackView.spacing = Constants.stackViewSpacing
        self.stackView.axis = .vertical
        self.stackView.alignment = .center
    }

    func addSubviewConstraints() {

        self.stackView.useAutoLayout()

        self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    @objc
    func retryButtonTapped() {

        self.delegate?.didPressRetryButton()
    }
}

