//
//  CharacterDetailsSectionView.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 25/03/2024.
//

import Foundation
import UIKit

public protocol DetailSection {

    var title: String { get }
    var description: String { get }
}

public struct DetailSectionConfig: DetailSection {

    public let title: String
    public let description: String
}

class CharacterDetailsSectionView: UIView {

    private enum Constants {

        static let stackViewSpacing: CGFloat = 4
    }

    private let stackView = UIStackView()

    init(config: DetailSection) {

        super.init(frame: CGRect.zero)

        self.configureView(with: config)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }
}

private extension CharacterDetailsSectionView {

    func configureView(with section: DetailSection) {

        self.addViews(section: section)
        self.defineSubviews()
        self.addSubviewConstraints()
    }

    func addViews(section: DetailSection) {

        self.addSubview(self.stackView)

        let titleView = UILabel()
        titleView.text = section.title
        titleView.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)

        let descriptionView = UILabel()
        descriptionView.text = section.description
        descriptionView.numberOfLines = 0

        self.stackView.addArrangedSubviews([titleView, descriptionView])
    }

    func defineSubviews() {

        self.stackView.axis = .vertical
        self.stackView.spacing = Constants.stackViewSpacing
    }

    func addSubviewConstraints() {

        self.stackView.edgeToSuperview()
    }
}
