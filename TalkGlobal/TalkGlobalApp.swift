//
//  TalkGlobalApp.swift
//  TalkGlobal
//
//  Created by Biraj Dahal on 3/23/25.
//

import SwiftUI
import FirebaseCore

@main
struct TalkGlobalApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            TranslateView()
        }
    }
}
