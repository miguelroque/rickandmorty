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

    private var viewModel: CharacterListViewModelProtocol = CharacterListViewModel(networkingApi: RickAndMortyNetworking())

    var body: some View {
        NavigationView {
            List {
                ForEach(self.viewModel.characters,
                        id: \.id) { character in

                    NavigationLink(destination: CharacterDetail(character: character)) {

                        CharacterRow(character: character)
                    }.onAppear {

                        if character == self.viewModel.characters.last {

                            self.viewModel.lastItemReached()
                        }
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