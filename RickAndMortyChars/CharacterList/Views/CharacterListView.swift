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

    @State private var viewModel: CharacterListViewModelProtocol = CharacterListViewModel()

    var body: some View {

        if self.viewModel.state == .failed {

            NoDataAvailableView {

                self.viewModel.retryButtonClicked()
            }

        } else {

            NavigationView {
                List {
                    ForEach(self.viewModel.characters,
                            id: \.id) { character in

                        NavigationLink(destination: CharacterDetailsViewControllerRepresentable(character: character)
                            .navigationTitle(character.name)) {

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
}
