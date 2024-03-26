//
//  UIView+EdgeToSuperview.swift
//  RickAndMortyChars
//
//  Created by Miguel Roque Ferreira on 26/03/2024.
//

import UIKit

public extension UIView {

    func edgeToSuperview(topMargin: CGFloat = 0,
                         bottomMargin: CGFloat = 0,
                         leadingMargin: CGFloat = 0,
                         trailingMargin: CGFloat = 0) {

        guard let superview = superview else {

            fatalError("View has no superview. Make sure to add it to a superview before calling edgeToSuperview.")
        }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: topMargin),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leadingMargin),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailingMargin),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottomMargin)
        ])
    }
}
