//
//  NoDataAvailableView.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 26/03/2024.
//

import Foundation
import SwiftUI

struct NoDataAvailableView: View {

    let retryAction: () -> Void

    var body: some View {

        VStack {
            Text("No Data Available")
            Button(action: {
                retryAction()
            }) {
                Text("Try Again")
            }
        }
    }
}
