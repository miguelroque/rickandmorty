//
//  CharacterDetailsView.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 25/03/2024.
//

import Foundation
import UIKit

class CharacterDetailsView: UIView {

    private enum Constants {

        static let stackViewSpacing: CGFloat = 16
    }

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    init() {

        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    func configureView(with image: UIImageView,
                       sections: [DetailSection]) {

        self.addViews(image: image,
                      sections: sections)
        self.defineSubviews()
        self.addSubviewConstraints()
    }
}

private extension CharacterDetailsView {

    func addViews(image: UIImageView,
                  sections: [DetailSection]) {

        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(image)
        self.stackView.addArrangedSubviews(sections.map { CharacterDetailsSectionView(config: DetailSectionConfig(title: $0.title,
                                                                                                                  description: $0.description)) })
    }

    func defineSubviews() {

        self.stackView.axis = .vertical
        self.stackView.spacing = Constants.stackViewSpacing
    }

    func addSubviewConstraints() {

        self.scrollView.edgeToSuperview()
        self.stackView.edgeToSuperview()

        NSLayoutConstraint.activate([

            self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
}

extension UIStackView {

    func addArrangedSubviews(_ views: [UIView]) {

        for view in views { self.addArrangedSubview(view) }
    }
}
