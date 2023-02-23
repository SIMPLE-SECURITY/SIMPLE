//
//  MapViewActionButton.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/19/23.
//

import SwiftUI

struct MapViewActionButton: View {
    var action: () -> Void
    let imageName: String
    let tintColor: Color
    let dimension: CGFloat = 56
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .imageScale(.large)
                .frame(width: dimension, height: dimension)
                .background(tintColor)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.7), radius: 6)
        }
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(action: {},
                            imageName: "exclamationmark.bubble.fill",
                            tintColor: Color(.systemRed))
    }
}
