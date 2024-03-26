//
//  CharacterDetailsViewControllerRepresentable.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 26/03/2024.
//

import Foundation
import SwiftUI

struct CharacterDetailsViewControllerRepresentable: UIViewControllerRepresentable {

    typealias UIViewControllerType = CharacterDetailsViewController

    let character: Character

    init(character: Character) {

        self.character = character
    }

    func makeUIViewController(context: Context) -> CharacterDetailsViewController {

        return CharacterDetailsViewController(character: self.character)
    }

    func updateUIViewController(_ uiViewController: CharacterDetailsViewController, context: Context) { }
}
