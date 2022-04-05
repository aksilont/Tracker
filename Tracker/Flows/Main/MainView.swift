//
//  MainView.swift
//  Tracker
//
//  Created by Aksilont on 02.04.2022.
//

import SwiftUI

struct MainView: View {
    
    var onMap: ((MapType) -> ())?
    var onLogout: (() -> ())?
    
    var body: some View {
        VStack {
            Button("Перейти к карте Google") {
                onMap?(.google)
            }
            .padding()
            Button("Перейти к карте Apple") {
                onMap?(.apple)
            }
            .padding()
            Button("Выход") {
                UserDefaults.standard.set(false, forKey: "isLogin")
                onLogout?()
            }
            .padding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
