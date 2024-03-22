//
//  CharacterListView.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 22/03/2024.
//

import SwiftUI

#Preview {
    CharacterListView()
}

struct CharacterListView: View {
    @State private var characters = [Character]()
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            List {
                ForEach(characters, id: \.name) { character in
                    NavigationLink(destination: CharacterDetail(character: character)) {
                        CharacterRow(character: character)
                    }
                }
                if self.isLoading {
                    HStack {
                        Spacer()
                        ZStack {
                            // ProgressView not working 
                            Text("Loading more...")
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("Characters")
            .onAppear {
                self.loadCharacters()
            }
        }
    }

    func loadCharacters() {

        self.isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let newCharacters = [
                Character(name: "Character 1", imageURL: URL(string: "https://example.com/character1.jpg")!),
                Character(name: "Character 2", imageURL: URL(string: "https://example.com/character2.jpg")!)
            ]
            self.characters += newCharacters
            self.isLoading = false
        }
    }
}
