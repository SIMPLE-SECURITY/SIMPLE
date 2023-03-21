//
//  LocationSearchView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/19/23.
//

import SwiftUI

struct LocationSearchView: View {
    @ObservedObject var viewModel: OSReportViewModel
    @Binding var selectedLocation: String?
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let userName = authViewModel.currentUser?.fullname ?? "N/A"
        VStack {
            TextField("Search for a location...", text: $viewModel.queryFragment)
                .frame(height: 36)
                .padding(.leading)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding()
            
            List {
                ForEach(viewModel.results, id: \.self) { result in
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .foregroundColor(Color(userName.contains("👮‍♂️") ? .systemRed : .systemBlue))
                            .accentColor(.white)
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(result.title)
                                .font(.body)
                            
                            Text(result.subtitle)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                            
                        }
                        .padding(.leading, 8)
                        .padding(.vertical, 8)
                    }
                    .onTapGesture {
                        viewModel.updateCustomLocationAddressString(result)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Custom Location")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(PlainListStyle())
            
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(viewModel: OSReportViewModel(), selectedLocation: .constant(""))
    }
}
