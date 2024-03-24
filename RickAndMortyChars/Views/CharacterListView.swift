//
//  CharacterListView.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 22/03/2024.
//

import SwiftUI
import RickAndMortyNetworking

#Preview {
    CharacterListView()
}

struct CharacterListView: View {

    private var viewModel = CharacterListViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(self.viewModel.characters,
                        id: \.name) { character in

                    NavigationLink(destination: CharacterDetail(character: character)) {

                        CharacterRow(character: character)
                    }
                }
                if self.viewModel.state == .loading {
                    LoadingView()
                }
            }
            .navigationTitle("Characters")
        }
    }
}
