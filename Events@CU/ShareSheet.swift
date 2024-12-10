//
//  ShareSheet.swift
//  Events@CU
//
//  Created by Jesse Mitra on 11/15/24.
//

import SwiftUI

// Share Sheet UIViewControllerRepresentable for SwiftUI
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
