//
//  CharacterDetailsViewController.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 25/03/2024.
//

import Foundation
import UIKit
import SwiftUI
import RickAndMortyNetworking
import Combine

class CharacterDetailsViewController: UIViewController { 

    private enum Constants {

        static let screenMargins: CGFloat = 16
    }

    let characterDetailsView = CharacterDetailsView()

    private let characterDetailsViewModel: CharacterDetailsViewModelProtocol
    private var cancellable = Set<AnyCancellable>()
    private let spinner = UIActivityIndicatorView(style: .large)

    init(character: Character,
         networkingAPI: RickAndMortyCharacterLocationFetcher = RickAndMortyNetworking()) {

        self.characterDetailsViewModel = CharacterDetailsViewModel(character: character,
                                                                   networkingAPI: networkingAPI)
        super.init(nibName: nil, bundle: nil)

        self.characterDetailsViewModel.loadLocation()
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.characterDetailsViewModel.currentState.receive(on: DispatchQueue.main).sink { [weak self] state in

            guard let self else { return }

            self.configureUI(for: state)
        }.store(in: &self.cancellable)
    }
}

private extension CharacterDetailsViewController {

    func configureUI(for state: CharacterDetailsViewState) {

        switch state {

        case .failed:
            break

        case .loading:
            self.showSpinner()

        case .loaded(let imageURL, let sections):
            self.hideSpinner()
            self.configureView(imageURL: imageURL, detailSections: sections)
        }
    }

    func configureView(imageURL: URL?, detailSections: [DetailSection]) {

        self.addSubviews()
        self.defineSubviews(imageURL: imageURL, detailSections: detailSections)
        self.defineSubviewConstraints()
    }

    func addSubviews() {

        self.view.addSubview(self.characterDetailsView)
    }

    func defineSubviews(imageURL: URL?, detailSections: [DetailSection]) {

        self.characterDetailsView.configureView(with: imageURL, sections: detailSections)
    }

    func defineSubviewConstraints() {

        self.characterDetailsView.edgeToSuperview(topMargin: Constants.screenMargins,
                                                  bottomMargin: Constants.screenMargins,
                                                  leadingMargin: Constants.screenMargins,
                                                  trailingMargin: Constants.screenMargins)
    }
}

private extension CharacterDetailsViewController {

    func showSpinner() {

        self.spinner.translatesAutoresizingMaskIntoConstraints = false
        self.spinner.color = .gray

        self.view.addSubview(spinner)

        self.spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        self.spinner.startAnimating()
    }

    func hideSpinner() {

        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
}
