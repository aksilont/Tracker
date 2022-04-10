//
//  SignUpView.swift
//  Tracker
//
//  Created by Aksilont on 02.04.2022.
//

import SwiftUI

struct SignUpView: View {
    private let dataRepository = DataRepository()
    
    @State var login: String = ""
    @State var password: String = ""
    
    var onExit: (() -> ())?
    
    var body: some View {
        VStack {
            
            Text("Регистрация")
                .foregroundColor(Color(red: 0.183, green: 0.689, blue: 0.928))
                .font(.largeTitle)
                .fontWeight(.medium)
            
            userNameView.padding(.leading, 80)
            Divider().padding(.vertical)
            passwordView.padding(.leading, 80)
            
            VStack {
                Button("OK") {
                    dataRepository.registerOrUpdateUser(login: login, password: password)
                    onExit?()
                }
                .tint(.black)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2))
                
                Button("Отмена") {
                    onExit?()
                }
                .tint(.black)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.pink, lineWidth: 2))
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
    
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
