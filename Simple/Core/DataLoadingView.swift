//
//  DataLoadingView.swift
//  Simple
//
//  Created by Morris Richman on 8/20/23.
//

import SwiftUI

struct DataLoadingView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Image(colorScheme == .dark ? "simple-logo-dark" : "simple-logo")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.vertical, 32)
            ProgressView()
        }
    }
}

struct DataLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        DataLoadingView()
    }
}
