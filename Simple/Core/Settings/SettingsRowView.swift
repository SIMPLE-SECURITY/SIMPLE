//
//  SettingsRowView.swift
//  SIMPLE
//
//  Created by Charles Shin on 2/8/23.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)

            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.primary)
                // .foregroundColor(.black)
        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(imageName: "paperplane.circle.fill",
                        title: "Test",
                        tintColor: Color(.systemPink))
    }
}
