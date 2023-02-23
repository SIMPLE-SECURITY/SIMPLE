//
//  OSMenuView.swift
//  SIMPLE
//
//  Created by Charles Shin on 1/13/23.
//

import SwiftUI

enum MenuOptions: Int, CaseIterable, Identifiable {
    case report
    case settings
    
    var title: String {
        switch self {
        case .report:
            return "Report"
        case .settings:
            return "Settings"
        }
    }
    
    var imageName: String {
        switch self {
        case .report:
            return "exclamationmark.bubble.fill"
        case .settings:
            return "gear"
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .report:
            return .systemRed
        case .settings:
            return .systemCyan
        }
    }
    
    var id: Int {
        return self.rawValue
    }
}

struct OSMenuView: View {
    @Binding var selectedMenuOption: MenuOptions
    @Binding var showCreateReportView: Bool
    
    var body: some View {
        HStack {
            ForEach(MenuOptions.allCases) { option in
                Button {
                    selectedMenuOption = option
                    showCreateReportView.toggle()
                } label: {
                    VStack(alignment: .center) {
                        Image(systemName: option.imageName)
                            .frame(width: 48, height: 48)
                            .background(Color(option.tintColor))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                        Text(option.title)
                            .font(.footnote)
                            .frame(width: 88)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 100)
        .background(Color.white)
        .cornerRadius(10)
//        .presentationDetents([.medium, .large, .height(100)])
//        .interactiveDismissDisabled(true)
//        .onAppear {
//            guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
//            if let controller = windows.windows.first?.rootViewController?.presentedViewController,
//               let sheet = controller.presentationController as? UISheetPresentationController {
//                controller.presentingViewController?.view.tintAdjustmentMode = .normal
//                sheet.largestUndimmedDetentIdentifier = .large
//            }
//        }
        .padding(.top, 32)
        .cornerRadius(10)

    }
}

struct OSMenuView_Previews: PreviewProvider {
    static var previews: some View {
        OSMenuView(selectedMenuOption: .constant(.report), showCreateReportView: .constant(false))
    }
}
