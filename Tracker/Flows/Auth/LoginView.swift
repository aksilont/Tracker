//
//  LoginView.swift
//  Tracker
//
//  Created by Aksilont on 02.04.2022.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @State private var login = ""
    @State private var password = ""
    @State private var shouldShowLogo: Bool = true
    
    var onLogin: (() -> ())?
    var onRecovery: (() -> ())?
    var onSignUp: (() -> ())?
    
    private let keyboardIsOnPublisher = Publishers.Merge(
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .map { _ in true },
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
    )
        .removeDuplicates()
        .eraseToAnyPublisher()

    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("wal")
                    .resizable()
                    .ignoresSafeArea()
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            
            VStack {
                if shouldShowLogo {
                    Text("Login")
                        .foregroundColor(Color(red: 0.183, green: 0.689, blue: 0.928))
                        .font(.largeTitle)
                        .fontWeight(.medium)
                }
                
                ZStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 60, style: .continuous)
                            .fill(Color.white)
                            .frame(height: 125)
                            .shadow(color: .gray.opacity(0.2), radius: 10, y: 5)
                        
                        VStack {
                            userNameView.padding(.leading, 80)
                            Divider().padding(.vertical)
                            passwordView.padding(.leading, 80)
                        }
                    }
                    .offset(x: -60)
                    
                    HStack {
                        Spacer()
                        Button {
                            UserDefaults.standard.set(true, forKey: "isLogin")
                            onLogin?()
                        } label: {
                            Image(systemName: "play").foregroundColor(.white).font(.largeTitle)
                        }
                        .padding()
                        .background(
                            LinearGradient(colors: [Color(#colorLiteral(red: 0.5529411765, green: 0.8784313725, blue: 0.6588235294, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))],
                                           startPoint: .trailing,
                                           endPoint: .leading)
                        )
                        .clipShape(Circle())
                        .shadow(color: .gray.opacity(0.5), radius: 7, y: 5)
                        .padding(.trailing, 40)
                    }
                }
                .onReceive(keyboardIsOnPublisher) { isKeyboardOn in
                    withAnimation(Animation.linear(duration: 0.2)) {
                        shouldShowLogo = !isKeyboardOn
                    }
                }

                
                HStack {
                    Spacer()
                    Button("Forgot?") {
                        onRecovery?()
                    }
                    .foregroundColor(.gray)
                }
                .padding()
                
                HStack {
                    registerButton
                        .offset(x: -25)
                    Spacer()
                }
            }
            
        }
    }
    
    var userNameView: some View {
        HStack {
            Image(systemName: "person").foregroundColor(.orange)
            TextField("Username", text: $login)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            Spacer()
        }
    }
    
    var passwordView: some View {
        HStack {
            Image(systemName: "lock").foregroundColor(.orange)
            SecureField("********", text: $password)
            Spacer()
        }
    }
    
    var registerButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
                .frame(width: 150, height: 50)
                .shadow(color: .gray.opacity(0.2), radius: 10, y: 5)
            Button("Register") {
                onSignUp?()
            }
            .foregroundColor(Color.orange.opacity(0.7))
        }
    }
    
}

extension UIApplication {
   func endEditing() {
       sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
