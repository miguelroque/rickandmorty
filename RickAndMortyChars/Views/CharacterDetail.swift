//
//  CharacterDetail.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 22/03/2024.
//

import SwiftUI

struct CharacterDetail: View {
    let character: Character

    var body: some View {
        Text("Detail view for \(self.character.name)")
            .navigationTitle(self.character.name)
    }
}
