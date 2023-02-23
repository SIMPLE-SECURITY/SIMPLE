//
//  OSInputField.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/13/23.
//

import SwiftUI

struct OSInputField: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // title
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            // text field
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
            }
            
            // divider
            Divider()
        }
    }
}

struct OSInputField_Previews: PreviewProvider {
    static var previews: some View {
        OSInputField(text: .constant(""), title: "Email", placeholder: "name@example.com")
    }
}
