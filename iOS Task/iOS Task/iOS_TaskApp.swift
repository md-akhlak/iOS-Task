//
//  iOS_TaskApp.swift
//  iOS Task
//
//  Created by Md Akhlak on 15/08/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

@main
struct iOS_TaskApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
