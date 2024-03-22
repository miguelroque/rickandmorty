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
            AsyncImage(url: self.character.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            Text(self.character.name)
        }
        .padding()
    }
}
