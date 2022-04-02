//
//  MainView.swift
//  Tracker
//
//  Created by Aksilont on 02.04.2022.
//

import SwiftUI

struct MainView: View {
    
    var onMap: ((String) -> ())?
    var onLogout: (() -> ())?
    
    var body: some View {
        VStack {
            Button("Перейти к карте") {
                onMap?("some value")
            }
            .padding()
            Button("Выход") {
                UserDefaults.standard.set(false, forKey: "isLogin")
                onLogout?()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
