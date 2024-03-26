//
//  CharacterRow.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 22/03/2024.
//

import SwiftUI

struct CharacterRow: View {
    let character: Character

    var body: some View {
        
        HStack {
            AsyncImageView(url: self.character.imageURL)
                .frame(width: 75, height: 75)
                .clipShape(Circle())
            Text(self.character.name)
        }
        .padding()
    }
}
