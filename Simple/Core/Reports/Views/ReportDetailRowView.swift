//
//  ReportDetailRowView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/24/23.
//

import SwiftUI

struct ReportDetailRowViewModel {
    let title: String
    let description: String
}

struct ReportDetailRowView: View {
    let model: ReportDetailRowViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.bottom, 1)
            
            Text(model.description)
                .font(.footnote)
        }
    }
}

struct ReportDetailRowView_Previews: PreviewProvider {
    static var previews: some View {
        ReportDetailRowView(model: .init(title: "Description", description: "Person injured on street"))
    }
}
