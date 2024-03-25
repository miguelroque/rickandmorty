//
//  AsyncImageView.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 24/03/2024.
//

import SwiftUI
import Kingfisher

struct AsyncImageView: View {

    @State private var isLoading = true

    let url: URL?

    var body: some View {

        KFImage(url)
            .placeholder {

                if isLoading {

                    ProgressView()

                } else {

                    Image("NoDataAvailable")
                        .resizable()
                        .scaledToFit()
                }
            }
            .onSuccess { _ in
                self.isLoading = false
            }
            .onFailure { error in
                self.isLoading = false
            }
            .resizable()
            .scaledToFit()
    }
}
