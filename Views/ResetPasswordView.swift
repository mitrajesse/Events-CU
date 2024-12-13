//
//  ResetPasswordView.swift
//  Events@CU
//
//  Created by Jesse Mitra and Abe Howder on 12/12/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 0/255, green: 56/255, blue: 101/255, alpha: 1))
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
                    .padding()
                
                TextField("Enter your email", text: $viewModel.resetPasswordEmail)
                    .textFieldStyle(AuthTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .accentColor(.black)
                    .colorScheme(.light)
                
                Button(action: {
                    viewModel.resetPassword()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Send Reset Email")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor(red: 252/255, green: 183/255, blue: 22/255, alpha: 1)))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text("Cancel")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}
