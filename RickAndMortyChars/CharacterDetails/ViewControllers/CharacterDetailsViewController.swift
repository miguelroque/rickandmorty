//
//  CharacterDetailsViewController.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 25/03/2024.
//

import Foundation
import UIKit
import SwiftUI

class CharacterDetailsViewController: UIViewController { 

    private enum Constants {

        static let screenMargins: CGFloat = 16
    }

    let characterDetailsView = CharacterDetailsView()

    init() {

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        let detailSessionConfig = DetailSectionConfig(title: "title",
                                                      description: "description")

        self.characterDetailsView.configureView(with: UIImageView(), sections: [detailSessionConfig])

        self.view.addSubview(self.characterDetailsView)

        self.characterDetailsView.edgeToSuperview(topMargin: Constants.screenMargins,
                                                  bottomMargin: Constants.screenMargins,
                                                  leadingMargin: Constants.screenMargins,
                                                  trailingMargin: Constants.screenMargins)
    }
}

struct UIKitViewWrapper: UIViewControllerRepresentable {

    typealias UIViewControllerType = CharacterDetailsViewController

    func makeUIViewController(context: Context) -> CharacterDetailsViewController {

        return CharacterDetailsViewController()
    }

    func updateUIViewController(_ uiViewController: CharacterDetailsViewController, context: Context) { }
}
